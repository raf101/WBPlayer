﻿package com.cognizant.google.wb.components {	import com.cognizant.google.video.components.ExPlayer;	import com.cognizant.google.video.data.PlayerSettings;	import com.cognizant.google.video.events.CustomVideoEvent;	import com.cognizant.google.wb.components.controls.WBPlaybackController;	import com.cognizant.google.wb.config.WBConfig;	import com.cognizant.google.wb.WBCreative;	import com.google.ads.studio.events.StudioEvent;	import com.google.ads.studio.ProxyEnabler;	import flash.display.DisplayObject;	import flash.display.MovieClip;	import flash.display.StageAlign;	import flash.display.StageScaleMode;	import flash.events.Event;	import flash.events.TimerEvent;	import flash.utils.Dictionary;	import flash.utils.Timer;		/**	 * ...	 * 	 * @author ...	 * 	 * @created mm/dd/yyyy 00:00 AM	 */	public class WBPlayer extends MovieClip {				// NOTE: This should be the order of access modifiers per section.		// - PUBLIC		// - INTERNAL		// - PROTECTED		// - PRIVATE				// Please use these section dividers as the guide limit length of chars per line.		// ------------------------------- STATIC VARIABLES --------------------------------				// ----------------------------------- VARIABLES -----------------------------------		// Stage's instances.		public var container:MovieClip;		public var togglePlay:MovieClip;		public var toggleStop:MovieClip;		public var toggleMute:MovieClip;		public var mcSeekbar:MovieClip;		public var btnReplay:MovieClip;		public var toggleSkipTo0:MovieClip;		public var toggleSkipTo1:MovieClip;						private var _fullscreenSettings:PlayerSettings;		private var _video:ExPlayer;		private var _hdVideo:ExPlayer;		private var _ctrl:WBPlaybackController;		private var _displayStates:Dictionary;				private var _autoAdvanceTimer:Timer;		private var _wb:WBCreative;				// --------------=--------------- STATIC GETTERS/SETTERS ---------------------------				// --------------------------- OVERRIDEN GETTERS/SETTERS ---------------------------				// ------------------------------- GETTERS/SETTERS ---------------------------------				// ------------------------------- STATIC METHODS ----------------------------------				// -------------------------------- CONSTRUCTOR ------------------------------------				public function WBPlayer () {			// constructor code			_wb = WBCreative.getInstance();						ProxyEnabler.getInstance().addEventListener(StudioEvent.FULL_SCREEN, studioFullScreenHandler);			ProxyEnabler.getInstance().addEventListener(StudioEvent.FULL_SCREEN_EXIT, studioFullScreenExitHandler);						_displayStates = new Dictionary();			_autoAdvanceTimer = new Timer(WBConfig.VIDEO_AUTO_ADVANCE_TIMEOUT, 1);			_autoAdvanceTimer.addEventListener(TimerEvent.TIMER_COMPLETE, autoAdvanceTimerCompleteHandler);		}						// ----------------------------- OVERRIDEN METHODS ---------------------------------				// ------------------------   OVERRIDEN EVENT HANDLERS -----------------------------				// ---------------------------------  METHODS --------------------------------------		public function init (settings:PlayerSettings):void {			if (_ctrl) _ctrl.destroy();			if (_video) {				container.removeChild(_video);			}									_video = new ExPlayer();			_video.init(settings);			_video.addEventListener(CustomVideoEvent.ENTER_FULLSCREEN, enterFullscreenHandler);			_video.addEventListener(CustomVideoEvent.COMPLETE, completeHandler);			container.addChild(_video);						_ctrl = new WBPlaybackController(_video);						_ctrl.setPlayToggle(togglePlay);			_ctrl.setStopToggle(toggleStop);			_ctrl.setMuteToggle(toggleMute);						_ctrl.setSkipToToggle(toggleSkipTo0, 0);			_ctrl.setSkipToToggle(toggleSkipTo1, 1);			_ctrl.setReplayButton(btnReplay);			_ctrl.setSeekBar(mcSeekbar.bar, mcSeekbar.hit, mcSeekbar.knob);			_ctrl.setFullscreenToggle(toggleFullscreen);						_ctrl.addEventListener(CustomVideoEvent.INTERACTED, interactedHandler);		}				public function initFullscreen (settings:PlayerSettings):void {			_fullscreenSettings = settings;		}				private function enterFullscreen (settings:PlayerSettings = null):void {			settings = settings || _fullscreenSettings;						saveDisplayState(this, togglePlay, toggleStop, toggleMute, mcSeekbar, btnReplay, toggleSkipTo0, toggleSkipTo1);			_video.autoDestroy = false;			_video.pause();						var fsWidth:Number = stage.fullScreenWidth || stage.width;			var fsHeight:Number = stage.fullScreenHeight || stage.height;						// enter fullscreen			if (settings) { // load new				var index:int = _video.getCurrentVideoIndex();				_video.visible = false;								_hdVideo = new ExPlayer();				_hdVideo.init(settings);				_hdVideo.addEventListener(CustomVideoEvent.EXIT_FULLSCREEN, exitFullscreenHandler);				container.addChild(_hdVideo);												if (index)					_hdVideo.skipTo(_video.getCurrentVideoIndex());									_ctrl.init(_hdVideo);				_hdVideo.autoDestroy = false;			} else { // use existing				// Resize video				_video.width = fsWidth;				_video.height = fsHeight;				_video.addEventListener(CustomVideoEvent.EXIT_FULLSCREEN, exitFullscreenHandler);				_video.replay();			}						toggleSkipTo1.x = fsWidth - 100;			toggleSkipTo0.x = toggleSkipTo1.x - 100;			toggleMute.x = togglePlay.x + 100;						//toggleStop.y = 			togglePlay.y = 			toggleMute.y = 			mcSeekbar.y = 			toggleSkipTo0.y =			toggleSkipTo1.y =				fsHeight - 100;							btnReplay.x = fsWidth * 0.5;			btnReplay.y = fsHeight * 0.5;						mcSeekbar.visible = false;						stage.addChild(this);			_video.autoDestroy = _video.settings.autoDestroy;						_wb.enterFullscreen();		}				private function exitFullscreen ():void {			_video.autoDestroy = false;			var index:int = _video.getCurrentVideoIndex();			// exit fullscreen			if (_hdVideo) {				index = _hdVideo.getCurrentVideoIndex();				_hdVideo.autoDestroy = _hdVideo.settings.autoDestroy;				container.removeChild(_hdVideo);				_hdVideo = null;			}						revertDisplayState(this, togglePlay, toggleStop, toggleMute, mcSeekbar, btnReplay, toggleSkipTo0, toggleSkipTo1);						_ctrl.init(_video);						_video.autoDestroy = _video.settings.autoDestroy;			_video.visible = true;			_video.skipTo(index);			_ctrl.stop();			_wb.exitFullscreen();		}						private function saveDisplayState (...targets:Array):void {			var state:Object;			var target:DisplayObject;			var len:int = targets.length;			for (var i:int = 0; i < len; i++) {				target = targets[i];				if (!target) continue;								state = _displayStates[target] || { };							state.matrix = target.transform.matrix.clone();				state.parent = target.parent;				state.index = target.parent.getChildIndex(target);				state.display = target;				state.visible = target.visible;								_displayStates[target] = state;							}		}		private function revertDisplayState (...targets:Array):void {			var state:Object;			var target:DisplayObject;			var len:int = targets.length;			for (var i:int = 0; i < len; i++) {				target = targets[i];				if (!target) continue;								state = _displayStates[target];				if (!state) continue;								state.parent.addChildAt(state.display, state.index);				state.display.transform.matrix = state.matrix;				state.display.visible = state.visible;			}		}				// ------------------------------ EVENT HANDLERS -----------------------------------		private function autoAdvanceTimerCompleteHandler (e:TimerEvent):void {			if (!_video.getCurrentVideoIndex()) {				_ctrl.next();				_wb.videoAutoAdvance();			}		}		private function interactedHandler (e:CustomVideoEvent):void {			_autoAdvanceTimer.reset();			_wb.interact();		}				// ------------------------------ STUDIO EVENT HANDLERS -----------------------------------		private function studioFullScreenHandler (e:StudioEvent):void {			enterFullscreen(_fullscreenSettings);		}		private function studioFullScreenExitHandler (e:StudioEvent):void {			exitFullscreen();		}						// ------------------------------ EXPLAYER EVENT HANDLERS -----------------------------------		private function completeHandler (e:CustomVideoEvent):void {			_autoAdvanceTimer.reset();			_autoAdvanceTimer.start();		}				private function enterFullscreenHandler (e:CustomVideoEvent):void {			if (ProxyEnabler.getInstance().isRunningLocally()) {				studioFullScreenHandler(null);			} else {				ProxyEnabler.getInstance().launchFullScreen(StageScaleMode.NO_SCALE, StageAlign.TOP_LEFT);			}					}		private function exitFullscreenHandler (e:CustomVideoEvent):void {			e.target.removeEventListener(CustomVideoEvent.EXIT_FULLSCREEN, exitFullscreenHandler);						if (ProxyEnabler.getInstance().isRunningLocally()) {				studioFullScreenExitHandler(null);			} else {				ProxyEnabler.getInstance().exitFullScreen();			}					}	}	}