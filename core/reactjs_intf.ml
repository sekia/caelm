open Js_of_ocaml.Js

module Dom_html = Js_of_ocaml.Dom_html
module Js = Js_of_ocaml.Js

class type ['element, 'props, 'state] component = object
  method props : 'props t readonly_prop
  method render : 'element t meth
  method setState : 'state t -> unit meth
  method state : 'state t readonly_prop
end

type ('element, 'props, 'state) component_class =
  ('props t -> ('element, 'props, 'state) component t) constr

module Or_js_string : sig
  type 'component_class t
  val of_component_class :
    ('element, 'props, 'state) component_class ->
    ('element, 'props, 'state) component_class t
  val of_js_string : js_string Js.t -> 'component_class t
end = struct
  type 'component_class t = Unsafe.any
  let of_component_class = Unsafe.inject
  let of_js_string = Unsafe.inject
end

class type ['element, 'props, 'state] react = object
  method createElement :
    ('element, 'props, 'state) component_class Or_js_string.t -> 'props t opt ->
    Unsafe.any js_array t opt -> 'element t meth
end

class type ['element] react_dom = object
  method render :
    'element t -> Dom_html.element t -> (unit -> unit) callback optdef ->
    Dom_html.element t meth
end

module type S = sig
  type element
  type props
  type state
  type nonrec component = (element, props, state) component
  type nonrec component_class = (element, props, state) component_class

  val react : (element, props, state) react t
  val react_dom : element react_dom t
end

module type Scope = sig
  val scope : < .. > t
  val var_name : [< `React | `ReactDOM ] -> string
end

module type Require = sig
  val require : js_string t -> 'a
end
