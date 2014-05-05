/**
 * Created by aa on 05.05.2014.
 */
package ru.arslanov.flash.display
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.utils.Dictionary;

	import ru.arslanov.core.events.LoaderEvent;
	import ru.arslanov.core.load.DisplayLoader;

	public class Picture extends ABitmap
	{
		static private var _cache:Dictionary /*BitmapData*/ = new Dictionary( true ); // id = BitmapData

		public static function clearCache():void
		{
			_cache = new Dictionary( true );
		}

		public static function disposeCacheBitmapData():void
		{
			for each ( var bd:BitmapData in _cache ) {
				bd.dispose();
			}

			clearCache();
		}


		private var _width:uint = 0;
		private var _height:uint = 0;

		public function Picture( width:uint = 0, height:uint = 0 )
		{
			_width = width;
			_height = height;
			super();
		}

		override public function init():*
		{
			return super.init();
		}

		/**
		 * Отображает данные BitmapData
		 * @param bitmapData
		 */
		public function attach( bitmapData:BitmapData ):void
		{
			var ww:int;
			var hh:int;

			if ( (_width > 0) && (_height <= 0) ) {
				ww = _width;
				hh = bitmapData.width * ( _width / bitmapData.width );
			}

			if ( (_width <= 0) && (_height > 0) ) {
				hh = _height;
				ww = bitmapData.height * ( _height / bitmapData.height );
			}

			if ( (_width > 0) && (_height > 0) ) {
				ww = _width;
				hh = _height;
			}

			var isResize:Boolean = (_width > 0) || (_height > 0);
			if ( isResize ) {
				var mtx:Matrix = new Matrix();
				mtx.scale( ww / bitmapData.width, hh / bitmapData.height );

				var bd:BitmapData = new BitmapData( ww, hh );
				bd.draw( bitmapData, mtx, null, null, null, true );

				bitmapData = bd;
			}

			this.bitmapData = bitmapData;

			eventManager.dispatchEvent( new LoaderEvent( LoaderEvent.COMPLETE ) );
		}

		/**
		 * Создание изображения из внедрённой картинки
		 * @param embedClass
		 */
		public function attachFromEmbed( embedClass:Class ):void
		{
			var bd:BitmapData = _cache[embedClass];

			if ( bd ) {
				attach( bd );
			} else {
				attach( ABitmap.fromClass( embedClass ).bitmapData );
			}
		}

		/**
		 * Загружает внешний ресурс
		 * @param url
		 */
		public function load( url:String ):void
		{
			var bd:BitmapData = _cache[url];

			if ( bd ) {
				attach( bd );
			} else {
				var loader:DisplayLoader = new DisplayLoader( url );
				loader.addEventListener( LoaderEvent.COMPLETE, onLoadComplete );
				loader.start();
			}
		}

		private function onLoadComplete( event:LoaderEvent ):void
		{
			attach( (event.target as DisplayLoader).getBitmapData() );
		}
	}
}
