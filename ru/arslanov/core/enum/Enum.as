package ru.arslanov.core.enum
{
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Перечисляемый тип - базовый класс
	 * @author Artem Arslanov
	 */
	public class Enum
	{
		
		public var value:* = null;
		
		public function Enum( val:* = null )
		{
			value = val;
		}
		
		/***************************************************************************
		   Static methods
		 ***************************************************************************/
		static public function getElementByValue( value:*, enumClass:Class ):Enum
		{
			if ( !value )
				throw new ArgumentError( 'Argument value:* is null!' );
			if ( !enumClass )
				throw new ArgumentError( 'Argument enumClass:Class is null!' );
			
			var item:Enum;
			var vect:Vector.<Enum> = getElementsList( enumClass );
			
			for each ( item in vect )
			{
				if ( item.value == value )
					break;
				item = null;
			}
			
			return item;
		}
		
		static public function getElementsList( enumClass:Class ):Vector.<Enum>
		{
			if ( !enumClass )
				throw new ArgumentError( 'Argument is null!' );
			
			var node:XML;
			var elements:Vector.<Enum> = new Vector.<Enum>();
			var constNodes:XMLList = describeType( enumClass ).constant;
			
			for each ( node in constNodes )
			{
				elements.push( enumClass[ node.attribute( "name" ) ] );
			}
			
			return elements;
		}
		
		protected function getClassName():String
		{
			return getQualifiedClassName( this ).split( ":" ).pop();
		}
		
		public function toString():String {
			return "[" + getClassName() + " " + value + "]";
		}
	}

}
