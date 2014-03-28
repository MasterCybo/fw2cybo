package ru.arslanov.starling.interactive {
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import starling.display.DisplayObject;
	import starling.events.EventDispatcher;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class TouchController extends EventDispatcher {
		
		public var onBegan:Function;
		public var onEnded:Function;
		public var onTapped:Function;
		public var onMoved:Function;
		public var onHoldTapped:Function;
		
		public var holdDelay:Number = 1; // сек.
		public var moveSensitivity:Number = 20; // Чувствительность к перемещению курсора
		
		protected var _pressGlobalPosition:Point;
		protected var _target:DisplayObject;
		protected var _touchBegan:Touch;
		protected var _touchMoved:Touch;
		protected var _touchEnded:Touch;
		
		private var _touchEvent:TouchEvent;
		private var _tmHold:Timer = new Timer( 1, 1 );
		private var _isHold:Boolean = false;
		private var _isMoved:Boolean = false;
		private var _enabled:Boolean = true;
		
		public function TouchController() {
			super();
		}
		
		public function init( target:DisplayObject ):void {
			if ( !target ) {
				throw new ArgumentError( "Не правильно задан целевой объект : " + target );
			}
			
			_target = target;
			
			_pressGlobalPosition = new Point();
			
			//trace( "_target : " + _target );
			
			_enabled = false;
			enabled = true;
		}
		
		private function touchHandler( ev:TouchEvent ):void {
			_touchEvent = ev;
			
			_touchBegan = ev.getTouch( _target, TouchPhase.BEGAN );
			_touchMoved = ev.getTouch( _target, TouchPhase.MOVED );
			_touchEnded = ev.getTouch( _target, TouchPhase.ENDED );
			
			//trace( "_touchBegan : " + _touchBegan );
			//trace( "_touchMoved : " + _touchMoved );
			//trace( "_touchEnded : " + _touchEnded );
			
			// Касание
			if ( _touchBegan ) {
				_pressGlobalPosition.setTo( _touchBegan.globalX, _touchBegan.globalY );
					
				if ( onBegan != null ) {
					if ( onBegan.length == 1 ) {
						onBegan( ev );
					} else {
						onBegan();
					}
				}
				
				// Если есть слушатель долгого нажатия,
				if ( onHoldTapped != null ) {
					// ...запускаем таймер удержания
					_tmHold.delay = holdDelay * 1000;
					_tmHold.addEventListener( TimerEvent.TIMER_COMPLETE, holdHandler );
					_tmHold.start();
				}
			}
			
			// Отпускание
			if ( _touchEnded ) {
				if ( onEnded != null ) {
					if ( onEnded.length == 1 ) {
						onEnded( ev );
					} else {
						onEnded();
					}
				}
				
				// если было движение, то больше не отправляем никаких событий
				if ( _isMoved ) {
					_isMoved = false;
					return;
				}
				
				// если зафиксиворано удержание, то не отправляем ТАП
				if ( _isHold ) {
					_isHold = false;
					return;
				}
				
				// Если удержание не зафиксировано, стопаем таймер
				clearHoldTimer();
				
				// Обычный клик
				if ( ev.currentTarget == _target ) {
					if ( onTapped != null ) {
						if ( onTapped.length == 1 ) {
							onTapped( ev );
						} else {
							onTapped();
						}
					}
				}
			}
			
			// Перемещение пальца
			if ( _touchMoved ) {
				// если перемещение было меньше допустимого, тогда не фиксируем его
				//if ( Math.round( Point.distance( _pressGlobalPosition, new Point( _touchMoved.globalX, _touchMoved.globalY ) ) ) < moveSensitivity ) {
				if ( Math.round( Point.distance( _pressGlobalPosition, _touchMoved.getLocation( _target.stage ) ) ) < moveSensitivity ) {
					return;
				}
				
				clearHoldTimer();
				
				_isMoved = true;
				
				//trace( _target.hitTest( _target.globalToLocal( new Point( _touch0.globalX, _touch0.globalY ) ), true ) );
				if ( onMoved != null ) {
					if ( onMoved.length == 1 ) {
						onMoved( ev );
					} else {
						onMoved();
					}
				}
			}
		}
		
		private function holdHandler( ev:TimerEvent ):void {
			_isHold = true;
			
			clearHoldTimer();
			
			if ( onHoldTapped != null ) {
				if ( onHoldTapped.length == 1 ) {
					onHoldTapped( _touchEvent );
				} else {
					onHoldTapped();
				}
			}
		}
		
		
		public function get enabled():Boolean {
			return _enabled;
		}
		
		public function set enabled( value:Boolean ):void {
			if ( value == _enabled ) return;
			
			_enabled = value;
			
			if ( _enabled ) {
				_target.addEventListener( TouchEvent.TOUCH, touchHandler );
			} else {
				_target.removeEventListener( TouchEvent.TOUCH, touchHandler );
			}
		}
		
		private function clearHoldTimer():void {
			_tmHold.stop();
			_tmHold.removeEventListener( TimerEvent.TIMER_COMPLETE, holdHandler );
		}
		
		public function kill():void {
			clearHoldTimer();
			
			_target.removeEventListener( TouchEvent.TOUCH, touchHandler );
			
			_tmHold = null;
			
			onBegan = null;
			onEnded = null;
			onTapped = null;
			onMoved = null;
			onHoldTapped = null;
			
			_target = null;
			_touchEvent = null;
			_touchBegan = null;
			_touchEnded = null;
			_touchMoved = null;
			_pressGlobalPosition = null;
		}
		
	}

}