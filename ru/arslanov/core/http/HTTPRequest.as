package ru.arslanov.core.http {
	import flash.net.URLVariables;
	import flash.utils.getQualifiedClassName;
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class HTTPRequest {
		
		static private var _counter:Number = 0;
		
		public var data:Object; // Данные, возвращаемые сервером
		
		public var method:String = "POST";
		public var vars:URLVariables = null;
		public var url:String = ""; // Основной адрес запроса
		public var altURL:String = ""; // Альтернативный адрес, если основной не доступен
		
		private var _uid:Number = 0;
		
		public function HTTPRequest( url:String, altURL:String = null, vars:URLVariables = null, method:String = "POST" ) {
			_uid = ++_counter;
			
			this.url = url;
			this.altURL = altURL;
			this.vars = vars;
			this.method = method;
		}
		
		public function get uid():Number {
			return _uid;
		}
		
		public function get uidStr():String {
			return "0x" + uid.toString( 16 ).toUpperCase();
		}
		
		public function toString():String {
			return "[" + getQualifiedClassName( this ) + " " + uidStr + "]";
		}
	}

}