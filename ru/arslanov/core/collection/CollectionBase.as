package ru.arslanov.core.collection {
	import flash.utils.Dictionary;
	import ru.arslanov.core.utils.Log;
	
	/**
	 * Базовый класс коллекций
	 * @version 25.10.2011
	 * @author Artem Arslanov
	 */
	public class CollectionBase {
		
		private var _list:Vector.<Object> = new Vector.<Object>();
		private var _collection:Dictionary/*Object*/ = new Dictionary( true );
		private var _length:uint;
		
		public function CollectionBase() {
			super ();
		}
		
		public function get firstItem():Object {
			return _first;
		}
		
		public function set firstItem( item:Object ):void {
			_first = item;
		}
		
		protected function addItem( key:*, item:Object ):Boolean {
			if ( hasKey( key ) ) {
				Log.traceError( this + ".addItem : Key " + key + " already exists!" );
				return false;
			}
			
			_collection[key] = item;
			_length++;
			
			return true;
		}
		
		protected function removeItem( key:* ):Boolean {
			if ( !hasKey( key ) ) {
				Log.traceError( this + ".removeItem (" + key + ") key not found!");
				return false;
			}
			
			delete _collection[key];
			_length--;
			
			return true;
		}
		
		protected function getItem( key:* ):Object {
			return hasKey( key ) ? _collection[key] : null;
		}
		
		protected function get items():Vector.<Object> {
			_list.length = 0;
			
			for each (var item:Object in _collection ) {
				_list.push( item );
			}
			
			return _list;
		}
		
		protected function getItemByProp( propName:String, propValue:* ):Object {
			for each (var item:Object in _collection ) {
				if ( ( propName in item ) && ( item[propName] == propValue ) ) {
					return item;
				}
			}
			
			return null;
		}
		
		protected function hasKey( key:* ):Boolean {
			return _collection[key] != undefined;
		}
		
		public function get length():uint {
			return _length;
		}
		
		public function clear():void {
			_list.length = 0;
			_collection = new Dictionary( true );
		}
		
		public function kill():void {
			_list.length = 0;
			_list = null;
			_collection = null;
		}
	}

}