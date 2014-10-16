package ru.arslanov.starling.display {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	import ru.arslanov.starling.interfaces.IKillableStarling;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class StImageBase extends Image implements IKillableStarling {
		
		static private var _count:Number = 0;
		
		public var customData:Object;
		
		private var _isKilled:Boolean = false;
		private var _uid:Number = 0;
		private var _pos:Point = new Point();
		
		static public function getFromBitmap( bitmap:Bitmap, generateMipMaps:Boolean = true, optimizeForRenderToTexture:Boolean = false, scale:Number=1 ):StImageBase {
			return new StImageBase( Texture.fromBitmap( bitmap, generateMipMaps, optimizeForRenderToTexture, scale ) );
		}
		
		static public function getFromBitmapData( bitmapData:BitmapData, generateMipMaps:Boolean = true, optimizeForRenderToTexture:Boolean = true, scale:Number = 1 ):StImageBase {
			return new StImageBase( Texture.fromBitmapData( bitmapData, generateMipMaps, optimizeForRenderToTexture, scale ) );
		}
		
		
		
		public function StImageBase( texture:Texture = null ) {
			_uid = ++_count;
			
			addEventListener( Event.ADDED_TO_STAGE, hrAddedToStage );
			
			super( texture );
		}
		
		protected function hrAddedToStage( ev:Event ):void {
			removeEventListener( Event.ADDED_TO_STAGE, hrAddedToStage );
			// override me
		}
		
		public function init():* {
			// override me
			return this;
		}
		
		//static public function getFromAtlas( name:String ):StBaseImage {
			//return new StBaseImage( Asset.getTexFromAtlas ( name ) );
		//}
		
		//static public function getFromEmbed( className:Class ):StBaseImage {
			//return new StBaseImage( Asset.getTexEmbed ( className ) );
		//}
		
		//static public function drawRect( width:uint, height:uint, color:Number ):StBaseImage {
			//return new StBaseImage( Asset.getDefTex ( width, height, color ) );
		//}
		
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
			if ( _isKilled ) {
				throw ( new Error ( this + " already killed!" ) ).getStackTrace();
			}
			
			removeEventListener( Event.ADDED_TO_STAGE, hrAddedToStage );
			
			removeFromParent( true );
			//texture.dispose();
			dispose();
			
			customData = null;
			_pos = null;
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
		
	}

}