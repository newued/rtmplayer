package com.dp.Custom {
	import flash.events.Event;
	public class FlashVarsEvent extends Event {
		public static const FLASHVARS_CHANGE = "flashvars_change";
		public static const WH_CHANGE = "wh_change";
		public static const V_CHANGE = "v_change";
		public static const C_CHANGE = "c_change";
		public static const H_CHANGE = "h_change";
		public static const TM_CHANGE = "tm_change";
		public static const CONFIGTM_CHANGE = "configtm_change";
		public static const TMDEFAULT_CHANGE = "tmdefault_change";
		public static const SUBTITLES_CHANGE = "subtitles_change";
		public static const DOTS_CHANGE = "dots_change";
		public static const LIGHT_CHANGE = "light_change";
		public var obj: Object = {};
		public var sender: String;
		public function FlashVarsEvent(eventType: String,_obj:Object,_sender:String) {
			super(eventType,true);
			obj=_obj;
			sender=_sender;
			
		}
	}
}