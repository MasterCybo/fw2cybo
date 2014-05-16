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

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class AVScroller2 extends ASprite {
		private var _thumb:ASprite; // Ползунок
		private var _scroller:ASprite; // Скроллер
		private var _container:ASprite;
		private var _content:ASprite;
		private var _minHThumb:Number; // Минимальная высота ползунка равна инициализированной высота ползунка

		private var _position:Number = 0;
		private var _height:Number;
		private var _body:ASprite;

		public function AVScroller2( height:Number = 100 ) {
			_height = height;

			super();
		}

		override public function init():* {
			_body = new ASprite().init();
			_content = new ASprite().init();
			_scroller = new ASprite().init();

			_container.addChild( _content );
			addChild( _container );
			addChild( _scroller );

			_minHThumb = _thumb.height;

			_scroller.addChild( _thumb as DisplayObject );

			return super.init();
		}

		/***************************************************************************
		 Обработчики событий
		 ***************************************************************************/
		private function onMouseMove( ev:MouseControllerEvent ):void {
			_thumb.y = Math.round( Math.min( Math.max( 0, _thumb.y + _msc.movement.y ), _height - _thumb.height ) );

			position = _thumb.y / ( _height - _thumb.height );
		}

		private function onMouseWheel( ev:MouseControllerEvent ):void {
			position -= Calc.sign( _msc.deltaWheel ) * 0.05;
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

			_thumb.y = ( _height - _thumb.height ) * value;

			updateScrollRect();
		}

		/***************************************************************************
		 Обновляторы
		 ***************************************************************************/
		public function update():void {
			//_container.scrollRect = _viewPort;

			updateScrollRect();

			updateThumbHeight();
			updateScroller();
			updateVisible();
		}

		private function updateThumbHeight():void {
			_thumb.height = int( Math.max( _height * _height / _content.height, _minHThumb ) );
		}

		private function updateScrollRect():void {
			_viewPort.y = ( _content.height - _viewPort.height ) * position;
			_container.scrollRect = _viewPort;
		}

		private function updateScroller():void {
			//setXY( _container.x + _container.width, _container.y );
			//_thumb.setXY( _container.x + _container.width, _container.y );

			_scroller.x = _viewPort.x + _viewPort.width;
		}

		private function updateVisible():void {
			var vis:Boolean = _content.height > _viewPort.height;

			if ( vis == _scroller.visible )
				return;

			_scroller.visible = vis;

			if ( _scroller.visible ) {
				_container.scrollRect = _viewPort;
			} else {
				_container.scrollRect = null;
			}
		}

		public function setViewPort( rect:Rectangle ):void {
			rect.offset( _viewPort.x, _viewPort.y );

			_viewPort = rect;

			update();

			_thumb.y = ( _viewPort.height - _thumb.height ) * _position;
		}

		public function getViewPort():Rectangle {
			return _viewPort;
		}

		override public function kill():void {
			_msc.dispose();

			super.kill();
		}

	}

}