package ru.arslanov.starling.gui.windows {
	import core.controllers.ControllerBase;
	import ru.arslanov.starling.interactive.DragController;
	import starling.display.DisplayObject;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class WindowController extends ControllerBase {
		
		private var _win:WindowBase;
		private var _dc:DragController;
		private var _body:DisplayObject;
		
		public function WindowController( window:WindowBase, body:DisplayObject ) {
			_win = window;
			_body = body;
			
			super();
		}
		
		override public function init():void {
			super.init();
			
			_dc = new DragController();
			_dc.onDragStart = onActivateWindow;
			_dc.init( _win, _body );
		}
		
		private function onActivateWindow():void {
			WindowsManager.toTop( _win.cfg.winID );
			WindowsManager.disableOtherWindows( _win );
		}
		
		override public function kill():void {
			_dc.kill();
			_dc = null;
			
			super.kill();
			
			_win = null;
			_body = null;
		}
	}

}