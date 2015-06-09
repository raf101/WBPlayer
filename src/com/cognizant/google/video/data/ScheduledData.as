package com.cognizant.google.video.data {
	/**
	 * ...
	 * @author Rafael Nepomuceno
	 * @created 6/7/2015 10:03 PM
	 */
	public class ScheduledData {
		
		private var _id:String;
		private var _begin:Date;
		private var _end:Date;
		
		public function get id ():String { return _id; }
		public function get begin ():Date { return _begin; }
		public function get end ():Date { return _end; }
		
		public function ScheduledData ( id:String, begin:Date = null, end:Date = null ) {
			_id = id;
			_begin = begin;
			_end = end;
		}
	}

}