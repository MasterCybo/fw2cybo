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
		private var _scrollTarget:Object;

		private var _position:Number = 0; // Положение ползунка 0-1

		private var _height:Number = 0; // Высота скроллера
		private var _gapValue:Number = 0;

		private var _downMouseY:Number = 0;
		private var _downThumbY:Number = 0;

		private var _isMouseDown:Boolean = false;
		private var _thumbAutoSize:Boolean = true;
		private var _scrollParam:String;
		private var _minValue:Number = 0;
		private var _maxValue:Number = 0;
		private var _deltaValue:Number = 0;

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

			updatePosition();
		}

		private function onMouseWheel( event:MouseEvent ):void
		{
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

		public function get position():Number
		{
			return _position;
		}

		public function set position( value:Number ):void
		{
			value = Math.max( 0, Math.min( value, 1 ) );

			if ( value == position ) return;

//			_position = value;
			_position = Math.abs( value - (inverted ? 1 : 0) );

			trace( "_position : " + _position );

			if( !_isMouseDown ) updateThumbPosition();
			updateTargetPosition();
		}

		override public function set height( value:Number ):void
		{
			_body.height = _height = value;

			gapScroll = _gapValue;
		}

		public function get scrollTarget():Object
		{
			return _scrollTarget;
		}

		public function setScrollTarget( object:Object, param:String ):void
		{
			_scrollTarget = object;
			_scrollParam = param;
		}

		public function setScrollRange( minValue:Number, maxValue:Number ):void
		{
			_minValue = minValue;
			_maxValue = maxValue;

			_deltaValue = _maxValue - _minValue;
		}

		public function setThumbAutoSize( autoSize:Boolean = true, thumbHeight:Number = 5 ):void
		{
			_thumbAutoSize = autoSize;
			_thumb.height = Math.max( 5, thumbHeight );
		}

		/***************************************************************************
		 Обновляторы
		 ***************************************************************************/
		public function set gapScroll( gapValue:Number ):void {
			_gapValue = gapValue;

			if ( _thumbAutoSize ) {
				_thumb.height = _height * ( (_gapValue ? _gapValue : 1) / _deltaValue );
			}

			if( _gapValue >= _deltaValue ) {
				position = 0;
			} else {
				updatePosition();
				updateThumbPosition();
			}

			checkThumbVisible();
		}

		private function updatePosition():void
		{
			position = _thumb.y / (_height - _thumb.height);
		}

		private function updateTargetPosition():void
		{
			_scrollTarget[_scrollParam] = _minValue + position * (_deltaValue - _gapValue) * (inverted ? 1 : -1);
		}

		public function updateThumbPosition():void
		{
			_thumb.y = _position * (_height - _thumb.height);
		}

		/**
		 * Проверка
		 */
		private function checkThumbVisible():void {
			var vis:Boolean = _deltaValue > _gapValue;

			if ( vis == _thumb.visible ) return;

			_thumb.visible = vis;
		}

		override public function kill():void {
			removeMouseControl();

			super.kill();
		}

	}

}