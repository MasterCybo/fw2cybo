package ru.arslanov.flash.gui {
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import ru.arslanov.core.controllers.MouseController;
	import ru.arslanov.core.events.MouseControllerEvent;
	import ru.arslanov.core.utils.Calc;
	import ru.arslanov.core.utils.Log;
	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.interfaces.IKillable;
	import ru.arslanov.flash.utils.Display;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class AVScroller2 extends ASprite {
		public var wheelDivide:uint = 10;
		
		private var _body:ASprite; // Тело скроллера
		private var _thumb:ASprite; // Ползунок
		private var _minHThumb:Number; // Минимальная высота ползунка равна инициализированной высота ползунка

		private var _position:Number = 0; // Положение ползунка 0-1
		private var _height:Number = 0; // Высота скроллера
		private var _downMouseY:Number = 0;
		private var _downThumbY:Number = 0;
		private var _targetHeight:Number = 0;
		private var _viewportHeight:Number = 0;

		public function AVScroller2( height:Number = 100 ) {
			_height = height;

			super();
		}

		override public function init():* {
			mouseEnabled = true;
			
			setThumb( new ASprite().init() );
			setBody( new ASprite().init() );
			setMouseControl();

			return super.init();
		}

		public function setBody( displayObject:ASprite ):void
		{
			if ( _body ) _body.kill();
			
			_body = displayObject;

			if ( _body ) {
				_body.height = _height;
				_body.mouseEnabled = true;
				addChildAt( _body, 0 );
			}
		}

		public function setThumb( displayObject:ASprite ):void
		{
			if ( _thumb ) _thumb.kill();

			_thumb = displayObject;

			if ( _thumb ) {
				addChild( _thumb );
				setMouseControl();
			}
		}

		private function setMouseControl():void
		{
			_thumb.mouseEnabled = true;
			_thumb.eventManager.addEventListener( MouseEvent.MOUSE_DOWN, onThumbMouseDown );
			Display.stageRemoveEventListener( MouseEvent.MOUSE_MOVE, onStageMouseMove );
			Display.stageRemoveEventListener( MouseEvent.MOUSE_UP, onStageMouseUp );
			this.eventManager.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}

		public function removeMouseControl():void
		{
			if ( _thumb ) {
				_thumb.eventManager.removeEventListener( MouseEvent.MOUSE_DOWN, onThumbMouseDown );
			}
			Display.stageRemoveEventListener( MouseEvent.MOUSE_MOVE, onStageMouseMove );
			Display.stageRemoveEventListener( MouseEvent.MOUSE_UP, onStageMouseUp );
			this.eventManager.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}

		private function onThumbMouseDown( event:MouseEvent ):void
		{
//			_offsetMouseY = event.localY - _thumb.y;
			_downMouseY = event.stageY;
			_downThumbY = _thumb.y;
			
			Display.stageAddEventListener( MouseEvent.MOUSE_MOVE, onStageMouseMove );
			Display.stageAddEventListener( MouseEvent.MOUSE_UP, onStageMouseUp );
		}
		
		private function onStageMouseMove( event:MouseEvent ):void
		{
			var newY:Number = _downThumbY + event.stageY - _downMouseY;
			var maxY:Number = _height - _thumb.height;
			
			_thumb.y = Math.max( 0, Math.min( newY, maxY ) );

			updatePosition();
		}
		
		private function onStageMouseUp( event:MouseEvent ):void
		{
			Display.stageRemoveEventListener( MouseEvent.MOUSE_MOVE, onStageMouseMove );
			Display.stageRemoveEventListener( MouseEvent.MOUSE_UP, onStageMouseUp );
		}

		private function updatePosition():void
		{
			_position = _thumb.y / (_height - _thumb.height);
		}

		public function updateThumbY():void
		{
			_thumb.y = _position * (_height - _thumb.height);
		}

		private function onMouseWheel( event:MouseEvent ):void {
			var deltaMouse:Number = event.delta / Math.abs( event.delta );
			
			position -= deltaMouse / wheelDivide;
		}

		/***************************************************************************
		 Геттеры / Сеттеры
		 ***************************************************************************/
		public function get position():Number {
			return _position;
		}

		public function set position( value:Number ):void {
			value = Math.max( 0, Math.min( value, 1 ) );

			if ( value == position ) return;

			_position = value;

			updateThumbY();
		}

		/***************************************************************************
		 Обновляторы
		 ***************************************************************************/
		public function update( targetHeight:Number, viewportHeight:Number ):void {
			_targetHeight = targetHeight;
			_viewportHeight = viewportHeight;
			
			_thumb.height = _height * ( viewportHeight / targetHeight );
			
			if( viewportHeight < targetHeight ){
				position = 0;
			} else {
				updateThumbY();
			}
		}

		override public function set height( value:Number ):void
		{
			_body.height = value;
			
			update( _targetHeight, _viewportHeight );
		}

		private function updateThumbHeight():void {
//			_thumb.height = int( Math.max( _height * _height / _content.height, _minHThumb ) );
		}

		private function checkThumbVisible():void {
//			var vis:Boolean = _content.height > _viewPort.height;

//			if ( vis == _scroller.visible )
//				return;

//			_scroller.visible = vis;

//			if ( _scroller.visible ) {
//				_container.scrollRect = _viewPort;
//			} else {
//				_container.scrollRect = null;
//			}
		}

		override public function kill():void {
			removeMouseControl();

			super.kill();
		}

	}

}