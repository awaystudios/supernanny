package nu.strafwerk.supernanny.gamecomponents {
	import away3d.materials.TextureMaterial;

	import nu.strafwerk.supernanny.assets.ShareAssets;

	/**
	 * @author admin
	 */
	public class PlaysetEntrance extends GameObject {
		public function PlaysetEntrance(x : Number, z : Number, collisionRadius : Number, collisionName : String, rotationY:Number, debug : Boolean = false) {
			mesh = ShareAssets.instance.getMesh("entrance", true);
			mesh.scale(0.15);

			// physics
			physicsBody = ShareAssets.instance.physicEngine.createCircle(0, 0, collisionRadius, false, collisionName);

			setPostion(x, z);
			mesh.rotationY = rotationY;
			
			TextureMaterial(mesh.material).alphaBlending = true;
		}
	}
}