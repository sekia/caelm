include module type of Caelm_reactjs_wrapper_intf

module Properties : S.Properties

module Unsafe : S.Unsafe

module Make (Caelm_reactjs : Caelm_reactjs.S) : S.Wrapper
  with module Caelm_reactjs := Caelm_reactjs
   and module Properties := Properties
