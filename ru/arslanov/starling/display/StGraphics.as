package ru.arslanov.starling.display {
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class StGraphics {
		
		public var updateTexture:Function;
		public var clearShape:Function;
		public var graphicsNative:Graphics;
		
		public function StGraphics() {
			
		}
		
		public function clear():void {
			graphicsNative.clear();
			clearShape();
		}
		
		public function beginFill( color:uint, alpha:Number=1 ):void {
			graphicsNative.beginFill( color, alpha );
		}
		
		public function beginBitmapFill( bitmap:BitmapData, matrix:Matrix=null, repeat:Boolean=true, smooth:Boolean=false ):void {
			graphicsNative.beginBitmapFill( bitmap, matrix, repeat, smooth );
		}
		
		public function endFill():void {
			graphicsNative.endFill();
			updateTexture();
		}
		
		public function lineStyle( thickness:Number = 1, color:uint = 0, alpha:Number = 1, pixelHinting:Boolean = false, scaleMode:String = "normal", caps:String = null, joints:String = null, miterLimit:Number = 3 ):void {
			graphicsNative.lineStyle( thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit );
		}
		
		public function lineBitmapStyle( bitmap:BitmapData, matrix:Matrix=null, repeat:Boolean=true, smooth:Boolean=false ):void {
			graphicsNative.lineBitmapStyle( bitmap, matrix, repeat, smooth );
		}
		
		// рисовашки
		public function moveTo( x:Number, y:Number ):void {
			graphicsNative.moveTo( x, y );
		}
		
		public function lineTo( x:Number, y:Number ):void {
			graphicsNative.lineTo( x, y );
			updateTexture();
		}
		
		public function drawRect( x:Number, y:Number, width:Number, height:Number ):void {
			graphicsNative.drawRect( x, y, width, height );
			updateTexture();
		}
		
		public function drawCircle( x:Number, y:Number, radius:Number ):void {
			graphicsNative.drawCircle( x, y, radius );
			updateTexture();
		}
		
		public function drawEllipse( x:Number, y:Number, width:Number, height:Number ):void {
			graphicsNative.drawEllipse( x, y, width, height );
			updateTexture();
		}
		
		public function drawRoundRect( x:Number, y:Number, width:Number, height:Number, ellipseWidth:Number, ellipseHeight:Number = NaN ):void {
			graphicsNative.drawRoundRect( x, y, width, height, ellipseWidth, isNaN(ellipseHeight) ? ellipseWidth : ellipseHeight );
			updateTexture();
		}
		
		public function drawRoundRectComplex( x:Number, y:Number, width:Number, height:Number, topLeftRadius:Number, topRightRadius:Number, bottomLeftRadius:Number, bottomRightRadius:Number ):void {
			graphicsNative.drawRoundRectComplex( x, y, width, height, topLeftRadius, topRightRadius, bottomLeftRadius, bottomRightRadius );
			updateTexture();
		}
		
		public function drawTriangles( vertices:Vector.<Number>, indices:Vector.<int> = null, uvtData:Vector.<Number> = null, culling:String = "none" ):void {
			graphicsNative.drawTriangles( vertices, indices, uvtData, culling );
			updateTexture();
		}
		
		public function cubicCurveTo( controlX1:Number, controlY1:Number, controlX2:Number, controlY2:Number, anchorX:Number, anchorY:Number ):void {
			graphicsNative.cubicCurveTo( controlX1, controlY1, controlX2, controlY2, anchorX, anchorY );
			updateTexture();
		}
		
		public function curveTo( controlX:Number, controlY:Number, anchorX:Number, anchorY:Number ):void {
			graphicsNative.curveTo( controlX, controlY, anchorX, anchorY );
			updateTexture();
		}
		
		public function kill():void {
			updateTexture = null;
			clearShape = null;
			graphicsNative = null;
		}
	}

}