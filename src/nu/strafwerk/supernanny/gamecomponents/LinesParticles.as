package nu.strafwerk.supernanny.gamecomponents {
	import away3d.animators.nodes.ParticleNodeBase;
	import away3d.animators.nodes.ParticleVisibleNode;
	import flash.display.BlendMode;
	import away3d.animators.states.ParticleVisibleState;
	import away3d.animators.ParticleAnimationSet;
	import away3d.animators.ParticleAnimator;
	import away3d.animators.data.ParticleProperties;
	import away3d.animators.data.ParticlePropertiesMode;
	import away3d.animators.nodes.ParticleBillboardNode;
	import away3d.animators.nodes.ParticleColorNode;
	import away3d.animators.nodes.ParticleFollowNode;
	import away3d.animators.nodes.ParticleVelocityNode;
	import away3d.containers.View3D;
	import away3d.core.base.Geometry;
	import away3d.core.base.Object3D;
	import away3d.core.base.ParticleGeometry;
	import away3d.entities.Mesh;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.tools.helpers.ParticleGeometryHelper;
	import away3d.tools.helpers.data.ParticleGeometryTransform;
	import away3d.utils.Cast;

	import nu.strafwerk.supernanny.assets.ShareAssets;

	import flash.geom.ColorTransform;
	import flash.geom.Vector3D;

	/**
	 * @author admin
	 */
	public class LinesParticles {
		private var particleMaterial : TextureMaterial;
		private var particleAnimationSet : ParticleAnimationSet;
		private var particleFollowNode : ParticleFollowNode;
		private var particleGeometry : ParticleGeometry;
		private var followTarget1 : Object3D;
		private var _particleMesh1 : Mesh;
		private var animator1 : ParticleAnimator;
		
		private var visibles:Vector.<Vector3D> = new Vector.<Vector3D>;
		private var visibleState:ParticleVisibleState;
		
		
		private var _time:uint = 0;
		
		private var _totalParticles : int = 1000;
		private var _view : View3D;
		[Embed(source="../../../../../embeds/textures/cards_suit.atf", mimeType="application/octet-stream")]
		private const ParticleTexture : Class;
		
		[Embed(source="../../../../../embeds/textures/footstep1.png")]
		private var FootstepTexture : Class;
		
		

		public function LinesParticles() {
			_view = ShareAssets.instance.view;
			initMaterials();
			initParticles();
			initObjects();
		}

		private function initMaterials() : void {
			// setup particle material
			//particleMaterial = new TextureMaterial(new ATFTexture(new ParticleTexture()));
			particleMaterial = new TextureMaterial(Cast.bitmapTexture(FootstepTexture));
			particleMaterial.alphaBlending = true;
			//particleMaterial.blendMode = BlendMode.ADD;
		}

		/**
		 * Initialise the particles
		 */
		private function initParticles() : void {
			// setup the base geometry for one particle
			var plane : Geometry = new PlaneGeometry(16, 16, 1, 1, false);

			// create the particle geometry
			var geometrySet : Vector.<Geometry> = new Vector.<Geometry>();
			var setTransforms : Vector.<ParticleGeometryTransform> = new Vector.<ParticleGeometryTransform>();
			var particleTransform : ParticleGeometryTransform;
			//var uvTransform : Matrix;
			for (var i : int = 0; i < _totalParticles; i++) {
				geometrySet.push(plane);
				particleTransform = new ParticleGeometryTransform();
				
				//uvTransform = new Matrix();
				//uvTransform.scale(0.5, 0.5);
				// uvTransform.translate(int(Math.random() * 2) / 2, int(Math.random() * 2) / 2);
				//uvTransform.translate(0, 0);
				//TODO: turn on when using textureatlas
				//particleTransform.UVTransform = uvTransform;
				
				//setTransforms.push(particleTransform);
				
				visibles.push(new Vector3D(1, 1, 1));
			}

			particleGeometry = ParticleGeometryHelper.generateGeometry(geometrySet, null);// setTransforms);

			// create the particle animation set
			particleAnimationSet = new ParticleAnimationSet(true, true, true);

			// define the particle animations and init function
			particleAnimationSet.addAnimation(new ParticleBillboardNode());
			//particleAnimationSet.addAnimation(new ParticleVelocityNode(ParticlePropertiesMode.LOCAL_STATIC));
//			particleAnimationSet.addAnimation(new ParticleColorNode(ParticlePropertiesMode.GLOBAL, true, false, false, false, new ColorTransform(1, 1, 1, 0.4), new ColorTransform(1, 1, 1, 0)));
			particleAnimationSet.addAnimation(particleFollowNode = new ParticleFollowNode(true, false));
			
			particleAnimationSet.addAnimation(new ParticleVisibleNode());
			
			particleAnimationSet.initParticleFunc = initParticleProperties;
			
			
		}

		/**
		 * Initialise the scene objects
		 */
		private function initObjects() : void {
			// create wireframe axes
			// scene.addChild(new WireframeAxesGrid(10,1500));

			// create follow targets
			followTarget1 = new Object3D();
			followTarget1.y = -100;

			// followTarget2 = new Object3D();

			// create the particle meshes
			particleMesh1 = new Mesh(particleGeometry, particleMaterial);
			particleMesh1.y = 0;
			_view.scene.addChild(particleMesh1);

			// particleMesh2 = particleMesh1.clone() as Mesh;
			// particleMesh2.y = 300;
			// scene.addChild(particleMesh2);

			// create and start the particle animators
			animator1 = new ParticleAnimator(particleAnimationSet);
			particleMesh1.animator = animator1;

			particleFollowNode.getAnimationState(animator1).followTarget = followTarget1;

			// animator2 = new ParticleAnimator(particleAnimationSet);
			// particleMesh2.animator = animator2;
			// animator2.start();
			// particleFollowNode.getAnimationState(animator2).followTarget = followTarget2;

			visibleState = animator1.getAnimationStateByName(ParticleNodeBase.getParticleNodeName(ParticleVisibleNode, ParticlePropertiesMode.LOCAL_DYNAMIC)) as ParticleVisibleState;
			visibleState.setVisibles(visibles);

		}

		/**
		 * Initialiser function for particle properties
		 */
		private function initParticleProperties(properties : ParticleProperties) : void {
			
			
			//properties.startTime = Math.random() * 10.1;
			
			properties.startTime = properties.index; 
			
			properties.duration = 1000;
			// properties[ParticleVelocityNode.VELOCITY_VECTOR3D] = new Vector3D(Math.random() * 100 - 50, Math.random() * 100 - 200, Math.random() * 100 - 50);
			// properties[ParticleVelocityNode.VELOCITY_VECTOR3D] = new Vector3D(Math.random() * 100 - 50, -10, Math.random() * 100 - 50);
			// properties[ParticleVelocityNode.VELOCITY_VECTOR3D] = new Vector3D(Math.random() * 10 - 5, Math.random() * 10 - 5, Math.random() * 10 - 5);
			
			//properties[ParticleVelocityNode.VELOCITY_VECTOR3D] = new Vector3D(Math.random() * 4 - 2, 0, Math.random() * 4 - 2);
			
			properties[ParticleVelocityNode.VELOCITY_VECTOR3D] = new Vector3D(0,0,0);
			
			// properties[ParticleVelocityNode.VELOCITY_VECTOR3D] = new Vector3D(0,0,0);
		}

		/**
		 * Mouse down listener for navigation
		 */
		public function start(xPos:Number, zPos:Number) : void {
			
			//animator1.start();
			
			//animator1.update(time);
			
			followTarget1.x = xPos;
			// event.scenePosition.x; // stage.mouseX;//lastMouseX;// Math.cos(angle) * 500;
			followTarget1.z = zPos;
			// event.scenePosition.z;//lastMouseY;//Math.sin(angle) * 500;
			followTarget1.y = 0;
			// _plane.addEventListener(MouseEvent3D.MOUSE_MOVE, onPlaneMove);
			// _plane.addEventListener(MouseEvent3D.MOUSE_UP, onPlaneUp);
			// _plane.addEventListener(MouseEvent3D.MOUSE_OUT, onPlaneUp);
			
			// 5, x:ev.scenePosition.x, z:ev.scenePosition.z, _bezier:{x:_cube.x, z:ev.scenePosition.z} });
		}

		public function stop() : void {
			//animator1.update(-10);
			followTarget1.y = -100;
			
			
//			var index:int=int(Math.random() * visibles.length);
//			visibles[index].x = 0;
//			visibles[index].y = 0;
//			visibles[index].z = 0;
			visibles[0].x = 0;
			visibles[0].y = 0;
			visibles[0].z = 0;
			visibles[1].x = 0;
			visibles[1].y = 0;
			visibles[1].z = 0;
			
			visibleState.setVisibles(visibles);
			
		}

		public function move(xPos:Number, zPos:Number) : void {
			
			followTarget1.x = xPos;
			followTarget1.z = zPos;
			followTarget1.y = 0;
			
			animator1.update(_time*1000);
			
			_time+=1;
		}

		public function get particleMesh1() : Mesh {
			return _particleMesh1;
		}

		public function set particleMesh1(particleMesh1 : Mesh) : void {
			this._particleMesh1 = particleMesh1;
		}
	}
}
