package ru.arslanov.starling.gui.layout {
	import flash.geom.Rectangle;
	import ru.arslanov.starling.display.StSpriteBase;
	import starling.display.DisplayObject;
	
	/**
	 * Контейнер дисплей-объектов, в котором объекты располагаются вертикально, с регулируемым промежутком
	 * @author Artem Arslanov
	 */
	public class VBox extends StSpriteBase {
		
		private var _space:Number = 0;
		private var _direction:int;
		private var _halign:String;
		
		public function VBox ( space:Number = 0, direction:int = 1, horizontalAlign:String = "left" ) {
			_direction = validDirect( direction );
			
			_space = space;
			
			_halign = horizontalAlign;
			
			super ();
		}
		
		override public function addChild( child:DisplayObject ):DisplayObject {
			var item:DisplayObject = super.addChild( child );
			
			update ();
			
			return item;
		}
		
		override public function addChildAt( child:DisplayObject, index:int ):DisplayObject {
			var item:DisplayObject = super.addChildAt( child, index );
			
			update ();
			
			return item;
		}
		
		override public function removeChild( child:DisplayObject, dispose:Boolean=false ):DisplayObject {
			if ( !contains( child ) ) return null;
			
			var item:DisplayObject = super.removeChild( child, dispose );
			
			update ();
			
			return item;
		}
		
		override public function removeChildAt( index:int, dispose:Boolean=false ):DisplayObject {
			if ( getChildAt( index ) && !contains( getChildAt( index ) ) ) return null;
			
			var item:DisplayObject = super.removeChildAt( index, dispose );
			
			update();
			
			return item;
		}
		
		public function get space():Number {
			return _space;
		}
		
		public function set space( value:Number ):void {
			if (space == value) return;
			
			_space = value;
			
			update ();
		}
		
		public function get direction():int {
			return _direction;
		}
		
		public function set direction( value:int ):void {
			if (direction == value) return;
			
			_direction = validDirect( value );
			
			update ();
		}
		
		public function hAlign( align:String ):void {
			_halign = align;
			
			update();
		}
		
		protected function update():void {
			var rect:Rectangle;
			var item:DisplayObject;
			var yp:Number = getFirstY();
			var maxWidth:Number = 0;
			
			for ( var i:int = 0; i < numChildren; i++ ) {
				item = getChildAt( i );
				rect = item.getBounds( item );
				item.y = yp - rect.y;
				yp += direction * ( item.height + space );
				
				if ( item.width > maxWidth ) maxWidth = item.width;
				
			} // for
			
			for ( i = 0; i < numChildren; i++ ) {
				item = getChildAt( i );
				
				switch ( _halign ) {
					case "right":
						item.x = maxWidth - item.width;
					break;
					case "center":
						item.x = Math.round( ( maxWidth - item.width ) / 2 );
					break;
					default:
						item.x = 0;
				}
				
			} // for
			
			item = null;
			rect = null;
		}
		
		protected function validDirect( value:int ):int {
			return Math.min( Math.max ( -1, value ), 1 );
		}
		
		protected function getFirstY():Number {
			return ( numChildren == 0 ) || ( direction >= 0 ) ? 0 : direction * getChildAt( 0 ).height;
		}
	}

}