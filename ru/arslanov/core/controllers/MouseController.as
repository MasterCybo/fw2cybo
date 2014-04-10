package ru.arslanov.core.controllers {
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
	import ru.arslanov.flash.utils.Display;
	
	/**
	 * ...
	 * @author
	 */
	public class MouseController extends EventDispatcher {
		
		public var handlerDown : Function;
		public var handlerDrag : Function;
		public var handlerUp : Function;
		public var handlerWheel : Function;
		public var handlerOver : Function;
		public var handlerOut : Function;
		
		private var _target : InteractiveObject;
		private var _targetUp : InteractiveObject;
		private var _targetMove : InteractiveObject;
		private var _targetWheel : InteractiveObject;
		
		private var _prevX : Number = 0;
		private var _prevY : Number = 0;
		private var _time : int;
		
		private var _wheelDelta:Number = 0;
		private var _movement:Point = new Point();
		private var _speed:Point = new Point();
		private var _pressed:Point = new Point();
		private var _released:Point = new Point();
		private var _positionOnStage:Point = new Point();
		
		public function MouseController( target:InteractiveObject, targetUp : InteractiveObject = null, targetMove : InteractiveObject = null, targetWheel : InteractiveObject = null ) {
			_target = target;
			_targetUp = targetUp ? targetUp : Display.stage;
			_targetMove = targetMove ? targetMove : Display.stage;
			_targetWheel = targetWheel ? targetWheel : target;
			
			_target.addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
			_target.addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
			_target.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			_targetWheel.addEventListener( MouseEvent.MOUSE_WHEEL, onMouseWheel );
			
			if ( !(_target is Stage) ) {
				_target.mouseEnabled = true;
			}
			
			super();
		}
		
		private function onMouseOver( ev : MouseEvent ) : void {
			if ( handlerOver != null ) {
				if ( handlerOver.length ) {
					handlerOver( ev );
				} else {
					handlerOver();
				}
			}
		}
		
		private function onMouseOut( ev : MouseEvent ) : void {
			if ( handlerOut != null ) {
				if ( handlerOut.length ) {
					handlerOut( ev );
				} else {
					handlerOut();
				}
			}
		}
		
		private function onMouseDown( ev : MouseEvent ) : void {
			_pressed.setTo( _target.mouseX, _target.mouseY );
			
			_prevX = ev.stageX;
			_prevY = ev.stageY;
			
			_time = getTimer();
			
			if ( handlerDown != null ) {
				if ( handlerDown.length ) {
					handlerDown( ev );
				} else {
					handlerDown();
				}
				
			}
			
			_targetUp.addEventListener( MouseEvent.MOUSE_UP, onMouseUp );
			_targetMove.addEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
		}
		
		private function onMouseUp( ev : MouseEvent ) : void {
			_time = getTimer() - _time;
			
			_released.setTo( _targetUp.mouseX, _targetUp.mouseY );
			
			if ( handlerUp != null ) {
				if ( handlerUp.length ) {
					handlerUp( ev );
				} else {
					handlerUp();
				}
			}
			
			_targetUp.removeEventListener( MouseEvent.MOUSE_UP, onMouseUp );
			_targetMove.removeEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
		}
		
		private function onMouseWheel( ev : MouseEvent ) : void {
			_wheelDelta = ev.delta;
			
			if ( handlerWheel != null ) {
				if ( handlerWheel.length ) {
					handlerWheel( ev );
				} else {
					handlerWheel();
				}
			}
		}
		
		private function onMouseMove( ev : MouseEvent ) : void {
			_positionOnStage.setTo( ev.stageX, ev.stageY );
			
			_movement.x = ev.stageX - _prevX;
			_movement.y = ev.stageY - _prevY;
			
			_prevX = ev.stageX;
			_prevY = ev.stageY;
			
			if ( handlerDrag != null ) {
				if ( handlerDrag.length ) {
					handlerDrag( ev );
				} else {
					handlerDrag();
				}
			}
		}
		
		public function get wheelDelta():Number {
			return _wheelDelta;
		}
		
		public function get movement():Point {
			return _movement;
		}
		
		public function get speed():Point {
			return _speed;
		}
		
		public function get pressed():Point {
			return _pressed;
		}
		
		public function get released():Point {
			return _released;
		}
		
		public function get positionOnStage():Point {
			return _positionOnStage;
		}
		
		public function dispose() : void {
			handlerDown = null;
			handlerDrag = null;
			handlerUp = null;
			handlerWheel = null;
			handlerOver = null;
			handlerOut = null;
			
			_target.removeEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
			_target.removeEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
			_target.removeEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			_targetUp.removeEventListener( MouseEvent.MOUSE_UP, onMouseUp );
			_targetMove.removeEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
			_targetWheel.removeEventListener( MouseEvent.MOUSE_WHEEL, onMouseWheel );
			
			_target = null;
			_targetUp = null;
			_targetMove = null;
			_targetWheel = null;
			_movement = null;
			_speed = null;
			_pressed = null;
			_released = null;
		}
	}

}