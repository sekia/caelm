open Caelm

module Make
    (State : S.State with module Thread := Lwt)
    (View : S.View with type state := State.t
                    and type message := State.message) :
  S.App with module Thread := Lwt
         and module React := Lwt_react
         and module State := State
