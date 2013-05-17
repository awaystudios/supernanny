package nu.strafwerk.supernanny.gamecomponents {
	import nu.strafwerk.supernanny.assets.ShareAssets;

	/**
	 * @author admin
	 */
	public class PlaysetCarousel extends GameObject {
		public function PlaysetCarousel(x : Number, z : Number, collisionRadius : Number, collisionName : String, debug : Boolean = false) {
			mesh = ShareAssets.instance.getMesh("carousel", false);
			mesh.scale(0.15);

			// physics
			physicsBody = ShareAssets.instance.physicEngine.createCircle(0, 0, collisionRadius, false, collisionName);

			setPostion(x, z);
		}
	}
}