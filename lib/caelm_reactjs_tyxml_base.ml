open Caelm_reactjs_tyxml_base_intf

module Make (Reactjs : Caelm_reactjs.S) = struct
  module Base = struct
    module Wrapper = Caelm_reactjs_wrapper.Make (Reactjs)
    module Properties = Caelm_reactjs_wrapper.Properties

    module Xml = struct
      module W = Xml_wrap.NoWrap

      type 'a wrap = 'a W.t
      type 'a list_wrap = 'a W.tlist

      type aname = string
      type ename = string

      type uri = Uri.t

      type attrib = string * Properties.Value.t

      type event_handler = Properties.Value.event_handler
      type mouse_event_handler = event_handler
      type keyboard_event_handler = event_handler

      let string_of_uri = Uri.to_string
      let uri_of_string = Uri.of_string

      let attrib_creator value_ctor = fun name value -> name, value_ctor value

      let float_attrib = attrib_creator (fun v -> `Float v)
      let int_attrib = attrib_creator (fun v -> `Int v)
      let string_attrib = attrib_creator (fun v -> `String v)
      let space_sep_attrib, comma_sep_attrib, uri_attrib, uris_attrib =
        let attrib f = attrib_creator (fun v -> `String (f v)) in
        attrib (String.concat " "),
        attrib (String.concat ","),
        attrib string_of_uri,
        attrib (fun uris -> List.map string_of_uri uris |> String.concat " ")

      let event_handler_attrib = attrib_creator (fun v -> `EventHandler v)
      let keyboard_event_handler_attrib = event_handler_attrib
      let mouse_event_handler_attrib = event_handler_attrib

      let bool_attrib = attrib_creator (fun v -> `Bool v)
      let object_attrib = attrib_creator (fun v -> `Object v)

      type elt = Wrapper.node

      let empty () = `String ""

      let comment _ = failwith "comment: Not used in ReactJS"

      let cdata s = `String s

      let cdata_script = cdata

      let cdata_style = cdata

      let pcdata s = `String s

      let encodedpcdata _ = failwith "encodedpcdata: Not used in ReactJS."

      let entity _ = failwith "entity: Not used in ReactJS."

      let node ?a:(attributes=[]) name children =
        let props = Properties.of_list attributes in
        `Element (Wrapper.create_element (`Tag name) props children)

      let leaf ?a:(attributes=[]) name = node ~a:attributes name []

      let react_component constr ?(props=[]) children =
        let props = Properties.of_list props in
        `Element (Wrapper.create_element (`Component constr) props children)
    end

    module Svg = Svg_f.Make (Xml)
    module Html = Html_f.Make (Xml) (Svg)
  end

  module Xml = Base.Xml

  module Html = struct
    include Base.Html

    let rename_attrib f name = fun arg -> name, snd (f arg)

    let event_handler_attrib name handler =
      let value = Base.Properties.Value.Unsafe.cast_event_handler handler in
      Base.Xml.event_handler_attrib name value |> to_attrib

    let object_attrib name value =
      let value = Base.Properties.Value.Unsafe.cast_any_object value in
      Base.Xml.object_attrib name value |> to_attrib

    let a_key key = ("key", `String key)
    let a_dangerouslysetinnerhtml fragment =
      let value = Base.Properties.Value.Unsafe.inner_html fragment in
      ("dangerouslySetInnerHTML", `InnerHtml value)

    (* Few attribute combinators below have multi-word names so they are
       immediately overriden by following definitions. This duplication is
       intended for ease of maintenance.
    *)
    let a_async = Base.Xml.bool_attrib "async"
    let a_autofocus = Base.Xml.bool_attrib "autoFocus"
    let a_autoplay = Base.Xml.bool_attrib "autoPlay"
    let a_checked = Base.Xml.bool_attrib "checked"
    let a_controls = Base.Xml.bool_attrib "controls"
    let a_defer = Base.Xml.bool_attrib "defer"
    let a_disabled = Base.Xml.bool_attrib "disabled"
    let a_formnovalidate = Base.Xml.bool_attrib "formNoValidate"
    let a_hidden = Base.Xml.bool_attrib "hidden"
    let a_loop = Base.Xml.bool_attrib "loop"
    let a_multiple = Base.Xml.bool_attrib "multiple"
    let a_muted = Base.Xml.bool_attrib "muted"
    let a_novalidate = Base.Xml.bool_attrib "novalidate"
    let a_open = Base.Xml.bool_attrib "open"
    let a_readonly = Base.Xml.bool_attrib "readonly"
    let a_required = Base.Xml.bool_attrib "required"
    let a_reversed = Base.Xml.bool_attrib "reversed"
    let a_scoped = Base.Xml.bool_attrib "scoped"
    let a_seamless = Base.Xml.bool_attrib "seamless"
    let a_selected = Base.Xml.bool_attrib "selected"
    let a_style value =
      ("style", `Object (Base.Properties.Value.Unsafe.cast_any_object value))

    (* Override multi-word attribute names with camel-cased ones. *)
    let a_accept_charset = rename_attrib a_accept_charset "acceptCharset"
    let a_accesskey = rename_attrib a_accesskey "accessKey"
    let a_autocomplete = rename_attrib a_autocomplete "autoComplete"
    let a_autofocus = rename_attrib a_autofocus "autoFocus"
    let a_autoplay = rename_attrib a_autoplay "autoPlay"
    let a_charset = rename_attrib a_charset "charSet"
    let a_class = rename_attrib a_class "className"
    let a_colspan = rename_attrib a_colspan "colSpan"
    let a_contenteditable = rename_attrib a_contenteditable "contentEditable"
    let a_contextmenu = rename_attrib a_contextmenu "contextMenu"
    let a_crossorigin = rename_attrib a_crossorigin "crossOrigin"
    let a_datetime = rename_attrib a_datetime "dateTime"
    let a_enctype = rename_attrib a_enctype "encType"
    let a_formaction = rename_attrib a_formaction "formAction"
    let a_formenctype = rename_attrib a_formenctype "formEncType"
    let a_formnovalidate = rename_attrib a_formnovalidate "formNoValidate"
    let a_formtarget = rename_attrib a_formtarget "formTarget"
    let a_hreflang = rename_attrib a_hreflang "hrefLang"
    let a_http_equiv = rename_attrib a_http_equiv "httpEquiv"
    let a_inputmode = rename_attrib a_inputmode "inputMode"
    let a_keytype = rename_attrib a_keytype "keyType"
    let a_label_for = rename_attrib a_label_for "htmlFor"
    let a_maxlength = rename_attrib a_maxlength "maxLength"
    let a_mediagroup = rename_attrib a_mediagroup "mediaGroup"
    let a_novalidate = rename_attrib a_novalidate "noValidate"
    let a_output_for = rename_attrib a_output_for "htmlFor"
    let a_radiogroup = rename_attrib a_radiogroup "radioGroup"
    let a_readonly = rename_attrib a_readonly "readOnly"
    let a_rowspan = rename_attrib a_rowspan "rowSpan"
    let a_spellcheck = rename_attrib a_spellcheck "spellCheck"
    let a_srcset = rename_attrib a_srcset "srcSet"
    let a_tabindex = rename_attrib a_tabindex "tabIndex"
    let a_usemap = rename_attrib a_usemap "useMap"

    let a_onanimationend = event_handler_attrib "onAnimationEnd"
    let a_onanimationiteration = event_handler_attrib "onAnimationIteration"
    let a_onanimationstart = event_handler_attrib "onAnimationStart"
    let a_oncopy = event_handler_attrib "onCopy"
    let a_oncut = event_handler_attrib "onCut"
    let a_onpaste = event_handler_attrib "onPaste"
    let a_oncompositionend = event_handler_attrib "onCompositionEnd"
    let a_oncompositionstart = event_handler_attrib "onCompositionStart"
    let a_oncompositionupdate = event_handler_attrib "onCompositionUpdate"
    let a_onblur = event_handler_attrib "onBlur"
    let a_onfocus = event_handler_attrib "onFocus"
    let a_onchange = event_handler_attrib "onChange"
    let a_oninput = event_handler_attrib "onInput"
    let a_onsubmit = event_handler_attrib "onSubmit"
    let a_onload = event_handler_attrib "onLoad"
    (* TODO: Should onError handler be splitted for media and image? *)
    let a_onkeydown = event_handler_attrib "onKeyDown"
    let a_onkeypress = event_handler_attrib "onKeyPress"
    let a_onkeyup = event_handler_attrib "onKeyUp"
    let a_onabort = event_handler_attrib "onAbort"
    let a_oncanplay = event_handler_attrib "onCanPlay"
    let a_oncanplaythrough = event_handler_attrib "onCanPlayThrough"
    let a_ondurationchange = event_handler_attrib "onDurationChange"
    let a_onemptied = event_handler_attrib "onEmptied"
    let a_onencrypted = event_handler_attrib "onEncrypted"
    let a_onended = event_handler_attrib "onEnded"
    let a_onerror = event_handler_attrib "onError"
    let a_onloadeddata = event_handler_attrib "onLoadedData"
    let a_onloadedmetadata = event_handler_attrib "onLoadedMetaData"
    let a_onloadstart = event_handler_attrib "onLoadStart"
    let a_onpause = event_handler_attrib "onPause"
    let a_onplay = event_handler_attrib "onPlay"
    let a_onplaying = event_handler_attrib "onPlaying"
    let a_onprogress = event_handler_attrib "onProgress"
    let a_onratechange = event_handler_attrib "onRateChange"
    let a_onseeked = event_handler_attrib "onSeeked"
    let a_onseeking = event_handler_attrib "onSeeking"
    let a_onstalled = event_handler_attrib "onStalled"
    let a_onsuspend = event_handler_attrib "onSuspend"
    let a_ontimeupdate = event_handler_attrib "onTimeUpdate"
    let a_onvolumechange = event_handler_attrib "onVolumeChange"
    let a_onwaiting = event_handler_attrib "onWaiting"
    let a_onclick = event_handler_attrib "onClick"
    let a_oncontextmenu = event_handler_attrib "onContextMenu"
    let a_ondoubleclick = event_handler_attrib "onDoubleClick"
    let a_ondrag = event_handler_attrib "onDrag"
    let a_ondragend = event_handler_attrib "onDragEnd"
    let a_ondragenter = event_handler_attrib "onDragEnter"
    let a_ondragexit = event_handler_attrib "onDragExit"
    let a_ondragleave = event_handler_attrib "onDragLeave"
    let a_ondragover = event_handler_attrib "onDragOver"
    let a_ondragstart = event_handler_attrib "onDragStart"
    let a_ondrop = event_handler_attrib "onDrop"
    let a_onmousedown = event_handler_attrib "onMouseDown"
    let a_onmouseenter = event_handler_attrib "onMouseEnter"
    let a_onmouseleave = event_handler_attrib "onMouseLeave"
    let a_onmousemove = event_handler_attrib "onMouseMove"
    let a_onmouseout = event_handler_attrib "onMouseOut"
    let a_onmouseover = event_handler_attrib "onMouseOver"
    let a_onmouseup = event_handler_attrib "onMouseUp"
    let a_onselect = event_handler_attrib "onSelect"
    let a_ontouchcancel = event_handler_attrib "onTouchCancel"
    let a_ontouchend = event_handler_attrib "onTouchEnd"
    let a_ontouchmove = event_handler_attrib "onTouchMove"
    let a_ontouchstart = event_handler_attrib "onTouchStart"
    let a_ontransitionend = event_handler_attrib "onTransitionEnd"
    let a_onscroll = event_handler_attrib "onScroll"
    let a_onwheel = event_handler_attrib "onWheel"

    let textarea = Unsafe.leaf "textarea"

    let select = Unsafe.node "select"

    let pcdata = pcdata

    let rec to_react_element = function
      | `String s -> to_react_element (span [ pcdata s ])
      | `Element e -> e
  end
end
