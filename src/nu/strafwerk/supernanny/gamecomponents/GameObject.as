package nu.strafwerk.supernanny.gamecomponents {
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import away3d.entities.Mesh;
	import away3d.errors.AbstractMethodError;

	/**
	 * @author admin
	 */
	public class GameObject {
		
		private var _mesh:Mesh;
		private var _physicsBody: b2Body;
		
		public function GameObject() {
			super();
		}
		
		public function update():void {
			new AbstractMethodError("Needs to be override");
		}

		public function get mesh() : Mesh {
			return _mesh;
		}

		public function set mesh(mesh : Mesh) : void {
			_mesh = mesh;
		}
		
		public function setSelected(selected:Boolean):void {
			// override
		}

		public function setPostion(x:Number,z:Number):void {
			mesh.x = x;
			mesh.z = z;
			physicsBody.SetPosition(new b2Vec2( mesh.x, - mesh.z));
		}


		public function get physicsBody() : b2Body {
			return _physicsBody;
		}

		public function set physicsBody(physicsBody : b2Body) : void {
			_physicsBody = physicsBody;
		}
	}
}
