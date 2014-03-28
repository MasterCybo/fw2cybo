package ru.arslanov.core.controllers {
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import ru.arslanov.core.utils.Log;
	/**
	 * ...
	 * @author 
	 */
	public class KeyController {
		
		static public var allowTrace:Boolean = true;
		static public var bufferSize:uint = 30;
		static public var delayPressRepeat:Number = 1;// seconds
		
		static private var _inited:Boolean = false;
		static private var _stage:Stage;
		static private var _enabled:Boolean = true;
		static private var _pressEvent:KeyboardEvent;
		static private var _buffer:Vector.<uint>;
		static private var _delayTimer:Timer;
		
		static private var _releaseListeners:Object/*Array*/;
		static private var _pressListeners:Object/*Array*/;
		static private var _combsListeners:Object/*Array*/;
		
		public function KeyController() {
			
		}
		
		static public function init( stage:Stage ):void {
			if ( _inited ) {
				Log.traceWarn( "KeyController.init : KeyController already inited!" );
				return;
			}
			
			_stage = stage;
			
			_releaseListeners = { };
			_pressListeners = { };
			_combsListeners = { };
			
			_buffer = new Vector.<uint>();
			
			_delayTimer = new Timer( delayPressRepeat * 1000 );
			_delayTimer.addEventListener( TimerEvent.TIMER, beginRepeat );
			
			_stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
			_stage.addEventListener( KeyboardEvent.KEY_UP, onKeyUp );
			
			Log.traceText( "KeyController successful inited." );
			
			_inited = true;
		}
		
		
		static private function onKeyDown( ev:KeyboardEvent ):void {
			toTrace( "KeyController.onKeyDown : Key down = " + String.fromCharCode( ev.keyCode ) + ", code = " + ev.keyCode );
			
			addToBuffer( ev.keyCode );
			
			_pressEvent = ev;
			
			_delayTimer.delay = delayPressRepeat * 1000;
			_delayTimer.start();
		}
		
		static private function beginRepeat( ev:TimerEvent ):void {
			_delayTimer.stop();
			_stage.addEventListener( Event.ENTER_FRAME, onEF );
		}
		
		static private function onEF( ev:Event ):void {
			var listeners:Array = _pressListeners[_pressEvent.keyCode];
			
			for each (var fn:Function in listeners ) {
				fn( _pressEvent );
			}
			
			listeners = null;
			
			addToBuffer( _pressEvent.keyCode );
		}
		
		static private function onKeyUp( ev:KeyboardEvent ):void {
			toTrace( "KeyController.onKeyUp : Key up = " + String.fromCharCode( ev.keyCode ) + ", code = " + ev.keyCode );
			
			_delayTimer.stop();
			
			_stage.removeEventListener( Event.ENTER_FRAME, onEF );
			_pressEvent = null;
			
			var listeners:Array = _releaseListeners[ev.keyCode];
			
			for each (var fn:Function in listeners ) {
				if ( fn.length > 0 ) {
					fn( ev );
				} else {
					fn();
				}
			}
			
			listeners = null;
		}
		
		static public function get enabled():Boolean {
			return _enabled;
		}
		
		static public function set enabled( value:Boolean ):void {
			_enabled = value
		}
		
		static public function bindPress( keyCode:uint, pressHandler:Function ):void {
			if ( !_pressListeners[keyCode] ) {
				_pressListeners[keyCode] = [];
			}
			
			if ( _pressListeners[keyCode].indexOf( pressHandler ) != -1 ) {
				Log.traceWarn( "For key code " + keyCode + " this press handler already exists!" );
				return;
			}
			
			_pressListeners[keyCode].push( pressHandler );
		}
		
		static public function bindRelease( keyCode:uint, releaseHandler:Function ):void {
			if ( !_releaseListeners[keyCode] ) {
				_releaseListeners[keyCode] = [];
			}
			
			if ( _releaseListeners[keyCode].indexOf( releaseHandler ) != -1 ) {
				Log.traceWarn( "For key code " + keyCode + " this release handler already exists!" );
				return;
			}
			
			_releaseListeners[keyCode].push( releaseHandler );
		}
		
		// TODO: реализовать KeyController.bindPressCombs
		static public function bindPressCombs( keyCodes:Array, releaseHandler:Function ):void {
			
		}
		
		static public function unbind( keyCode:uint, handler:Function ):void {
			var idx:int;
			
			var listeners:Array = _releaseListeners[keyCode];
			if ( listeners ) {
				idx = listeners.indexOf( handler );
				if ( idx != -1 ) {
					_releaseListeners[keyCode].splice( idx, 1 );
				}
			}
			
			listeners = _pressListeners[keyCode];
			if ( listeners ) {
				idx = listeners.indexOf( handler );
				if ( idx != -1 ) {
					_pressListeners[keyCode].splice( idx, 1 );
				}
			}
		}
		
		static public function unbindAll():void {
			_releaseListeners = { };
			_pressListeners = { };
		}
		
		static private function toTrace( str:String ):void {
			if ( !allowTrace) return;
			
			Log.traceText( str );
		}
		
		static public function clearBuffer():void {
			_buffer.length = 0;
		}
		
		static public function getBufferString():String {
			var str:String = "";
			
			for (var i:int = _buffer.length - 1; i >= 0 ; i--) {
				str += String.fromCharCode( _buffer[i] );
			}
			
			return str;
		}
		
		static public function getBufferCode():Vector.<uint> {
			return _buffer.concat();
		}
		
		static private function addToBuffer( keyCode:uint ):void {
			_buffer.unshift( keyCode );
			
			if ( _buffer.length > bufferSize ) {
				_buffer.length = bufferSize;
			}
		}
		
		// TODO: реализовать KeyController.getAllBinds
		static public function getAllBinds():String {
			var str:String = "";
			
			return str;
		}
	}

}