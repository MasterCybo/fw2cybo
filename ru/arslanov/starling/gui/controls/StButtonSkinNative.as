package ru.arslanov.starling.gui.controls {
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class StButtonSkinNative {
		
		public var upTexture:Texture;
		public var downTexture:Texture;
		public var textLabel:String;
		
		public function StButtonSkinNative( upTexture:Texture = null, textLabel:String = "", downTexture:Texture = null ) {
			this.upTexture = upTexture;
			this.textLabel = textLabel;
			this.downTexture = downTexture;
		}
		
		public function init():void {
			// override me
		}
	}

}