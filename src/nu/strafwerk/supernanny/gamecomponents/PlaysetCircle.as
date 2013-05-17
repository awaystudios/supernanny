package nu.strafwerk.supernanny.gamecomponents {
	import away3d.entities.Mesh;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;

	import nu.strafwerk.supernanny.assets.ShareAssets;

	/**
	 * @author admin
	 */
	public class PlaysetCircle extends GameObject {
		
		private var _materialNormal:TextureMaterial;
		private var _materialActive:TextureMaterial;
		
		public function PlaysetCircle(x : Number, z : Number, collisionRadius : Number, collisionName : String, debug : Boolean = false) {
			mesh = new Mesh(new PlaneGeometry(collisionRadius*2,collisionRadius*2,1,1,true,false));
			
			_materialNormal = ShareAssets.instance.materialPlaysetCircleNormal;
			_materialActive = ShareAssets.instance.materialPlaysetCircleActive;
			setSkin(false);
			
			setPostion(x, z);
		}
		
		public function setSkin(active:Boolean):void {
			if (active) {
				mesh.material = _materialActive;
				TextureMaterial(mesh.material).alphaBlending = true; 
			}
			else {
				mesh.material = _materialNormal;
				TextureMaterial(mesh.material).alphaBlending = true;
			}
		}
		
		override public function setPostion(x:Number,z:Number):void {
			mesh.x = x;
			mesh.z = z;
		}
		
	}
}