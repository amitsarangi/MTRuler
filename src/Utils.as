package 
{
	import flash.net.SharedObject;
	/**
	 * ...
	 * @author Amit
	 */
	public class Utils
	{
		static var object:SharedObject;
		static var isCaliberated:Boolean;
		static var pixperinch:Number;
		
		{
			object = SharedObject.getLocal("measurementMT");
			if (object.data.ppx == undefined)
			{
				isCaliberated = false;
			}
			else
			{
				isCaliberated = true;
				pixperinch = object.data.ppx;
			}
		}	
		
		public static function getInch(pixel:Number):Number
		{
			return pixel / pixperinch;
		}
		
		public static function setPixPerInch(pixelPerInch:Number):void
		{
			pixperinch = pixelPerInch;
			object.data.ppx = pixelPerInch;
			isCaliberated = true;
		}
		
		public static function getCm(pixel:Number)
		{
			return getInch(pixel) * 2.54;
		}
		
		public static function Caliberated():Boolean
		{
			return isCaliberated;
		}
		
		public static function round(n:Number, d:uint):Number{
			return Math.round(n*d)/d;
		}
	}

}