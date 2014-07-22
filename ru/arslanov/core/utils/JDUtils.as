package ru.arslanov.core.utils {
	
	/**
	 * Класс для работы с Юлианским календарём. Формула справедлива для дат после 23 ноября −4713 г.
	 * @author Artem Arslanov
	 */
	public class JDUtils {
		
		static public const MIN_YEAR:int = -4713; // 
		static public const DAYS_PER_YEAR:Number = 365.25; // Среднее количество дней в Юлианском году
		static public const DAYS_PER_MONTH:Number = 30.4375; // Среднее количество дней в месяце 365.25/12
		static public const WEEKS_PER_MONTH:Number = 4.34821428571428571429; // Среднее количество недель в месяце 30.4375/7
		
		static public var weekdaysLocale:Array = [ "Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье" ];
		static public var monthsLocale:Array = [ "Января", "Февраля", "Марта", "Апреля", "Мая", "Июня", "Июля", "Августа", "Сентября", "Октября", "Ноября", "Декабря" ];
		
		//static private var _cachedDateJD:Object = {};
		//static private var _cachedDateJDN:Object = {};
		
		/**
		 * Григорианская дата по номеру Юлианского дня
		 * @param	jdn
		 * @return	Object { year:Number, month:Number, date:Number, weekday:Number }
		 */
		static public function JDNToDate( jdn:Number ):Object {
			jdn += 0.5;
			jdn = Math.floor( jdn );
			var a:Number = jdn + 32044;
			var b:Number = Math.floor( (4 * a + 3) / 146097 );
			var c:Number = a - Math.floor( 146097 * b / 4 );
			var d:Number = Math.floor( (4 * c + 3) / 1461 );
			var e:Number = c - Math.floor( 1461 * d / 4 );
			var m:Number = Math.floor( (5 * e + 2) / 153 );
			
			var date:Number = e - Math.floor( (153 * m + 2) / 5 ) + 1;
			var month:Number = m + 3 - 12 * Math.floor(m / 10);
			var year:Number = 100 * b + d - 4800 + Math.floor(m / 10);
			
			var weekday:uint = ( Math.floor( jdn + 0.5 ) + 1 ) % 7; // 0-воскресенье, 1-понедельник, 2-вторник и т.д.
			
			//_cachedDateJDN.year = year;
			//_cachedDateJDN.month = month;
			//_cachedDateJDN.date = date;
			//_cachedDateJDN.weekday = weekday;
			
			//return _cachedDateJDN;
			
			return { year:year, month:month, date:date, weekday:weekday };
		}
		
		/**
		 * Номер Юлианского дня (Julian Day Number), который начинается в полдень числа, для которого производятся вычисления
		 * @param	year
		 * @param	month - от 1 до 12. 1 - январь, 2 - февраль и т.д.
		 * @param	date
		 * @return	JDN:Number
		 */
		static public function dateToJDN( year:int, month:uint = 0, date:uint = 0 ):Number {
			if ( year == 0 ) year = 1; // Нулевого года не существует, сразу после 1 г. до н.э. идёт 1 г. н.э.
			if ( month < 1 ) month = 1; // Исправляем нулевой месяц
			if (date < 1) date = 1; // Исправляем нулевое число
			
			var a:Number = Math.floor(( 14 - month ) / 12 );
			var y:Number = year + 4800 - a;
			var m:Number = month + ( 12 * a ) - 3;
			
			var jdn:Number = date + Math.floor((( 153 * m ) + 2 ) / 5 ) + ( 365 * y ) + Math.floor( y / 4 ) - Math.floor( y / 100 ) + Math.floor( y / 400 ) - 32045;
			
			
			// Метод взят с сайта http://deep125.narod.ru/astra_calc/p4.htm
			/*if ( month <= 2 ) {
				year -= 1;
				month += 12;
			}
			
			var b:Number = 0;
			//Если наша дата позднее 15 октября 1582 г
			if ( (year > 1582) || ( (year == 1582) && (month > 10) ) || ( (year == 1582) && (month == 10) && (date > 15) ) ) {
				var a:Number = Math.floor( year / 100.0 );
				b = 2 - a + Math.floor( a / 4.0 );
			}
			
			var c:Number = Math.floor( 365.25 * year );
			var d:Number = Math.floor( 30.6001 * ( month + 1 ) );
			
			var jdn:Number = b + c + d + date + 1720994.5;
			*/
			return jdn;
		}
		
		/**
		 * Юлианская дата, содержащая дробную часть
		 * @param	year
		 * @param	month
		 * @param	date
		 * @param	hours
		 * @param	minutes
		 * @param	seconds
		 * @return	JD:Number
		 */
		static public function dateToJD( year:int, month:uint = 0, date:uint = 0, hours:uint = 12, minutes:uint = 0, seconds:uint = 0 ):Number {
			var jd:Number = dateToJDN( year, month, date ) + (( hours - 12 ) / 24 ) + ( minutes / 1440 ) + ( seconds / 86400 );
			
			return jd;
		}
		
		/**
		 * Полная Григорианская дата через Юлианскую дату
		 * @param	jd - Юлианская дата, содержащая дробную часть
		 * @return	Object { year:Number, month:Number, date:Number, weekday:Number, hours:hours, minutes:minutes, seconds:seconds }
		 */
		static public function JDToDate( jd:Number ):Object {
			var a:Number = jd + 32044 - 0.5;
			var b:Number = int(( 4 * a + 3 ) / 146097 );
			var c:Number = a - int( 146097 * b / 4 );
			var d:Number = int(( 4 * c + 3 ) / 1461 );
			var e:Number = c - int( 1461 * d / 4 );
			var m:Number = int(( 5 * e + 2 ) / 153 );
			
			var date:Number = int( e - ( 153 * m + 2 ) / 5 + 1 );
			
//			Log.traceText( "1 date : " + date );

//			date = uint( date );

//			Log.traceText( "\t2 date : " + date );
			
			var month:Number = m + 3 - 12 * int( m / 10 );
			var year:Number = 100 * b + d - 4800 + int( m / 10 );
			
			var jd2:Number = jd + 0.5;
			var time:Number = jd2 % int( jd2 );
			
			//Log.traceText( "time : " + time );
			
			var hours:uint = time * 24;
			var minutes:uint = (time * 1440) % 60;
			var seconds:uint = (time * 86400) % 60;
			
			var weekday:uint = ( int( jd + 0.5 ) + 1 ) % 7; // 0-воскресенье, 1-понедельник, 2-вторник и т.д.
			
			//_cachedDateJD.year = year;
			//_cachedDateJD.month = month;
			//_cachedDateJD.date = date;
			//_cachedDateJD.weekday = weekday;
			//_cachedDateJD.hours = hours;
			//_cachedDateJD.minutes = minutes;
			//_cachedDateJD.seconds = seconds;
			
			//return _cachedDateJD;
			
			return { year:year, month:month, date:date, weekday:weekday, hours:hours, minutes:minutes, seconds:seconds };
		}
		
		static public function getNameMonth( numMonth:uint ):String {
			//trace( "*execute* DateUtils.getNameMonth" );
			//trace( "num : " + num );
			return monthsLocale[ Math.max( 0, numMonth - 1 ) ];
		}
		
		static public function getNameWeekday( num:uint ):String {
			return weekdaysLocale[( 6 + num ) % 7 ];
		}
		
		/**
		* Форматирование даты
		* @param jd
		* @param formatString - шаблон строки {0}-год, {1}-месяц, {2}-число, {3}-день недели, {4}-час, {5}-минута
		* @return
		*/
		static public function getFormatString( jd:Number, formatString:String = "{2} {1} {0}, {4}:{5}" ):String { // –
			var date:Object = JDToDate( jd );
			
			var str:String = "";
			
			if ( formatString && formatString != "" ) {
				str = StringUtils.substitute( formatString
						, date.year // {0}
						, getNameMonth( date.month ) // {1}
						, StringUtils.numberToString( date.date ) // {2}
						, getNameWeekday(date.weekday) // {3}
						, StringUtils.numberToString( date.hours ) // {4}
						, StringUtils.numberToString( date.minutes ) ); // {5}
			} else {
				str = "" + jd;
			}
			
			return str;
		}
		
		/**
		* Разница между двумя юлианскими датами в ЮЛИАНСКИХ ДНЯХ
		* @param jd1
		* @param jd2
		* @return
		*/
		static public function diffDays( jd1:Number, jd2:Number ):Number {
			return jd2 - jd1;
		}
		
		/**
		* Разница между двумя юлианскими датами в ГОДАХ
		* @param jd1
		* @param jd2
		* @return
		*/
		static public function diffYears( jd1:Number, jd2:Number ):Number {
			return ( jd2 - jd1 ) / 365.25;
		}
	}

}