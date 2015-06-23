﻿package com.cognizant.google.wb {
	import com.cognizant.google.video.components.ExPlayer;
	import com.cognizant.google.video.data.VideoData;
	import com.cognizant.google.video.events.CustomVideoEvent;
	import com.cognizant.google.wb.config.WBConfig;
	import com.cognizant.google.wb.config.WBStaticVideos;
	import com.cognizant.google.wb.data.WBPlayerSettings;
	import com.cognizant.google.wb.data.WBVideos;
	import com.cognizant.google.wb.events.WBEvent;
	import com.google.ads.studio.events.StudioEvent;
	import com.google.ads.studio.ProxyEnabler;
	import com.google.ads.studio.utils.StudioClassAccessor;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	
	
	[Event(name="interacted",type="com.cognizant.google.wb.events.WBEvent")]
	[Event(name="autoExpanded",type="com.cognizant.google.wb.events.WBEvent")]
	[Event(name="autoExpandEnd",type="com.cognizant.google.wb.events.WBEvent")]
	[Event(name="expanded",type="com.cognizant.google.wb.events.WBEvent")]
	[Event(name="collapsed",type="com.cognizant.google.wb.events.WBEvent")]
	[Event(name="videoAutoplayEnd",type="com.cognizant.google.wb.events.WBEvent")]
	[Event(name="videoAutoAdvanced",type="com.cognizant.google.wb.events.WBEvent")]
	[Event(name="videoSkipped",type="com.cognizant.google.wb.events.WBEvent")]
	[Event(name="enterFullscreen",type="com.cognizant.google.wb.events.WBEvent")]
	[Event(name="exitFullscreen",type="com.cognizant.google.wb.events.WBEvent")]
	[Event(name="wbExit",type="com.cognizant.google.wb.events.WBEvent")]
	[Event(name="wbCounter",type="com.cognizant.google.wb.events.WBEvent")]
	[Event(name="wbStartTimer",type="com.cognizant.google.wb.events.WBEvent")]
	[Event(name="wbStopTimer",type="com.cognizant.google.wb.events.WBEvent")]
	
	/**
	 * ...
	 * @author Rafael Nepomuceno
	 * @created 6/17/2015 1:38 AM
	 * 
	 * Please make sure to always update your working files.
	 * 
	 */
	public class WBCreative extends EventDispatcher {
		private static var __instance:WBCreative;
		
		// Panel references
		public var mcCollapsed:MovieClip;
		public var mcExpanded:MovieClip;
		// Video references
		public var vidIntro:ExPlayer;
		public var vidCollapsed:ExPlayer;
		public var vidExpanded:ExPlayer;
		
		/// Play intro video or the actual video
		public var isIntro:Boolean;
		
		
		private var _shell:DisplayObject;
		private var _autoExpandTimer:Timer;
		private var _expanding:Object;
		private var _enabler:ProxyEnabler;
		private var _trackings:WBTrackings;
		private var _helper:WBHelper;
		private var _videos:WBVideos;
		private var _playerSettings:WBPlayerSettings;
		private var _rmdc:WBRMDC;
		private var _isIntro:Boolean;
		
		private var _isInteracted:Boolean;
		private var _isExpanded:Boolean;
		private var _isAutoExpanded:Boolean;
		private var _isStartExpanded:Boolean;
		private var _isInit:Boolean;
		
		/// loosely typed object storage
		private var _data:Object;
		
		
		// Read-only properties
		public function get shell ():DisplayObject { return _shell; }
		public function get isInteracted ():Boolean { return _isInteracted; }
		public function get isExpanded ():Boolean { return _isExpanded; }
		public function get isAutoExpanded ():Boolean { return _isAutoExpanded; }
		public function get playerSettings ():WBPlayerSettings { return _playerSettings; }
		public function get helper ():WBHelper { return _helper; }
		public function get rmdc ():WBRMDC { return _rmdc; }
		public function get data ():Object { return _data; }
		
		
		
		
		public static function getInstance ():WBCreative {
			if (!__instance) __instance = new WBCreative(new SingletonEnforcer());
			return __instance;
		}
		
		public function WBCreative (s:SingletonEnforcer) {}
		
		/**
		 * This should be called once after HTMLEnabler.init.
		 * 
		 * Sets up RMDC (WBRMDC)
		 * Sets up video urls to be used. (WBPlayerSettings)
		 * Sets up trackings. (WBTrackings)
		 * Sets up expanding. (Expanding)
		 * Sets up helper. (Helper)
		 * 
		 * @param	shell - Shell reference.
		 */
		public function init (shell:DisplayObject = null):void {
			if (_isInit) throw new Error('[WBCreative] WBCreative::init was already called.');
			_isInit = true;
			
			_data = { };
			_enabler = ProxyEnabler.getInstance();
			_expanding = StudioClassAccessor.getInstance(StudioClassAccessor.CLASS_EXPANDING);
			_helper = new WBHelper(this);
			_trackings = new WBTrackings();
			_playerSettings = new WBPlayerSettings();
			isIntro = WBConfig.HAS_INTRO_VIDEO;
			
			if (WBConfig.IS_RMDC) {
				_rmdc = new WBRMDC();
				_rmdc.init();
				
				_videos = _rmdc.getWeightedVideos();
				_playerSettings.init(_videos);
			} else {
				setupStaticVideos();
			}
			
			if (_expanding) {
				_expanding.addEventListener(
					StudioEvent.COLLAPSE_COMPLETE, collapsedHandler);
				_expanding.addEventListener(
					StudioEvent.EXPAND, expandedHandler);
				
				_enabler.addEventListener(StudioEvent.PAGE_LOADED, function ():void {
					_enabler.removeEventListener(StudioEvent.PAGE_LOADED, arguments.callee);
					startAutoExpand(WBConfig.TIMEOUT_AUTO_EXPAND);
				});
			}
			
			_enabler.addEventListener(StudioEvent.EXIT, exitHandler);
			ExPlayer.addAllEventListeners(videoEventsHandler);
			
			_shell = shell;
		}
		
		/**
		 * Calls enabler.exit from WBTrackings.as.
		 * Broadcasts WBEvent.WB_EXIT event.
		 * 
		 * @param	type - Could be type of String or int.
		 */
		public function exit (type:Object):void {
			_trackings.exit(type);
			dispatchEvent(new WBEvent(WBEvent.WB_EXIT, type));
		}
		
		/**
		 * Calls enabler.counter from WBTrackings.as.
		 * Broadcasts WBEvent.WB_COUNTER event.
		 * 
		 * @param	type - Could be type of String or int.
		 */
		public function counter (type:Object):void {
			_trackings.counter(type);
			dispatchEvent(new WBEvent(WBEvent.WB_COUNTER, type));
		}
		
		/**
		 * Calls enabler.counter from WBTrackings.as.
		 * Broadcasts WBEvent.WB_START_TIMER event.
		 * Only tracks one time even you call it multiple times.
		 * 
		 * @param	type - Could be type of String or int.
		 */
		public function startTimer (type:Object):void {
			_trackings.startTimer(type);
			dispatchEvent(new WBEvent(WBEvent.WB_START_TIMER, type));
		}
		
		/**
		 * Calls enabler.counter from WBTrackings.as.
		 * Broadcasts WBEvent.WB_START_TIMER event.
		 * Only tracks one time even you call it multiple times.
		 * 
		 * @param	type - Could be type of String or int.
		 */
		public function stopTimer (type:Object):void {
			_trackings.stopTimer(type);
			dispatchEvent(new WBEvent(WBEvent.WB_STOP_TIMER, type));
		}
		
		/**
		 * Stop all running timers from WBTrackings.as.
		 */
		public function stopAllTimers ():void {
			_trackings.stopAllTimers();
		}
		
		
		/**
		 * Auto expand the creative with automated timeout.
		 * Broadcasts WBEvent.AUTO_EXPANDED and WBEvent.AUTO_EXPAND_END after the timeout
		 * or when it collapsed during auto expansion.
		 * 
		 * @param	timeout - Milliseconds.
		 */
		public function startAutoExpand (timeout:int = 0):void {
			if (_isStartExpanded) return;
			_isStartExpanded = true;
			
			if (_expanding) {
				if (timeout > 0) {
					_autoExpandTimer = new Timer(timeout, 1);
					_autoExpandTimer.addEventListener(TimerEvent.TIMER_COMPLETE, autoExpandTimeoutHandler);
					_autoExpandTimer.start();	
				}
				
				_isAutoExpanded = true;
				_expanding.startExpanded();
				dispatchEvent(new WBEvent(WBEvent.AUTO_EXPANDED));
			}			
		}
		
		/**
		 * Expands the creative with additional functionalities.
		 * Broadcasts WBEvent.EXPANDED on expanded.
		 */
		public function expand ():void {
			if (isExpanded) return;
			
			if (_expanding) {
				interact();
				_isExpanded = true;
				_expanding.expand();
			}
		}
		
		/**
		 * Collapse the creative with additional functionalities.
		 * Broadcasts WBEvent.COLLAPSED when collapsed.
		 * 
		 * @param	isManualClose - Calls enabler.reportManualClose.
		 */
		public function collapse (isManualClose:Boolean = false):void {
			if (!isExpanded) return;
			
			if (_expanding) {
				interact();
				_isExpanded = false;
				_isAutoExpanded = false;
				_expanding.collapse();
				
				if (isManualClose) 
					_enabler.reportManualClose();
			}
		}
		
		/**
		 * Does nothing besides broadcasting the event WBEvent.INTERACTED and
		 * stops the autoExpandsion timeout.
		 */
		public function interact ():void {
			_isInteracted = true;
			if (_autoExpandTimer) {
				_autoExpandTimer.reset();
				_autoExpandTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, autoExpandTimeoutHandler);
				_autoExpandTimer = null;
			}
			dispatchEvent(new WBEvent(WBEvent.INTERACTED));
		}
		
		/**
		 * Does nothing only broadcasts the WBEvent.VIDEO_AUTO_ADVANCED event.
		 */
		public function videoAutoAdvance ():void {
			dispatchEvent(new WBEvent(WBEvent.VIDEO_AUTO_ADVANCED));
		}
		
		/**
		 * Does nothing only broadcasts the WBEvent.VIDEO_SKIPPED event.
		 */
		public function videoSkip ():void {
			dispatchEvent(new WBEvent(WBEvent.VIDEO_SKIPPED));
		}
		
		/**
		 * Does nothing only broadcasts the WBEvent.ENTER_FULLSCREEN event.
		 * 
		 * @param	data - Data to be add in the broadcasted event.
		 */
		public function enterFullscreen (data:Object = null):void {
			dispatchEvent(new WBEvent(WBEvent.ENTER_FULLSCREEN, data));
		}
		
		/**
		 * Does nothing only broadcasts the WBEvent.EXIT_FULLSCREEN event.
		 * 
		 * @param	data - Data to be add in the broadcasted event.
		 */
		public function exitFullscreen (data:Object = null):void {
			dispatchEvent(new WBEvent(WBEvent.EXIT_FULLSCREEN, data));
		}
		
		
		
		
		
		
		
		// ---------------------------- PRIVATE METHODS ----------------------------
		
		
		private function setupStaticVideos (  ):void {
			var videos:WBVideos = new WBVideos();
			
			// INTRO
			videos.intro.progressive = new VideoData(
				WBConfig.REPORTING_ID_VIDEO_INTRO,  
				WBStaticVideos.PROGRESSIVE_INTRO_LOW,
				WBStaticVideos.PROGRESSIVE_INTRO_MEDIUM,
				WBStaticVideos.PROGRESSIVE_INTRO_HIGH);
			videos.intro.streaming = new VideoData(
				WBConfig.REPORTING_ID_VIDEO_INTRO,  
				WBStaticVideos.STREAMING_INTRO_LOW,
				WBStaticVideos.STREAMING_INTRO_MEDIUM,
				WBStaticVideos.STREAMING_INTRO_HIGH, true);
				
			
			// VIDEO1
			videos.video1SD.progressive = new VideoData(
				WBConfig.REPORTING_ID_VIDEO1_SD,  
				WBStaticVideos.PROGRESSIVE_VIDEO1_LOW,
				WBStaticVideos.PROGRESSIVE_VIDEO1_MEDIUM,
				WBStaticVideos.PROGRESSIVE_VIDEO1_HIGH);
			videos.video1SD.streaming = new VideoData(
				WBConfig.REPORTING_ID_VIDEO1_SD,  
				WBStaticVideos.STREAMING_VIDEO1_LOW,
				WBStaticVideos.STREAMING_VIDEO1_MEDIUM,
				WBStaticVideos.STREAMING_VIDEO1_HIGH, true);
				
			videos.video1HD.progressive = new VideoData(
				WBConfig.REPORTING_ID_VIDEO1_HD,  
				WBStaticVideos.PROGRESSIVE_VIDEO1_HD,
				WBStaticVideos.PROGRESSIVE_VIDEO1_HD,
				WBStaticVideos.PROGRESSIVE_VIDEO1_HD);
			videos.video1HD.streaming = new VideoData(
				WBConfig.REPORTING_ID_VIDEO1_HD,  
				WBStaticVideos.STREAMING_VIDEO1_HD,
				WBStaticVideos.STREAMING_VIDEO1_HD,
				WBStaticVideos.STREAMING_VIDEO1_HD, true)
				
				
			// VIDEO2
			videos.video2SD.progressive = new VideoData(
				WBConfig.REPORTING_ID_VIDEO2_SD,  
				WBStaticVideos.PROGRESSIVE_VIDEO1_LOW,
				WBStaticVideos.PROGRESSIVE_VIDEO1_MEDIUM,
				WBStaticVideos.PROGRESSIVE_VIDEO1_HIGH);
			videos.video2SD.streaming = new VideoData(
				WBConfig.REPORTING_ID_VIDEO2_SD,  
				WBStaticVideos.STREAMING_VIDEO1_LOW,
				WBStaticVideos.STREAMING_VIDEO1_MEDIUM,
				WBStaticVideos.STREAMING_VIDEO1_HIGH, true);
				
			videos.video2HD.progressive = new VideoData(
				WBConfig.REPORTING_ID_VIDEO2_HD,  
				WBStaticVideos.PROGRESSIVE_VIDEO1_HD,
				WBStaticVideos.PROGRESSIVE_VIDEO1_HD,
				WBStaticVideos.PROGRESSIVE_VIDEO1_HD);
			videos.video2HD.streaming = new VideoData(
				WBConfig.REPORTING_ID_VIDEO2_HD,  
				WBStaticVideos.STREAMING_VIDEO1_HD,
				WBStaticVideos.STREAMING_VIDEO1_HD,
				WBStaticVideos.STREAMING_VIDEO1_HD, true)
				
				
			_videos = videos;
			_playerSettings.init(_videos);
		}
		
		private function autoExpandTimeoutHandler (e:TimerEvent):void {
			dispatchEvent(new WBEvent(WBEvent.AUTO_EXPAND_END));
			collapse();
		}
		
		private function exitHandler (e:StudioEvent):void {
			interact();
			if (isExpanded) {
				if (isAutoExpanded)
					dispatchEvent(new WBEvent(WBEvent.AUTO_EXPAND_END));
				collapse();
			}
		}
		
		private function expandedHandler (e:StudioEvent):void {
			_isExpanded = true;
			dispatchEvent(new WBEvent(WBEvent.EXPANDED));
		}
		
		private function collapsedHandler (e:StudioEvent):void {
			_isExpanded = false;
			_isAutoExpanded = false;
			dispatchEvent(new WBEvent(WBEvent.COLLAPSED));
		}
		
		
		
		private function videoEventsHandler (e:CustomVideoEvent):void {
			dispatchEvent(e);
			switch (e.type) {
				case CustomVideoEvent.PREVIEW_COMPLETE:
					dispatchEvent(new WBEvent(WBEvent.VIDEO_AUTOPLAY_END, e.data));
				case CustomVideoEvent.COMPLETE:
					if (isAutoExpanded && !isInteracted) {
						dispatchEvent(new WBEvent(WBEvent.AUTO_EXPAND_END));
						collapse();
					}
					break;
			}
		}		
	}

}
import com.cognizant.google.video.components.ExPlayer;
import com.cognizant.google.video.data.PlayerSettings;
import com.cognizant.google.video.utils.dateSwap;
import com.cognizant.google.wb.WBCreative;
import com.google.ads.studio.display.StudioLoader;
import com.google.ads.studio.ProxyEnabler;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Graphics;
import flash.display.MovieClip;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.net.URLRequest;
import flash.system.Capabilities;
import flash.utils.Dictionary;

class WBHelper {
	private var _wb:WBCreative;
	private var _listeners:Object;
	
	public function WBHelper (wb:WBCreative) { 
		_wb = wb;
		_listeners = {};
	}
	
	/**
	 * Helper function for adding all the video events that
	 * using the ExPlayer.
	 * 
	 * @param	listener - handler(e:CustomVideoEvent)
	 */
	public function addAllVideoEvents (listener:Function):void {
		ExPlayer.addAllEventListeners(listener);
	}
	
	/**
	 * Helper function to easily remove all the event listeners to each target.
	 * 
	 * @param	id - ID of the target.
	 * @param	type - Event type.
	 * @param	listener - Handler
	 */
	public function addEventListenerTo ( id:String, type:String, listener:Function ):void {
		var d:Dictionary;
		if (!_listeners[id]) {
			_listeners[id] = { };
			_listeners[id][type] = listener;
		} else {
			if (_listeners[id][type]) return;			
			_listeners[id][type] = listener;
		}
		
		_wb.addEventListener(type, listener);
	}
	
	/**
	 * Remove specific event to the target.
	 * 
	 * @param	id - ID of the target.
	 * @param	type - Event type.
	 */
	public function removeEventListenerTo ( id:Object, type:String ):void {
		if (!_listeners[id]) return;
		if (!_listeners[id][type]) return;
		
		_wb.removeEventListener(type, _listeners[id][type]);
		_listeners[id][type] = null;
	}
	
	/**
	 * Remove all event listeners to the target.
	 * 
	 * @param	id - ID of the target.
	 */
	public function removeAllEventListenersTo ( id:Object ):void {
		if (!_listeners[id]) return;
		
		var obj:Object = _listeners[id];
		
		for ( var i:String in obj ) {
			if (!obj[i]) continue;
			_wb.removeEventListener(i, obj[i]);
			obj[i] = null;
		}
		
		_listeners[id] = null;
	}
	
	/**
	 * Set video using ExPlayer.
	 * 
	 * @param	componentInstance - VideoPlayerAdvanced.
	 * @param	type - [intro, videoSD, videoHD]
	 * 
	 * @return ExPlayer instance.
	 */
	public function setVideo (componentInstance:Object, type:String = 'videoSD'):ExPlayer {
		var player:ExPlayer = new ExPlayer();
		var settings:PlayerSettings;
		
		switch ( type ) {
			case 'intro':
				settings = _wb.playerSettings.intro;
				break;
			case 'videoSD':
				settings = _wb.playerSettings.videoSD;
				break;
			case 'videoHD':
				settings = _wb.playerSettings.videoHD;
				break;
			default:
		}
		
		settings.componentInstance = componentInstance;
		player.init(settings);
		
		return player;
	}
	
	/**
	 * Adjust the size of the display in fullscreen size
	 * and maintain its aspect ratio.
	 * 
	 * @param	display - Display to be scaled.
	 * @param	rect - Optional dimension of the display, if null the display itself will be used.
	 */
	public function toFullscreen (display:DisplayObjectContainer, rect:Rectangle = null):void {
		rect = rect || new Rectangle(display.x, display.y, display.width, display.height);
		
		var screenWidth:Number = Capabilities.screenResolutionX;
		var screenHeight:Number = Capabilities.screenResolutionY;
		var actualWidth:Number = rect.width;
		var actualHeight:Number = rect.height;
		
		if (ProxyEnabler.getInstance().isRunningLocally()) {
			screenWidth = display.stage.width;
			screenHeight = display.stage.height;
		}
		
		if (actualWidth >= actualHeight) {
			actualHeight = screenWidth / (actualWidth / actualHeight);
			actualWidth = screenWidth;
			
			rect.y = (screenHeight - actualHeight) * 0.5;
		} else {
			actualWidth = (actualWidth / actualHeight) * screenHeight;
			actualHeight = screenHeight;
			
			rect.x = (screenWidth - actualWidth) * 0.5;
		}
		
		rect.width = actualWidth;
		rect.height = actualHeight;
		
		display.x = rect.x;
		display.y = rect.y;
		display.width = rect.width;
		display.height = rect.height;
		
		var bg:MovieClip = new MovieClip();
		var g:Graphics = bg.graphics;
		g.beginFill(0);
		g.drawRect(0, 0, screenWidth, screenHeight);
		g.endFill();
		display.addChildAt(bg, 0);
		
		trace('> [WB FULLSCREEN]\t->\t' + rect.toString());
	}
		
	/**
	 * Helper function for loading external file.
	 * 
	 * @param	url Url of the to be loaded.
	 * @param	onComplete Callback function when it loads succesfully.
	 * 
	 * @return	Instance of the loader.
	 * 
	 * @see https://gist.github.com/raf101/eed7d6a10b375460ebbf#file-loaddisplay
	 */
	public function loadDisplay (url:String, onComplete:Function = null):StudioLoader {
		var loader:StudioLoader = new StudioLoader();
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function (e:Event):void {
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, arguments.callee);
			if (onComplete != null) onComplete(e);
		});
		loader.load(new URLRequest(url));
		
		return loader;
	}	
	
	/**
	 * Helper function for date swapping.
	 * 
	 * @param	schedsData ScheduledData Array
	 * @param	currentDate For testing
	 * 
	 * @return 	ScheduleData.id
	 * 
	 * @see https://gist.github.com/raf101/4c340c39a07e98a772aa#file-dateswap
	 */
	public function dateSwap (schedsData:Array, currentDate:Date = null):String {
		return com.cognizant.google.video.utils.dateSwap(schedsData, currentDate);
	}
	
	/**
	 * Helper function for end frame functionality.
	 * 
	 * @param	target Parent of all the MovieClips to end.
	 * @param	ignoreTargets Child's names array to ignore.
	 */
	public function endFrame (target:MovieClip, ignoreTargets:Array = null):void {
		for each ( var ignoreTarget:String in ignoreTargets ) {
			if (target.name == ignoreTarget) {
				return;			
			}
		}
		
		target.gotoAndStop(target.totalFrames);
		
		target.addEventListener(Event.ENTER_FRAME, function ():void {
			target.removeEventListener(Event.ENTER_FRAME, arguments.callee);
			target.stage.invalidate();
		});
		
		target.addEventListener(Event.RENDER, function():void {
			target.removeEventListener(Event.RENDER, arguments.callee);
			var child:DisplayObject;
			var len:int = target.numChildren;
			for (var i:int = 0; i < len; i++) {
				child = target.getChildAt(i);
				if (child is MovieClip) {
					endFrame(MovieClip(child), ignoreTargets);
				}
			}
		});
	}
}
class SingletonEnforcer {}