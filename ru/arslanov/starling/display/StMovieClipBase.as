package ru.arslanov.starling.display {
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	import ru.arslanov.starling.interfaces.IStDisplayObjectKillable;
	import starling.display.DisplayObject;
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.textures.Texture;

	
	/**
	 * Базовый спрайт
	 * @author Artem Arslanov
	 */
	public class StMovieClipBase extends MovieClip implements IStDisplayObjectKillable {
		
		static private var _count:Number = 0;
		
		private var _isKilled:Boolean = false;
		private var _uid:Number = 0;
		private var _pos:Point = new Point();
		
		public var customData:Object;
		
		public function StMovieClipBase( textures:Vector.<Texture>, fps:Number = 30 ) {
			_uid = ++_count;
			
			addEventListener( Event.ADDED_TO_STAGE, hrAddedToStage );
			
			super( textures, fps );
		}
		
		protected function hrAddedToStage( ev:Event ):void {
			removeEventListener( Event.ADDED_TO_STAGE, hrAddedToStage );
			// override me
		}
		
		public function init():* {
			// override me
			return this;
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
				throw ( new Error ( this + " already killed!" ) ).getStackTrace();
			}
			
			removeEventListener( Event.ADDED_TO_STAGE, hrAddedToStage );
			
			removeFromParent( true );
			
			dispose();
			
			_pos = null;
			
			customData = null;
			
			_isKilled = true;
			
			// override me
		}
		
		public function get uid():Number {
			return _uid;
		}
		
		public function get uidStr():String {
			return "0x" + uid.toString( 16 ).toUpperCase();
		}
		
		public function toString():String {
			return "[" + getQualifiedClassName( this ).split( ":" ).pop() + " " + uidStr + "]";
		}
		
		//public function set mouseEnabled( value:Boolean ):void {
			// unused
		//}
		
		//public function set mouseChildren( value:Boolean ):void {
			// unused
		//}
		
		//override public function getBounds( space:DisplayObject ):Rectangle {
			// unused
			//return null;
		//}
		//public function getRect( space:DisplayObject ):Rectangle {
			// unused
			//return null;
		//}
		
		//public function get graphics():Graphics {
			// unused
			//return null;
		//}
	}

}