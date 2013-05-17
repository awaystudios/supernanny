package nu.strafwerk.supernanny.gamecomponents {
	import away3d.entities.Mesh;

	import nu.strafwerk.supernanny.assets.ShareAssets;

	/**
	 * @author admin
	 */
	public class Playground {
		private var _mesh : Mesh;

		public function Playground(debug : Boolean = false) {
			_mesh = ShareAssets.instance.getMesh("Playground", false);
			_mesh.scaleX = 0.19;
			_mesh.scaleZ = 0.19;
			_mesh.y = -1;
		}

		public function get mesh() : Mesh {
			return _mesh;
		}

		public function set mesh(mesh : Mesh) : void {
			_mesh = mesh;
		}
	}
}