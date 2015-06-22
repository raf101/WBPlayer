package com.cognizant.google.wb.components {
	import com.cognizant.google.video.components.ExPlayer;
	import com.cognizant.google.video.data.PlayerSettings;
	import com.cognizant.google.video.events.CustomVideoEvent;
	import com.cognizant.google.wb.components.controls.WBPlaybackController;
	import com.cognizant.google.wb.WBCreative;
	import com.google.ads.studio.events.StudioEvent;
	import com.google.ads.studio.ProxyEnabler;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	/**
	 * ...
	 * @author Rafael Nepomuceno
	 * @created 6/21/2015 9:47 AM
	 * 
	 * @see https://gist.github.com/raf101/53533a4e3305353109f7#file-wbplayer
	 */
	public class WBPlayerHD extends MovieClip {
		// Stage's instances.
		public var container:MovieClip;
		public var togglePlay:MovieClip;
		public var toggleMute:MovieClip;
		public var btnReplay:MovieClip;
		public var toggleSkipTo0:MovieClip;
		public var toggleSkipTo1:MovieClip;
		public var btnExitFullScreen:SimpleButton;
		
		private var _video:ExPlayer;
		private var _ctrl:WBPlaybackController;
		private var _wb:WBCreative;
		
		public function get ctrl ():WBPlaybackController { return _ctrl; }
		
		public function get video ():ExPlayer { return _video; }
		
		public function WBPlayerHD (  ) {
			_wb = WBCreative.getInstance();
			
			if (stage) addedToStageHandler();
			else addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
		}
		
		private function addedToStageHandler ( e:Event = null ):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			ProxyEnabler.getInstance().addEventListener(StudioEvent.FULL_SCREEN_EXIT, studioFullScreenExitHandler);
			
			resizeToFullscreen();
		}
		
		
		public function init ( settings:PlayerSettings ):void {
			// constructor code
			_wb = WBCreative.getInstance();
			
			_video = new ExPlayer();
			_video.init(settings);
			_video.addEventListener(CustomVideoEvent.EXIT_FULLSCREEN, exitFullscreenHandler);
			container.addChild(_video);
			
			_ctrl = new WBPlaybackController(_video);
			
			_ctrl.setPlayToggle(togglePlay);
			_ctrl.setMuteToggle(toggleMute);
			
			_ctrl.setSkipToToggle(toggleSkipTo0, 0);
			_ctrl.setSkipToToggle(toggleSkipTo1, 1);
			_ctrl.setReplayButton(btnReplay);
			_ctrl.setBtnExitFullscreen(btnExitFullScreen);
			
		}
		
		private function exitFullscreen ():void {			
			_wb.exitFullscreen({videoIndex:_video.getCurrentVideoIndex()});
			
			stage.removeChild(this);
		}
		
		private function resizeToFullscreen ():void {
			var videoDimension:Rectangle = _video.settings.dimension;
			var screenWidth:Number = Capabilities.screenResolutionX;
			var screenHeight:Number = Capabilities.screenResolutionY;
			var vidWidth:Number = videoDimension.width;
			var vidHeight:Number = videoDimension.height;
			
			if (ProxyEnabler.getInstance().isRunningLocally()) {
				screenWidth = stage.width;
				screenHeight = stage.height;
				
				trace(screenWidth, screenHeight);
			}
			
			if (vidWidth >= vidHeight) {
				vidHeight = screenWidth / (vidWidth / vidHeight);
				vidWidth = screenWidth;
				
				videoDimension.y = (screenHeight - vidHeight) * 0.5;
			} else {
				vidWidth = (vidWidth / vidHeight) * screenHeight;
				vidHeight = screenHeight;
				
				videoDimension.x = (screenWidth - vidWidth) * 0.5;
			}
			
			videoDimension.width = vidWidth;
			videoDimension.height = vidHeight;
			
			_video.componentInstance.x = videoDimension.x;
			_video.componentInstance.y = videoDimension.y;
			_video.componentInstance.width = videoDimension.width;
			_video.componentInstance.height = videoDimension.height;
			
			togglePlay.y = 
			toggleMute.y =
			toggleSkipTo0.y =
			toggleSkipTo1.y =
			btnExitFullScreen.y =
				screenHeight - 40;
			
			btnExitFullScreen.x = screenWidth - (btnExitFullScreen.width * 0.5) - 40;
			toggleSkipTo1.x = btnExitFullScreen.x - 40;
			toggleSkipTo0.x = toggleSkipTo1.x - 20;
			
			btnReplay.x = screenWidth * 0.5;
			btnReplay.y = screenHeight * 0.5;
		}
		
		private function studioFullScreenExitHandler (e:StudioEvent):void {
			exitFullscreen();
		}
		
		private function exitFullscreenHandler (e:CustomVideoEvent):void {
			e.target.removeEventListener(CustomVideoEvent.EXIT_FULLSCREEN, exitFullscreenHandler);
			
			if (ProxyEnabler.getInstance().isRunningLocally()) {
				studioFullScreenExitHandler(null);
			} else {
				ProxyEnabler.getInstance().exitFullScreen();
			}			
		}
		
		
	}

}