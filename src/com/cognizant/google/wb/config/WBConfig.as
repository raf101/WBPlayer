﻿package com.cognizant.google.wb.config {	/**	 * ...	 * @author Rafael Nepomuceno	 * @created 6/17/2015 1:25 AM	 */	public class WBConfig {				public static const AUTO_EXPAND_TIMEOUT:int = 15000; // Auto collapse		public static const VIDEO_AUTOPLAY_TIMEOUT:int = 15000; // Video preview timeout		public static const VIDEO_AUTO_ADVANCE_TIMEOUT:int = 5000; // Auto play next video timeout				public static const URL_CHILD:String = 'collapsed.swf';		public static const URL_EXPANDED:String = 'expanded.swf';		public static const URL_AUTO_EXPANDED:String = 'expanded.swf'; // If no different auto expanded panel just put the expanded panel too.		public static const AUTO_EXPAND:Boolean = true;	}}