package {
	import com.google.cognizant.video.data.ScheduledData;
	import com.google.cognizant.video.utils.dateSwap;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Rafael Nepomuceno
	 */
	public class Main extends Sprite {
		
		public function Main():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			dateSwapTest();
		}
		
		private function dateSwapTest (  ):void {
			var testDate:Date = new Date(2015, 5, 7); // For testing
			
			var schedPre:ScheduledData = new ScheduledData('pre', new Date(2015, 5, 6, 23), new Date(2015, 5, 7));
			var schedNow:ScheduledData = new ScheduledData('now', new Date(2015, 5, 7), new Date(2015, 5, 9));
			var schedPost:ScheduledData = new ScheduledData('post', new Date(2015, 5, 9), new Date(2015, 5, 10));
			
			//trace(dateSwap([schedPre, schedNow, schedPost]));
			trace(dateSwap([schedPre, schedNow, schedPost], testDate)); // Test using test date
			// -- result 'now'
		}
	}
	
}