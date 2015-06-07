package com.google.cognizant.video.events {
	import com.google.cognizant.video.data.VideoEventData;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Rafael Nepomuceno
	 * @created 6/7/2015 9:28 PM
	 */
	public class CustomVideoEvent extends Event {
		public static const BUFFERED:String = 'buffered';
		public static const PLAY:String = 'play';
		public static const PAUSE:String = 'pause';
		public static const MUTE:String = 'mute';
		public static const UNMUTE:String = 'unmute';
		public static const FIRST_QUARTILE:String = 'firstQuartile';
		public static const MID_POINT:String = 'midPoint';
		public static const THIRD_QUARTILE:String = 'thirdQuartile';
		public static const COMPLETE:String = 'complete';
		public static const REPLAY:String = 'replay';
		public static const ERROR:String = 'error';
		public static const SEEK:String = 'seek';
		public static const SKIP:String = 'skip';
		public static const COMPLETE_ALL:String = 'completeAll';
		public static const USER_PLAY:String = 'userPlay';
		public static const USER_PAUSE:String = 'userPause';
		public static const USER_MUTE:String = 'userMute';
		public static const USER_UNMUTE:String = 'userUnmute';
		public static const USER_REPLAY:String = 'userReplay';
		
		private var _data:VideoEventData;
		
		public function get data ():VideoEventData { return _data };
		
		public static function getAllEvents ():Array {
			return [BUFFERED, PLAY, PAUSE, MUTE, UNMUTE, FIRST_QUARTILE, MID_POINT, THIRD_QUARTILE, COMPLETE, REPLAY, ERROR, SEEK, SKIP, COMPLETE_ALL, USER_PLAY, USER_PAUSE, USER_MUTE, USER_UNMUTE, USER_REPLAY];
		}
		
		
		
		public function CustomVideoEvent ( type:String, data:VideoEventData = null, bubbles:Boolean=false, cancelable:Boolean=false ) { 
			super(type, bubbles, cancelable);
			_data = data || new VideoEventData();
		} 
		
		public override function clone ():Event { 
			return new CustomVideoEvent( type, bubbles, cancelable );
		} 
		
		public override function toString ():String { 
			return formatToString( "CustomVideoEvent", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
		
	}
	
}