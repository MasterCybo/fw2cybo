package ru.arslanov.core.collection {
	import com.adobe.utils.DictionaryUtil;
	import flash.utils.Dictionary;
	/**
	* Расширенный класс словаря
	* @author Artem Arslanov
	*/
	public dynamic class AMap extends Dictionary {
		
		private var _map:Dictionary = new Dictionary( true );
		private var _len:uint;
		
		public function AMap() {
			super();
			this.constructor.prototype.cdcd = function():void {
				trace("asdasdasd");
			}
		}
		
		public function addValue( key:*, value:* ):void {
			if ( !key || !value ) return;
			
			_map[key] = value;
			_len++;
		}
		
		public function removeValue( key:* ):void {
			if ( !key ) return;
			if ( !_map[key] ) return;
			
			delete _map[key];
			_len--;
		}
		
		public function getValue( key:* ):* {
			return _map[key];
		}
		
		public function hasKey( key:* ):Boolean {
			return _map[key] != undefined;
		}
		
		public function get length():uint {
			return _len;
		}
		
		public function getValues():Array {
			return DictionaryUtil.getValues( _map );
		}
		
		public function getKeys():Array {
			return DictionaryUtil.getKeys( _map );
		}
		
		public function dispose():void {
			_map = null;
		}
	}

}