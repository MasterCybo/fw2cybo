package ru.arslanov.flash.interfaces {
	import ru.arslanov.core.events.EventManager;
	
	/**
	 * ...
	 * @author Artem Arslanov
	 */
	public interface IKillableInteractive extends IKillable {
		function get eventManager():EventManager;
		function set mouseEnabled( value:Boolean ):void;
	}
	
}