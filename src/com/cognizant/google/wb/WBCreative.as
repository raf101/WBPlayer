﻿package com.cognizant.google.wb {	import com.cognizant.google.video.components.ExPlayer;	import com.cognizant.google.video.events.CustomVideoEvent;	import com.cognizant.google.wb.components.WBPlayerSD;	import com.cognizant.google.wb.events.WBEvent;	import com.cognizant.google.wb.data.WBVideos;	import com.google.ads.studio.display.StudioLoader;	import com.google.ads.studio.events.StudioEvent;	import com.google.ads.studio.ProxyEnabler;	import com.google.ads.studio.utils.StudioClassAccessor;	import flash.display.DisplayObject;	import flash.display.MovieClip;	import flash.events.Event;	import flash.events.EventDispatcher;	import flash.events.TimerEvent;	import flash.net.URLRequest;	import flash.utils.Timer;				[Event(name="interacted",type="com.cognizant.google.wb.events.WBEvent")]	[Event(name="autoExpanded",type="com.cognizant.google.wb.events.WBEvent")]	[Event(name="autoExpandEnd",type="com.cognizant.google.wb.events.WBEvent")]	[Event(name="expanded",type="com.cognizant.google.wb.events.WBEvent")]	[Event(name="collapsed",type="com.cognizant.google.wb.events.WBEvent")]	[Event(name="videoAutoplayEnd",type="com.cognizant.google.wb.events.WBEvent")]	[Event(name="videoAutoAdvanced",type="com.cognizant.google.wb.events.WBEvent")]	[Event(name="videoSkipped",type="com.cognizant.google.wb.events.WBEvent")]	[Event(name="enterFullscreen",type="com.cognizant.google.wb.events.WBEvent")]	[Event(name="exitFullscreen",type="com.cognizant.google.wb.events.WBEvent")]		/**	 * ...	 * @author Rafael Nepomuceno	 * @created 6/17/2015 1:38 AM	 * 	 * Please make sure to always update your working files.	 * 	 */	public class WBCreative extends EventDispatcher {		private static var __instance:WBCreative;				public var mcShell:MovieClip;		public var mcCollapsed:MovieClip;		public var mcExpanded:MovieClip;				public var vidIntro:ExPlayer;		public var vidCollapsed:WBPlayerSD;		public var vidExpanded:WBPlayerSD;						/// loosely typed object		public var data:Object;				private var _autoExpandTimer:Timer;		private var _expanding:Object;		private var _enabler:ProxyEnabler;		private var _trackings:WBTrackings;		private var _helper:WBHelper;		private var _wbVideos:WBVideos;		private var _rmdc:WBRMDC;				private var _isInteracted:Boolean;		private var _isExpanded:Boolean;		private var _isAutoExpanded:Boolean;		private var _isStartExpanded:Boolean;				public function get isInteracted ():Boolean { return _isInteracted; }		public function get isExpanded ():Boolean { return _isExpanded; }		public function get isAutoExpanded ():Boolean { return _isAutoExpanded; }		public function get rmdc ():WBRMDC { return _rmdc; }		public function get wbVideos ():WBVideos { return _wbVideos; }		public function get helper ():WBHelper { return _helper; }						public static function getInstance ():WBCreative {			if (!__instance) __instance = new WBCreative(new SingletonEnforcer());			return __instance;		}				public function WBCreative (s:SingletonEnforcer) {			_enabler = ProxyEnabler.getInstance();			_expanding = StudioClassAccessor.getInstance(StudioClassAccessor.CLASS_EXPANDING);			_rmdc = new WBRMDC();			_helper = new WBHelper();			_trackings = new WBTrackings();						_rmdc.init();						if (_expanding) {				_expanding.addEventListener(					StudioEvent.COLLAPSE_COMPLETE, collapsedHandler);				_expanding.addEventListener(					StudioEvent.EXPAND, expandedHandler);			}						_enabler.addEventListener(StudioEvent.EXIT, exitHandler);			ExPlayer.addAllEventListeners(videoEventsHandler);		}						public function exit (type:Object):void {			_trackings.exit(type);		}				public function counter (type:Object):void {			_trackings.counter(type);		}				public function startTimer (type:Object):void {			_trackings.startTimer(type);		}				public function stopTimer (type:Object):void {			_trackings.stopTimer(type);		}				public function stopAllTimers ():void {			_trackings.stopAllTimers();		}								public function startAutoExpand (timeout:int = 0):void {			if (_isStartExpanded) return;			_isStartExpanded = true;						if (_expanding) {				if (timeout > 0) {					_autoExpandTimer = new Timer(timeout, 1);					_autoExpandTimer.addEventListener(TimerEvent.TIMER_COMPLETE, autoExpandTimeoutHandler);					_autoExpandTimer.start();					}								_isAutoExpanded = true;				_expanding.startExpanded();				dispatchEvent(new WBEvent(WBEvent.AUTO_EXPANDED));			}					}				public function expand ():void {			if (isExpanded) return;						if (_expanding) {				interact();				_isExpanded = true;				_expanding.expand();			}		}				public function collapse (isManualClose:Boolean = false):void {			if (!isExpanded) return;						if (_expanding) {				interact();				_isExpanded = false;				_isAutoExpanded = false;				_expanding.collapse();								if (isManualClose) 					_enabler.reportManualClose();			}		}				public function interact ():void {			_isInteracted = true;			if (_autoExpandTimer) {				_autoExpandTimer.reset();				_autoExpandTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, autoExpandTimeoutHandler);				_autoExpandTimer = null;			}			dispatchEvent(new WBEvent(WBEvent.INTERACTED));		}				public function videoAutoAdvance ():void {			dispatchEvent(new WBEvent(WBEvent.VIDEO_AUTO_ADVANCED));		}				public function videoSkip ():void {			dispatchEvent(new WBEvent(WBEvent.VIDEO_SKIPPED));		}				public function enterFullscreen (data:Object = null):void {			dispatchEvent(new WBEvent(WBEvent.ENTER_FULLSCREEN, data));		}				public function exitFullscreen (data:Object = null):void {			dispatchEvent(new WBEvent(WBEvent.EXIT_FULLSCREEN, data));		}								private function autoExpandTimeoutHandler (e:TimerEvent):void {			dispatchEvent(new WBEvent(WBEvent.AUTO_EXPAND_END));			collapse();		}				private function exitHandler (e:StudioEvent):void {			interact();			if (isExpanded) {				if (isAutoExpanded)					dispatchEvent(new WBEvent(WBEvent.AUTO_EXPAND_END));				collapse();			}		}				private function expandedHandler (e:StudioEvent):void {			_isExpanded = true;			dispatchEvent(new WBEvent(WBEvent.EXPANDED));		}				private function collapsedHandler (e:StudioEvent):void {			_isExpanded = false;			_isAutoExpanded = false;			dispatchEvent(new WBEvent(WBEvent.COLLAPSED));		}								private function videoEventsHandler (e:CustomVideoEvent):void {			switch (e.type) {				case CustomVideoEvent.PREVIEW_COMPLETE:					dispatchEvent(new WBEvent(WBEvent.VIDEO_AUTOPLAY_END, e.data));				case CustomVideoEvent.COMPLETE:					if (isAutoExpanded && !isInteracted) {						dispatchEvent(new WBEvent(WBEvent.AUTO_EXPAND_END));						collapse();					}					break;			}		}					}}import com.cognizant.google.video.utils.dateSwap;import com.google.ads.studio.display.StudioLoader;import flash.display.MovieClip;import flash.events.Event;import flash.net.URLRequest;import flash.display.DisplayObject;class WBHelper {	public function WBHelper () { }		/**	 * Helper function for loading external file.	 * 	 * @param	url Url of the to be loaded.	 * @param	onComplete Callback function when it loads succesfully.	 * 	 * @return	Instance of the loader.	 * 	 * @see https://gist.github.com/raf101/eed7d6a10b375460ebbf#file-loaddisplay	 */	public function loadDisplay (url:String, onComplete:Function = null):StudioLoader {		var loader:StudioLoader = new StudioLoader();		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function (e:Event):void {			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, arguments.callee);			if (onComplete != null) onComplete(e);		});		loader.load(new URLRequest(url));				return loader;	}			/**	 * Helper function for date swapping.	 * 	 * @param	schedsData ScheduledData Array	 * @param	currentDate For testing	 * 	 * @return 	ScheduleData.id	 * 	 * @see https://gist.github.com/raf101/4c340c39a07e98a772aa#file-dateswap	 */	public function dateSwap (schedsData:Array, currentDate:Date = null):String {		return com.cognizant.google.video.utils.dateSwap(schedsData, currentDate);	}		/**	 * Helper function for end frame functionality.	 * 	 * @param	target Parent of all the MovieClips to end.	 * @param	ignoreTargets Child's names array to ignore.	 */	public function endFrame (target:MovieClip, ignoreTargets:Array = null):void {		for each ( var ignoreTarget:String in ignoreTargets ) {			if (target.name == ignoreTarget) {				return;						}		}				target.gotoAndStop(target.totalFrames);				target.addEventListener(Event.ENTER_FRAME, function ():void {			target.removeEventListener(Event.ENTER_FRAME, arguments.callee);			target.stage.invalidate();		});				target.addEventListener(Event.RENDER, function():void {			target.removeEventListener(Event.RENDER, arguments.callee);			var child:DisplayObject;			var len:int = target.numChildren;			for (var i:int = 0; i < len; i++) {				child = target.getChildAt(i);				if (child is MovieClip) {					endFrame(MovieClip(child), ignoreTargets);				}			}		});	}}class SingletonEnforcer {}