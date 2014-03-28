package ru.arslanov.starling {
	//import flash.desktop.NativeApplication;
	import flash.display.Stage;
	import flash.display.Stage3D;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import ru.arslanov.flash.utils.Display;
	import ru.arslanov.core.utils.Log;
	import starling.core.Starling;
	import starling.display.Stage;
	import starling.events.ResizeEvent;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	//import flash.events.StageOrientationEvent;
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class StarlingEngine {
		static private var _starling:Starling;
		static private var _stageNative:flash.display.Stage;
		static private var _viewport:Rectangle;
		static private var _stageBounds:Rectangle;
		static private var _iOS:Boolean;
		static private var _isInited:Boolean;
		
		public function StarlingEngine() {
			
		}
		
		static public function init( rootClass:Class, stage:flash.display.Stage, stageBounds:Rectangle = null, stage3D:Stage3D = null, renderMode:String = "auto", profile:String = "baselineConstrained" ):void {
			if (_isInited) return;
			
			Log.traceText( "CALL >> StarlingEngine.init" );
			
			_stageNative = stage;
			_stageBounds = stageBounds;
			
            _iOS = Capabilities.manufacturer.indexOf( "iOS" ) != -1;
			
			Starling.multitouchEnabled = false;  // useful on mobile devices
            Starling.handleLostContext = !_iOS;  // not necessary on _iOS. Saves a lot of memory!
			
			//Log.traceText( "------------------------------------" );
			//Log.traceText( "stage : " + stage.width + " x " + stage.height );
			//Log.traceText( "stage.fullscreen : " + stage.fullScreenWidth + " x " + stage.fullScreenHeight );
			//Log.traceText( "stage.fullScreenSourceRect : " + stage.fullScreenSourceRect );
			//Log.traceText( "Display.fullscreen : " + Display.fullScreenWidth + " x " + Display.fullScreenHeight );
			//Log.traceText( "Display.stageWidth x Display.stageHeight : " + Display.stageWidth + " x " + Display.stageHeight );
			//Log.traceText( "------------------------------------" );
			
			var vp:Rectangle = new Rectangle( 0, 0, stage.fullScreenWidth, stage.fullScreenHeight );
			
			//vp = RectangleUtil.fit( vp, new Rectangle( 0, 0, stage.fullScreenWidth, stage.fullScreenHeight ), ScaleMode.SHOW_ALL, _iOS );
			
			//Log.traceText( "------------------------------------" );
			//Log.traceText( "stage : " + stage.width + " x " + stage.height );
			//Log.traceText( "stage.fullscreen : " + stage.fullScreenWidth + " x " + stage.fullScreenHeight );
			//Log.traceText( "stage.fullScreenSourceRect : " + stage.fullScreenSourceRect );
			//Log.traceText( "Display.fullscreen : " + Display.fullScreenWidth + " x " + Display.fullScreenHeight );
			//Log.traceText( "Display : " + Display.stageWidth + " x " + Display.stageHeight );
			//Log.traceText( "------------------------------------" );
			
			_starling = new Starling( rootClass, stage, vp, stage3D, renderMode, profile );
			_starling.antiAliasing = 1;
			_starling.stage.stageWidth = Display.fullScreenWidth > Display.fullScreenHeight ? stageBounds.width : stageBounds.height;
			_starling.stage.stageHeight = Display.fullScreenWidth > Display.fullScreenHeight ? stageBounds.height : stageBounds.width;
			
			//_starling.stage.stageWidth = viewPort.width;
			//_starling.stage.stageHeight = viewPort.height;
			
			_viewport = _starling.viewPort;
			
			_starling.start();
			
			//Log.traceText( "------------------------------------" );
			//Log.traceText( "stage : " + stage.width + " x " + stage.height );
			//Log.traceText( "stage.fullscreen : " + stage.fullScreenWidth + " x " + stage.fullScreenHeight );
			//Log.traceText( "stage.fullScreenSourceRect : " + stage.fullScreenSourceRect );
			//Log.traceText( "Display.fullscreen : " + Display.fullScreenWidth + " x " + Display.fullScreenHeight );
			//Log.traceText( "Display : " + Display.stageWidth + " x " + Display.stageHeight );
			//Log.traceText( "_starling.stage : " + _starling.stage.stageWidth + " x " + _starling.stage.stageHeight )
			//Log.traceText( "------------------------------------" );
			
			
			starling.stage.addEventListener( ResizeEvent.RESIZE, hrStageResize );
			
			//NativeApplication.nativeApplication.addEventListener( Event.ACTIVATE, engineStart );
            //NativeApplication.nativeApplication.addEventListener( Event.DEACTIVATE, engineStop );
			
			//Log.traceText( "Display : " + Display.stageWidth + " x " + Display.stageHeight );
			Log.traceText( "Starling ViewPort : " + _viewport );
			Log.traceText( "starling contentScaleFactor : " + starling.contentScaleFactor );
			Log.traceText( "Starling VERSION : " + Starling.VERSION );
			Log.traceText( "StarlingEngine successful inited." );
			
			_isInited = true;
		}
		
		static private function hrStageResize( ev:ResizeEvent ):void {
			//Log.traceText( "*execute* StarlingEngine.hrStageResize" );
			//Log.traceText( "1 starling.contentScaleFactor : " + starling.contentScaleFactor );
			//Log.traceText( "1 StarlingEngine viewPort : " + _viewport );
			
			_viewport.width = ev.width;
			_viewport.height = ev.height;
			starling.viewPort = _viewport;
			
			//Log.traceText( "2 starling.contentScaleFactor : " + starling.contentScaleFactor );
			//Log.traceText( "2 StarlingEngine viewPort : " + _viewport );
			
			//var scale:Number = starling.contentScaleFactor;
			var scale:Number = isLandscape ? _viewport.width / _stageBounds.width : _viewport.width / _stageBounds.height;
			starling.stage.stageWidth  = _viewport.width / scale;
			starling.stage.stageHeight = _viewport.height / scale;
		}
		
		static public function get isLandscape():Boolean {
			return viewPortWidth > viewPortHeight;
		}
		
		static private function engineStop( ev:Event ):void {
			Log.traceText( "Engine STOP!" );
			_starling.stop();
		}
		
		static private function engineStart( ev:Event ):void {
			Log.traceText( "Engine START!" );
			_starling.start();
		}
		
		static public function get starling():Starling {
			return _starling;
		}
		
		static public function get stage():starling.display.Stage {
			return _starling.stage;
		}
		
		static public function get stageNative():flash.display.Stage {
			return _stageNative;
		}
		
		static public function get stageWidth():Number {
			return stage.stageWidth;
		}
		
		static public function get stageHeight():Number {
			return stage.stageHeight;
		}
		
		static public function get viewPortWidth():Number {
			return starling.viewPort.width;
		}
		
		static public function get viewPortHeight():Number {
			return starling.viewPort.height;
		}
		
		static public function get iOS():Boolean {
			return _iOS;
		}
		
		static public function get scale():Number {
			return starling.contentScaleFactor;
		}
		
		static public function showStats( isView:Boolean = true, hAlign:String = "left", vAlign:String = "top" ):void {
			starling.showStats = isView;
			starling.showStatsAt( hAlign, vAlign, 1 / starling.contentScaleFactor );
		}
		
	}

}