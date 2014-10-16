package ru.arslanov.starling.gui.windows {
	import ru.arslanov.core.layout.Align;
	import ru.arslanov.starling.display.ASpriteStarling;
	import ru.arslanov.starling.gui.controls.StButtonNative;
	import starling.events.Event;
	import starling.filters.ColorMatrixFilter;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class WindowBase extends ASpriteStarling {
		
		public var onClose:Function;
		
		private var _enabled:Boolean = true;
		private var _cfg:CfgWindow;
		private var _ctrl:WindowController;
		private var _skin:SkinWindow;
		
		public function WindowBase( config:CfgWindow ) {
			_cfg = config;
			
			super();
		}
		
		override protected function init( ev:Event ):void {
			super.init( ev );
			
			drawWindow();
			
			if ( cfg.draggable && _skin.skinBody ) {
				_ctrl = new WindowController( this, _skin.skinBody );
				_ctrl.init();
			}
		}
		
		public function drawWindow():void {
			_skin = new cfg.skinClass( cfg );
			_skin.create();
			
			if ( _skin.skinBody ) {
				addChild( _skin.skinBody );
			}
			
			if ( _skin.skinClose ) {
				var btnClose:StButtonNative = new StButtonNative( Texture.fromColor( 50, 50, 0xffFF0000 ), "X" );
				btnClose.onClick = close;
				Align.toRT( _skin.skinBody.getBounds( _skin.skinBody.parent ), btnClose );
				addChild( btnClose );
			}
			
			// override me
		}
		
		private function close():void {
			WindowsManager.closeWindow( cfg.winID );
		}
		
		public function get cfg():CfgWindow {
			return _cfg;
		}
		
		public function getDepth():int {
			if ( !parent ) return -1;
			return parent.getChildIndex( this );
		}
		
		public function set enabled( value:Boolean ):void {
			if ( value == _enabled ) return;
			
			_enabled = value;
			
			if ( enabled ) {
				super.filter = null;
			} else {
				var filter:ColorMatrixFilter = new ColorMatrixFilter();
				filter.adjustSaturation( -1 );
				
				super.filter = filter;
			}
		}
		
		public function get enabled():Boolean {
			return _enabled;
		}
		
		override public function toString():String {
			return "[WindowBase " + uidStr + "]";
		}
		
		override public function kill():void {
			if ( _ctrl ) _ctrl.kill();
			_ctrl = null;
			
			if ( _skin ) _skin.kill();
			_skin = null;
			
			super.kill();
			
			if ( onClose != null ) onClose();
			
			_cfg = null;
			onClose = null;
		}
	}

}