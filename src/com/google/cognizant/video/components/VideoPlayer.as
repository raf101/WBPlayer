﻿package com.google.cognizant.video.components {	import com.google.cognizant.video.data.PlayerSettings;	import com.google.cognizant.video.data.VideoData;	import com.google.ads.studio.utils.StudioClassAccessor;		import flash.display.DisplayObject;	import flash.display.Sprite;	import flash.events.Event;	import com.google.cognizant.video.events.CustomVideoEvent;		/**	 * ...	 * 	 * @author ...	 * 	 * @created mm/dd/yyyy 00:00 AM	 */	public class VideoPlayer extends Sprite {				// NOTE: This should be the order of access modifiers per section.		// - PUBLIC		// - INTERNAL		// - PROTECTED		// - PRIVATE				// Please use these section dividers as the guide limit length of chars per line.		// ------------------------------- STATIC VARIABLES --------------------------------		private static var _collection:Array = []; // VideoPlayer on stage		private static var _handlers:Array = [];		private static var _currentVideo:VideoPlayer;				// ----------------------------------- VARIABLES -----------------------------------		private var _settings:PlayerSettings;		private var _handler:Function;		private var _hasAllEventListeners:Boolean;		private var _autoDestroy:Boolean;		private var _componentInstance:Object;						// --------------=--------------- STATIC GETTERS/SETTERS ---------------------------				// --------------------------- OVERRIDEN GETTERS/SETTERS ---------------------------				// ------------------------------- GETTERS/SETTERS ---------------------------------		public function get id ():String { return _settings.id; }		public function get componentInstance ():Object { return _componentInstance }		public function get videoController ():Object { return _componentInstance.getCurrentVideoController(); }				// ------------------------------- STATIC METHODS ----------------------------------		public static function addAllEventListeners (handler:Function):void {			_handlers.push(handler);		}				public static function removeAllEventListeners (handler:Function):void {			_handlers.length = 0;		}				public static function getCurrentVideoController ():Object {			return getCurrentVideo().componentInstance.getCurrentVideoController();		}				public static function getCurrentVideo ():VideoPlayer {			return _currentVideo;		}				public static function getVideo (id:String):VideoPlayer {			for each (var vid:VideoPlayer in _collection)				if (vid.id == id) return vid;			return null;		}				public static function pauseAll ():void {			for each (var vid:VideoPlayer in _collection)				vid.pause();		}				public static function muteAll ():void {			for each (var vid:VideoPlayer in _collection)				vid.mute();		}				public function destroyAll ():void {			for each (var vid:VideoPlayer in _collection)				vid.destroy();		}				// -------------------------------- CONSTRUCTOR ------------------------------------				public function VideoPlayer () {			// constructor code			if (stage) addedToStageHandler(null);			else addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);		}				private function addedToStageHandler (e:Event):void {			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);			_collection.push(this);		}				private function removedFromStageHandler (e:Event):void {			if (!_autoDestroy) return;						removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);						var index:int = _collection.indexOf(this);			if (index != -1)				_collection.splice(index, 1)[0];						destroy();		}								// ----------------------------- OVERRIDEN METHODS ---------------------------------				// ------------------------   OVERRIDEN EVENT HANDLERS -----------------------------				// ---------------------------------  METHODS --------------------------------------				public function init (settings:PlayerSettings):void {			trace(settings);			if (!settings.componentInstance) { // Create new component instance				var videoPlayerAdvanced:Class = StudioClassAccessor.getClass('com.google.ads.studio.video.VideoPlayerAdvanced');				_componentInstance = new videoPlayerAdvanced();							} else { // Use existing component instance				_componentInstance = settings.componentInstance;							}						if (settings.dimension) {				_componentInstance.x = settings.dimension.x;				_componentInstance.y = settings.dimension.y;				_componentInstance.width = settings.dimension.width;				_componentInstance.height = settings.dimension.height;			}						_componentInstance.videoSmoothing = true;						var progressive:Array = settings.progressiveData || [];			var streaming:Array = settings.streamingData || [];						var vidData:VideoData;			var vidCtrl:Object;			var i:int;			var len:int = streaming.length >= progressive.length ? streaming.length : progressive.length;										for (i = 0; i < len; i++) {				_componentInstance.getPlaylist().addVideoController(createVideoController(streaming[i], progressive[i]));			}						vidCtrl = _componentInstance.getCurrentVideoController();			vidCtrl.setVideoObject(_componentInstance.getVideoObject());						_componentInstance.startMuted = settings.startMuted;			if (settings.autoPlay) {				if (settings.startMuted) mute();				_componentInstance.getPlaylist().start(true);			}												addChild(_componentInstance as DisplayObject);			_settings = settings;		}						public function addAllEventListeners (handler:Function):void {			_handler = handler;						if (_hasAllEventListeners) {				return;			}						var events:Array = CustomVideoEvent.getAllStudioVideoEvents();			var i:int = events.length;			while (i--) {				videoController.addEventListener(					events[i], videoEventsHandler);			}						// TODO Thinking if PLAYHEAD_MOVE should be removed to free some process			//videoController.removeEventListener(//				StudioVideoEvent.PLAYHEAD_MOVE, videoEventsHandler);			_hasAllEventListeners = true;						trace('add all event listeners');		}				public function removeAllEventListeners ():void {				if (!_hasAllEventListeners) {				return;			}						var events:Array = CustomVideoEvent.getAllStudioVideoEvents();			var i:int = events.length;			while (i--) {				videoController.removeEventListener(					events[i], videoEventsHandler);			}				_hasAllEventListeners = false;		}				private function videoEventsHandler (e:Object):void {			var vidCtrl:EnhancedVideoController =  				e.currentTarget as EnhancedVideoController;			e.addProperty('index', _currentIndex);			e.addProperty('reportingIdentifier', 				_currentController.getReportingIdentifier());						if (_handler != null || __handler != null) {				var e2:StudioVideoEvent;				if (_handler != null) {					_handler(e);				}				if (__handler != null) {					__handler(e);				}								switch (e.type) {					case StudioVideoEvent.PLAY:						e2 = new StudioVideoEvent(							ExStudioVideoEvent.VIDEO_VIEW_TIMER_START);						e2.addProperty('index', _currentIndex);						e2.addProperty('reportingIdentifier', 							_currentController.getReportingIdentifier());						if (_handler != null) {							_handler(e2);						}						if (__handler != null) {							__handler(e2);						}						break;										case StudioVideoEvent.COMPLETE:						if (_isAutoPlay) {							stopAutoPlay();							_currentController.stop();						}					case StudioVideoEvent.PAUSE:					case StudioVideoEvent.STOP:						e2 = new StudioVideoEvent(							ExStudioVideoEvent.VIDEO_VIEW_TIMER_STOP);						e2.addProperty('index', _currentIndex);						e2.addProperty('reportingIdentifier', 							_currentController.getReportingIdentifier());						if (_handler != null) {							_handler(e2);						}						if (__handler != null) {							__handler(e2);						}						default:				}			}		}				public function play ():void {			videoController.play();		}				public function pause ():void {			videoController.pause();		}				public function mute ():void {			_componentInstance.mute();		}				public function unmute ():void {			_componentInstance.unmute();		}				public function seek (sec:Number):void {			videoController.seek(sec);		}				public function skipTo (index:int):void {			_componentInstance.skipTo(index);		}				public function replay ():void {			videoController.replay();		}				public function next ():void {			_componentInstance.next();		}				public function previous ():void {			_componentInstance.previous();		}				public function setVolume (value:Number):void {			videoController.getAudioChannel().setVolume(value);		}				public function enterFullscreen ():void {					}				public function exitFullScreen ():void {					}				public function destroy ():void {			_componentInstance.unload();		}						private function createVideoController (streaming:VideoData, progressive:VideoData = null):Object {			var enhancedVideoController:Class = StudioClassAccessor.getClass('com.google.ads.studio.video.EnhancedVideoController');			var videoEntry:Class = StudioClassAccessor.getClass('com.google.ads.studio.video.VideoEntry');						var vidCtrl:Object = new enhancedVideoController();						var vidEntry:Object;						if (streaming) {				// streaming				vidCtrl.setReportingIdentifier(streaming.id);				vidEntry = new videoEntry(streaming.low, streaming.medium, streaming.high, StudioClassAccessor.getClass('com.google.ads.studio.video.SmartStreamingConnection'));				vidCtrl.addVideoEntry(vidEntry);								// progressive fallback				if (progressive) {					vidEntry = new videoEntry(progressive.low, progressive.medium, progressive.high);					vidCtrl.addVideoEntry(vidEntry);				}			} else if (progressive) {				vidCtrl.setReportingIdentifier(progressive.id);				vidEntry = new videoEntry(progressive.low, progressive.medium, progressive.high);				vidCtrl.addVideoEntry(vidEntry);			} else {				throw new Error('VideoPlayer:: No VideoData found.');			}						return vidCtrl;		}				// ------------------------------ EVENT HANDLERS -----------------------------------	}	}