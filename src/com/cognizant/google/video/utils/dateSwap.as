package com.cognizant.google.video.utils {
	import com.cognizant.google.video.data.VideoData;
	import com.cognizant.google.video.data.ScheduledData;
	/**
	 * ...
	 * @author Rafael Nepomuceno
	 * @created 6/7/2015 10:02 PM
	 */
		
	public function dateSwap ( schedsData:Array, currentDate:Date = null ):String {
		var now:Date = currentDate || new Date();
		var data:ScheduledData;
		var len:int = schedsData.length;
		for ( var i:int = 0; i < len; i++ ) {
			data = schedsData[i];
			
			if (!data.begin && !data.end) { // default always return
				return data.id;
			} else if (!data.begin) { // returns video before end date.
				if (now < data.end)
					return data.id;
			} else if (!data.end) { // returns video during and after begin date.
				if (data.begin >= now)
					return data.id;
			} else { // return video between begin and end date.
				if (now >= data.begin && now < data.end)
					return data.id;
			}
		}
		
		return '';
	}

}