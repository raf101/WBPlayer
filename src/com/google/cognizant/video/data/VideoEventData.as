﻿package com.google.cognizant.video.data {	/**	 * ...	 * @author Rafael Nepomuceno	 * @created 6/7/2015 9:42 PM	 */	public class VideoEventData {		private var _reportingIdentifier:String;		private var _id:String;		private var _index:int;				public function get reportingIdentifier ():String { return _reportingIdentifier; }		public function get id ():String { return _id; }		public function get index ():int { return _index; }						public function VideoEventData ( id:String, reportingIdentifier:String, index:int ) {			_id = id;			_reportingIdentifier = reportingIdentifier;			_index = index;		}				public function toString ():String {			return '[VideoEventData id="'+ id + '"' + '" reportingIdentifier="' + reportingIdentifier + '" index=' + index + ']';		}	}}