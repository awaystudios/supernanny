package nu.strafwerk.supernanny.utils
{
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.display.BitmapData;


	public class TextureGenerator
	{
		/**
		 * Create a checkerbox
		 * @param widthBmd Width of the return bitmapdata
		 * @param heightBmd Height of the return bitmapdata
		 * @param sizeSquare Width and Height checker
		 * @param colorSquare1 First color of a square
		 * @param colorSquare2 Second color of a square
		 * @return returnBmd Bitmapdata
		 */

		public static function checkerBox(widthBmd : int, heightBmd : int, sizeSquare : int, colorSquare1:uint=0x000000,colorSquare2:uint=0xffffff) : BitmapData
		{
			var returnBmd:BitmapData = new BitmapData(widthBmd, heightBmd,false,0xFF0000);

			// number of squares horizontally
			var rows : int = widthBmd / sizeSquare;
			// number of squares vertically
			var cols : int = heightBmd / sizeSquare;
			trace(rows,cols);
			var square1:BitmapData = new BitmapData(sizeSquare,sizeSquare,false,colorSquare1);
			var square2:BitmapData = new BitmapData(sizeSquare,sizeSquare,false,colorSquare2);

			var destPoint:Point = new Point();
			var srcRect:Rectangle = new Rectangle(0,0,sizeSquare,sizeSquare);
			var srcBmd:BitmapData = square1;

			// loop cols
			for (var i:int=0;i < cols;i++) {
				// loop rows
				for (var j:int=0; j < rows; j++) {
					destPoint.x = j*sizeSquare;
					destPoint.y = i*sizeSquare;
					returnBmd.copyPixels(srcBmd, srcRect, destPoint);
					srcBmd = (srcBmd==square1) ? square2 : square1;
				}
				srcBmd = (srcBmd==square1) ? square2 : square1;
			}
			return returnBmd;
		}
		
	}
}