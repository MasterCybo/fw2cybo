package ru.arslanov.starling.gui.windows {
	import ru.arslanov.starling.display.StShapeBase;
	import starling.display.DisplayObject;
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class SkinWindow {
		
		public var skinBody:DisplayObject;
		public var skinHeader:DisplayObject;
		public var skinClose:DisplayObject;
		
		private var _cfg:CfgWindow;
		
		public function SkinWindow( config:CfgWindow ) {
			_cfg = config;
		}
		
		public function create():void {
			if ( !skinBody ) {
				skinBody = new StShapeBase();
				( skinBody as StShapeBase ).graphics.lineStyle( 1, 0x0 );
				( skinBody as StShapeBase ).graphics.beginFill( 0xCACACA );
				( skinBody as StShapeBase ).graphics.drawRect( 0, 0, _cfg.bounds.width, _cfg.bounds.height );
				( skinBody as StShapeBase ).graphics.endFill();
			}
			
			if ( !skinClose ) {
				// TODO: в текущей реализации не используется
				skinClose = new StShapeBase();
				( skinClose as StShapeBase ).graphics.lineStyle( 1, 0x0 );
				( skinClose as StShapeBase ).graphics.beginFill( 0xFF0000 );
				( skinClose as StShapeBase ).graphics.drawRect( 0, 0, 50, 50 );
				( skinClose as StShapeBase ).graphics.endFill();
			}
		}
		
		public function kill():void {
			_cfg = null;
			skinBody = null;
			skinHeader = null;
			skinClose = null;
		}
	}

}