package nu.strafwerk.supernanny.gamecomponents {
	import away3d.materials.TextureMaterial;

	import nu.strafwerk.supernanny.assets.ShareAssets;

	/**
	 * @author admin
	 */
	public class PlaysetTunnel extends GameObject {
		public function PlaysetTunnel(x : Number, z : Number, collisionRadius : Number, collisionName : String, debug : Boolean = false) {
			mesh = ShareAssets.instance.getMesh("tunnel", false);
			mesh.scale(0.15);

			TextureMaterial(mesh.material).bothSides = true;

			// physics
			physicsBody = ShareAssets.instance.physicEngine.createCircle(0, 0, collisionRadius, false, collisionName);
			
			setPostion(x, z);
		}
	}
}