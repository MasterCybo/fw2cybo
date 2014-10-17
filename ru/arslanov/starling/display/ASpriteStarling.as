package ru.arslanov.starling.display
{
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	import ru.arslanov.starling.interfaces.IKillableContainerStarling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	
	/**
	 * Базовый спрайт
	 * @author Artem Arslanov
	 */
	public class ASpriteStarling extends Sprite implements IKillableContainerStarling
	{
		
		static private var _counter:Number = 0;
		
		public var customData:Object; // Для хранения пользовательских данных. Зануляется в kill()
		
		private var _uid:Number = 0;
		private var _isKilled:Boolean;
		private var _isInited:Boolean;
		private var _pos:Point = new Point();
		
		public function ASpriteStarling()
		{
			_uid = ++_counter;
			
			super();
		}
		
		/**
		 * Метод инициализации экземпляра. Вызывать перед добавлением на stage
		 * @return ссылка на себя
		 */
		public function init():*
		{
			_isInited = true;
			//touchable = false;
			// override me
			return this;
		}
		
		public function get isInited():Boolean
		{
			return _isInited;
		}
		
		public function kill():void
		{
			if ( isKilled )
				throw( new Error( this + " already killed!" ) ).getStackTrace();
			
			killChildren();
			
			removeFromParent( true );
			
			dispose();
			
			_pos = null;
			
			customData = null;
			
			_isKilled = true;
		
			// override me
		}
		
		public function get isKilled():Boolean { return _isKilled; }
		
		override public function addChild( object:DisplayObject ):DisplayObject
		{
			if ( !( "kill" in object ) )
			{
				throw new ArgumentError( "StSpriteBase : added object no have a kill() method!" ).getStackTrace();
			}
			
			return super.addChild( object );
		}
		
		public function get pos():Point
		{
			_pos.setTo( x, y );
			return _pos;
		}
		
		public function set pos( value:Point ):void
		{
			_pos = value;
			
			x = _pos.x;
			y = _pos.y;
		}
		
		public function setXY( x:Number = 0, y:Number = 0, round:Boolean = true ):void
		{
			super.x = round ? Math.round( x ) : x;
			super.y = round ? Math.round( y ) : y;
			
			_pos.setTo( super.x, super.y );
		}
		
		public function killChildren( startIdx:uint = 0, num:int = -1 ):void
		{
			if ( numChildren == 0 )
				return;
			
			var obj:DisplayObject;
			
			num = ( num == -1 ) ? numChildren : Math.min( num, numChildren - startIdx );
			startIdx = Math.min( startIdx, numChildren );
			
			while ( num > 0 )
			{
				obj = getChildAt( startIdx );
				
				if ( obj )
				{
					obj[ "kill" ]();
					num--;
				}
			}
			
			obj = null;
		}
		
		/**
		 * Уникальный идентификатор
		 */
		public function get uid():Number { return _uid; }
		public function get uidStr():String { return "0x" + uid.toString( 16 ).toUpperCase(); }
		public function getClassName():String { return getQualifiedClassName( this ).split( ":" ).pop(); }
		public function toString():String { return "[" + getClassName() + " " + uidStr + "]"; }
		public function toStringGeometry():String { return toString() + " x:" + x + ", y:" + y + ", width:" + width + ", height:" + height; }
	}

}