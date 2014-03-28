package ru.arslanov.flash.gui {
	import flash.events.Event;
	import ru.arslanov.flash.display.ASprite;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class GUIComponent extends ASprite {
		
		private var _children:Vector.<GUIComponent> = new Vector.<GUIComponent>();
		
		private var _px:Number = 0; // Процентное значение x = 0...1
		private var _py:Number = 0; // Процентное значение y = 0...1
		private var _pWidth:Number = 0; // Процентное значение width = 0...1
		private var _pHeight:Number = 0; // Процентное значение height = 0...1
		
		public function GUIComponent() {
			addEventListener(Event.ADDED_TO_STAGE, hrAddedToStage);
			
			super();
		}
		
		private function hrAddedToStage( ev:Event ):void {
			removeEventListener(Event.ADDED_TO_STAGE, hrAddedToStage);
			
			updateRelativePosition();
			updateRelativeSize();
		}
		
		public function addChildComponent( component:GUIComponent ):GUIComponent {
			super.addChild( component );
			_children.push( component );
			
			return conponent;
		}
		
		public function removeChildComponent( component:GUIComponent ):GUIComponent {
			var idx:int = _children.indexOf( component );
			
			if ( idx != -1 ) {
				_children.splice( idx, 1 );
			}
			
			super.removeChild( component );
			
			return conponent;
		}
		
		override public function removeChildren( beginIndex:int = 0, endIndex:int = 2147483647 ):void {
			super.removeChildren( beginIndex, endIndex );
			
			_children.splice( beginIndex, endIndex > (_children.length - 1) ? _children.length - 1 : endIndex );
		}
		
		public function get childrenComponents():Vector.<GUIComponent> {
			return _children;
		}
		
		/***************************************************************************
		Изменение ПОЛОЖЕНИЯ компонента
		***************************************************************************/
		//{ region 
		public function get px():Number {
			return _px;
		}
		
		public function set px( value:Number ):void {
			if ( !parent ) return;
			
			value = Math.max( 0, Math.min( value, 1 ) );
			
			if ( value == px ) return;
			
			_px = value;
			
			super.x = _px * parent.width;
		}
		
		public function get py():Number {
			return _py;
		}
		
		public function set py( value:Number ):void {
			if ( !parent ) return;
			
			value = Math.max( 0, Math.min( value, 1 ) );
			
			if ( value == py ) return;
			
			_py = value;
			
			super.y = _py * parent.height;
		}
		
		override public function setXY( x:Number, y:Number, rounded:Boolean = true ):void {
			super.setXY( x, y, rounded );
		}
		//} endregion
		
		/***************************************************************************
		Изменение РАЗМЕРОВ компонента
		***************************************************************************/
		//{ region 
		public function get pwidth():Number {
			return _pwidth;
		}
		
		public function set pwidth( value:Number ):void {
			if ( !parent ) return;
			
			value = Math.max( 0, Math.min( value, 1 ) );
			
			if ( value == pwidth ) return;
			
			_pwidth = value;
			
			super.width = _pwidth * parent.width;
		}
		
		public function get pheight():Number {
			return _pheight;
		}
		
		public function set pheight( value:Number ):void {
			if ( !parent ) return;
			
			value = Math.max( 0, Math.min( value, 1 ) );
			
			if ( value == pheight ) return;
			
			_pheight = value;
			
			super.height = value;
		}
		
		override public function setSize( width:Number, height:Number, rounded:Boolean = true ):void {
			super.setSize( width, height, rounded );
		}
		//} endregion
		
		/***************************************************************************
		Обновление положения и размеров
		***************************************************************************/
		public function updateRelativePosition():void {
			if ( !parent ) return;
			
			super.x = px * parent.width;
			super.y = py * parent.height;
		}
		
		public function updateRelativeSize():void {
			if ( !parent ) return;
			
			super.width = pwidth * parent.width;
			super.height = pheight * parent.height;
			
			updateChildrenSize();
			updateChildrenPosition();
		}
		
		public function updateChildrenSize():void {
			var len:uint = _children.length;
			var guic:GUIComponent;
			
			for (var i:int = 0; i < len ; i++) {
				guic = _children[i];
				guic.updateRelativeSize();
			}
		}
		
		public function updateChildrenPosition():void {
			var len:uint = _children.length;
			var guic:GUIComponent;
			
			for (var i:int = 0; i < len ; i++) {
				guic = _children[i];
				guic.updateRelativePosition();
			}
		}
		
		override public function kill():void {
			removeEventListener(Event.ADDED_TO_STAGE, hrAddedToStage);
			
			_children = null;
			super.kill();
		}
	}

}