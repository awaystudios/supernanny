package nu.strafwerk.supernanny.utils
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	
	public class UtilBitmap
	{
		/**
		 * Check if value is Power of 2
		 */
		public static function scaleBitmapData(bmd:BitmapData) : BitmapData
		{
			if (!isPowerOfTwo(bmd.width) || !isPowerOfTwo(bmd.height)) {
				var newWidth:Number  = nextBestPowerOfTwo( bmd.width );
				var newHeight:Number = nextBestPowerOfTwo( bmd.height );
				
				var scaleFactorX:Number = newWidth/bmd.width;
				var scaleFactorY:Number = newHeight/bmd.height;
				
				var scaleMatrix:Matrix=new Matrix();
				scaleMatrix.scale(scaleFactorX, scaleFactorY);
				
				var scaledBitmapData:BitmapData = new BitmapData(newWidth, newHeight, true, 0x00000000);
				scaledBitmapData.draw(bmd, scaleMatrix);
				
				bmd =scaledBitmapData;
			}
			return bmd;
		}
		
		/**
		 * Check if value is Power of 2
		 */
		public static function isPowerOfTwo(x:Number) : Boolean 
		{
			return ((x & (x - 1)) === 0);
		}
		
		/**
		 * Returns the next Highest Power of 2
		 */
		public static function nextHighestPowerOfTwo(x:Number) : Number
		{
			--x;
			for (var i:Number = 1; i < 32; i <<= 1) {
				x = x | x >> i;
			}
			return (x + 1);
		}
		
		public static function nextBestPowerOfTwo(x:Number) : Number
		{
			var log2x:Number = Math.log(x) / Math.log(2);
			return Math.pow(2, Math.round(log2x));
		}
	}
}