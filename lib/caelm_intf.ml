module S = struct
  module type Thread = sig
    type 'a t
    val return : 'a -> 'a t
    val bind : 'a t -> ('a -> 'b t) -> 'b t
    val map : ('a -> 'b) -> 'a t -> 'b t
    val async : (unit -> 'a t) -> unit
  end

  module type React = sig
    module E : module type of React.E
    module S : module type of React.S
    type 'a event = 'a E.t
    type 'a signal = 'a S.t
  end

  module type State = sig
    type t
    type message
    module Thread : Thread
    type command = message Thread.t
    val equal : t -> t -> bool
    val update : t -> message -> t * command option
  end

  module type View = sig
    type state
    type message
    val render :
      (message -> unit) -> Dom_html.element Js.t -> state ->
      Dom_html.element Js.t
  end

  module type Subscription = sig
    module Thread : Thread
    module React : React
    module State : State with module Thread := Thread
    val start :
      State.t React.signal -> State.message React.event * (unit -> unit)
  end

  module type App = sig
    type t
    module Thread : Thread
    module React : React
    module State : State with module Thread := Thread
    module type Subscription =
      Subscription with module Thread := Thread
                    and module React := React
                    and module State := State
    val create : State.t -> t
    val run :
      t -> ?subscriptions:(module Subscription) list -> Dom_html.element Js.t ->
      unit -> t
  end
end

module Reactjs = Caelm_reactjs
module Reactjs_wrapper = Caelm_reactjs_wrapper
