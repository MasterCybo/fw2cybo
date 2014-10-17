package ru.arslanov.starling.events {
	import flash.utils.Dictionary;
	import ru.arslanov.core.utils.Log;
	import starling.events.Event;
	import starling.events.EventDispatcher;


	/**
	 * Менеджер подписчиков
	 * @author Artem Arslanov
	 */
	public class EventManagerStarling {
		
		static private var _tracer:Function = trace;
		
		static public function tracer( traceMethod:Function ):void {
			_tracer = traceMethod;
		}
		
		
		private var _target:EventDispatcher;
		private var _mapEventData:Dictionary/*Vector.<EventData>*/; // Формат type:Vector.<EventData>
		
		public function EventManagerStarling( target:EventDispatcher = null ) {
			_target = target ? target : new EventDispatcher();
			_mapEventData = new Dictionary( true );
		}
		
		public function get target():EventDispatcher {
			return _target;
		}
		
		/***************************************************************************
		Подписка на событие
		***************************************************************************/
		public function addEventListener( type:String, listener:Function ):void {
			// Проверяем, существуют ли записи для этого события, если нет, тогда создаём пустую запись
			var vect:Vector.<EventData> = _mapEventData[ type ];
			if ( vect == null ) {
				vect = new Vector.<EventData>();
				_mapEventData[ type ] = vect;
			}
			
			// Проверяем, зарегистрировано ли это событие
			if ( hasEventListener( type, listener ) ) {
				Log.traceWarn( 'EventManager.addEvent : The event listener "' + type + '" for ' + _target + ' already exists.' );
				return;
			}
			
			vect.push( new EventData( type, listener ) );
			_target.addEventListener( type, listener );
			
			traceMessage( _target + ".addEventListener : " + type );
		}
		
		/***************************************************************************
		Проверка подписки события
		***************************************************************************/
		public function hasEventListener( type:String, listener:Function = null ):Boolean {
			if ( type && listener ) {
				var vect:Vector.<EventData> = _mapEventData[ type ];
				if ( !vect ) return false;
				
				var eventData:EventData;
				for each ( eventData in vect ) {
					if ( eventData.equalsParams( type, listener ) ) {
						return true;
					}
				}
			}
			
			return _mapEventData[ type ] && _mapEventData[ type ].length;
		}
		
		/***************************************************************************
		Отписка от события
		***************************************************************************/
		public function removeEventListener( type:String, listener:Function ):void {
			// Проверяем, есть ли запись данного типа события
			var vect:Vector.<EventData> = _mapEventData[ type ];
			if ( !vect || ( vect.length == 0 ) ) {
				Log.traceWarn( 'EventManager.removeEvent (' + type + ') : Object ' + _target + ' not have listeners.' );
				return;
			}
			
			// Проверяем, если находим событие - удаляем
			var i:int = vect.length;
			while ( i-- ) {
				if ( vect[i].equalsParams( type, listener ) ) {
					vect.splice( i, 1 );
					_target.removeEventListener( type, listener );
					traceMessage( _target + ".removeEventListener : " + type );
					return;
				}
			}
			
			Log.traceWarn( 'EventManager.removeEvent : Object ' + _target + ' not found listeners on event "' + type + '".' );
		}
		
		/***************************************************************************
		Отписываемся от всех событий
		***************************************************************************/
		public function removeAllEventListeners():void {
			var vect:Vector.<EventData>;
			var eventData:EventData;
			for each ( vect in _mapEventData ) {
				for each ( eventData in vect ) {
					_target.removeEventListener( eventData.type, eventData.listener );
					eventData.dispose();
				}
				vect.length = 0;
			}
		}
		
		public function dispatchEvent( event:Event ):void {
			_target.dispatchEvent( event );
		}
		
		public function dispatchEventWith( type:String, bubbles:Boolean = false, data:Object = null ):void {
			var vect:Vector.<EventData> = _mapEventData[type];
			var eventData:EventData;
			for each (eventData in vect) {
				dispatchEvent( new Event( type, bubbles, data ) );
			}
		}
		
		static private function traceMessage( message:String ):void {
			if ( _tracer == null ) return;
			
			_tracer( message );
		}
		
		public function dispose():void {
			removeAllEventListeners();
			
			_mapEventData.length = 0;
			_mapEventData = null;
			_target = null;
		}
		
		
	}

}

internal class EventData {
	public var type:String;
	public var listener:Function;
	
	public function EventData( type:String, listener:Function ):void {
		this.type = type;
		this.listener = listener;
	}
	
	public function dispose():void {
		this.listener = null;
	}
	
	public function equals( evData:EventData ):Boolean {
		return equalsParams( evData.type, evData.listener );
	}
	
	public function equalsParams( type:String, listener:Function ):Boolean {
		return ( this.type == type ) && ( this.listener == listener );
	}
}