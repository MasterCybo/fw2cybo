package ru.arslanov.starling.display {
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import starling.display.Image;
	import starling.textures.Texture;
	/**
	 * Класс, реализующий функционал класса flash.display.Shape
	 * Слабое место класса - метод прорисовки в текстуру
	 * @author Artem Arslanov
	 */
	public class StShapeBase extends StImageBase {
		
		private var _shape:Shape;
		private var _shBounds:Rectangle;
		private var _graphics:StGraphics;
		private var _bmpData:BitmapData = new BitmapData( 1, 1, true, 0xff0000 );
		private var _mtx:Matrix = new Matrix();
		
		public function StShapeBase() {
			_shape = new Shape();
			
			_graphics = new StGraphics();
			_graphics.updateTexture = updateTexture;
			_graphics.clearShape = clearShape;
			_graphics.graphicsNative = _shape.graphics;
			
			super( Texture.fromBitmapData( _bmpData ) );
		}
		
		private function clearShape():void {
			_bmpData.dispose();
			_mtx.identity();
			_shBounds = _shape.getBounds( _shape );
			
			updateTexture();
		}
		
		public function get graphics():StGraphics {
			return _graphics;
		}
		
		/**
		 * запекаем в текстуру
		 */
		private function updateTexture():void {
			_shBounds = _shape.getBounds( _shape );
			
			if ( _shBounds.width == 0 || _shBounds.height == 0 ) return;
			
			_shBounds.x = Math.round( _shBounds.x );
			_shBounds.y = Math.round( _shBounds.y );
			
			_mtx.identity();
			_mtx.translate( -_shBounds.x, -_shBounds.y );
			
			_bmpData.dispose();
			_bmpData = new BitmapData( _shBounds.width, _shBounds.height, true, 0xff0000 );
			_bmpData.draw( _shape, _mtx );
			
			texture.dispose();
			texture = Texture.fromBitmapData( _bmpData );
			
			pivotX = -_shBounds.x;
			pivotY = -_shBounds.y;
			
			readjustSize();
		}
		
		override public function kill():void {
			_graphics.kill();
			_graphics = null;
			
			super.kill();
			
			_shape = null;
			_bmpData = null;
			_mtx = null;
			_shBounds = null;
			
			// override me
		}
		
		override public function toString():String {
			return "[StShapeSimple " + uidStr + "]";
		}
	}

}