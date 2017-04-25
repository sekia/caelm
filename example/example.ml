module State = struct
  type message =
    | Button_clicked of string
    | Set_message
    | Tick
    | Update_field of string

  type t =
    { field : string
    ; message : string
    ; time : string
    }

  type command = message Lwt.t

  let equal a b = a = b

  let update state = function
    | Button_clicked button ->
       let message =
         if button <> "B" then "You clicked button " ^ button
         else "You clicked button B (but it will be switched soon!)" in
       let command =
         if button <> "B" then None
         else
           let waiter =
             let waiter, sender = Lwt.wait () in
             let open Js.Unsafe in
             let f =
               Js.wrap_callback
                 (fun () -> Lwt.wakeup sender (Button_clicked "A")) in
             ignore @@ fun_call global##.setTimeout [| inject f; inject 3000 |];
             waiter in
           Some waiter in
       { state with message }, command
    | Set_message -> { state with message = state.field; field = "" }, None
    | Tick ->
       let open Js in
       let time = (new%js date_now)##toString |> to_string in
       { state with time }, None
    | Update_field field -> { state with field }, None

  let create () =
    let state = { message = "Click a buton below"; field = ""; time = "" } in
    let state, _ = update state Tick in
    state

  let field { field; _ } = field

  let message { message; _ } = message

  let time { time; _ } = time
end

module Reactjs = Caelm_reactjs.Make
  (struct
    let scope = Js.Unsafe.global
    let var_name = function
      | `React -> "React"
      | `ReactDOM -> "ReactDOM"
  end)

module View = struct
  module Tyxml = Caelm_reactjs_tyxml.Make (Reactjs)
  module Wrapper = Caelm_reactjs_wrapper.Make (Reactjs)
  let render send container =
    fun state ->
    let open State in  (* For message constructors. *)
    let on_click m = fun _ -> send m in
    let on_input e =
      let field = Js.to_string (e##.target##.value) in
      send (Update_field field) in
    let open Tyxml.Html in
    div [ p [ text "Msg: "; text (State.message state) ]
        ; button ~a:[ a_onclick (on_click (Button_clicked "A")) ] [ text "A" ]
        ; button ~a:[ a_onclick (on_click (Button_clicked "B")) ] [ text "B" ]
        ; button ~a:[ a_onclick (on_click (Button_clicked "C")) ] [ text "C" ]
        ; form
            ~a:[ a_onsubmit (fun e -> e##preventDefault; send Set_message) ]
            [ textarea ~a:[ a_oninput on_input
                          ; a_value (State.field state) ] ()
            ; button ~a:[ a_button_type `Submit ] [ text "show" ]
            ]
        ; p [ text (State.time state) ]
        ]
    |> to_react_element
    |> Wrapper.render container
end

module App = Caelm.Make_with_lwt (State) (View)

module Tick = struct
  let start _ =
    let e, send = Lwt_react.E.create () in
    let f = Js.wrap_callback (fun () -> send State.Tick) in
    let open Js.Unsafe in
    let id = fun_call global##.setInterval [| inject f; inject 1000 |] in
    let stop () = ignore @@ fun_call global##.clearInterval [| inject id |] in
    e, stop
end

let () =
  let root =
    Dom_html.document##(getElementById (Js.string "react-app"))
    |> Caelm_reactjs_wrapper.Unsafe.opt_get_exn in
  let app = App.create (State.create ()) in
  let subscriptions = [ (module Tick : App.Subscription) ] in
  let terminate = App.run app ~subscriptions root in
  Js.export "Terminate" terminate
