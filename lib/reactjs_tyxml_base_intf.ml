type animation_event_attrib =
  [ `OnAnimationEnd | `OnAnimationIteration | `OnAnimationStart ]
type clipboard_event_attrib = [ `OnCopy | `OnCut | `OnPaste ]
type composition_event_attrib =
  [ `OnCompositionEnd | `OnCompositionStart | `OnCompositionUpdate ]
type focus_event_attrib = [ `OnBlur | `OnFocus ]
type form_event_attrib = [ `OnChange | `OnInput | `OnSubmit ]
type image_event_attrib = [ `OnLoad | `OnError ]
type keyboard_event_attrib = [ `OnKeyDown | `OnKeyPress | `OnKeyUp ]
type media_event_attrib =
  [ `OnAbort | `OnCanPlay | `OnCanPlayThrough | `OnDurationChange | `OnEmptied
  | `OnEncrypted | `OnEnded | `OnError | `OnLoadStart | `OnLoadedData
  | `OnLoadedMetaData | `OnPause | `OnPlay | `OnPlaying | `OnProgress
  | `OnRateChange | `OnSeeked | `OnSeeking | `OnStalled | `OnSuspend
  | `OnTimeUpdate | `OnVolumeChange | `OnWaiting
  ]
type mouse_event_attrib =
  [ `OnClick | `OnContextMenu | `OnDblClick | `OnDrag | `OnDragEnd
  | `OnDragEnter | `OnDragExit | `OnDragLeave | `OnDragOver | `OnDragStart
  | `OnDrop | `OnMouseDown |`OnMouseEnter | `OnMouseLeave | `OnMouseMove
  | `OnMouseOut | `OnMouseOver | `OnMouseUp
  ]
type select_event_attrib = [ `OnSelect ]
type touch_event_attrib =
  [ `OnTouchCancel | `OnTouchEnd | `OnTouchMove | `OnTouchStart ]
type transition_event_attrib = [ `OnTransitionEnd ]
type ui_event_attrib = [ `OnScroll ]
type wheel_event_attrib = [ `OnWheel ]

type event_attrib =
  [ animation_event_attrib | clipboard_event_attrib | composition_event_attrib
  | focus_event_attrib | form_event_attrib | image_event_attrib
  | keyboard_event_attrib | media_event_attrib | mouse_event_attrib
  | select_event_attrib | touch_event_attrib | transition_event_attrib
  | ui_event_attrib | wheel_event_attrib
  ]
