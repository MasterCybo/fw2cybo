package ru.arslanov.starling.gui.controls {
	import starling.display.DisplayObject;
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class StButtonSkinBase {
		
		public var upSkin:DisplayObject;
		public var downSkin:DisplayObject;
		public var label:DisplayObject;
		
		public function StButtonSkinBase() {
			
		}
		
		public function init():* {
			return this;
			// override me
		}
		
		public function setSize( width:uint, height:uint ):void {
			if ( upSkin ) {
				upSkin.width = width;
				upSkin.height = height;
			}
			if ( downSkin ) {
				downSkin.width = width;
				downSkin.height = height;
			}
			
			updateLabelPosition();
		}
		
		public function updateLabelPosition():void {
			if ( !label ) return;
			
			label.x = Math.round(( upSkin.width - label.width ) / 2);
			label.y = Math.round(( upSkin.height - label.height ) / 2);
			
			// override me
		}
	}

}