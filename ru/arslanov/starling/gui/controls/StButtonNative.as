package ru.arslanov.starling.gui.controls {
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	import ru.arslanov.core.utils.Log;
	import ru.arslanov.starling.interfaces.IKillableStarling;
	import starling.display.Button;
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class StButtonNative extends Button implements IKillableStarling {
		
		static private var _count:Number = 0;
		
		public var onClick:Function;
		public var customData:Object;
		
		private var _uid:Number = 0;
		private var _isKilled:Boolean = false;
		private var _pos:Point = new Point();
		private var _skin:StButtonSkinNative;
		
		public function StButtonNative( skinClass:Class ) {
			_uid = ++_count;
			
			_skin = new skinClass();
			_skin.init();
			
			if ( !_skin.upTexture ) {
				Log.traceError( "upTexture texture is null!" );
				_skin.upTexture = Texture.fromColor( 50, 50, 0xffff0000 );
			}
			
			super( _skin.upTexture, _skin.textLabel, _skin.downTexture );
		}
		
		public function init():* {
			addEventListener( Event.TRIGGERED, hrTriggered );
			
			// override me
			return this;
		}
		
		private function hrTriggered( ev:Event ):void {
			if ( onClick != null ) {
				if (onClick.length == 1) {
					onClick( this );
				} else {
					onClick();
				}
			}
		}
		
		public function get pos():Point {
			_pos.setTo( x, y );
			return _pos;
		}
		
		public function set pos( value:Point ):void {
			_pos = value;
			
			x = _pos.x;
			y = _pos.y;
		}
		
		public function setXY( x:Number = 0, y:Number = 0, round:Boolean = true ):void {
			super.x = round ? Math.round( x ) : x;
			super.y = round ? Math.round( y ) : y;
		}
		
		public function get isKilled():Boolean {
			return _isKilled;
		}
		
		public function kill() : void {
			if ( _isKilled ) throw ( new Error ( this + " already killed!" ) ).getStackTrace();
			
			removeEventListener( Event.TRIGGERED, hrTriggered );
			onClick = null;
			
			removeFromParent( true );
			
			_pos = null;
			_skin = null;
			customData = null;
			
			_isKilled = true;
			
			// override me
		}
		
		public function get uid():Number {
			return _uid;
		}
		
		public function get uidStr():String {
			return "0x" + _uid.toString( 16 ).toUpperCase();
		}
		
		public function toString():String {
			return "[" + getQualifiedClassName( this ).split( ":" ).pop() + " " + uidStr + "]";
		}
		
	}

}