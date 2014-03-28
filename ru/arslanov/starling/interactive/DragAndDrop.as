package ru.arslanov.starling.interactive {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import ru.arslanov.starling.StEngine;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.events.TouchEvent;
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class DragAndDrop {
		
		public var rootContainer:DisplayObjectContainer;
		
		private var _dropDataObjects:Dictionary/*DropData*/ = new Dictionary( true );
		private var _parentDrag:DisplayObjectContainer;
		private var _startPosition:Point = new Point();
		private var _dropEvent:DropEvent = new DropEvent( null, null, null );
		
		public function DragAndDrop( rootContainer:DisplayObjectContainer = null ) {
			this.rootContainer = rootContainer ? rootContainer : StEngine.me.stage;
		}
		
		public function undoDrag( object:DisplayObject ):void {
			addChildTo( _parentDrag, object );
			
			object.x = _startPosition.x;
			object.y = _startPosition.y;
		}
		
		public function addChildTo( container:DisplayObjectContainer, object:DisplayObject ):void {
			var lp:Point = container.globalToLocal( object.parent.localToGlobal( new Point( object.x, object.y ) ) );
			
			object.x = lp.x;
			object.y = lp.y;
			
			container.addChild( object );
		}
		
		/***************************************************************************
		Добавление драг-объектов
		***************************************************************************/
		public function addDragObject( object:DisplayObject, onDropHandler:Function, onBeginHandler:Function = null, handlerDrag:Function = null ):void {
			var dc:DragController = new DragController();
			dc.onDragStart = onDragStart;
			dc.onDragStop = onDragStop;
			if ( handlerDrag != null ) dc.onDrag = onDrag;
			dc.init( object );
			
			_dropDataObjects[object] = new DropData( dc, onDropHandler, onBeginHandler, handlerDrag );
		}
		
		//public function addChildsAsDragObjects( container:DisplayObjectContainer ):void {
			//var len:uint = container.numChildren;
			//for (var i:int = 0; i < len; i++) {
				//var child:DisplayObject = container.getChildAt( i );
				//addDragObject( child );
			//}
		//}
		
		/***************************************************************************
		Удаление драг-объектов
		***************************************************************************/
		public function removeDragObject( object:DisplayObject ):void {
			_dropDataObjects[object].kill();
			_dropDataObjects[object] = null;
			delete _dropDataObjects[object];
		}
		
		//public function removeDragObjects( ...objects ):void {
			//for each (var obj:DisplayObject in objects ) {
				//for each (var ctrl:DragController in _dropDataObjects ) {
					//if ( obj == ctrl.target ) {
						//removeDropTarget( obj );
					//}
				//}
			//}
		//}
		
		public function removeAllDragObjects():void {
			var item:DropData;
			
			for each (item in _dropDataObjects ) {
				removeDragObject( item.controller.target );
			}
			
			item = null;
		}
		
		/***************************************************************************
		Обработчики
		***************************************************************************/
		private function onDragStart( ev:TouchEvent ):void {
			var target:DisplayObject = ev.currentTarget as DisplayObject;
			
			var hitData:DropData = _dropDataObjects[ target ];
			
			if ( hitData ) {
				if ( hitData.onBegin != null ) {
					_dropEvent.dragAndDrop = this;
					_dropEvent.dragObject = target;
					hitData.onBegin( _dropEvent );
				}
			}
			
			_startPosition.setTo( target.x, target.y );
			
			// Сохраняем parent
			_parentDrag = target.parent;
			
			addChildTo( rootContainer, target );
		}
		
		private function onDragStop( ev:TouchEvent ):void {
			var target:DisplayObject = ev.currentTarget as DisplayObject;
			
			var dropTarget:DisplayObject = beginHitTest( target, target.stage );
			
			addChildTo( _parentDrag, target );
			
			var hitData:DropData = _dropDataObjects[ target ];
			
			if ( hitData ) {
				if ( hitData.onDrop != null ) {
					_dropEvent.dragAndDrop = this;
					_dropEvent.dragObject = target;
					_dropEvent.dropTarget = dropTarget;
					hitData.onDrop( _dropEvent );
				}
			} else {
				undoDrag( target );
			}
		}
		
		private function onDrag( ev:TouchEvent ):void {
			var target:DisplayObject = ev.target as DisplayObject;
			
			var dropTarget:DisplayObject = beginHitTest( target, target.stage );
			
			var hitData:DropData = _dropDataObjects[ target ];
			
			if ( hitData ) {
				if ( hitData.onDrag != null ) {
					_dropEvent.dragAndDrop = this;
					_dropEvent.dragObject = target;
					_dropEvent.dropTarget = dropTarget;
					hitData.onDrag( _dropEvent );
				}
			}
		}
		
		private function beginHitTest( target:DisplayObject, root:DisplayObjectContainer ):DisplayObject {
			var hit:DisplayObject;
			var item:DisplayObject;
			
			var bounds:Rectangle = target.getBounds( target );
			
			var locPoint:Point = new Point( target.x + bounds.width * 0.5, target.y + bounds.height * 0.5 );
			
			for (var i:int = root.numChildren - 1; i >= 0; i-- ) {
				item = root.getChildAt( i );
				
				if ( item != target ) {
					hit = item.hitTest( item.globalToLocal( target.parent.localToGlobal( locPoint ) ) );
					if ( hit ) return hit;
				}
			}
			
			hit = null;
			item = null;
			locPoint = null;
			
			return null;
		}
		
		
		
		
		
		public function kill():void {
			removeAllDragObjects();
			
			_dropDataObjects = null;
			
			rootContainer = null;
			_parentDrag = null;
			_startPosition = null;
			_dropEvent = null;
		}
	}
}

import ru.arslanov.starling.interactive.DragController;

internal class DropData {
	
	public var onDrop:Function;
	public var onDrag:Function;
	public var onBegin:Function;
	public var controller:DragController;
	
	public function DropData( controller:DragController, onDrop:Function, onBegin:Function = null, onDrag:Function = null ) {
		this.controller = controller;
		this.onDrop = onDrop;
		this.onDrag = onDrag;
		this.onBegin = onBegin;
	}
	
	public function kill():void {
		onDrop = null;
		onDrag = null;
		onBegin = null;
		controller.kill();
		controller = null;
	}
}