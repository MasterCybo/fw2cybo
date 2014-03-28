package ru.arslanov.core.gui {
	import ru.arslanov.core.interfaces.IKillable;
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class SliderSkinBase {
		
		public var thumb:ButtonBase;
		public var track:IKillable;
		
		public var isVertical:Boolean;
		
		public function SliderSkinBase() {
			
		}
		
		public function init():* {
			return this;
			// override me
		}
		
		public function setSize( width:uint, height:uint = 0 ):void {
			if ( !track ) return;
			
			track.width = width > 0 ? width : track.width;
			track.height = height > 0 ? height : track.height;
		}
		
		public function setSizeThumb( width:uint, height:uint = 0 ):void {
			thumb.skin.setSize( width > 0 ? width : thumb.width, height > 0 ? height : thumb.height );
		}
		
		public function updatePositionThumb():void {
			if ( thumb.height >= track.height ) {
				track.y = Math.round( ( thumb.height - track.height ) / 2 );
			} else {
				thumb.y = Math.round( ( thumb.height - track.height ) / 2 );
			}
		}
	}

}