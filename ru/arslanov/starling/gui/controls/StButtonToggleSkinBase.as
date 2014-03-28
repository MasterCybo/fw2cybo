package ru.arslanov.starling.gui.controls {
	import starling.display.DisplayObject;
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class StButtonToggleSkinBase {
		
		public var stateSkin1:DisplayObject;
		public var stateSkin2:DisplayObject;
		public var label:DisplayObject;
		
		public function StButtonToggleSkinBase() {
			
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