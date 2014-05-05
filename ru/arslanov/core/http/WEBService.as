package ru.arslanov.core.http {
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.LocalConnection;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.utils.Dictionary;
	import ru.arslanov.core.utils.Log;
	/**
	 * Сервис отправки и получения запросов на сервер посредством HTTP-запросов
	 * @author Artem Arslanov
	 */
	public class WEBService {

		public static var verbose:Boolean = true; // (verbose = многословный) Разрешение протоколировать работу сервиса

		private var _serverURL:String = "";
		private var _queue:Vector.<HTTPRequest> = new Vector.<HTTPRequest>();
		private var _dataRequests:Dictionary/*URLLoader:DataRequest*/ = new Dictionary( true );
		
		private var _serverIsAvailable:Boolean;
		private var _callbackCheckServer:Function;
		
		
		public function WEBService( serverURL:String = null ) {
			_serverURL = serverURL;

			_serverIsAvailable = (serverURL != null) && (serverURL != "") && (( new LocalConnection() ).domain != "localhost");
			
//			Log.traceText( "_serverIsAvailable : " + _serverIsAvailable );
//			Log.traceText( "Create WEBService : " + _serverURL );
		}

		/**
		 * Проверка доступности сервера
		 */
		public function get serverIsAvailable():Boolean {
			return _serverIsAvailable;
		}

		public function get isOnline():Boolean {
			return ( serverURL != "localhost" ) && ( serverURL.search( "app#" ) == -1 );
		}
		
		public function get serverURL():String {
			return _serverURL;
		}
		
		public function addRequest( request:HTTPRequest, callbackSuccessful:Function = null, callbackError:Function = null ):void {
			send( new DataRequest( request, callbackSuccessful, callbackError ) );
		}
		
		private function send( dataRequest:DataRequest ):void {
			var loader:URLLoader = new URLLoader();
			loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
			loader.addEventListener( HTTPStatusEvent.HTTP_STATUS, onHTTPStatus );
			loader.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
			loader.addEventListener( Event.COMPLETE, onComplete );
			
			var httpRequest:HTTPRequest = dataRequest.httpRequest;
			
			var req:URLRequest = new URLRequest();
//			Log.traceText( "req.requestHeaders : " + req.requestHeaders );
			//req.requestHeaders.push( new URLRequestHeader( "Cache-Control", "no-store, must-revalidate, max-age=0" ) );
			req.requestHeaders.push( new URLRequestHeader( "Cache-Control", "no-store" ) );
			req.requestHeaders.push( new URLRequestHeader( "Pragma", "no-cache") );
			
			if ( !serverIsAvailable ) {
				req.url = httpRequest.altURL;
			} else {
				req.url = _serverURL + httpRequest.url;
				req.method = httpRequest.method;
				if ( httpRequest.vars ) {
					req.data = httpRequest.vars;
				}
			}
			
			Log.traceNetSend( "Send " + httpRequest + " : " + req.url + ( httpRequest.vars == null ? "" : "?" + unescape( httpRequest.vars.toString() ) ) );
			
			_dataRequests[loader] = dataRequest;
			
			loader.load( req );
		}
		
		/***************************************************************************
		Обработчики лоадера
		***************************************************************************/
		//{ region
		private function onComplete( ev:Event ):void {
			callSuccessful( ev.target as URLLoader );
		}
		
		private function onSecurityError( ev:SecurityErrorEvent ):void {
			var loader:URLLoader = ev.target as URLLoader;
			var dataRequest:DataRequest = _dataRequests[loader];
			
			Log.traceError( "HTTPManager: " + dataRequest.httpRequest + " Security Error: " + ev );
			
			callError( ev.target as URLLoader );
		}
		
		private function onHTTPStatus( ev:HTTPStatusEvent ):void {
			var loader:URLLoader = ev.target as URLLoader;
			var dataRequest:DataRequest = _dataRequests[loader];
			
			var message:String = "HTTP Status: " + ev.status;
			if ( ev.status >= 400 ) {
				//message += ". Сервер не работает или не отвечает."
				message += ". Запрос по адресу altURL : " + dataRequest.httpRequest.altURL;
			}
			
			Log.traceNetAnswer( "HTTPManager: " + dataRequest.httpRequest + " : " + message );
		}
		
		private function onIOError( ev:IOErrorEvent ):void {
			var loader:URLLoader = ev.target as URLLoader;
			var dataRequest:DataRequest = _dataRequests[loader];
			
			Log.traceError( "HTTPManager: " + dataRequest.httpRequest + " : IO Error: " + ev.text );
			
			callError( ev.target as URLLoader );
		}
		//} endregion
		
		
		private function callSuccessful( loader:URLLoader ):void {
			var dataRequest:DataRequest = _dataRequests[loader];
			
			if ( !dataRequest ) return;
			
			Log.traceNetAnswer( "Response " + dataRequest.httpRequest );
			
			var f:Function = dataRequest.callbackSuccessful;
			if ( f != null ) {
				dataRequest.httpRequest.responseData = loader.data;
				f( dataRequest.httpRequest );
			}
			
			//dataRequest.dispose();
			delete _dataRequests[loader];
		}
		
		private function callError( loader:URLLoader ):void {
			var dataRequest:DataRequest = _dataRequests[loader];
			
			if ( !dataRequest ) return;
			
			var f:Function = dataRequest.callbackError;
			if ( f != null ) {
				f();
			}
			
			dataRequest.dispose();
			delete _dataRequests[loader];
		}
		
		public function dispose():void {
			_queue = null;
			_dataRequests = null;
			_callbackCheckServer = null;
		}
	}
}

import ru.arslanov.core.http.HTTPRequest;

internal class DataRequest {
	
	public var httpRequest:HTTPRequest;
	public var callbackSuccessful:Function;
	public var callbackError:Function;
	
	public function DataRequest ( request:HTTPRequest, callbackSuccessful:Function = null, callbackError:Function = null ) {
		httpRequest = request;
		this.callbackSuccessful = callbackSuccessful;
		this.callbackError = callbackError;
	}
	
	public function dispose():void {
		httpRequest = null;
		callbackSuccessful = null;
		callbackError = null;
	}
}