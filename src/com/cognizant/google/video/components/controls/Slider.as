﻿package com.cognizant.google.video.components.controls  {	import flash.display.MovieClip;	import flash.events.Event;	import flash.events.MouseEvent;	import flash.geom.Rectangle;	import flash.events.EventDispatcher;	import flash.display.DisplayObject;		/**	 * ...	 * 	 * @author ...	 * 	 * @created mm/dd/yyyy 00:00 AM	 */	public class Slider extends EventDispatcher {				// NOTE: This should be the order of access modifiers per section.		// - PUBLIC		// - INTERNAL		// - PROTECTED		// - PRIVATE				// Please use these section dividers as the guide limit length of chars per line.		// ------------------------------- STATIC VARIABLES --------------------------------				// ----------------------------------- VARIABLES -----------------------------------		public var _knob:DisplayObject;		public var _bar:DisplayObject;		private var _hitArea:DisplayObject;				private var _bound:Rectangle;		private var _barWidth:Number;		private var _tmpPos:Number;		private var _isDrag:Boolean;								// --------------=--------------- STATIC GETTERS/SETTERS ---------------------------				// --------------------------- OVERRIDEN GETTERS/SETTERS ---------------------------				// ------------------------------- GETTERS/SETTERS ---------------------------------		public function get isDrag ():Boolean {			return _isDrag;		}				public function get barWidth ():Number {			return _barWidth;		}						// ------------------------------- STATIC METHODS ----------------------------------				// -------------------------------- CONSTRUCTOR ------------------------------------				public function Slider (bar:DisplayObject, hitArea:DisplayObject, knob:DisplayObject = null) {			// constructor code			_bar = bar;			_hitArea = hitArea;			_knob = knob;			init();		}						// ----------------------------- OVERRIDEN METHODS ---------------------------------				// ------------------------   OVERRIDEN EVENT knobRS -----------------------------				// ---------------------------------  METHODS --------------------------------------				public function update (value:Number):void {			if (isDrag) return;			_bar.scaleX = value;			_knob.x = _bar.width;		}				public function getValue ():Number {			return _bar.scaleX;		}				private function updatePos ():void {			var pos:Number = _hitArea.mouseX;;			if (pos > _barWidth) pos = _barWidth;			else if (pos < 0) pos = 0;						if (pos != _tmpPos) {				if (_knob)					_knob.x = pos;				_bar.width = pos;								dispatchEvent(new Event('update'));			}			_tmpPos = pos;		}				// ------------------------------ EVENT knobRS -----------------------------------		private function init ():void {						if (_hitArea is MovieClip) {				MovieClip(_hitArea).buttonMode = true;				MovieClip(_hitArea).mouseChildren = false;			}			_barWidth = _bar.width;			_bar.width = _tmpPos = 0;						if (_knob) {				_knob.x = 0;				_knob.y = _bar.y;			}						_hitArea.addEventListener(MouseEvent.MOUSE_DOWN, barDownHandler);						_hitArea.stage.addEventListener(MouseEvent.MOUSE_UP, upHandler);		}				private function upHandler (e:MouseEvent):void {			// stop drag			if (!_isDrag) return;						_isDrag = false;			_hitArea.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);			dispatchEvent(new Event('stopDrag'));		}				private function barDownHandler (e:MouseEvent):void {			if (!_isDrag) {				// jump				updatePos();								_isDrag = true;				_hitArea.addEventListener(Event.ENTER_FRAME, enterFrameHandler);				dispatchEvent(new Event('startDrag'));			}					}				private function enterFrameHandler (e:Event):void {			updatePos();		}				public function destroy ():void {			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);			_hitArea.removeEventListener(MouseEvent.MOUSE_DOWN, barDownHandler);						_hitArea.stage.removeEventListener(MouseEvent.MOUSE_UP, upHandler);		}	}	}