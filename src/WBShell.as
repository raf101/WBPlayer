package  {
	import com.cognizant.google.wb.WBCreative;
	import flash.display.MovieClip;
	import flash.events.Event;
	import com.google.ads.studio.HtmlEnabler;
	import com.google.ads.studio.events.StudioEvent;
	
	
	/**
	 * ...
	 * 
	 * @author ...
	 * 
	 * @created mm/dd/yyyy 00:00 AM
	 */
	public class WBShell extends MovieClip {
		
		// NOTE: This should be the order of access modifiers per section.
		// - PUBLIC
		// - INTERNAL
		// - PROTECTED
		// - PRIVATE
		
		// Please use these section dividers as the guide limit length of chars per line.
		// ------------------------------- STATIC VARIABLES --------------------------------
		
		// ----------------------------------- VARIABLES -----------------------------------
		public var enabler:HtmlEnabler;
		
		private var _wb:WBCreative;
		
		// --------------=--------------- STATIC GETTERS/SETTERS ---------------------------
		
		// --------------------------- OVERRIDEN GETTERS/SETTERS ---------------------------
		
		// ------------------------------- GETTERS/SETTERS ---------------------------------
		
		// ------------------------------- STATIC METHODS ----------------------------------
		
		// -------------------------------- CONSTRUCTOR ------------------------------------
		
		public function WBShell () {
			// constructor code
			if (stage) addedToStageHandler();
			else addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		
		// ----------------------------- OVERRIDEN METHODS ---------------------------------
		
		// ------------------------   OVERRIDEN EVENT HANDLERS -----------------------------
		
		// ---------------------------------  METHODS --------------------------------------
		
		// ------------------------------ EVENT HANDLERS -----------------------------------
		private function addedToStageHandler (e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			enabler = HtmlEnabler.getInstance();
			enabler.init(this);
			_wb = WBCreative.getInstance();
			
			
			enabler.addEventListener(StudioEvent.PAGE_LOADED, politeLoadHandler);
		}
		
		private function politeLoadHandler (e:StudioEvent):void {
			enabler.removeEventListener(StudioEvent.PAGE_LOADED, politeLoadHandler);
		}
	}
	
}
