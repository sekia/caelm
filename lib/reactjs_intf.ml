open Js

class type ['element, 'props] react =
  object
    method createElement : js_string t -> 'props t opt ->
                           Unsafe.any js_array t opt -> 'element t meth
  end

class type ['element] react_dom =
  object
    method render : 'element t -> Dom_html.element t ->
                    (unit -> unit) callback optdef -> Dom_html.element t meth
  end

module type S = sig
  type element
  type props
  val react : (element, props) react t
  val react_dom : element react_dom t
end

module type Scope = sig
  val scope : < .. > t
  val var_name : [< `React | `ReactDOM ] -> string
end
