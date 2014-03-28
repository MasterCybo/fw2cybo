package ru.arslanov.starling.interfaces {
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public interface IStDisplayObjectContainerKillable extends IStDisplayObjectKillable {
		
		//function set mouseChildren( value:Boolean ):void;
		
		function killChildren( startIdx:uint = 0, num:int = -1 ):void;
	}
	
}