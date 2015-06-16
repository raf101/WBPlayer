package com.cognizant.google.wb.components.controls {
	import com.cognizant.google.video.components.controls.PlaybackController;
	import com.cognizant.google.video.components.ExPlayer;
	
	/**
	 * ...
	 * @author Rafael Nepomuceno
	 * @created 6/17/2015 1:34 AM
	 */
	public class WBPlaybackController extends PlaybackController {
		
		public function WBPlaybackController ( video:ExPlayer ) {
			super(video);
		}
		
		public function next (  ):void {
			_playState = true;
			_muteState = false;
			
			_video.unmute();
			_video.next();
			
			if (_btnReplay) _btnReplay.visible = false;
			
			updatePlaybackButtonState();
		}
		
	}

}