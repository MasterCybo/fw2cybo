package ru.arslanov.core.controllers {
	import flash.display.InteractiveObject;
	
	/**
	* ...
	* @author Artem Arslanov
	*/
	public class SimpleDragController {
		private var _mctrl:MouseController;
		private var _target:InteractiveObject;
		
		public function SimpleDragController() {
			
		}
		
		public function init( target:InteractiveObject ):void {
			_target = target;
			
			_mctrl = new MouseController( target );
			_mctrl.handlerDrag = onDragMouse;
		}
		
		private function onDragMouse():void {
			_target.x += _mctrl.movement.x;
			_target.y += _mctrl.movement.y;
		}
		
		public function dispose():void {
			_target = null;
			_mctrl.dispose();
		}
	}

}