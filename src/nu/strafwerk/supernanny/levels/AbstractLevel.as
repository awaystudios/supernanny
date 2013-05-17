package nu.strafwerk.supernanny.levels {
	import nu.strafwerk.supernanny.gamecomponents.LinesParticles;
	import away3d.containers.ObjectContainer3D;

	import nu.strafwerk.supernanny.gamecomponents.Playground;

	/**
	 * @author admin
	 */
	public class AbstractLevel extends ObjectContainer3D {
		
		private var _playground : Playground;
		private var _linesParticles:LinesParticles;
		
		public function AbstractLevel() {
			super();
		}
		
		public function update() : void {
		}

		public function get playground() : Playground {
			return _playground;
		}

		public function set playground(playground : Playground) : void {
			_playground = playground;
		}

		public function get linesParticles() : LinesParticles {
			return _linesParticles;
		}

		public function set linesParticles(linesParticles : LinesParticles) : void {
			_linesParticles = linesParticles;
		}

	}
}
