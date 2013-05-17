package nu.strafwerk.supernanny.gamecomponents {
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.animators.VertexAnimator;

	import nu.strafwerk.supernanny.assets.ShareAssets;

	/**
	 * @author admin
	 */
	public class Bully extends GameObject {
		private var _speedForward : Number = .4;
		private var _vertexAnimator : VertexAnimator;

		private var _bullyMesh:Mesh;
		private var _container:ObjectContainer3D;


		public function Bully(x:Number,z:Number,collisionRadius: Number, collisionName:String, debug : Boolean = false) {
	
			_bullyMesh = ShareAssets.instance.getMesh("bully", true);
			_bullyMesh.scale(0.15);
			_bullyMesh.rotationY = 180;
			_container = new ObjectContainer3D();
			_container.addChild(_bullyMesh);
			
			
			_vertexAnimator = new VertexAnimator(ShareAssets.instance._bullyAnimations);
			_bullyMesh.animator = _vertexAnimator;
			_vertexAnimator.play(ShareAssets.instance._bullyAnimations.animationNames[0], null, 0);

			// physics
			//physicsBody = ShareAssets.instance.physicEngine.createCircle(0, 0, collisionRadius, true, collisionName);
			setPostion(x, z);
		}

		override public function update() : void {
			if (_container.z < -370) {
				_container.z = 370;
			}
			//setPostion(mesh.x, mesh.z + _speedForward);
			_container.moveForward(_speedForward);
		}
		
		
		override public function setPostion(x:Number,z:Number):void {
			_container.x = x;
			_container.z = z;
			// physicsBody.SetPosition(new b2Vec2( mesh.x, - mesh.z));
		}

		public function get container() : ObjectContainer3D {
			return _container;
		}

		public function set container(container : ObjectContainer3D) : void {
			_container = container;
		}
		
		
	}
}