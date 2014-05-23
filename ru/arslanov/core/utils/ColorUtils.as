/**
 * Created by aa on 23.05.2014.
 */
package ru.arslanov.core.utils
{
	import flash.geom.ColorTransform;

	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class ColorUtils
	{
		static public function toAlphaColor( alpha:Number,  color:uint ):Number
		{
			trace( alpha + " = " + Number(0.5 * 255).toString(16) );
			trace( "0xff000000 = " + 0xff000000);

			return (alpha * 0xff000000) + 0xff0000;
		}
	}
}
