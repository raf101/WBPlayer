package com.cognizant.google.wb {
	import com.cognizant.google.video.components.ExPlayer;
	import com.cognizant.google.wb.components.WBPlayer;
	import com.cognizant.google.wb.events.WBEvent;
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	
	[Event(name="interacted",type="com.cognizant.google.wb.events.WBEvent")]
	[Event(name="autoExpanded",type="com.cognizant.google.wb.events.WBEvent")]
	[Event(name="expanded",type="com.cognizant.google.wb.events.WBEvent")]
	[Event(name="collapsed",type="com.cognizant.google.wb.events.WBEvent")]
	[Event(name="autoExpandEnd",type="com.cognizant.google.wb.events.WBEvent")]
	[Event(name="videoAutoplayEnd",type="com.cognizant.google.wb.events.WBEvent")]
	[Event(name="videoAutoAdvanced",type="com.cognizant.google.wb.events.WBEvent")]
	[Event(name="enterFullscreen",type="com.cognizant.google.wb.events.WBEvent")]
	[Event(name="exitFullscreen",type="com.cognizant.google.wb.events.WBEvent")]
	
	/**
	 * ...
	 * @author Rafael Nepomuceno
	 * @created 6/17/2015 1:38 AM
	 */
	public class WBCreative extends EventDispatcher {
		private var __instance:WBCreative;
		
		public var collapsed:DisplayObject;
		public var expanded:DisplayObject;
		
		public var introVideo:ExPlayer;
		public var collapsedVideo:WBPlayer;
		public var expandedVideo:WBPlayer;
		
		
		/// loosely typed object
		public var data:Object;
		
		private var _autoExpandTimer:Timer;
		//private var _enabler:ProxyEnabler;
		
		
		public static function getInstance ():WBCreative {
			if (!__instance) __instance = new WBCreative(new SingletonEnforcer());
			return __instance;
		}
		public function WBCreative (s:SingletonEnforcer) {
			//_enabler = ProxyEnabler.getInstance();
		}
		
		public function startAutoExpand ( timeout:int ):void {
			if (!_autoExpandTimer) {
				_autoExpandTimer = new Timer(timeout, 1);
				_autoExpandTimer.addEventListener(TimerEvent.TIMER_COMPLETE, autoExpandTimeoutHandler);
			} else {
				_autoExpandTimer.delay = timeout;
			}
			_autoExpandTimer.reset();
			_autoExpandTimer.start();			
			
			dispatchEvent(new WBEvent(WBEvent.AUTO_EXPANDED));
		}
		
		public function expand (  ):void {
			// TODO Expand creative
			dispatchEvent(new WBEvent(WBEvent.EXPANDED));
		}
		
		public function collapse ( isManualClose:Boolean = false ):void {
			if (isManualClose) interact();
			
			// TODO Collapse creative
			dispatchEvent(new WBEvent(WBEvent.COLLAPSED));
		}
		
		public function interact (  ):void {
			dispatchEvent(new WBEvent(WBEvent.INTERACTED));
		}
		
		public function videoAutoAdvance (  ):void {
			dispatchEvent(new WBEvent(WBEvent.VIDEO_AUTO_ADVANCED));
		}
		
		public function enterFullscreen (  ):void {
			dispatchEvent(new WBEvent(WBEvent.ENTER_FULLSCREEN));
		}
		
		public function exitFullscreen (  ):void {
			dispatchEvent(new WBEvent(WBEvent.EXIT_FULLSCREEN));
		}
		
		
		
		private function autoExpandTimeoutHandler ( e:TimerEvent ):void {
			dispatchEvent(new WBEvent(WBEvent.AUTO_EXPAND_END));
		}
		
		
		
	}

}
class SingletonEnforcer {}