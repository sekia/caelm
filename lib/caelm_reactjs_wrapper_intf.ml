module S = struct
  module type Properties = sig
    module Value : sig
      type event_handler
      type inner_html

      type t =
        [ `Bool of bool
        | `EventHandler of event_handler
        | `Float of float
        | `InnerHtml of inner_html
        | `Int of int
        | `String of string
        ]

      module Unsafe : sig
        val cast_event_handler : ('a Js.t -> unit) -> event_handler
        val inner_html : string -> inner_html
      end
    end

    type t

    val empty : t
    val of_list : (string * Value.t) list -> t
  end

  module type Unsafe = sig
    val arrayish_get : 'a Js.t -> int -> 'b Js.t Js.optdef
    val opt_get_exn : 'a Js.t Js.opt -> 'a Js.t
    val optdef_get_exn : 'a Js.t Js.optdef -> 'a Js.t
  end

  module type Wrapper = sig
    module Caelm_reactjs : Caelm_reactjs.S
    module Properties : Properties

    type node = [ `String of string | `Element of Caelm_reactjs.element Js.t ]

    type element_type = [ `Tag of string ]

    val create_element :
      element_type -> Properties.t -> node list -> Caelm_reactjs.element Js.t

    val render :
      ?callback:(unit -> unit) -> container:Dom_html.element Js.t ->
      Caelm_reactjs.element Js.t -> Dom_html.element Js.t
  end
end

open Js

class type element =
  object
    method className : js_string t readonly_prop
    method dataset : 'a t readonly_prop
    method id : js_string t readonly_prop
    method innerHTML : js_string t readonly_prop
    method lang : js_string t readonly_prop
    method tagName : js_string t readonly_prop
    method textContent : js_string t readonly_prop
    method title : js_string t readonly_prop
  end

class type image_element =
  object
    inherit element
    method alt : js_string t readonly_prop
    method complete : bool t readonly_prop
    method height : int readonly_prop
    method naturalHeight : int readonly_prop
    method naturalWidth : int readonly_prop
    method src : js_string t readonly_prop
    method width : int readonly_prop
  end

(* Not only input but also select textarea. *)
class type input_element =
  object
    inherit element
    method capture : bool t optdef readonly_prop
    method checked : bool t optdef readonly_prop
    method disabled : bool t optdef readonly_prop
    method indeterminate : bool t optdef readonly_prop
    method selectionDirection : js_string t optdef readonly_prop
    method selectionEnd : int optdef readonly_prop
    method selectionStart : int optdef readonly_prop
    method _type : js_string t readonly_prop
    method value : js_string t readonly_prop
  end

class type media_element = Dom_html.mediaElement

class type blob =
  object
    method size : int readonly_prop
    method slice : int optdef -> int optdef -> js_string t optdef -> blob t meth
    method _type : js_string t readonly_prop
  end

class type file =
  object
    inherit blob
    method lastModified : int readonly_prop
    method name : js_string t readonly_prop
  end

class type data_transfer_item =
  object
    method getAsFile : file t opt meth
    method getAsString : (js_string t -> unit) Js.callback -> unit meth
    method kind : js_string t readonly_prop
    method _type : js_string t readonly_prop
  end

class type data_transfer_item_list =
  object
    method add_string :
      js_string t -> js_string t -> data_transfer_item t opt meth
    method add_file : file t -> data_transfer_item t opt meth
    method clear : unit meth
    method length : int readonly_prop
    method remove : int -> unit meth
  end

class type data_transfer =
  object
    method dropEffect : js_string t prop
    method effectAllowed : js_string t prop
    method items : data_transfer_item_list t readonly_prop
    method setDragImage : image_element t -> int -> int -> unit meth
  end

class type modifier_key_properties =
  object
    method altKey : bool t readonly_prop
    method ctrlKey : bool t readonly_prop
    method getModifierState : js_string t -> bool t meth
    method metaKey : bool t readonly_prop
    method shiftKey : bool t readonly_prop
  end

class type point_properties =
  object
    method clientX : int readonly_prop
    method clientY : int readonly_prop
    method pageX : int readonly_prop
    method pageY : int readonly_prop
    method screenX : int readonly_prop
    method screenY : int readonly_prop
  end

class type touch =
  object
    inherit point_properties
    method identifier : int readonly_prop
    method target : element t readonly_prop
  end

class type touch_list =
  object
    method length : int readonly_prop
    method item : int -> touch t readonly_prop
  end

class type ['t] event =
  object
    method bubbles : bool t readonly_prop
    method cancelable : bool t readonly_prop
    method currentTarget : element t readonly_prop
    method defaultPrevented : bool t readonly_prop
    method eventPhase : int readonly_prop
    method isTrusted : bool t readonly_prop
    method nativeEvent : Dom_html.event t readonly_prop
    method persist : unit meth
    method preventDefault : unit meth
    method isDefaultPrevented : bool t meth
    method stopPropagation : unit meth
    method isPropagationStopped : bool t meth
    method target : 't t readonly_prop
    method timeStamp : int readonly_prop
    method _type : js_string t readonly_prop
  end

class type ['t] animation_event =
  object
    inherit ['t] event
    method animationName : js_string t readonly_prop
    method elapsedTime : float readonly_prop
  end

class type ['t] clipboard_event =
  object
    inherit ['t] event
    method clipboardData : data_transfer opt readonly_prop
  end

class type ['t] composition_event =
  object
    inherit ['t] event
    method data : js_string t readonly_prop
  end

class type ['t] focus_event =
  object
    inherit ['t] event
    method relatedTarget : element t opt readonly_prop
  end

class type ['t] input_event =
  object
    inherit ['t] event
    method data : bool t opt readonly_prop
  end

class type ['t] keyboard_event =
  object
    inherit ['t] event
    inherit modifier_key_properties
    method charCode : int readonly_prop
    method key : js_string t readonly_prop
    method keyCode : int t readonly_prop
    method locale : js_string t readonly_prop
    method location : int readonly_prop
    method repeat : bool t readonly_prop
    (* According to https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent,
       |which| is deprecated so we trimmed it off here. Use |keyCode| instead.
    *)
  end

class type ['t] mouse_event =
  object
    inherit ['t] event
    inherit modifier_key_properties
    inherit point_properties
    method button : int readonly_prop
    method buttons : int readonly_prop
    method relatedTarget : element t opt readonly_prop
  end

class type ['t] touch_event =
  object
    inherit ['t] event
    inherit modifier_key_properties
    method changedTouches : touch_list t readonly_prop
    method targetTouches : touch_list t readonly_prop
    method touches : touch_list t readonly_prop
  end

class type ['t] transition_event =
  object
    inherit ['t] event
    method elapsedTime : float readonly_prop
    method propertyName : js_string readonly_prop
    method pseudoElement : js_string t readonly_prop
  end

class type ['t] wheel_event =
  object
    inherit ['t] mouse_event
    method deltaMode : int readonly_prop
    method deltaX : float readonly_prop
    method deltaY : float readonly_prop
    method deltaZ : float readonly_prop
  end
