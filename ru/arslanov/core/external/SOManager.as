package ru.arslanov.core.external {
	import flash.net.SharedObject;
	import ru.arslanov.core.utils.Log;
	/**
	 * Статический класс для комфортной работы с SharedObject
	 * @author Artem Arslanov
	 */
	public class SOManager {
		
		static private var _inited:Boolean = false;
		static private var _so:SharedObject;
		
		public function SOManager() {
			
		}
		
		static public function init( name:String = "settings", localPath:String = null, secure:Boolean = false ):void {
			if ( _inited ) return;
			
			name = !name || (name.length == 0) ? "settings" : name;
			
			try {
				_so = SharedObject.getLocal( name, localPath, secure );
			} catch ( err:Error ) {
				Log.traceError( err );
			}
			
			
			_inited = true;
		}
		
		static public function setVar( varName:String, value:* ):void {
			_so.data[varName] = value;
			
			try {
				_so.flush();
			} catch ( err:Error ) {
				Log.traceError( err );
			}
		}
		
		static public function getVar( varName:String, defaultValue:* = null ):* {
			var value:* = _so.data[varName];
			return value ? value : defaultValue;
		}
		
		static public function getString( varName:String, defaultValue:String = "" ):String {
			var value:String = String( _so.data[varName] );
			return value ? value : defaultValue;
		}
		
		static public function getNumber( varName:String, defaultValue:Number = 0 ):Number {
			var value:Number = Number( _so.data[varName] );
			return isNaN( value ) ? defaultValue : value;
		}
		
		static public function getBoolean( varName:String, defaultValue:Boolean = false ):Boolean {
			return _so.data[varName] != undefined ? Boolean( _so.data[varName] ) : defaultValue;
		}
		
		static public function getData():Object {
			return _so.data;
		}
		
		static public function clear():void {
			_so.clear();
		}
		
		static public function get sharedObject():SharedObject {
			return _so;
		}
	}

}