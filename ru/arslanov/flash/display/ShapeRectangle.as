/**
 * Copyright (c) 2014 SmartHead. All rights reserved.
 */
package ru.arslanov.flash.display
{

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ShapeRectangle extends AShape
	{
		private var _x:Number;
		private var _y:Number;
		private var _width:Number;
		private var _height:Number;

		private var _cornerRadius:Number = 0;
		private var _isFill:Boolean = true;
		private var _fillColor:Number = 0xff0000;
		private var _fillAlpha:Number = 1;

		private var _isBorder:Boolean = false;
		private var _borderThickness:Number = 1;
		private var _borderColor:Number = 0x0000ff;
		private var _borderAlpha:Number = 1;
		private var _pixelHinting:Boolean;

		public function ShapeRectangle( x:Number, y:Number, width:Number, height:Number, cornerRadius:Number = 0 )
		{
			_x = x;
			_y = y;
			_width = width;
			_height = height;
			_cornerRadius = cornerRadius;
			mouseEnabled = false;
			super();
		}

		public function clear():void
		{
			this.graphics.clear();
		}

		public function setBackground( isFill:Boolean, fillColor:Number, fillAlpha:Number = 1 ):ShapeRectangle
		{
			_isFill = isFill;
			_fillColor = fillColor;
			_fillAlpha = fillAlpha;
			return draw();
		}

		public function setBorder( isBorder:Boolean, borderThickness:Number, borderColor:Number, borderAlpha:Number = 1, pixelHinting:Boolean = false ):ShapeRectangle
		{
			_isBorder = isBorder;
			_borderThickness = borderThickness;
			_borderColor = borderColor;
			_borderAlpha = borderAlpha;
			_pixelHinting = pixelHinting;
			return draw();
		}

		public function resize( width:Number, height:Number ):ShapeRectangle
		{
			if ( (width == this.width) && (height == this.height) ) return this;

			_width = width;
			_height = height;
			return draw();
		}

		public function draw():ShapeRectangle
		{
			this.clear();
			if ( _isFill ) this.graphics.beginFill( _fillColor, _fillAlpha );
			if ( _isBorder ) this.graphics.lineStyle( _borderThickness, _borderColor, _borderAlpha, _pixelHinting );
			if ( _cornerRadius == 0 ) {
				this.graphics.drawRect( _x, _y, _width, _height );
			} else {
				this.graphics.drawRoundRect( _x, _y, _width, _height, 2 * _cornerRadius, 2 * _cornerRadius );
			}
			if ( _isFill ) this.graphics.endFill();
			return this;
		}

		override public function get width():Number { return _width; }

		override public function set width( value:Number ):void
		{
			if ( value == width ) return;
			_width = value;
			draw();
		}

		override public function get height():Number { return _height; }

		override public function set height( value:Number ):void
		{
			if ( value == height ) return;
			_height = value;
			draw();
		}
	}
}
