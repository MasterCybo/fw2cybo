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
	 * ...
	 * @author Artem Arslanov
	 */
	public class WEBService {
		
		private var _queue:Vector.<DataRequest> = new Vector.<DataRequest>();
		private var _dataRequests:Dictionary/*URLLoader:DataRequest*/ = new Dictionary( true );
		
		public function WEBService() {

		}
		
		/***************************************************************************
		Проверка доступности сервера
		***************************************************************************/
		public function get isOnline():Boolean {
			return ( new LocalConnection() ).domain.search( "app#" ) == -1;
		}

		/**
		 * Добавляет новый запрос в очередь
		 * @param request
		 * @param callbackSuccessful
		 * @param callbackError
		 */
		public function addRequest( request:HTTPRequest, callbackSuccessful:Function = null, callbackError:Function = null ):void {
			pushToQueue( new DataRequest( request, callbackSuccessful, callbackError ) );
			trySend();
		}

		/**
		 * Помещаем объект данных запроса в очередь
		 * @param dataRequest
		 */
		private function pushToQueue( dataRequest:DataRequest ):void
		{
			_queue.push( dataRequest );
		}

		/**
		 * Пробуем отправить запрос
		 * @param dataRequest
		 */
		private function trySend():void {
			if( !_queue.length ) return;

			var dataRequest:DataRequest = _queue.shift();

			var loader:URLLoader = new URLLoader();
			loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
			loader.addEventListener( HTTPStatusEvent.HTTP_STATUS, onHTTPStatus );
			loader.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
			loader.addEventListener( Event.COMPLETE, onComplete );

			var httpRequest:HTTPRequest = dataRequest.httpRequest;
			
			var req:URLRequest = new URLRequest();
			Log.traceText( "req.requestHeaders : " + req.requestHeaders );
			//req.requestHeaders.push( new URLRequestHeader( "Cache-Control", "no-store, must-revalidate, max-age=0" ) );
			req.requestHeaders.push( new URLRequestHeader( "Cache-Control", "no-store" ) );
			req.requestHeaders.push( new URLRequestHeader( "Pragma", "no-cache") );
			
			req.url = httpRequest.url;
			req.method = httpRequest.method;
			if ( httpRequest.vars ) {
				req.data = httpRequest.vars;
			}

			Log.traceNetSend( "Send " + httpRequest + " : " + req.url + ( httpRequest.vars == null ? "" : "?" + unescape( httpRequest.vars.toString() ) ) );
			
			_dataRequests[loader] = dataRequest;
			
			loader.load( req );
		}

		private function trySendAlternative():void {
			if( !_queue.length ) return;

			var dataRequest:DataRequest = _queue.shift();

			var loader:URLLoader = new URLLoader();
			loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
			loader.addEventListener( HTTPStatusEvent.HTTP_STATUS, onHTTPStatus );
			loader.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
			loader.addEventListener( Event.COMPLETE, onComplete );

			var httpRequest:HTTPRequest = dataRequest.httpRequest;

			var req:URLRequest = new URLRequest();
			Log.traceText( "req.requestHeaders : " + req.requestHeaders );
			//req.requestHeaders.push( new URLRequestHeader( "Cache-Control", "no-store, must-revalidate, max-age=0" ) );
			req.requestHeaders.push( new URLRequestHeader( "Cache-Control", "no-store" ) );
			req.requestHeaders.push( new URLRequestHeader( "Pragma", "no-cache") );

			req.url = httpRequest.altURL;
			req.method = httpRequest.method;
			if ( httpRequest.vars ) {
				req.data = httpRequest.vars;
			}

			Log.traceNetSend( "Send " + httpRequest + " : " + req.url + ( httpRequest.vars == null ? "" : "?" + unescape( httpRequest.vars.toString() ) ) );

			_dataRequests[loader] = dataRequest;

			loader.load( req );
		}
		
		/***************************************************************************
		Обработчики лоадера
		***************************************************************************/
		private function onComplete( ev:Event ):void {
			callSuccessful( ev.target as URLLoader );
		}

		private function callSuccessful( loader:URLLoader ):void {
			var dataRequest:DataRequest = _dataRequests[loader];

			if ( !dataRequest ) return;

			Log.traceNetAnswer( "Response " + dataRequest.httpRequest );

			var f:Function = dataRequest.handlerSuccessful;
			if ( f != null ) {
				dataRequest.httpRequest.data = loader.data;
				f( dataRequest.httpRequest );
			}

			//dataRequest.dispose();
			delete _dataRequests[loader];
		}
		
		private function onSecurityError( ev:SecurityErrorEvent ):void {
			var loader:URLLoader = ev.target as URLLoader;
			var dataRequest:DataRequest = _dataRequests[loader];
			
			Log.traceError( "WEBService: " + dataRequest.httpRequest + " Security Error: " + ev );
			
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
			
			Log.traceNetAnswer( "WEBService: " + dataRequest.httpRequest + " : " + message );
		}
		
		private function onIOError( ev:IOErrorEvent ):void {
			var loader:URLLoader = ev.target as URLLoader;
			var dataRequest:DataRequest = _dataRequests[loader];
			
			Log.traceError( "WEBService: " + dataRequest.httpRequest + " : IO Error: " + ev.text );
			
			callError( ev.target as URLLoader );
		}

		private function callError( loader:URLLoader ):void {
			var dataRequest:DataRequest = _dataRequests[loader];
			
			if ( !dataRequest ) return;
			
			var f:Function = dataRequest.handlerError;
			if ( f != null ) {
				f();
			}
			
			dataRequest.dispose();
			delete _dataRequests[loader];
		}



		public function dispose():void {
			_queue = null;
			_dataRequests = null;
		}
	}
}

import ru.arslanov.core.http.HTTPRequest;

internal class DataRequest {
	
	public var httpRequest:HTTPRequest;
	public var handlerSuccessful:Function;
	public var handlerError:Function;
	
	public function DataRequest ( request:HTTPRequest, callbackSuccessful:Function = null, callbackError:Function = null ) {
		this.httpRequest = request;
		this.handlerSuccessful = callbackSuccessful;
		this.handlerError = callbackError;
	}
	
	public function dispose():void {
		httpRequest = null;
		handlerSuccessful = null;
		handlerError = null;
	}
}