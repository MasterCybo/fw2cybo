package ru.arslanov.starling.gui.feathers {
	import feathers.controls.Button;
	import flash.geom.Point;
	import ru.arslanov.starling.interfaces.IStDisplayObject;
	import starling.display.Image;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class BtnFeathersNative extends Button implements IStDisplayObject {
		
		static private var _count:Number = 0;
		
		private var _uid:Number = 0;
		private var _isKilled:Boolean = false;
		private var _pos:Point = new Point();
		
		public function BtnFeathersNative( text:String = "" ) {
			super();
			
			super.label = text;
		}
		
		/* INTERFACE ru.arslanov.starling.interfaces.IStDisplayObject */
		
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
			if ( _isKilled ) throw ( new Error ( "BtnFeathersNative already killed!" ) ).getStackTrace();
			
			removeFromParent( true );
			_pos = null;
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
			return "[BtnFeathersNative " + uidStr + ", x=" + x + ", y=" + y + "]";
		}
		
		/* INTERFACE ru.arslanov.starling.interfaces.IStDisplayObject */
		
		public function killChildren( startIdx:uint = 0, num:int = -1 ):void {
			
		}
	}

}