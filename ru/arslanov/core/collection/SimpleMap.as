package ru.arslanov.core.collection {
	import com.adobe.utils.DictionaryUtil;
	import flash.utils.Dictionary;
	/**
	* ...
	* @author Artem Arslanov
	*/
	public class SimpleMap {
		
		private var _map:Dictionary = new Dictionary( true );
		private var _len:uint;
		
		public function SimpleMap() {
			
		}
		
		public function addValue( key:*, value:* ):void {
			_map[key] = value;
			_len++;
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
			_map = new Dictionary( true );
			_len = 0;
		}
	}

}