include Caelm_intf

module Make
  (Thread : S.Thread) (React : S.React)
  (State : S.State with module Thread := Thread)
  (View : S.View with type state := State.t
                  and type message := State.message) = struct
  module type Subscription =
    S.Subscription with module Thread := Thread
                    and module React := React
                    and module State := State

  module App = struct
    module Types = struct
      type phase = Ready | Running | Terminated
      type t = { phase : phase; state : State.t }
      type input = Message of State.message | Nop | Terminate
    end
    include Types

    let create ~phase ~state = { phase; state }

    let phase { phase; _ } = phase

    let state { state; _ } = state

    let equal a b =
      match phase a, phase b with
      | Ready, Ready | Running, Running | Terminated, Terminated ->
         State.equal (state a) (state b)
      | _ -> false

    let update send_message =
      function
      | { phase = Ready; _ } | { phase = Terminated; _ } as app ->
         fun _ -> (app, None)
      | { phase = Running; state } as app ->
         function
         | Nop -> app, None
         | Terminate -> { app with phase = Terminated }, None
         | Message m ->
            let state, command = State.update state m in
            { app with state }, command
  end
  open App.Types
  type t = App.t

  let equal_command_opt c d =
    match c, d with
    | None, None -> true
    | None, Some _ | Some _, None -> false
    (* Note that physical equality check ( == ) is used here,
       because commands can perform with side effects. *)
    | Some c, Some d -> c == d

  let create state = App.create ~phase:Ready ~state

  let run app ?(subscriptions=[]) container =
    match App.phase app with
    | Running -> assert false (* Running state is never exposured *)
    | Terminated -> (fun () -> app)
    | Ready ->
       let open React in
       let event, send_event = E.create () in
       let send_message m = send_event (Message m) in
       let send_termination_request () = send_event Terminate in
       let app, command_dispatcher =
         let pair =
           S.fold (fun (app, _) -> App.update send_message app)
             ({ app with phase = Running }, None) event in
         let app = S.Pair.fst ~eq:App.equal pair in
         let command = S.Pair.snd ~eq:equal_command_opt pair in
         let dispatch = function
           | None -> ()
           | Some command ->
              Thread.(async (fun () -> map send_message command)) in
         app, S.l1 dispatch command in
       let state = S.l1 App.state app in
       let renderer = S.l1 (View.render send_message container) state in
       let stop_subscriptions =
         let start module_ =
           let module Subscription = (val module_ : Subscription) in
           Subscription.start state in
         let events, stoppers = List.split (List.map start subscriptions) in
         let senders = List.map (E.l1 send_message) events in
         fun () ->
         List.iter (fun f -> f ()) stoppers;
         List.iter E.stop senders in
       (fun () ->
         stop_subscriptions ();
         send_termination_request ();
         let strong =
           let open Sys in
           match backend_type with
           | Other "js_of_ocaml" -> true
           | Native | Bytecode | Other _ -> false in
         S.stop ~strong app;
         S.stop ~strong command_dispatcher;
         S.stop ~strong renderer;
         S.value app)
end

module Make_with_lwt = Make (Lwt) (Lwt_react)
