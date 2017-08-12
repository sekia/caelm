open Html_types
open Caelm_reactjs_tyxml_base_intf
open Caelm_reactjs_wrapper

module Make (Reactjs : Caelm_reactjs.S) : sig
  module Base : sig
    module Properties : Caelm_reactjs_wrapper.S.Properties

    module Xml : sig
      type attrib = string * Properties.Value.t

      type elt = Caelm_reactjs_wrapper.Make(Reactjs).node

      type event_handler = Properties.Value.event_handler

      include Xml_sigs.NoWrap
        with type attrib := attrib
         and type elt := elt
         and type event_handler := event_handler
         and type uri = Uri.t

      val react_component :
        Reactjs.component_class -> ?props:attrib list -> elt list -> elt
    end

    module Svg : Svg_sigs.Make(Xml).T

    module Html : Html_sigs.Make(Xml)(Svg).T
  end

  module Xml : module type of Base.Xml

  module Html : sig
    include module type of Base.Html

    val a_key : string -> [> `Key ] attrib
    val a_dangerouslysetinnerhtml :
      string -> [> `DangerouslySetInnerHTML ] attrib

    (* Redefine ReactJS's boolean attributes *)
    val a_async : bool -> [> `Async ] attrib
    val a_autofocus : bool -> [> `Autofocus ] attrib
    val a_autoplay : bool -> [> `Autoplay ] attrib
    val a_checked : bool -> [> `Checked ] attrib
    val a_controls : bool -> [> `Controls ] attrib
    val a_defer : bool -> [> `Defer ] attrib
    val a_disabled : bool -> [> `Disabled ] attrib
    val a_formnovalidate : bool -> [> `Formnovalidate ] attrib
    val a_hidden : bool -> [> `Hidden ] attrib
    val a_loop : bool -> [> `Loop ] attrib
    val a_multiple : bool -> [> `Multiple ] attrib
    val a_muted : bool -> [> `Muted ] attrib
    val a_novalidate : bool -> [> `Novalidate ] attrib
    val a_open : bool -> [> `Open ] attrib
    val a_readonly : bool -> [> `Readonly ] attrib
    val a_required : bool -> [> `Required ] attrib
    val a_reversed : bool -> [> `Reversed ] attrib
    val a_scoped : bool -> [> `Scoped ] attrib
    val a_seamless : bool -> [> `Seamless ] attrib
    val a_selected : bool -> [> `Selected ] attrib

    (* ReactJS's synthetic event handlers *)

    (* Animation events *)
    val a_onanimationend :
      (element animation_event Js.t -> unit) -> [> `OnAnimationEnd ] attrib
    val a_onanimationiteration :
      (element animation_event Js.t -> unit) ->
      [> `OnAnimationIteration ] attrib
    val a_onanimationstart :
      (element animation_event Js.t -> unit) -> [> `OnAnimationStart ] attrib

    (* Clipboard events *)
    val a_oncopy :
      (element clipboard_event Js.t -> unit) -> [> `OnCopy ] attrib
    val a_oncut :
      (element clipboard_event Js.t -> unit) -> [> `OnCut ] attrib
    val a_onpaste :
      (element clipboard_event Js.t -> unit) -> [> `OnPaste ] attrib

    (* Composition events *)
    val a_oncompositionend :
      (element composition_event Js.t -> unit) -> [> `OnCompositionEnd ] attrib
    val a_oncompositionstart :
      (element composition_event Js.t -> unit) ->
      [> `OnCompositionStart ] attrib
    val a_oncompositionupdate :
      (element composition_event Js.t -> unit) ->
      [> `OnCompositionUpdate ] attrib

    (* Focus events *)
    val a_onblur : (element focus_event Js.t -> unit) -> [> `OnBlur ] attrib
    val a_onfocus : (element focus_event Js.t -> unit) -> [> `OnFocus ] attrib

    (* Form events *)
    val a_onchange : (input_element event Js.t -> unit) -> [> `OnChange ] attrib
    val a_oninput : (input_element event Js.t -> unit) -> [> `OnInput ] attrib
    val a_onsubmit : (element event Js.t -> unit) -> [> `OnSubmit ] attrib

    (* Image events *)
    val a_onerror : (element event Js.t -> unit) -> [> `OnError ] attrib
    val a_onload : (image_element event Js.t -> unit) -> [> `OnLoad] attrib

    (* Keyboard events *)
    val a_onkeydown :
      (element keyboard_event Js.t -> unit) -> [> `OnKeyDown ] attrib
    val a_onkeypress :
      (element keyboard_event Js.t -> unit) -> [> `OnKeyPress ] attrib
    val a_onkeyup :
      (element keyboard_event Js.t -> unit) -> [> `OnKeyUp ] attrib

    (* Media events*)
    val a_onabort :
      (media_element event Js.t -> unit) -> [> `OnAbort ] attrib
    val a_oncanplay :
      (media_element event Js.t -> unit) -> [> `OnCanPlay ] attrib
    val a_oncanplaythrough :
      (media_element event Js.t -> unit) -> [> `OnCanPlayThrough ] attrib
    val a_ondurationchange :
      (media_element event Js.t -> unit) -> [> `OnDurationChange ] attrib
    val a_onemptied :
      (media_element event Js.t -> unit) -> [> `OnEmptied ] attrib
    val a_onencrypted :
      (media_element event Js.t -> unit) -> [> `OnEncrypted ] attrib
    val a_onended :
      (media_element event Js.t -> unit) -> [>  `OnEnded ] attrib
    (* a_onerror's signature is in image events section. *)
    val a_onloadeddata :
      (media_element event Js.t -> unit) -> [> `OnLoadedData ] attrib
    val a_onloadedmetadata :
      (media_element event Js.t -> unit) -> [> `OnLoadedMetaData ] attrib
    val a_onloadstart :
      (media_element event Js.t -> unit) -> [> `OnLoadStart ] attrib
    val a_onpause :
      (media_element event Js.t -> unit) -> [> `OnPause ] attrib
    val a_onplay :
      (media_element event Js.t -> unit) -> [> `OnPlay ] attrib
    val a_onplaying :
      (media_element event Js.t -> unit) -> [> `OnPlaying ] attrib
    val a_onprogress :
      (media_element event Js.t -> unit) -> [> `OnProgress ] attrib
    val a_onratechange :
      (media_element event Js.t -> unit) -> [> `OnRateChange ] attrib
    val a_onseeked :
      (media_element event Js.t -> unit) -> [> `OnSeeked ] attrib
    val a_onseeking :
      (media_element event Js.t -> unit) -> [> `OnSeeking ] attrib
    val a_onstalled :
      (media_element event Js.t -> unit) -> [> `OnStalled ] attrib
    val a_onsuspend :
      (media_element event Js.t -> unit) -> [> `OnSuspend ] attrib
    val a_ontimeupdate :
      (media_element event Js.t -> unit) -> [> `OnTimeUpdate ] attrib
    val a_onvolumechange :
      (media_element event Js.t -> unit) -> [> `OnVolumeChange ] attrib
    val a_onwaiting :
      (media_element event Js.t -> unit) -> [> `OnWaiting ] attrib

    (* Mouse events*)
    val a_onclick :
      (element mouse_event Js.t -> unit) -> [> `OnClick ] attrib
    val a_oncontextmenu :
      (element mouse_event Js.t -> unit) -> [> `OnContextMenu ] attrib
    val a_ondoubleclick :
      (element mouse_event Js.t -> unit) -> [> `OnDblClick ] attrib
    val a_ondrag :
      (element mouse_event Js.t -> unit) -> [> `OnDrag ] attrib
    val a_ondragend :
      (element mouse_event Js.t -> unit) -> [> `OnDragEnd ] attrib
    val a_ondragenter :
      (element mouse_event Js.t -> unit) -> [> `OnDragEnter ] attrib
    val a_ondragexit :
      (element mouse_event Js.t -> unit) -> [> `OnDragExit ] attrib
    val a_ondragleave :
      (element mouse_event Js.t -> unit) -> [> `OnDragLeave ] attrib
    val a_ondragover :
      (element mouse_event Js.t -> unit) -> [> `OnDragOver ] attrib
    val a_ondragstart :
      (element mouse_event Js.t -> unit) -> [> `OnDragStart ] attrib
    val a_ondrop :
      (element mouse_event Js.t -> unit) -> [> `OnDrop ] attrib
    val a_onmousedown :
      (element mouse_event Js.t -> unit) -> [> `OnMouseDown ] attrib
    val a_onmouseenter :
      (element mouse_event Js.t -> unit) -> [> `OnMouseEnter ] attrib
    val a_onmouseleave :
      (element mouse_event Js.t -> unit) -> [> `OnMouseLeave ] attrib
    val a_onmousemove :
      (element mouse_event Js.t -> unit) -> [> `OnMouseMove ] attrib
    val a_onmouseout :
      (element mouse_event Js.t -> unit) -> [> `OnMouseOut ] attrib
    val a_onmouseover :
      (element mouse_event Js.t -> unit) -> [> `OnMouseOver ] attrib
    val a_onmouseup :
      (element mouse_event Js.t -> unit) -> [> `OnMouseUp ] attrib

    (* Select events *)
    val a_onselect :
      (input_element event Js.t -> unit) -> [> `OnSelect ] attrib

    (* Touch events *)
    val a_ontouchcancel :
      (element touch_event Js.t -> unit) -> [> `OnTouchCancel ] attrib
    val a_ontouchend :
      (element touch_event Js.t -> unit) -> [> `OnTouchEnd ] attrib
    val a_ontouchmove :
      (element touch_event Js.t -> unit) -> [> `OnTouchMove ] attrib
    val a_ontouchstart :
      (element touch_event Js.t -> unit) -> [> `OnTouchStart ] attrib

    (* Transition events *)
    val a_ontransitionend :
      (element event Js.t -> unit) -> [> `OnTransitionEnd ] attrib

    (* UI events *)
    val a_onscroll :
      (element event Js.t -> unit) -> [> `OnScroll ] attrib

    (* Wheel events *)
    val a_onwheel :
      (element wheel_event Js.t -> unit) -> [> `OnWheel ] attrib

    val html :
      ?a:[< html_attrib | event_attrib | `DangerouslySetInnerHTML | `Key
         ] attrib list -> [< `Head ] elt -> [< `Body ] elt -> [> `Html ] elt

    val head :
      ?a:[< head_attrib | event_attrib | `DangerouslySetInnerHTML | `Key
         ] attrib list ->
      [< `Title ] elt -> head_content_fun elt list -> [> head ] elt

    val body :
      ([< body_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< body_content_fun ], [> body ]) star

    val footer :
      ([< common | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< flow5_without_header_footer ], [> `Footer ]) star

    val header :
      ([< common | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< flow5_without_header_footer ], [> `Header ]) star

    val section :
      ([< section_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< section_content_fun ], [> section ]) star

    val nav :
      ([< nav_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< nav_content_fun ], [> nav ]) star

    val h1 :
      ([< h1_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< h1_content_fun ], [> h1 ]) star

    val h2 :
      ([< h2_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< h2_content_fun ], [> h2 ]) star

    val h3 :
      ([< h3_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< h3_content_fun ], [> h3 ]) star

    val h4 :
      ([< h4_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< h4_content_fun ], [> h4 ]) star

    val h5 :
      ([< h5_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< h5_content_fun ], [> h5 ]) star

    val h6 :
      ([< h6_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< h6_content_fun ], [> h6 ]) star

    val hgroup :
      ([< hgroup_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< hgroup_content_fun ], [> hgroup ]) star

    val address :
      ([< address_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< address_content_fun ], [> address ]) star

    val article :
      ([< article_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< article_content_fun ], [> article ]) star

    val aside :
      ([< aside_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< aside_content_fun ], [> aside ]) star

    val main :
      ([< main_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< main_content_fun ], [> main ]) star

    val p :
      ([< p_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< p_content_fun ], [> p ]) star

    val pre :
      ([< pre_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< pre_content_fun ], [> pre ]) star

    val blockquote :
      ([< blockquote_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< blockquote_content_fun ], [> blockquote ]) star

    val div :
      ([< div_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< div_content_fun ], [> div ]) star

    val dl :
      ([< dl_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< dl_content_fun ], [> dl ]) star

    val ol :
      ([< ol_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< ol_content_fun ], [> ol ]) star

    val ul :
      ([< ul_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< ul_content_fun ], [> ul ]) star

    val dd :
      ([< dd_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< dd_content_fun ], [> dd ]) star

    val dt :
      ([< dt_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< dt_content_fun ], [> dt ]) star

    val li :
      ([< li_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< li_content_fun ], [> li ]) star

    val figcaption :
      ([< figcaption_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< figcaption_content_fun ], [> figcaption ]) star

    val figure :
      ?figcaption:[ `Top of [< `Figcaption ] elt
                  | `Bottom of [< `Figcaption ] elt ] ->
      ([< figure_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< figure_content_fun ], [> figure ]) star

    val hr :
      ([< hr_attrib | event_attrib | `Key ], [> hr ]) nullary

    val b :
      ([< b_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< b_content_fun ], [> b ]) star

    val i :
      ([< i_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< i_content_fun ], [> i ]) star

    val u :
      ([< u_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< u_content_fun ], [> u ]) star

    val small :
      ([< small_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< small_content_fun ], [> small ]) star

    val sub :
      ([< sub_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< sub_content_fun ], [> sub ]) star

    val sup :
      ([< sup_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< sup_content_fun ], [> sup ]) star

    val mark :
      ([< mark_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< mark_content_fun ], [> mark ]) star

    val wbr :
      ([< wbr_attrib | event_attrib | `Key ], [> wbr ]) nullary

    val bdo :
      dir:[< `Ltr | `Rtl ] ->
      ([< common | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< phrasing ], [> `Bdo ]) star

    val abbr :
      ([< abbr_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< abbr_content_fun ], [> abbr ]) star

    val br :
      ([< br_attrib | event_attrib | `Key ], [> br ]) nullary

    val cite :
      ([< cite_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< cite_content_fun ], [> cite ]) star

    val code :
      ([< code_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< code_content_fun ], [> code ]) star

    val dfn :
      ([< dfn_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< dfn_content_fun ], [> dfn ]) star

    val em :
      ([< em_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< em_content_fun ], [> em ]) star

    val kbd :
      ([< kbd_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< kbd_content_fun ], [> kbd ]) star

    val q :
      ([< q_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< q_content_fun ], [> q ]) star

    val samp :
      ([< samp_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< samp_content_fun ], [> samp ]) star

    val span :
      ([< span_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< span_content_fun ], [> span ]) star

    val strong :
      ([< strong_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< strong_content_fun ], [> strong ]) star

    val time :
      ([< time_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< time_content_fun ], [> time ]) star

    val var :
      ([< var_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< var_content_fun ], [> var ]) star

    val a :
      ([< a_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ], 'a,
       [> `A of 'a ]) star

    val del :
      ([< del_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ], 'a,
       [> `Del of 'a ]) star

    val ins :
      ([< ins_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ], 'a,
       [> `Ins of 'a ]) star

    val img :
      src:Xml.uri ->
      alt:text ->
      ([< img_attrib | event_attrib | `Key ], [> img ]) nullary

    val iframe :
      ([< common | event_attrib | `DangerouslySetInnerHTML | `Key | `Src | `Name
       | `Sandbox | `Seamless | `Width | `Height ], [< `PCDATA ], [> `Iframe ]
      ) star

    val object_ :
      ?params:[< `Param ] elt list ->
      ([< common | event_attrib | `DangerouslySetInnerHTML | `Key | `Data
       | `Form | `Mime_type | `Height | `Width | `Name | `Usemap ], 'a,
       [> `Object of 'a ]) star

    val param :
      ([< param_attrib | event_attrib | `Key ], [> param ]) nullary

    val embed :
      ([< common | event_attrib | `Key | `Src | `Height | `Mime_type | `Width ],
       [> `Embed ]) nullary

    val audio :
      ?src:Xml.uri ->
      ?srcs:[< source ] elt list ->
      ([< audio_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ], 'a,
       [> 'a audio ]) star

    val video :
      ?src:Xml.uri ->
      ?srcs:[< source ] elt list ->
      ([< video_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ], 'a,
       [> 'a video ]) star

    val canvas :
      ([< canvas_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ], 'a,
       [> 'a canvas ]) star

    val source :
      ([< source_attrib | event_attrib | `Key ], [> source ]) nullary

    val area :
      alt:text ->
      ([< common | event_attrib | `Key | `Alt | `Coords | `Shape | `Target
       | `Rel | `Media | `Hreflang | `Mime_type], [> `Area ]) nullary

    val map :
      ([< map_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ], 'a,
       [> `A of 'a ]) star

    val caption :
      ([< caption_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< caption_content_fun ], [> caption ]) star

    val table :
      ?caption:[< caption ] elt ->
      ?columns:[< colgroup ] elt list ->
      ?thead:[< thead ] elt ->
      ?tfoot:[< tfoot ] elt ->
      ([< table_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< table_content_fun ], [> table ]) star

    val tablex :
      ?caption:[< caption ] elt ->
      ?columns:[< colgroup ] elt list ->
      ?thead:[< thead ] elt ->
      ?tfoot:[< tfoot ] elt ->
      ([< tablex_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< tablex_content_fun ], [> tablex ]) star

    val colgroup :
      ([< colgroup_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< colgroup_content_fun ], [> colgroup ]) star

    val col : ([< col_attrib | event_attrib | `Key ], [> col ]) nullary

    val thead :
      ([< thead_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< thead_content_fun ], [> thead ]) star

    val tbody :
      ([< tbody_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< tbody_content_fun ], [> tbody ]) star

    val tfoot :
      ([< tfoot_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< tfoot_content_fun ], [> tfoot ]) star

    val td :
      ([< td_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< td_content_fun ], [> td ]) star

    val th :
      ([< th_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< th_content_fun ], [> th ]) star

    val tr :
      ([< tr_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< tr_content_fun ], [> tr ]) star

    val form :
      ([< form_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< form_content_fun ], [> form ]) star

    val fieldset :
      ?legend:[< `Legend ] elt ->
      ([< common | event_attrib | `DangerouslySetInnerHTML | `Key | `Disabled
       | `Form | `Name ], [< flow5 ], [> `Fieldset ]) star

    val legend :
      ([< legend_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< legend_content_fun ], [> legend ]) star

    val label :
      ([< label_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< label_content_fun ], [> label ]) star

    val input :
      ([< input_attrib | event_attrib | `Key ], [> input ]) nullary

    val button :
      ([< button_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< button_content_fun ], [> button ]) star

    val select :
      ([< select_attrib | event_attrib | `DangerouslySetInnerHTML | `Key
       | `Value ], [< select_content_fun ], [> select ]) star

    val datalist :
      ?children:[< `Options of [< `Option ] elt list
                | `Phras of [< phrasing ] elt list ] ->
      ([< common | event_attrib | `Key ], [> `Datalist ]) nullary

    val optgroup :
      label:text ->
      ([< common | event_attrib | `DangerouslySetInnerHTML | `Key | `Disabled
       | `Label ], [< `Option ], [> `Optgroup ]) star

    val option :
      ([< option_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< option_content_fun ], [> selectoption ]) unary

    val textarea :
      ([< textarea_attrib | event_attrib | `Key | `Value ],
       [> textarea ]) nullary

    val keygen :
      ([< keygen_attrib | event_attrib | `Key ], [> keygen ]) nullary

    val progress :
      ([< progress_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< progress_content_fun ], [> progress ]) star

    val meter :
      ([< meter_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< meter_content_fun ], [> meter ]) star

    val output_elt :
      ([< output_elt_attrib | event_attrib | `DangerouslySetInnerHTML | `Key ],
       [< output_elt_content_fun ], [> output_elt ]) star

    val pcdata : string -> [> `PCDATA ] elt

    val to_react_element : 'a elt -> Reactjs.element Js.t
  end
end
