package nu.strafwerk.supernanny.gamecomponents {
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;

	import away3d.animators.VertexAnimator;
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;

	import nu.strafwerk.supernanny.assets.ShareAssets;

	import flash.geom.Point;
	import flash.geom.Vector3D;

	/**
	 * @author admin
	 */
	public class Toddler extends GameObject {
		private var _speedForward : Number = 0.5;
		private var _toddlerMesh : Mesh;
		private var _container : ObjectContainer3D;
		private var _vertexAnimator : VertexAnimator;
		private var _physicsBodySensor : b2Body;
		private const MOVEMENT_PATH : int = 0;
		private const MOVEMENT_AUTO : int = 1;
		private const MOVEMENT_NONE : int = 2;
		private const ANIMATION_WALK : int = 2;
		private const ANIMATION_SIT : int = 0;
		private var _currentMovement : int;
		private var _currentAnimation : int = -1;
		private var _isSelected : Boolean = false;
		private var _userPath : Vector.<Point>;
		private var _lookAt : Vector3D = new Vector3D();
		private var _distance : Number = 0;
		// TODO: change this since only one character can be selected
		private var _toddlerMeshSelected : Mesh;
		private var _targetPointUserPath : int = -1;

		public function Toddler(x : Number, z : Number, collisionRadius : Number, collisionName : String, gameobjectId : int, skin : int = 0, debug : Boolean = false) {
			_userPath = new Vector.<Point>();

			_currentMovement = MOVEMENT_AUTO;

			// setup meshes and container
			_toddlerMesh = ShareAssets.instance.getMesh("toddler", true);
			_toddlerMesh.scale(0.15);
			_toddlerMesh.rotationY = 180;
			_container = new ObjectContainer3D();
			_container.addChild(_toddlerMesh);

			// mesh when the toddler is selected
			_toddlerMeshSelected = new Mesh(new PlaneGeometry(64, 64, 1, 1, true, false));
			_toddlerMeshSelected.material = ShareAssets.instance.materialToddlerSelected;
			TextureMaterial(_toddlerMeshSelected.material).alphaBlending = true;

			// setup material
			if (skin == 0) {
				_toddlerMesh.material = ShareAssets.instance.materialToddlerBoy;
			} else {
				_toddlerMesh.material = ShareAssets.instance.materialToddlerGirl;
			}

			// animation
			_vertexAnimator = new VertexAnimator(ShareAssets.instance._toddlerAnimations);
			_toddlerMesh.animator = _vertexAnimator;
			// _vertexAnimator.play(ShareAssets.instance._toddlerAnimations.animationNames[2], null, Math.random()*1000);

			// physics toddler
			physicsBody = ShareAssets.instance.physicEngine.createCircle(0, 0, collisionRadius, true, collisionName, gameobjectId);
			_physicsBodySensor = ShareAssets.instance.physicEngine.createCircle(0, 0, 36, true, "sensor" + collisionName, gameobjectId, true);

			_container.x = x;
			_container.z = z;
			setPostion(x, z);
		}

		public function playAnimation(animationNr : int) : void {
			if (_currentAnimation != animationNr) {
				_vertexAnimator.play(ShareAssets.instance._toddlerAnimations.animationNames[animationNr], null, Math.random() * 1000);
				_currentAnimation = animationNr;
			}
		}

		public function turnToddler() : void {
			trace("turnToddler");

			_container.rotationY = _container.rotationY + 180 + (-5 + Math.random() * 10);
			_currentMovement = MOVEMENT_AUTO;
		}

		override public function setSelected(selected : Boolean) : void {
			if (selected) {
				_currentMovement = MOVEMENT_NONE;
				_container.addChild(_toddlerMeshSelected);
				_isSelected = true;
			} else {
				if (_isSelected) {
					if (_container.contains(_toddlerMeshSelected)) {
						_container.removeChild(_toddlerMeshSelected);
					}
					_currentMovement = MOVEMENT_PATH;
					_isSelected = false;
				}
			}
		}

		override public function update() : void {
			switch (_currentMovement) {
				case MOVEMENT_AUTO: {
					
					// check out of bounds left -350, right 350, top 370, bottom -370
					if (_container.z > 370 || _container.z < -370 || _container.x < -350 || _container.x > 350) {
						turnToddler();
					}
					
					_container.moveForward(_speedForward);
					playAnimation(ANIMATION_WALK);
					break;
				}
				case MOVEMENT_NONE: {
					playAnimation(ANIMATION_SIT);
					break;
				}
				case MOVEMENT_PATH: {
					playAnimation(ANIMATION_WALK);
					moveOverUserPath();
					break;
				}
			}

			setPostion(_container.x, _container.z);
		}

		public function startRecordingUserPath() : void {
			_userPath = new Vector.<Point>();
			_targetPointUserPath = 0;
		}

		private function moveOverUserPath() : void {
			var userPathLength : int = userPath.length;
			if (userPathLength > _targetPointUserPath) {
				// look at current target point
				_lookAt.x = userPath[_targetPointUserPath].x;
				_lookAt.y = 0;
				_lookAt.z = userPath[_targetPointUserPath].y;

				_container.lookAt(_lookAt);
				_container.moveForward(_speedForward);

				_distance = ShareAssets.instance.distanceTwoPoints(_userPath[_targetPointUserPath].x, _container.x, _userPath[_targetPointUserPath].y, _container.z);
				if (_distance < 2) {
					_targetPointUserPath += 1;
				}
			} else {
				_currentMovement = MOVEMENT_AUTO;
			}
		}

		override public function setPostion(x : Number, z : Number) : void {
			physicsBody.SetPosition(new b2Vec2(x, -z));

			_physicsBodySensor.SetPosition(new b2Vec2(x, -z));
		}

		public function get container() : ObjectContainer3D {
			return _container;
		}

		public function set container(container : ObjectContainer3D) : void {
			_container = container;
		}

		public function get userPath() : Vector.<Point> {
			return _userPath;
		}

		public function set userPath(userPath : Vector.<Point>) : void {
			_userPath = userPath;
		}

		public function get currentMovement() : int {
			return _currentMovement;
		}

		public function set currentMovement(currentMovement : int) : void {
			_currentMovement = currentMovement;
		}
	}
}

/*
public function setSkin(row:int,col:int):void {
	var totalRows:int = 2;
	var totalCols:int = 2;
	mesh.geometry.scaleUV(1/totalRows,1/totalCols);
	mesh.subMeshes[0].offsetU = 1/totalRows * row;
	mesh.subMeshes[0].offsetV = 1/totalCols * col;
}
 * 
 */