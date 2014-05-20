package ru.arslanov.flash.gui {
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	import ru.arslanov.flash.display.ASprite;
	import ru.arslanov.flash.gui.events.ASliderEvent;
	import ru.arslanov.flash.utils.Display;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class AVScroller3 extends ASlider {
		private var _scrollTarget:Object;

		private var _gapValue:Number = 0;

		private var _thumbAutoSize:Boolean = true;
		private var _scrollAxis:String;
		private var _minValue:Number = 0;
		private var _maxValue:Number = 0;
		private var _deltaValue:Number = 0;

		public function AVScroller3( size:Number = 100, body:ASprite = null, thumb:ASprite = null ) {

			super( size, body, thumb );
		}

		override public function init():* {
			super.init();

			super.eventManager.addEventListener(ASliderEvent.CHANGE_VALUE, onChangeValue);

			return this;
		}

		private function onChangeValue( event:ASliderEvent ):void
		{
			updateTargetPosition();
		}

		/***************************************************************************
		 Геттеры / Сеттеры
		 ***************************************************************************/
		override public function set size( value:Number ):void
		{
			super.size = value;

			gapScroll = _gapValue;
		}

		public function get scrollTarget():Object
		{
			return _scrollTarget;
		}

		public function setScrollTarget( object:Object, axis:String = "y" ):void
		{
			_scrollTarget = object;
			_scrollAxis = axis;
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
			super.getThumb().height = Math.max( 5, thumbHeight );
		}

		/***************************************************************************
		 Обновляторы
		 ***************************************************************************/
		public function set gapScroll( gapValue:Number ):void {
			_gapValue = gapValue;

			if ( _thumbAutoSize ) {
				super.getThumb().height = super.size * ( (_gapValue ? _gapValue : 1) / _deltaValue );
			}

			if( _gapValue >= _deltaValue ) {
				super.position = 0;
			} else {
//				updatePosition();
				super.updateThumbPosition();
			}

			checkThumbVisible();
		}

		private function updateTargetPosition():void
		{
			_scrollTarget[_scrollAxis] = _minValue + position * (_deltaValue - _gapValue) * (inverted ? 1 : -1);
		}

		/**
		 * Проверка
		 */
		private function checkThumbVisible():void {
			var vis:Boolean = _deltaValue > _gapValue;

			if ( vis == super.getThumb().visible ) return;

			super.getThumb().visible = vis;
		}

		override public function kill():void {
			removeMouseControl();

			super.kill();
		}

	}

}