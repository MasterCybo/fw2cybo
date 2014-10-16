package ru.arslanov.starling.gui.windows {
	import flash.utils.Dictionary;
	import ru.arslanov.core.layout.Align;
	import ru.arslanov.core.utils.Display;
	import ru.arslanov.core.utils.Log;
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public class WindowsManager {
		
		static public const CENTER			:String = "center";
		static public const LEFT			:String = "left";
		static public const LEFT_TOP		:String = "leftTop";
		static public const TOP				:String = "top";
		static public const RIGHT_TOP		:String = "rightTop";
		static public const RIGHT			:String = "right";
		static public const RIGHT_BOTTOM	:String = "rightBottom";
		static public const BOTTOM			:String = "bottom";
		static public const LEFT_BOTTOM		:String = "leftBottom";
		
		
		static private var _container:Object;
		static private var _windows:Dictionary/*WindowBase*/ = new Dictionary( true );
		static private var _count:uint;
		
		public function WindowsManager() {
			
		}
		
		static public function init( displayObjectContainer:Object ):void {
			if ( !("addChild" in displayObjectContainer) ) {
				throw new TypeError( "displayObjectContainer mast have addChild method!" );
			}
			
			_container = displayObjectContainer;
		}
		
		/***************************************************************************
		Получение ссылки на экземпляр окна
		***************************************************************************/
		static public function getWindow( windowId:String ):WindowBase {
			if ( !_windows[ windowId ] ) {
				Log.traceWarn( "Undefined winID '" + windowId + "'!" );
				return null;
			}
			
			return _windows[windowId];
		}
		
		static public function getWindowTop():WindowBase {
			if ( _count == 0 ) return null;
			
			var depth:int = -1;
			var window:WindowBase;
			
			for each (var win:WindowBase in _windows ) {
				if ( win.getDepth() > depth ) {
					window = win;
					depth = win.getDepth();
				}
			}
			
			return window;
		}
		
		static public function getWindowDown():WindowBase {
			if ( _count == 0 ) return null;
			
			var depth:int = int.MAX_VALUE;
			var window:WindowBase;
			
			for each (var win:WindowBase in _windows ) {
				if ( win.getDepth() < depth ) {
					window = win;
					depth = win.getDepth();
				}
			}
			
			return window;
		}
		
		/***************************************************************************
		Отображение
		***************************************************************************/
		static public function displayWindow( config:CfgWindow, closePrevious:Boolean = true, modal:Boolean = true ):String {
			if ( closePrevious ) {
				closeWindowTop();
			}
			
			var win:WindowBase = new config.winClass( config );
			_container.addChild( win );
			
			switch ( win.cfg.screenAlign ) {
				case CENTER:
					Align.toCenter( Display.rect, win );
				break;
				case LEFT:
					Align.toL( Display.rect, [win] );
				break;
				case LEFT_TOP:
					Align.toLT( Display.rect, win );
				break;
				case TOP:
					Align.toT( Display.rect, [win] );
				break;
				case RIGHT_TOP:
					Align.toRT( Display.rect, win );
				break;
				case RIGHT:
					Align.toR( Display.rect, [win] );
				break;
				case RIGHT_BOTTOM:
					Align.toRB( Display.rect, win );
				break;
				case BOTTOM:
					Align.toB( Display.rect, [win] );
				break;
				case LEFT_BOTTOM:
					Align.toLB( Display.rect, win );
				break;
				default:
					win.x = win.cfg.bounds.x;
					win.y = win.cfg.bounds.y;
			}
			
			_windows[ win.cfg.winID ] = win;
			
			_count++;
			
			if ( modal ) {
				disableOtherWindows( win );
			}
			
			return win.cfg.winID;
		}
		
		static public function disableOtherWindows( window:WindowBase ):void {
			window.enabled = true;
			
			for each (var win:WindowBase in _windows ) {
				if ( win != window ) {
					win.enabled = false;
				}
			}
		}
		
		/***************************************************************************
		Удаление
		***************************************************************************/
		static public function closeWindow( windowId:String, killConfig:Boolean = true ):void {
			killWindow( getWindow( windowId ), killConfig );
		}
		
		static public function closeWindowTop( killConfig:Boolean = true ):void {
			killWindow( getWindowTop(), killConfig );
		}
		
		static private function killWindow( win:WindowBase, killConfig:Boolean = true ):void {
			if ( !win ) return;
			
			delete _windows[ win.cfg.winID ];
			
			if ( killConfig ) win.cfg.kill();
			
			win.kill();
			win = null;
			
			_count--;
			
			win = getWindowTop();
			
			if ( !win ) return;
			
			win.enabled = true;
		}
		
		/***************************************************************************
		Поменять местами
		***************************************************************************/
		static public function swapWindows( windowId1:String, windowId2:String ):void {
			swapDepths( getWindow( windowId1 ), getWindow( windowId2 ) );
		}
		
		static public function toTop( windowId:String ):void {
			var winTop:WindowBase = getWindowTop();
			
			if ( !winTop || ( windowId == winTop.cfg.winID ) ) return;
			
			var targetWin:WindowBase = getWindow( windowId );
			
			swapDepths( winTop, targetWin );
		}
		
		static private function swapDepths( win1:WindowBase, win2:WindowBase ):void {
			if ( !win1 || !win2 ) return;
			
			_container.swapChildren( win1, win2 );
		}
	}

}