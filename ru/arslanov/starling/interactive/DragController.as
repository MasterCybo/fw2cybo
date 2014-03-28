package ru.arslanov.starling.interactive {
	import flash.geom.Point;
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class DragController {
		
		public var onDragStart:Function;
		public var onDragStop:Function;
		public var onDrag:Function;
		
		private var _dragObject:DisplayObject;
		private var _touchCtrl:TouchController;
		private var _pressPosition:Point;
		private var _currentPosition:Point;
		
		public function DragController() {
			super();
		}
		
		public function init( dragObject:DisplayObject, touchObject:DisplayObject = null ):void {
			_dragObject = dragObject;
			
			_touchCtrl = new TouchController();
			_touchCtrl.moveSensitivity = 0;
			_touchCtrl.onBegan = startDrag;
			_touchCtrl.onEnded = stopDrag;
			
			_touchCtrl.init( touchObject ? touchObject : _dragObject );
		}
		
		private function startDrag( ev:TouchEvent ):void {
			_pressPosition = ev.getTouch( ev.target as DisplayObject ).getLocation( _dragObject );
			
			if ( onDragStart != null ) {
				if ( onDragStart.length == 1 ) {
					onDragStart( ev );
				} else {
					onDragStart();
				}
			}
			
			_touchCtrl.onMoved = onMove;
		}
		
		private function onMove( ev:TouchEvent ):void {
			_currentPosition = ev.getTouch( ev.target as DisplayObject ).getLocation( _dragObject.parent );
			
			_dragObject.x = Math.round( _currentPosition.x - _pressPosition.x + _dragObject.pivotX );
			_dragObject.y = Math.round( _currentPosition.y - _pressPosition.y + _dragObject.pivotY );
			
			if ( onDrag != null ) {
				if ( onDrag.length == 1 ) {
					onDrag( ev );
				} else {
					onDrag();
				}
			}
		}
		
		private function stopDrag( ev:TouchEvent ):void {
			_touchCtrl.onMoved = null;
			
			if ( onDragStop != null ) {
				if ( onDragStop.length == 1 ) {
					onDragStop( ev );
				} else {
					onDragStop();
				}
			}
		}
		
		public function get target():DisplayObject {
			return _dragObject;
		}
		
		public function kill():void {
			_touchCtrl.kill();
			_touchCtrl = null;
			
			onDragStart = null;
			onDragStop = null;
			onDrag = null;
			
			_pressPosition = null;
			_currentPosition = null;
			_dragObject = null;
		}
	}

}