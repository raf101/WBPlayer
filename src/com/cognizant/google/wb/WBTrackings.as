﻿package com.cognizant.google.wb {	import com.google.ads.studio.ProxyEnabler;		/**	 * ...	 * 	 * @author ...	 * 	 * @created mm/dd/yyyy 00:00 AM	 */	public class WBTrackings {				// NOTE: This should be the order of access modifiers per section.		// - PUBLIC		// - INTERNAL		// - PROTECTED		// - PRIVATE				// Please use these section dividers as the guide limit length of chars per line.		// ------------------------------- STATIC VARIABLES --------------------------------				// ----------------------------------- VARIABLES -----------------------------------		public var enabler:ProxyEnabler;		private var _activeTimers:Object;		// --------------=--------------- STATIC GETTERS/SETTERS ---------------------------				// --------------------------- OVERRIDEN GETTERS/SETTERS ---------------------------				// ------------------------------- GETTERS/SETTERS ---------------------------------				// ------------------------------- STATIC METHODS ----------------------------------				// -------------------------------- CONSTRUCTOR ------------------------------------				public function WBTrackings () {			// constructor code			enabler = ProxyEnabler.getInstance();			_activeTimers = {};		}						// ----------------------------- OVERRIDEN METHODS ---------------------------------				// ------------------------   OVERRIDEN EVENT HANDLERS -----------------------------				// ---------------------------------  METHODS --------------------------------------		public function exit (type:Object):void {			switch (type) {				case 0:					trace('[EXIT type = int]', type);					break;				case 'A':					trace('[EXIT type = String]', type);					break;			}		}				public function counter (type:Object):void {			switch (type) {				case 0:					trace('[COUNTER type = int]', type);					break;				case 'A':					trace('[COUNTER type = String]', type);					break;			}		}				public function startTimer (type:Object):void {			if (_activeTimers[type]) return;			_activeTimers[type] = true;						switch (type) {				case 0:					trace('[STARTTIMER type = int]', type);					break;				case 'A':					trace('[STARTTIMER type = String]', type);					break;			}		}				public function stopTimer (type:Object):void {			if (!_activeTimers[type]) return;			_activeTimers[type] = false;						switch (type) {				case 0:					trace('[STOPTIMER type = int]', type);					break;				case 'A':					trace('[STOPTIMER type = String]', type);					break;			}		}				public function stopAllTimers ():void {			for (var i:Object in _activeTimers) {				stopTimer(i);			}		}				// ------------------------------ EVENT HANDLERS -----------------------------------	}	}