﻿package com.google.cognizant.video.events {	import com.google.cognizant.video.data.VideoEventData;	import flash.events.Event;		/**	 * ...	 * @author Rafael Nepomuceno	 * @created 6/7/2015 9:28 PM	 */	public class CustomVideoEvent extends Event {		public static const BUFFERED:String = 'buffered';		public static const DURATION:String = 'duration';		public static const PLAY:String = 'play';		public static const PAUSE:String = 'pause';		public static const MUTE:String = 'mute';		public static const UNMUTE:String = 'unMute';		public static const FIRST_QUARTILE:String = 'firstQuartile';		public static const MID_POINT:String = 'midPoint';		public static const THIRD_QUARTILE:String = 'thirdQuartile';		public static const PLAYHEAD_MOVE:String = 'playheadMove';		public static const COMPLETE:String = 'complete';		public static const REPLAY:String = 'replay';				public static const SKIP:String = 'skip';		public static const PREVIEW_COMPLETE:String = 'previewComplete';		public static const COMPLETE_ALL:String = 'completeAll';		public static const VIDEO_VIEW_TIMER_START:String = 'videoVideoTimerStart';		public static const VIDEO_VIEW_TIMER_STOP:String = 'videoVideoTimerStop';		public static const USER_CLICK_TO_PLAY:String = 'userClickToPlay';		public static const USER_SEEK:String = 'userSeek';		public static const USER_PLAY:String = 'userPlay';		public static const USER_PAUSE:String = 'userPause';		public static const USER_MUTE:String = 'userMute';		public static const USER_UNMUTE:String = 'userUnmute';		public static const USER_REPLAY:String = 'userReplay';		public static const CONNECTION_ERROR:String = 'connectionError';				private var _data:VideoEventData;				public function get data ():VideoEventData { return _data };				public static function getAllStudioVideoEvents ():Array {			return ['play','buffered','replay','pause','stop','mute','unMute','volumeChange','firstQuartile','midPoint','thirdQuartile','complete','backwardsSeek','playheadMove','stateChange','netConnectionPreInitialize','netConnectionAvailable','netConnectionStatus','netStreamPreInitialize','netStreamAvailable','netStreamStatus','netStreamMetaData','netStreamCuePoint','connectionError','duration'];		}		public static function getAllEvents ():Array {			return [BUFFERED, DURATION, PLAY, PAUSE, MUTE, UNMUTE, FIRST_QUARTILE, MID_POINT, THIRD_QUARTILE, PLAYHEAD_MOVE, COMPLETE, REPLAY, SKIP, PREVIEW_COMPLETE, COMPLETE_ALL, USER_SEEK, USER_PLAY, USER_PAUSE, USER_MUTE, USER_UNMUTE, USER_REPLAY, CONNECTION_ERROR];		}								public function CustomVideoEvent ( type:String, data:VideoEventData = null, bubbles:Boolean=false, cancelable:Boolean=false ) { 			super(type, bubbles, cancelable);			_data = data;		} 				public override function clone ():Event { 			return new CustomVideoEvent( type, data, bubbles, cancelable );		} 				public override function toString ():String { 			return formatToString( 'CustomVideoEvent', 'type', 'data', 'bubbles', 'cancelable', 'eventPhase' ); 		}			}	}