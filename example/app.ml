open Sexplib.Std

module Scope = struct
  let scope = Js.Unsafe.global
  let var_name = function
    | `React -> "React"
    | `ReactDOM -> "ReactDOM"
end

module Reactjs = Caelm.Reactjs.Make (Scope)

module Todo = struct
  type state = Editing | View [@@deriving sexp]
  type t =
    { description : string
    ; done_ : bool
    ; id : int
    ; state : state
    } [@@deriving sexp]

  let id = ref 0

  let create description =
    let id' = !id in
    incr id;
    { description; done_ = false; id = id'; state = View }

  let set_next_id id' = id := id'

  let id todo = todo.id

  let description todo = todo.description

  let done_ todo = todo.done_

  let state todo = todo.state
end

module State = struct
  type filter = All | Active | Completed
  type todos = Todo.t list [@@deriving sexp]
  type t =
    { filter : filter
    ; input : string
    ; todos : todos
    }

  type message =
    | Add_todo of Todo.t
    | Remove_todo of Todo.t
    | Replace_todo of (Todo.t * Todo.t)
    | Set_filter of filter
    | Todo_saved
    | Update_input of string

  type command = message Lwt.t

  let local_storage =
    Dom_html.window##.localStorage
    |> Caelm.Reactjs_wrapper.Unsafe.optdef_get_exn

  let storage_key = Js.string "todos"

  let load_todos () =
    let todos =
      let deserialize s =
        Js.to_string s |> Sexplib.Sexp.of_string |> todos_of_sexp in
      Js.Opt.case
        local_storage##(getItem storage_key)
        (fun () -> [])
        deserialize in
    let latest_id = List.map Todo.id todos |> List.fold_left max 0 in
    Todo.set_next_id (latest_id + 1);
    todos

  let save_todos todos =
    let serialized =
      sexp_of_todos todos |> Sexplib.Sexp.to_string_mach |> Js.string in
    local_storage##(setItem storage_key serialized);
    Lwt.return Todo_saved

  let create () = { filter = All; input = ""; todos = load_todos () }

  let equal = ( = )

  let visible_todos state =
    let f = match state.filter with
      | All -> fun _ -> true
      | Active -> fun todo -> not (Todo.done_ todo)
      | Completed -> fun todo -> Todo.done_ todo in
    List.filter f state.todos

  let replace todos old new_ =
    List.map (fun todo -> if todo = old then new_ else todo) todos

  let update state = function
    | Add_todo todo ->
      let todos = todo :: state.todos in
      { state with input = ""; todos }, Some (save_todos todos)
    | Remove_todo todo ->
      let todos = List.filter (fun t -> t <> todo) state.todos in
      { state with todos }, Some (save_todos todos)
    | Replace_todo (old, new_) ->
      let todos = replace state.todos old new_ in
      { state with todos }, Some (save_todos todos)
    | Set_filter filter -> { state with filter }, None
    | Todo_saved -> state, None (* No-op. *)
    | Update_input input -> { state with input }, None
end

module View = struct
  module Tyxml = Caelm_reactjs_tyxml.Make (Reactjs)
  module Wrapper = Caelm.Reactjs_wrapper.Make (Reactjs)

  open State
  open Tyxml.Html

  let is_checked e =
    e##.target##.checked
    |> Caelm.Reactjs_wrapper.Unsafe.optdef_get_exn
    |> Js.to_bool

  let header_controls ~add_todo ~replace_todo ~update_input ~input ~todos =
    let add_todo e =
      let key = Js.to_string e##.key in
      if input <> "" && key = "Enter" then add_todo (Todo.create input) in
    let update_input e =
      update_input (Js.to_string e##.target##.value) in
    let toggle_all e =
      let done_ = is_checked e in
      let f todo = replace_todo todo { todo with Todo.done_ } in
      List.iter f todos in
    (* Alias for avoiding conflict with arguemnt. *)
    let input' = Tyxml.Html.input in
    div ~a:[ a_id "header-controls" ]
      [ input' ~a:[ a_input_type `Checkbox
                  ; a_onchange toggle_all
                  ; a_checked (todos <> [] && List.for_all Todo.done_ todos)
                  ; a_alt "Mark all as complated" ] ()
      ; input' ~a:[ a_id "new-input"
                  ; a_input_type `Text
                  ; a_value input
                  ; a_oninput update_input
                  ; a_onkeydown add_todo
                  ; a_maxlength 140
                  ; a_placeholder "What needs to be done?"
                  ] ()
      ]

  let todo ~replace_todo todo =
    let open Todo in
    let update new_todo = replace_todo todo new_todo in
    let start_edit _ =
      if todo.state = View then update { todo with state = Editing } in
    let finish_edit _ =
      if todo.description <> "" then update { todo with state = View } in
    let finish_edit_if_enter e =
      let key = Js.to_string e##.key in
      if key = "Enter" then finish_edit () in
    let update_description e =
      let description = e##.target##.value |> Js.to_string in
      update { todo with description } in
    let toggle e = update { todo with done_ = is_checked e } in
    let description = match todo.state with
      | Editing ->
        input ~a:[ a_class [ "todo-description"]
                 ; a_input_type `Text
                 ; a_value todo.description
                 ; a_autofocus true
                 ; a_onblur finish_edit
                 ; a_onchange update_description
                 ; a_onkeypress finish_edit_if_enter
                 ] ()
      | View ->
        span ~a:[ a_class [ "todo-description"]; a_ondoubleclick start_edit ]
          [ if todo.done_ then del [ pcdata todo.description ]
            else pcdata todo.description
          ] in
    li ~a:[ a_class [ "todo-entry" ] ]
      [ input ~a:[ a_input_type `Checkbox
                 ; a_checked todo.done_
                 ; a_onchange toggle ] ()
      ; description
      ]

  let filter_buttons ~set_filter current_filter =
    let button_text = function
      | All -> "All"
      | Active -> "Active"
      | Completed -> "Completed" in
    let button filter =
      let a =
        let a = [ a_onclick (fun _ -> set_filter filter) ] in
        if filter = current_filter then (a_class [ "selected-filter" ]) :: a
        else a in
      button ~a [ pcdata (button_text filter) ] in
    span ~a:[ a_id "filter-buttons" ]
      (List.map button [ All; Active; Completed ])

  let footer_controls ~remove_todo ~set_filter ~filter ~todos =
    let dones = List.filter Todo.done_ todos in
    let num_dones = List.length dones in
    let num_undones = List.length todos - num_dones in
    let clear_completed _ = List.iter remove_todo dones in
    footer ~a:[ a_id "footer-controls" ]
      [ span ~a:[ a_id "left-items"; a_hidden (num_undones = 0) ]
          [ pcdata (Printf.sprintf "%d item%s left" num_undones
                      (if num_undones = 1 then "" else "s"))
          ]
      ; filter_buttons ~set_filter filter
      ; span ~a:[ a_id "clear-completed"; a_hidden (num_dones = 0) ]
          [ button ~a:[ a_onclick clear_completed ]
              [ pcdata (Printf.sprintf "Clear completed (%d)" num_dones) ]
          ]
      ]

  let render ~send ~container state =
    let add_todo todo = send (Add_todo todo) in
    let remove_todo todo = send (Remove_todo todo) in
    let replace_todo old new_ = send (Replace_todo (old, new_)) in
    let update_input input = send (Update_input input) in
    let set_filter filter = send (Set_filter filter) in
    let visible_todos = State.visible_todos state in
    section [ header [ h1 ~a:[ a_id "app-title" ] [ pcdata "todos" ]
                     ; header_controls
                         ~add_todo ~update_input ~replace_todo
                         ~input:state.input ~todos:visible_todos
                     ]
            ; section ~a:[ a_id "todo-list" ]
                [ ul (List.rev_map (todo ~replace_todo) visible_todos) ]
            ; footer_controls
                ~remove_todo ~set_filter ~filter:state.filter ~todos:state.todos
            ]
    |> to_react_element
    |> Wrapper.render ~container
end

module App = Caelm_lwt.Make (State) (View)

let () =
  let container =
    Dom_html.document##(getElementById (Js.string "todo-app"))
    |> Caelm.Reactjs_wrapper.Unsafe.opt_get_exn in
  let app = App.run ~container (State.create ()) in
  let terminate () = App.terminate app in
  Js.(export "terminateApp" @@ wrap_callback terminate)
