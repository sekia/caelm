include Caelm_reactjs_intf

let wrap_react react = object%js
  method createElement type_ props children =
    let open Js in
    let open Unsafe in
    let args = Opt.get children (fun () -> new%js array_empty) in
    ignore @@ args##(unshift_2 (inject type_) (inject props));
    fun_call react##.createElement (to_array args)
end

module Types = struct
  type element
  type props
  type state
  type nonrec component = (element, props, state) component
  type component_class = (props Js.t -> component Js.t) Js.constr
end

module Make (Scope : Scope) = struct
  include Types

  let get var =
    let prop = Js.string (Scope.var_name var) in
    Js.Unsafe.get Scope.scope prop

  let react = wrap_react @@ get `React

  let react_dom = get `ReactDOM
end

module Make_with_require (Require : Require) = struct
  include Types

  let react = wrap_react @@ Require.require (Js.string "react")

  let react_dom = Require.require (Js.string "react-dom")
end
