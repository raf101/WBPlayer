package com.google.cognizant.video.data {
	/**
	 * ...
	 * @author Rafael Nepomuceno
	 * @created 6/7/2015 10:03 PM
	 */
	public class VideoSched {
		
		private var _videoData:VideoData;
		private var _begin:Date;
		private var _end:Date;
		
		public function get videoData ():VideoData { return _videoData; }
		public function get begin ():Date { return _begin; }
		public function get end ():Date { return _end; }
		
		public function VideoSched ( videoData:VideoData, begin:Date = null, end:Date = null ) {
			_videoData = videoData;
			_begin = begin;
			_end = end;
		}
	}

}