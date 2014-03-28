package ru.arslanov.starling.interactive {
	import starling.display.DisplayObject;
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class DropEvent {
		
		public var dropTarget:DisplayObject;
		public var dragObject:DisplayObject;
		public var dragAndDrop:DragAndDrop;
		
		public function DropEvent( dragAndDrop:DragAndDrop, dropTarget:DisplayObject, dragObject:DisplayObject ) {
			this.dragAndDrop = dragAndDrop;
			this.dropTarget = dropTarget;
			this.dragObject = dragObject;
		}
		
	}

}