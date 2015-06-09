package com.google.cognizant.video.data {
	/**
	 * ...
	 * @author Rafael Nepomuceno
	 * @created 6/7/2015 10:04 PM
	 */
	public class VideoData {
		private var _reportingIdentifier:String;
		private var _low:String;
		private var _medium:String;
		private var _high:String;
		private var _hd:String;
		private var _isStreaming:Boolean;
		
		public function get reportingIdentifier ():String { return _reportingIdentifier; }
		public function get low ():String { return _low; }
		public function get medium ():String { return _medium; }
		public function get high ():String { return _high; }
		public function get hd ():String { return _hd; }
		public function get isStreaming ():Boolean { return _isStreaming; }
		
		public function VideoData ( reportingIdentifier:String, low:String = null, medium:String = null, high:String = null, hd:String = null, isStreaming:Boolean = false ) {
			_reportingIdentifier = reportingIdentifier;
			_low = low;
			_medium = medium;
			_high = high;
			_hd = hd;
			_isStreaming = isStreaming;
		}
	}

}