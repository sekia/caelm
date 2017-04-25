include Caelm_reactjs_intf

module Make (Scope : Scope) = struct
  type element
  type props

  let get var =
    let prop = Js.string (Scope.var_name var) in
    Js.Unsafe.get Scope.scope prop

  let react =
    let create_element = (get `React)##.createElement in
    object%js
      method createElement type_ props children =
        let open Js in
        let open Unsafe in
        let args = Opt.get children (fun () -> new%js array_empty) in
        ignore @@ args##(unshift_2 (inject type_) (inject props));
        fun_call create_element (to_array args)
    end

  let react_dom = get `ReactDOM
end
