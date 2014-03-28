package ru.arslanov.starling.gui.windows {
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class CfgWindow {
		
		static private var _count:Number = 0;
		
		public var winClass:Class = WindowBase;
		public var skinClass:Class = SkinWindow;
		
		public var winID:String = "defaultID"; // Идентификатор окна, с помощью которого можно получить ссылку на экземпляр видимого окна
		public var bounds:Rectangle = new Rectangle( 0, 0, 200, 150 ); // Задаёт положение и размеры окна
		public var title:String = "Безимянное окно";
		public var screenAlign:String = ""; // см. константы WindowsManager
		public var data:Object; // Используется для передачи пользовательских данных
		public var draggable:Boolean = false; // 
		
		public function CfgWindow( windowId:String = "defaultID" ) {
			winID = windowId + (++_count);
		}
		
		public function kill():void {
			bounds = null;
			title = null;
			winClass = null;
			winID = null;
			data = null;
		}
	}

}