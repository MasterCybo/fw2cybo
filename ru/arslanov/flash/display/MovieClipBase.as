package ru.arslanov.flash.display {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	dynamic public class MovieClipBase extends MovieClip {
		
		static public var enterFrameDispatcher:EventDispatcher;
		static private var _isAllPlaying:Boolean = true;
		
		public var frameStep:Number = 1;
		
		private var _isAutoPlay:Boolean;
		private var _isAutoPlayReversed:Boolean;
		private var _isReversed:Boolean;
		private var _frame:Object = 1;
		private var _totalFrames:Number = 0;
		
		
		//static public function createFromClass( className:Class, autoPlay:Boolean = true, reversed:Boolean = false ):MovieClipBase {
			//return new MovieClipBase( new className(), autoPlay,  );
		//}
		
		static public function stopAll():void {
			_isAllPlaying = false;
		}
		
		static public function resumeAll():void {
			_isAllPlaying = true;
		}
		
		/***************************************************************************
		Constructor
		***************************************************************************/
		public function MovieClipBase( autoPlay:Boolean = true, reversed:Boolean = false ) {
			_isAutoPlay = autoPlay;
			_isAutoPlayReversed = reversed;
			
			enterFrameDispatcher = this;
			
			super();
		}
		
		public function init():* {
			//override me
			
			return super.init();
		}
		
		public function kill():void {
			super.kill();
		}
		
	}

}