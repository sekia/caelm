include module type of Caelm_intf

module Make
    (Thread : S.Thread) (React : S.React)
    (State : S.State with module Thread := Thread)
    (View : S.View with type state := State.t
                    and type message := State.message) :
  S.App with module Thread := Thread
         and module React := React
         and module State := State
