include module type of Caelm_reactjs_wrapper_intf

module Properties : S.Properties

module Unsafe : S.Unsafe

module Make (Reactjs : Caelm_reactjs.S) : S.Wrapper
  with module Reactjs := Reactjs
   and module Properties := Properties
