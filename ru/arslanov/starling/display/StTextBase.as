package ru.arslanov.starling.display {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	import ru.arslanov.starling.interfaces.IStDisplayObjectKillable;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class StTextBase extends TextField implements IStDisplayObjectKillable {
		
		static public var defaultAutoScale:Boolean = false;
		static public var defaultAutoSize:String = TextFieldAutoSize.BOTH_DIRECTIONS;
		
		static private var _count:Number = 0;
		
		private var _isKilled:Boolean = false;
		private var _uid:Number = 0;
		private var _pos:Point = new Point();
		
		public function StTextBase( text:String = "", width:int = 50, height:int = 50, fontName:String = "Verdana", fontSize:Number = 12, color:uint = 0, bold:Boolean = false ) {
			_uid = ++_count;
			addEventListener( Event.ADDED_TO_STAGE, hrAddedToStage );
			
			super( width, height, text, fontName, fontSize, color, bold );
		}
		
		protected function hrAddedToStage( ev:Event ):void {
			removeEventListener( Event.ADDED_TO_STAGE, hrAddedToStage );
			// override me
		}
		
		public function init():* {
			touchable = false;
			autoScale = defaultAutoScale;
			//autoSize = defaultAutoSize;
			
			hAlign = "left";
			vAlign = "top";
			
			//border = true;
			//autoFit();
			return this;
			// override me
		}
		
		private var _autoScale:Boolean;
		
		public function autoFit():void {
			_autoScale = autoScale;
			
			autoScale = false;
			
			//dispose();
			
			width = 1500;
			
			width = textBounds.width + 5;
			height = textBounds.height + 5;
			
			autoScale = _autoScale;
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
			
			_pos.setTo( super.x, super.y );
		}
		
		public function get isKilled():Boolean {
			return _isKilled;
		}
		
		public function kill() : void {
			if ( _isKilled ) {
				throw ( new Error ( "StBaseText already killed!" ) ).getStackTrace();
			}
			
			removeEventListener( Event.ADDED_TO_STAGE, hrAddedToStage );
			
			removeFromParent( true );
			_pos = null;
			_isKilled = true;
			
			dispose();
			
			// override me
		}
		
		public function get uid():Number {
			return _uid;
		}
		
		public function get uidStr():String {
			return "0x" + uid.toString( 16 ).toUpperCase();
		}
		
		public function toString():String {
			return "[" + getQualifiedClassName( this ).split( ":" ).pop() + " " + uidStr + ', text="' + text.substr( 0, 20 ) + '", x=' + x + ", y=" + y + ", font=" + fontName + ", size=" + fontSize + ", color=" + color + "]";
		}
		
	}

}