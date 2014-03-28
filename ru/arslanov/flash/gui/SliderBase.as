package ru.arslanov.flash.gui {
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import ru.arslanov.core.utils.Calc;
	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.utils.Display;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class SliderBase extends ASprite {
		
		public var onSlide:Function;
		
		private var _skin:SliderSkinBase;
		private var _target:DisplayObject;
		private var _ptMouse:Point;
		private var _ptPress:Point;
		private var _resizableThumb:Boolean;
		private var _position:Number = 0;
		private var _length:Number = 0;
		private var _size:Number = 0;
		
		public function SliderBase( skin:SliderSkinBase, size:Number = 100 ) {
			_skin = skin;
			_size = size;
			
			super();
		}
		
		override public function init():* {
			_ptMouse = new Point();
			_ptPress = new Point();
			
			_skin.init();
			_skin.thumb.onDown = onThumbPress;
			_skin.updatePositionThumb();
			
			size = _size;
			
			addChild( _skin.track as DisplayObject );
			addChild( _skin.thumb );
			
			updateThumbSize();
			
			( _skin.track as DisplayObject ).addEventListener( MouseEvent.CLICK, onBodyClick );
			
			return super.init();
		}
		
		/***************************************************************************
		Мышиные обработчики
		***************************************************************************/
		private function onBodyClick( ev:MouseEvent ):void {
			position = ( ev.localX - _skin.thumb.width / 2 ) / _length;
		}
		
		private function onThumbPress():void {
			_ptPress.x = Display.mouseX;
			_ptPress.y = Display.mouseY;
			
			_ptPress = _skin.thumb.globalToLocal( _ptPress );
			
			//trace( "Math.sin : " + Math.sin( Calc.toRad( rotation ) ) );
			
			if ( ( rotation != 0 ) && ( Math.abs( rotation ) != 180 ) ) {
				var px:Number = _ptPress.x;
				_ptPress.x = _ptPress.y;
				_ptPress.y = px;
			}
			
			Display.stageAddEventListener( MouseEvent.MOUSE_UP, onRelease );
			Display.stageAddEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
			
			( _skin.track as DisplayObject ).removeEventListener( MouseEvent.CLICK, onBodyClick );
		}
		
		private function onMouseMove( ev:MouseEvent ):void {
			_ptMouse.x = ev.stageX - _ptPress.x;
			_ptMouse.y = ev.stageY - _ptPress.y;
			
			position = Math.max( 0, Math.min( globalToLocal( _ptMouse ).x, _length ) ) / _length;
		}
		
		private function onRelease( ev:MouseEvent ):void {
			Display.stageRemoveEventListener( MouseEvent.MOUSE_UP, onRelease );
			Display.stageRemoveEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
			
			( _skin.track as DisplayObject ).addEventListener( MouseEvent.CLICK, onBodyClick );
		}
		
		/***************************************************************************
		Геттеры / Сеттеры
		***************************************************************************/
		public function get position():Number {
			return _position;
		}
		
		public function set position( value:Number ):void {
			value = Math.max( 0, Math.min( value, 1 ) );
			
			if ( value == _position ) return;
			
			_position = value;
			
			updateThumbPosition();
		}
		
		public function get size():Number {
			return _size;
		}
		
		public function set size( value:Number ):void {
			_size = value;
			
			_skin.setSize( _size );
			
			if ( _resizableThumb ) updateThumbSize();
		}
		
		public function getTargetObject():DisplayObject {
			return _target;
		}
		
		public function setTargetObject( value:DisplayObject, resizeThumb:Boolean = true ):void {
			_resizableThumb = resizeThumb;
			_target = value;
			
			updateThumbSize();
		}
		
		/***************************************************************************
		Утилитарные
		***************************************************************************/
		private function updateThumbPosition():void {
			_skin.thumb.x = _position * _length;
			
			if ( onSlide != null ) {
				if ( onSlide.length == 1 ) {
					onSlide( this );
				} else {
					onSlide();
				}
			}
		}
		
		private function updateThumbSize():void {
			_length = _skin.track.width - _skin.thumb.width;
			
			if ( !_target ) return;
			
			_skin.setSizeThumb( _size * _size / _target.width );
			_length = _skin.track.width - _skin.thumb.width;
		}
		
		override public function kill():void {
			( _skin.track as DisplayObject ).removeEventListener( MouseEvent.CLICK, onBodyClick );
			Display.stageRemoveEventListener( MouseEvent.MOUSE_UP, onRelease );
			Display.stageRemoveEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
			
			onSlide = null;
			
			super.kill();
			
			_target = null;
			_skin = null;
			_ptMouse = null;
			_ptPress = null;
		}
	}

}