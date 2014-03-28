package ru.arslanov.starling.gui.layout {
	import flash.geom.Rectangle;
	import starling.display.DisplayObject;
	
	/**
	 * Контейнер дисплей-объектов, в котором объекты располагаются горизонтально, с регулируемым промежутком
	 * @author Artem Arslanov
	 */
	public class HBox extends VBox {
		
		private var _valign:String;
		
		public function HBox( space:int = 0, direction:int = 1, verticalAlign:String = "top" ) {
			_valign = verticalAlign;
			
			super ( space, direction );
		}
		
		public function vAlign( align:String ):void {
			_valign = align;
			
			update();
		}
		
		override public function hAlign( align:String ):void {
			// Empty - no work
		}
		
		override protected function update():void {
			var rect:Rectangle;
			var item:DisplayObject;
			var xp:Number = getFirstY();
			var maxHeight:Number = 0;
			
			for ( var i:int = 0; i < numChildren; i++ ) {
				item = getChildAt( i );
				rect = item.getBounds( item );
				item.x = xp - rect.x;
				xp += direction * ( item.width + space );
				
				if ( item.height > maxHeight ) maxHeight = item.height;
			} // for
			
			for ( i = 0; i < numChildren; i++ ) {
				item = getChildAt( i );
				
				switch ( _valign ) {
					case "bottom":
						item.y = maxHeight - item.height;
					break;
					case "center":
						item.y = Math.round( ( maxHeight - item.height ) / 2 );
					break;
					default:
						item.y = 0;
				}
			} // for
			
			item = null;
			rect = null;
		}
	}

}