package ru.arslanov.starling.utils {
	import starling.display.DisplayObject;
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class DisplayUtils {
		
		static public function fitSize( target:DisplayObject, width:uint, height:uint, proportional:Boolean = true, allowIncrease:Boolean = false ):void {
			var ww:Number = target.width;
			var hh:Number = target.height;
			
			var kh:Number = hh / ww;
			var kw:Number = ww / hh;
			
			if ( ww >= hh ) { // Ландшафтный
				if ( ( ww > width ) || allowIncrease ) {
					ww = width;
					if ( proportional ) {
						hh = ww * kh;
					} else {
						hh = height;
					}
				}
			} else { // Портретный
				if ( ( hh > height ) || allowIncrease ) {
					hh = height;
					if ( proportional ) {
						ww = hh * kw;
					} else {
						ww = width;
					}
				}
			}
			
			target.width = ww;
			target.height = hh;
		}
		
	}

}