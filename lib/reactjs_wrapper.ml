include Reactjs_wrapper_intf

module Properties = struct
  module Value = struct
    type event_handler = element event Js.t -> unit
    type inner_html

    type t =
      [ `Bool of bool
      | `EventHandler of event_handler
      | `Float of float
      | `Int of int
      | `InnerHtml of inner_html
      | `String of string
      ]

    module Unsafe = struct
      let cast_event_handler f event = f (Js.Unsafe.coerce event)

      let inner_html fragment =
        let open Js.Unsafe in
        obj [| "__html", inject (Js.string fragment) |]
    end

    let to_any =
      let open Js.Unsafe in
      function
      | `Bool b -> if b then Some (inject (Js.string "")) else None
      | `EventHandler h -> Some (inject (Js.wrap_callback h))
      | `Float f -> Some (inject f)
      | `Int i -> Some (inject i)
      | `InnerHtml h -> Some (inject h)
      | `String s -> Some (inject (Js.string s))
  end

  type t = (string * Value.t) list

  let empty = []

  let of_list l = l

  let rec filter_map f = function
    | [] -> []
    | hd :: tl ->
       match f hd with
       | None -> filter_map f tl
       | Some x -> x :: (filter_map f tl)

  let to_props =
    function
    | [] -> Js.null
    | props ->
       props
       |> filter_map
            begin fun (name, value) ->
            match Value.to_any value with
            | None -> None
            | Some value -> Some (name, value)
            end
       |> Array.of_list
       |> Js.Unsafe.obj
       |> Js.some
end

module Unsafe = struct
  open Js

  let arrayish_get arrayish index = array_get (Unsafe.coerce arrayish) index

  let opt_get_exn opt =
    Opt.get opt (fun () -> invalid_arg "Unsafe.get_opt_exn: null")

  let optdef_get_exn opt =
    Optdef.get opt (fun () -> invalid_arg "Unsafe.get_optdef_exn: undefined")
end

module Make (Reactjs : Reactjs.S) = struct
  type element_type = [ `Tag of string ]

  type node = [ `String of string | `Element of Reactjs.element Js.t ]

  let any_of_node =
    let open Js in
    function
    | `String s -> Unsafe.inject (string s)
    | `Element e -> Unsafe.inject e

  let create_element (`Tag type_) props children =
    let open Js in
    let type_ = string type_ in
    let props = Properties.to_props props in
    let children = match children with
      | [] -> null
      | _ -> Array.(children |> of_list |> map any_of_node |> array |> some) in
    Reactjs.react##(createElement type_ props children)

  let render ?callback container element =
    let callback = Js.Optdef.(map (option callback)) Js.wrap_callback in
    Reactjs.react_dom##(render element container callback)
end
