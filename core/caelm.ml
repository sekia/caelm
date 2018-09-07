module Make
    (Thread : S.Thread) (React : S.React)
    (State : S.State with module Thread := Thread)
    (View : S.View with type state := State.t
                    and type message := State.message) = struct
  module type Subscription =
    S.Subscription with module Thread := Thread
                    and module React := React
                    and module State := State

  type t =
    { send : State.message -> unit
    ; state : State.t React.signal
    ; terminate : unit -> State.t
    }

  let run ?(subscriptions=[]) ?initial_command ~container initial_state =
    let open React in
    let event, send = E.create () in
    let state, command_dispatcher =
      let pair =
        S.fold (fun (state, _) -> State.update state)
          (initial_state, initial_command) event in
      let state = S.Pair.fst ~eq:State.equal pair in
      let command = S.Pair.snd ~eq:( == ) pair in
      let dispatch = function
        | None -> ()
        | Some command -> Thread.(async (fun () -> map send command)) in
      (state, S.l1 dispatch command) in
    let renderer = S.l1 (View.render ~send ~container) state in
    let stop_subscriptions =
      let start module_ =
        let module Subscription = (val module_ : Subscription) in
        Subscription.start state in
      let events, stoppers = List.split (List.map start subscriptions) in
      let senders = List.map (E.l1 send) events in
      fun () ->
        List.iter (fun f -> f ()) stoppers;
        List.iter E.stop senders in
    let terminate () =
      stop_subscriptions ();
      let strong = Sys.(backend_type = Other "js_of_ocaml") in
      S.stop ~strong state;
      S.stop ~strong command_dispatcher;
      S.stop ~strong renderer;
      S.value state in
    { send; state; terminate }

  let send { send; _ } message = send message

  let terminate { terminate; _ } = terminate ()
end

module Reactjs = Reactjs

module Reactjs_wrapper = Reactjs_wrapper

module S = S
