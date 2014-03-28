package ru.arslanov.core.gui {
	import ru.arslanov.flash.display.ASprite;
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class SliderSkinDefault extends SliderSkinBase {
		
		static public const TRACK_HEIGHT:Number = 5;
		static public const THUMB_HEIGHT:Number = 15;
		
		private var _thumbSkin:ButtonSkinBase;
		
		public function SliderSkinDefault() {
			super();
		}
		
		override public function init():* {
			super.track = new ASprite().init();
			
			_thumbSkin = new ButtonSkinBase();
			_thumbSkin.upSkin = new ASprite().init();
			_thumbSkin.overSkin = new ASprite().init();
			_thumbSkin.downSkin = new ASprite().init();
			
			super.thumb = new ButtonBase( _thumbSkin ).init();
			
			setSizeThumb( 15, 15 );
			setSize( isVertical ? 0 : 100, isVertical ? 100 : 0 );
			
			return super.init();
		}
		
		override public function setSize( width:uint, height:uint = 0 ):void {
			drawRoundRect( super.track as ASprite, 0xC0C0C0, width, TRACK_HEIGHT, 5 );
		}
		
		override public function setSizeThumb( width:uint, height:uint = 0 ):void {
			drawRoundRect( _thumbSkin.upSkin as ASprite, 0x008000, width, THUMB_HEIGHT, 3 );
			drawRoundRect( _thumbSkin.overSkin as ASprite, 0X00BB00, width, THUMB_HEIGHT, 3 );
			drawRoundRect( _thumbSkin.downSkin as ASprite, 0X8BB900, width, THUMB_HEIGHT, 3 );
		}
		
		private function drawRoundRect( target:ASprite, color:uint, width:uint, height:uint, radius:uint ):void {
			target.graphics.clear();
			target.graphics.beginFill( color );
			target.graphics.drawRoundRect( 0, 0, width, height, radius, radius );
			target.graphics.endFill();
		}
	}

}