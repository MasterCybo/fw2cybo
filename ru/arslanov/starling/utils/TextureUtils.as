package ru.arslanov.starling.utils {
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import starling.display.DisplayObject;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class TextureUtils {
		
		static public function snapshotDisplayObject( object:DisplayObject, rect:Rectangle = null,  matrix:Matrix = null, alpha:Number = 1, antiAliasing:int = 0 ):Texture {
			var bounds:Rectangle = object.getBounds( object );
			var rtex:RenderTexture = new RenderTexture( bounds.width, bounds.height );
			rtex.draw( object, matrix, alpha, antiAliasing );
			
			return rtex;
		}
		
	}

}