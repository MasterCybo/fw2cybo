package ru.arslanov.flash.gui {
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.utils.Display;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class AVScroller2 extends ASprite {
		public var wheelDivide:uint = 10; // Количество шагов при прокрутке колесом мыши
		public var inverted:Boolean = false; // обратный отсчёт позиции
		
		private var _body:ASprite; // Тело скроллера
		private var _thumb:ASprite; // Ползунок
		private var _scrollTarget:DisplayObject;

		private var _position:Number = 0; // Положение ползунка 0-1

		private var _height:Number = 0; // Высота скроллера
		private var _heightTarget:Number = 0;
		private var _heightView:Number = 0;

		private var _downMouseY:Number = 0;
		private var _downThumbY:Number = 0;
		private var _targetY:Number = 0;

		private var _isMouseDown:Boolean = false;

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

		/**
		 * Подключаем управление мышью
		 */
		private function setMouseControl():void
		{
			_thumb.mouseEnabled = true;
			_thumb.eventManager.addEventListener( MouseEvent.MOUSE_DOWN, onThumbMouseDown );
			Display.stageRemoveEventListener( MouseEvent.MOUSE_MOVE, onStageMouseMove );
			Display.stageRemoveEventListener( MouseEvent.MOUSE_UP, onStageMouseUp );
			this.eventManager.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}

		/**
		 * Удаляем управление мышью
		 */
		public function removeMouseControl():void
		{
			if ( _thumb ) {
				_thumb.eventManager.removeEventListener( MouseEvent.MOUSE_DOWN, onThumbMouseDown );
			}
			Display.stageRemoveEventListener( MouseEvent.MOUSE_MOVE, onStageMouseMove );
			Display.stageRemoveEventListener( MouseEvent.MOUSE_UP, onStageMouseUp );
			this.eventManager.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}

		/***************************************************************************
		 Обработчики мышиных событий
		 ***************************************************************************/
		private function onThumbMouseDown( event:MouseEvent ):void
		{
			_downMouseY = event.stageY;
			_downThumbY = _thumb.y;
			
			Display.stageAddEventListener( MouseEvent.MOUSE_MOVE, onStageMouseMove );
			Display.stageAddEventListener( MouseEvent.MOUSE_UP, onStageMouseUp );

			_isMouseDown = true;
		}

		private function onStageMouseUp( event:MouseEvent ):void
		{
			Display.stageRemoveEventListener( MouseEvent.MOUSE_MOVE, onStageMouseMove );
			Display.stageRemoveEventListener( MouseEvent.MOUSE_UP, onStageMouseUp );

			_isMouseDown = false;
		}

		private function onStageMouseMove( event:MouseEvent ):void
		{
			var newY:Number = _downThumbY + event.stageY - _downMouseY;
			var maxY:Number = _height - _thumb.height;

			_thumb.y = Math.max( 0, Math.min( newY, maxY ) );

			updatePositionOnMouse();
		}

		private function onMouseWheel( event:MouseEvent ):void {
			var deltaMouse:Number = event.delta / Math.abs( event.delta );
			
			position -= deltaMouse / wheelDivide;
		}

		/***************************************************************************
		 Геттеры / Сеттеры
		 ***************************************************************************/
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

		public function get position():Number {
			return _position;
		}

		public function set position( value:Number ):void {
			value = Math.max( 0, Math.min( value, 1 ) );

			if ( value == position ) return;

			_position = value;

			if( !_isMouseDown ) updateThumbPosition();
			updateTargetPosition();
		}

		override public function set height( value:Number ):void
		{
			_body.height = _height = value;

			update( _heightTarget, _heightView );
		}

		public function get scrollTarget():DisplayObject
		{
			return _scrollTarget;
		}

		public function set scrollTarget( value:DisplayObject ):void
		{
			_scrollTarget = value;
			_targetY = _scrollTarget.y;
		}

		/***************************************************************************
		 Обновляторы
		 ***************************************************************************/
		public function update( heightTarget:Number = 0, heightView:Number = 0 ):void {
			_heightTarget = heightTarget > 0 ? heightTarget : _heightTarget ;
			_heightView = heightView > 0 ? heightView : _heightView;

			if ( _heightTarget ) {
				_thumb.height = _height * ( _heightView / _heightTarget );

				if( _heightView < _heightTarget ){
					position = 0;
				} else {
					updateThumbPosition();
				}
			}

			checkThumbVisible();
		}

		private function updatePositionOnMouse():void
		{
//			_position = _thumb.y / (_height - _thumb.height);
			position = _thumb.y / (_height - _thumb.height);

//			updateTargetPosition();
		}

		private function updateTargetPosition():void
		{
			_scrollTarget.y = _targetY - position * (_heightTarget - _heightView);
		}

		public function updateThumbPosition():void
		{
			_thumb.y = _position * (_height - _thumb.height);
		}

		/**
		 * Проверка
		 */
		private function checkThumbVisible():void {
			var vis:Boolean = _heightTarget > _heightView;

			if ( vis == _thumb.visible ) return;

			_thumb.visible = vis;
		}

		override public function kill():void {
			removeMouseControl();

			super.kill();
		}

	}

}