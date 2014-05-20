package ru.arslanov.flash.gui {
	import avmplus.getQualifiedSuperclassName;

	import flash.events.MouseEvent;

	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.gui.events.ASliderEvent;
	import ru.arslanov.flash.utils.Display;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ASlider extends ASprite {
		public var wheelDivide:uint = 10; // Количество шагов при прокрутке колесом мыши
//		public var inverted:Boolean = false; // обратный отсчёт позиции
		public var roundToPixel:Boolean = true; // Округление позиции ползунка

		private var _body:ASprite; // Тело скроллера
		private var _thumb:ASprite; // Ползунок

		private var _position:Number = -1; // Положение ползунка 0-1

		private var _size:Number = 0; // Высота скроллера

		private var _downMouseY:Number = 0;
		private var _downThumbY:Number = 0;

		private var _inverted:Boolean = false; // обратный отсчёт позиции

		public function ASlider( size:Number = 100, body:ASprite = null, thumb:ASprite = null ) {
			_size = size;
			_body = body;
			_thumb = thumb;

			super();
		}

		override public function init():* {
			if ( !_body ) new ASprite().init();
			if ( !_thumb ) new ASprite().init();

			var body:ASprite = _body;
			var thumb:ASprite = _thumb;

			_body = null;
			_thumb = null;

			setBody( body );
			setThumb( thumb );

			position = 0;

			return super.init();
		}

		/**
		 * Подключаем управление мышью
		 */
		protected function setMouseControl():void
		{
			mouseEnabled = true;
			_thumb.mouseEnabled = true;
			_thumb.eventManager.addEventListener( MouseEvent.MOUSE_DOWN, onThumbMouseDown );
			Display.stageRemoveEventListener( MouseEvent.MOUSE_MOVE, onStageMouseMove );
			Display.stageRemoveEventListener( MouseEvent.MOUSE_UP, onStageMouseUp );
			this.eventManager.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}

		/**
		 * Удаляем управление мышью
		 */
		protected function removeMouseControl():void
		{
			mouseEnabled = false;
			_thumb.mouseEnabled = false;

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
		protected function onThumbMouseDown( event:MouseEvent ):void
		{
			_downMouseY = event.stageY;
			_downThumbY = _thumb.y;
			
			Display.stageAddEventListener( MouseEvent.MOUSE_MOVE, onStageMouseMove );
			Display.stageAddEventListener( MouseEvent.MOUSE_UP, onStageMouseUp );
		}

		protected function onStageMouseUp( event:MouseEvent ):void
		{
			Display.stageRemoveEventListener( MouseEvent.MOUSE_MOVE, onStageMouseMove );
			Display.stageRemoveEventListener( MouseEvent.MOUSE_UP, onStageMouseUp );
		}

		protected function onStageMouseMove( event:MouseEvent ):void
		{
			var newY:Number = _downThumbY + event.stageY - _downMouseY;
			var maxY:Number = _size - _thumb.height;

			_thumb.y = Math.max( 0, Math.min( newY, maxY ) );

			if( roundToPixel ) _thumb.y = Math.round(_thumb.y);

			updatePosition();
		}

		protected function onMouseWheel( event:MouseEvent ):void
		{
			var deltaMouse:Number = event.delta / Math.abs( event.delta ) * (inverted ? -1 : 1);

			position -= deltaMouse / wheelDivide;
		}

		/***************************************************************************
		 Геттеры / Сеттеры
		 ***************************************************************************/
		public function setBody( value:ASprite ):void
		{
			if ( value == _body ) return;

			if ( _body ) _body.kill();

			_body = value;

			if ( _body ) {
				_body.mouseEnabled = true;
				_body.height = _size;
				addChildAt( _body, 0 );
			}
		}

		public function getBody():ASprite
		{
			return _body;
		}

		public function setThumb( value:ASprite ):void
		{
			if ( value == _thumb ) return;

			if ( _thumb ) _thumb.kill();

			_thumb = value;

			if ( _body ) {
				addChild( _thumb );
				setMouseControl();
			}
		}

		public function getThumb():ASprite
		{
			return _thumb;
		}

		public function get position():Number
		{
			return _position;
		}

		public function set position( value:Number ):void
		{
			value = Math.max( 0, Math.min( value, 1 ) );

			if ( value == _position ) return;

			_position = value;

			updateThumbPosition();

			eventManager.dispatchEvent( new ASliderEvent( position, ASliderEvent.CHANGE_VALUE ) );
		}

		public function set size( value:Number ):void
		{
			_body.height = _size = value;

			updateThumbPosition();
		}

		public function get size():Number
		{
			return _size;
		}

		public function set enabled( value:Boolean ):void
		{
			if( value == enabled ) return;

			if ( value ) {
				setMouseControl();
			} else {
				removeMouseControl();
			}
		}

		public function get enabled():Boolean
		{
			return mouseEnabled;
		}

		public function get inverted():Boolean
		{
			return _inverted;
		}

		public function set inverted( value:Boolean ):void
		{
			if ( value == inverted ) return;

			_inverted = value;

			//*/
			// С отправкой события
			var oldPos:Number = position;
			_position = -1;
			position = Math.abs( oldPos - (inverted ? 0 : 1) );
			/*/
			// Без отправки события
			_position = Math.abs( position - (inverted ? 0 : 1) );

			updateThumbPosition();
			//*/
		}

		/***************************************************************************
		 Обновляторы
		 ***************************************************************************/
		protected function updatePosition():void
		{
			var newPos:Number = _thumb.y / (_size - _thumb.height);

			if ( newPos == position ) return;

			position = Math.abs( newPos - (inverted ? 1 : 0) );
		}

		protected function updateThumbPosition():void
		{
			if ( !_thumb ) return;

			var newY:Number = Math.abs( position - (inverted ? 1 : 0) ) * (_size - _thumb.height);

			if ( newY == _thumb.y ) return;

			_thumb.y = newY;

			if ( roundToPixel ) _thumb.y = Math.round( _thumb.y );
		}

		override public function kill():void {
			removeMouseControl();

			super.kill();

			_body = null;
			_thumb = null;
		}

	}

}