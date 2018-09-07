include module type of Reactjs_wrapper_intf

module Properties : S.Properties

module Unsafe : S.Unsafe

module Make (Reactjs : Reactjs.S) : S.Wrapper
  with module Reactjs := Reactjs
   and module Properties := Properties
