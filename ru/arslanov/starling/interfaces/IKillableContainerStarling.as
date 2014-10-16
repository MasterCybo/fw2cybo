package ru.arslanov.starling.interfaces {
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public interface IKillableContainerStarling extends IKillableStarling {
		
		//function set mouseChildren( value:Boolean ):void;
		
		function killChildren( startIdx:uint = 0, num:int = -1 ):void;
	}
	
}