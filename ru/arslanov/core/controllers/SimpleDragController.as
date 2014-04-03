package ru.arslanov.core.controllers {
	import flash.display.InteractiveObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	* ...
	* @author Artem Arslanov
	*/
	public class SimpleDragController {
		public var onDrag:Function;
		
		private var _mctrl:MouseController;
		private var _target:InteractiveObject;
		private var _dragArea:Rectangle;
		private var _checkBounds:Boolean;
		private var _position:Point = new Point();
		private var _tbounds:Rectangle;
		
		public function SimpleDragController() {
			
		}
		
		public function init( target:InteractiveObject, checkBounds:Boolean = false ):void {
			_target = target;
			_checkBounds = checkBounds;
			
			_mctrl = new MouseController( target );
			_mctrl.handlerDrag = onDragMouse;
		}
		
		private function onDragMouse():void {
			setPosition( _target.x + _mctrl.movement.x, _target.y + _mctrl.movement.y );
			
			if ( onDrag != null ) {
				onDrag();
			}
		}
		
		public function get dragArea():Rectangle {
			return _dragArea;
		}
		
		public function set dragArea( value:Rectangle ):void {
			if (!value) return;
			if ( _dragArea && _dragArea.equals( value ) ) return;
			
			_dragArea = value;
		}
		
		public function get position():Point {
			return _position;
		}
		
		public function setPosition( newX:Number, newY:Number ):void {
			_tbounds = _target.getBounds( _target.parent );
			_tbounds.x = newX;
			_tbounds.y = newY;
			
			var left:Number = 0;
			var right:Number = 0;
			var top:Number = 0;
			var bottom:Number = 0;
			
			if ( _checkBounds ) {
				left = _tbounds.left;
				right = _tbounds.right;
				top = _tbounds.top;
				bottom = _tbounds.bottom;
			} else {
				left = right = _tbounds.x + _tbounds.width * 0.5;
				top = bottom = _tbounds.y + _tbounds.height * 0.5;
			}
			
			if ( (left >= _dragArea.left) && (right <= _dragArea.right) ) {
				_target.x = _tbounds.x;
			}
			
			if ( (top >= _dragArea.top) && (bottom <= _dragArea.bottom) ) {
				_target.y = _tbounds.y;
			}
			
			_position.setTo( _target.x, _target.y );
		}
		
		public function get target():InteractiveObject {
			return _target;
		}
		
		public function dispose():void {
			onDrag = null;
			_target = null;
			_dragArea = null;
			_mctrl.dispose();
		}
	}

}