package com.google.cognizant.video.utils {
	import com.google.cognizant.video.data.VideoData;
	import com.google.cognizant.video.data.VideoSched;
	/**
	 * ...
	 * @author Rafael Nepomuceno
	 * @created 6/7/2015 10:02 PM
	 */
		
	public function dateSwap ( videoScheds:Array, currentDate:Date = null ):VideoData {
		var now:Date = currentDate || new Date();
		var videoSched:VideoSched;
		var len:int = videoScheds.length;
		for ( var i:int = 0; i < len; i++ ) {
			videoSched = videoScheds[i];
			
			if (!videoSched.begin && !videoSched.end) { // default always return
				return videoSched.videoData;
			} else if (!videoSched.begin) { // returns video before end date.
				if (now < videoSched.end)
					return videoSched.videoData;
			} else if (!videoSched.end) { // returns video during and after begin date.
				if (videoSched.begin >= now)
					return videoSched.videoData;
			} else { // return video between begin and end date.
				if (now >= videoSched.begin && now < videoSched.end)
					return videoSched.videoData;
			}
		}
		
		return new VideoData('none');
	}

}