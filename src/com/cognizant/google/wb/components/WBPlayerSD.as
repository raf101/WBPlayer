﻿package com.cognizant.google.wb.components {
	import com.cognizant.google.video.components.ExPlayer;
	import com.cognizant.google.video.data.PlayerSettings;
	import com.cognizant.google.video.events.CustomVideoEvent;
	import com.cognizant.google.wb.components.controls.WBPlaybackController;
	import com.cognizant.google.wb.config.WBConfig;
	import com.cognizant.google.wb.events.WBEvent;
	import com.cognizant.google.wb.WBCreative;
	import com.google.ads.studio.events.StudioEvent;
	import com.google.ads.studio.ProxyEnabler;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * 
	 * @author Rafael Nepomuceno
	 * 
	 * @created mm/dd/yyyy 00:00 AM
	 * 
	 * @see https://gist.github.com/raf101/53533a4e3305353109f7#file-wbplayer
	 */
	public class WBPlayerSD extends MovieClip {
		
		// NOTE: This should be the order of access modifiers per section.
		// - PUBLIC
		// - INTERNAL
		// - PROTECTED
		// - PRIVATE
		
		// Please use these section dividers as the guide limit length of chars per line.
		// ------------------------------- STATIC VARIABLES --------------------------------
		
		// ----------------------------------- VARIABLES -----------------------------------
		// Stage's instances.
		public var container:MovieClip;
		public var togglePlay:MovieClip;
		public var toggleMute:MovieClip;
		public var mcSeekbar:MovieClip;
		public var btnReplay:MovieClip;
		public var toggleSkipTo0:MovieClip;
		public var toggleSkipTo1:MovieClip;
		public var btnFullScreen:SimpleButton;
		public var btnSkip:SimpleButton;
		
		
		private var _fullscreenSettings:PlayerSettings;
		private var _video:ExPlayer;
		private var _ctrl:WBPlaybackController;
		
		private var _autoAdvanceTimer:Timer;
		private var _wb:WBCreative;
		
		// --------------=--------------- STATIC GETTERS/SETTERS ---------------------------
		
		// --------------------------- OVERRIDEN GETTERS/SETTERS ---------------------------
		
		// ------------------------------- GETTERS/SETTERS ---------------------------------
		
		public function get ctrl ():WBPlaybackController { return _ctrl; }
		
		// ------------------------------- STATIC METHODS ----------------------------------
		
		// -------------------------------- CONSTRUCTOR ------------------------------------
		
		public function WBPlayerSD () {
			// constructor code
			_wb = WBCreative.getInstance();
			
			if (stage) addedToStageHandler();
			else addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function addedToStageHandler ( e:Event = null ):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			ProxyEnabler.getInstance().addEventListener(StudioEvent.FULL_SCREEN, studioFullScreenHandler);
			
			_autoAdvanceTimer = new Timer(WBConfig.VIDEO_AUTO_ADVANCE_TIMEOUT, 1);
			_autoAdvanceTimer.addEventListener(TimerEvent.TIMER_COMPLETE, autoAdvanceTimerCompleteHandler);
			
		}
		
		
		// ----------------------------- OVERRIDEN METHODS ---------------------------------
		
		// ------------------------   OVERRIDEN EVENT HANDLERS -----------------------------
		
		// ---------------------------------  METHODS --------------------------------------
		public function init (settings:PlayerSettings):void {
			if (_ctrl) _ctrl.destroy();
			if (_video) {
				container.removeChild(_video);
			}
			
			
			_video = new ExPlayer();
			_video.init(settings);
			_video.addEventListener(CustomVideoEvent.ENTER_FULLSCREEN, enterFullscreenHandler);
			_video.addEventListener(CustomVideoEvent.COMPLETE, completeHandler);
			container.addChild(_video);
			
			_ctrl = new WBPlaybackController(_video);
			
			_ctrl.setPlayToggle(togglePlay);
			_ctrl.setMuteToggle(toggleMute);
			
			_ctrl.setSkipToToggle(toggleSkipTo0, 0);
			_ctrl.setSkipToToggle(toggleSkipTo1, 1);
			_ctrl.setReplayButton(btnReplay);
			_ctrl.setSeekBar(mcSeekbar.bar, mcSeekbar.hit, mcSeekbar.knob);
			_ctrl.setBtnFullscreen(btnFullscreen);
			_ctrl.setBtnSkip(btnSkip);
			
			_ctrl.addEventListener(CustomVideoEvent.INTERACTED, interactedHandler);
			_wb.addEventListener(WBEvent.EXIT_FULLSCREEN, exitFullscreenHandler);
		}
		
		public function initFullscreen (settings:PlayerSettings):void {
			_fullscreenSettings = settings;
		}
		
		private function enterFullscreen (settings:PlayerSettings = null):void {
			settings = settings || _fullscreenSettings;
			
			_video.pause();
			
			var hdVideo:WBPlayerHD = new WBPlayerHD();
			var index:int = _video.getCurrentVideoIndex();
			
			hdVideo.init(settings);
			stage.addChild(hdVideo);
			
			if (index)
				hdVideo.ctrl.skipTo(index);
				
			_wb.enterFullscreen();
		}
		
		// ------------------------------ EVENT HANDLERS -----------------------------------
		private function autoAdvanceTimerCompleteHandler (e:TimerEvent):void {
			if (!_video.getCurrentVideoIndex()) {
				_ctrl.autoAdvance();
				_wb.videoAutoAdvance();
			}
		}
		private function interactedHandler (e:CustomVideoEvent):void {
			_autoAdvanceTimer.reset();
			_wb.interact();
		}
		
		// ------------------------------ STUDIO EVENT HANDLERS -----------------------------------
		private function studioFullScreenHandler (e:StudioEvent):void {
			enterFullscreen(_fullscreenSettings);
		}
		
		
		// ------------------------------ EXPLAYER EVENT HANDLERS -----------------------------------
		private function completeHandler (e:CustomVideoEvent):void {
			_autoAdvanceTimer.reset();
			_autoAdvanceTimer.start();
		}
		
		private function enterFullscreenHandler (e:CustomVideoEvent):void {
			if (ProxyEnabler.getInstance().isRunningLocally()) {
				studioFullScreenHandler(null);
			} else {
				ProxyEnabler.getInstance().launchFullScreen(StageScaleMode.NO_SCALE, StageAlign.TOP_LEFT);
			}
			
		}
		private function exitFullscreenHandler (e:WBEvent):void {
			_video.skipTo(e.data.videoIndex);
			_ctrl.stop();
		}
		
		
	}
	
}
