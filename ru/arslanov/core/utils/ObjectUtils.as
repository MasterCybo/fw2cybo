package ru.arslanov.core.utils {
	import flash.utils.ByteArray;
	/**
	* ...
	* @author Artem Arslanov
	*/
	public class ObjectUtils {
		
		static public function clone( target:* ):* {
			var bytes:ByteArray = new ByteArray();
			bytes.writeObject( target );
			bytes.position = 0;
			
			return bytes.readObject();
		}
		
	}

}