package ru.arslanov.core.utils {
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import ru.arslanov.core.utils.Log;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class Display {
		
		static private var _inited:Boolean = false;
		static private var _nativeStage:Stage;
		static private var _nativeRoot:DisplayObject;
		static private var _rectStage:Rectangle;
		
		public function Display() {
			
		}
		
		/***************************************************************************
		Initialization
		***************************************************************************/
		static public function init( root:DisplayObject, scaleMode:String = StageScaleMode.NO_SCALE, align:String = StageAlign.TOP_LEFT ):void {
			if ( _inited ) {
				Log.traceWarn( "Display.init() : Display already inited!" );
				return;
			}
			
			_nativeStage = root.stage;
			_nativeRoot = root;
			
			_nativeStage.scaleMode = StageScaleMode.NO_SCALE;
			_nativeStage.align = StageAlign.TOP_LEFT;
			
			_rectStage = new Rectangle( stage.x, stage.y, stageWidth, stageHeight );
			
			stageAddEventListener( Event.RESIZE, onStageResize );
			
			Log.traceText( "Stage : " + _nativeStage );
			Log.traceText( "Root : " + _nativeRoot );
			Log.traceText( "Stage size : " + stageWidth + "x" + stageHeight );
			Log.traceText( "Screen size : " + stage.fullScreenWidth + "x" + stage.fullScreenHeight );
			Log.traceText( "Display successful inited." );
			
			_inited = true;
		}
		
		static private function onStageResize( ev:Event ):void {
			_rectStage.setTo( stage.x, stage.y, stageWidth, stageHeight );
		}
		
		/***************************************************************************
		Getters/Setters
		***************************************************************************/
		static public function get root():DisplayObject {
			return _nativeRoot;
		}
		
		static public function get stage():Stage {
			return _nativeStage;
		}
		
		static public function get stageWidth():Number {
			return stage.stageWidth;
		}
		
		static public function get stageHeight():Number {
			return stage.stageHeight;
		}
		
		static public function get fullScreenWidth():Number {
			return stage.fullScreenWidth;
		}
		
		static public function get fullScreenHeight():Number {
			return stage.fullScreenHeight;
		}
		
		static public function get stageRect():Rectangle {
			return _rectStage;
		}
		
		static public function get mouseX():Number {
			return stage.mouseX;
		}
		
		static public function get mouseY():Number {
			return stage.mouseY;
		}
		
		static public function get quality():String {
			return stage ? stage.quality : "";
		}
		
		static public function set quality( value:String ):void {
			if ( !stage ) return;
			stage.quality = value;
		}
		
		static public function get fullscreen():Boolean {
			return stage.displayState == StageDisplayState.FULL_SCREEN;
		}
		
		static public function set fullscreen( value:Boolean ):void {
			if ( value ) {
				stage.displayState = StageDisplayState.FULL_SCREEN;
			} else {
				stage.displayState = StageDisplayState.NORMAL;
			}
		}
		
		static public function alignObject( displayObject:Object, align:String = "center" ):void {
			if( !validateDisplayObject( displayObject ) ) throw new TypeError( "displayObject is not DisplayObject!" );
			
			switch ( align ) {
				case "left":
					displayObject.x = 0;
					displayObject.y = int((stageHeight - displayObject.height) / 2);
				break;
				case "right":
					displayObject.x = int(stageWidth - displayObject.width);
					displayObject.y = int((stageHeight - displayObject.height) / 2);
				break;
				case "top":
					displayObject.x = int((stageWidth - displayObject.width) / 2);
					displayObject.y = 0;
				break;
				case "bottom":
					displayObject.x = int((stageWidth - displayObject.width) / 2);
					displayObject.y = int(stageHeight - displayObject.height);
				break;
				case "leftTop":
					displayObject.x = 0;
					displayObject.y = 0;
				break;
				case "rightTop":
					displayObject.x = int(stageWidth - displayObject.width);
					displayObject.y = 0;
				break;
				case "leftBottom":
					displayObject.x = 0;
					displayObject.y = int(stageHeight - displayObject.height);
				break;
				case "rightBottom":
					displayObject.x = int(stageWidth - displayObject.width);
					displayObject.y = int(stageHeight - displayObject.height);
				break;
				default:
					displayObject.x = int((stageWidth - displayObject.width) / 2);
					displayObject.y = int((stageHeight - displayObject.height) / 2);
			}
		}
		
		static private function validateDisplayObject(displayObject:Object):Boolean {
			return ("x" in displayObject) && ("y" in displayObject) && ("width" in displayObject) && ("height" in displayObject);
		}
		
		/***************************************************************************
		Events
		***************************************************************************/
		static public function stageAddEventListener( type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false ):void {
			stage.addEventListener( type, listener, useCapture, priority, useWeakReference );
		}
		
		static public function stageRemoveEventListener( type:String, listener:Function, useCapture:Boolean=false ):void {
			stage.removeEventListener( type, listener, useCapture );
		}
		
		static public function toString():String {
			return "[Display stage=" + stage + ", stageWidth=" + stageWidth + ", stageHeight=" + stageHeight + "]";
		}
		
	}

}