package nu.strafwerk.supernanny.gamecomponents {
	import nu.strafwerk.supernanny.utils.TextureGenerator;
	import away3d.textures.BitmapTexture;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.entities.Mesh;
	/**
	 * @author admin
	 */
	public class Ground extends Mesh {
		public function Ground(width:int,height:int,color:uint = 0xe1e1e1) {
			
			var mat:TextureMaterial = new TextureMaterial(new BitmapTexture(TextureGenerator.checkerBox(1024, 1024, 32,color)),true,true,true);
			mat.repeat = true;
			
			var geometry:PlaneGeometry = new PlaneGeometry(width,height,8,8,true,false);
			//geometry.scaleUV(2, 2);
			super(geometry, mat);
		}
	}
}