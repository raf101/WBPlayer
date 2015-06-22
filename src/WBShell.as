﻿package  {	import com.cognizant.google.wb.config.WBConfig;	import com.cognizant.google.wb.events.WBEvent;	import com.cognizant.google.wb.WBCreative;	import com.google.ads.studio.display.StudioLoader;	import com.google.ads.studio.events.StudioEvent;	import com.google.ads.studio.HtmlEnabler;	import flash.display.MovieClip;	import flash.events.Event;	import flash.system.Security;			/**	 * ...	 * 	 * @author Rafael Nepomuceno	 * 	 * @created mm/dd/yyyy 00:00 AM	 */	public class WBShell extends MovieClip {				// NOTE: This should be the order of access modifiers per section.		// - PUBLIC		// - INTERNAL		// - PROTECTED		// - PRIVATE				// Please use these section dividers as the guide limit length of chars per line.		// ------------------------------- STATIC VARIABLES --------------------------------				// ----------------------------------- VARIABLES -----------------------------------		public var enabler:HtmlEnabler;		public var collapsedContainer:MovieClip;		public var expandedContainer:MovieClip;				private var _wb:WBCreative;				// --------------=--------------- STATIC GETTERS/SETTERS ---------------------------				// --------------------------- OVERRIDEN GETTERS/SETTERS ---------------------------				// ------------------------------- GETTERS/SETTERS ---------------------------------				// ------------------------------- STATIC METHODS ----------------------------------				// -------------------------------- CONSTRUCTOR ------------------------------------				public function WBShell () {			// constructor code			Security.allowDomain('*');			if (stage) addedToStageHandler();			else addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);		}						// ----------------------------- OVERRIDEN METHODS ---------------------------------				// ------------------------   OVERRIDEN EVENT HANDLERS -----------------------------				// ---------------------------------  METHODS --------------------------------------				// ------------------------------ EVENT HANDLERS -----------------------------------		private function addedToStageHandler (e:Event = null):void {			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);						enabler = HtmlEnabler.getInstance();			enabler.init(this);						_wb = WBCreative.getInstance();			_wb.init(this);						_wb.addEventListener(WBEvent.EXPANDED, wbExpandHandler);			_wb.addEventListener(WBEvent.COLLAPSED, wbCollapseHandler);						enabler.addEventListener(StudioEvent.PAGE_LOADED, politeLoadHandler);		}				private function politeLoadHandler (e:StudioEvent):void {			enabler.removeEventListener(StudioEvent.PAGE_LOADED, politeLoadHandler);						var loader:StudioLoader = _wb.helper.loadDisplay(WBConfig.URL_CHILD, 				function (e:Event):void { // onComplete					_wb.mcCollapsed = MovieClip(loader.content);				}			);			collapsedContainer.addChild(loader);						if (WBConfig.AUTO_EXPAND) {				_wb.startAutoExpand(WBConfig.TIMEOUT_AUTO_EXPAND);				collapsedContainer.visible = false;			}		}				private function wbExpandHandler (e:WBEvent):void {			var loader:StudioLoader = _wb.helper.loadDisplay(				_wb.isAutoExpanded ? 					WBConfig.URL_AUTO_EXPANDED : 					WBConfig.URL_EXPANDED, 				function (e:Event):void { // onComplete					_wb.mcExpanded = MovieClip(loader.content);				}			);			expandedContainer.addChild(loader);		}				private function wbCollapseHandler (e:WBEvent):void {			expandedContainer.removeChildAt(0);			collapsedContainer.visible = true;		}	}	}