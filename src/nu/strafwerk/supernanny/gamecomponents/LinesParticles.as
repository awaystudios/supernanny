package nu.strafwerk.supernanny.gamecomponents {
	import away3d.animators.ParticleAnimationSet;
	import away3d.animators.ParticleAnimator;
	import away3d.animators.data.ParticleProperties;
	import away3d.animators.nodes.ParticleBillboardNode;
	import away3d.animators.nodes.ParticleFollowNode;
	import away3d.core.base.Geometry;
	import away3d.core.base.Object3D;
	import away3d.core.base.ParticleGeometry;
	import away3d.entities.Mesh;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.textures.ATFTexture;
	import away3d.tools.helpers.ParticleGeometryHelper;

	import nu.strafwerk.supernanny.assets.ShareAssets;

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
		
		//private var visibles:Vector.<Vector3D> = new Vector.<Vector3D>;
		//private var visibleState:ParticleVisibleState;
		
		private var _currentTime:Number = 0;
		
		private var _totalParticles : int = 500;
		
		//private var particleTransforms:Vector.<ParticleGeometryTransform> = new Vector.<ParticleGeometryTransform>;
		
		private var _drawPoints:Vector.<Number>;

		public function LinesParticles() {
			_drawPoints = new Vector.<Number>();
			//_view = view;
			initMaterials();
			initParticles();
			initObjects();
		}

		private function initMaterials() : void {
			// setup particle material
			//particleMaterial = new TextureMaterial(new ATFTexture(new ParticleTexture()));
			particleMaterial = new TextureMaterial(new ATFTexture(new ShareAssets.instance.TextureFootstep1()));
			
			particleMaterial.alphaBlending = true;
			//particleMaterial.blendMode = BlendMode.MULTIPLY;//NORMAL;// ADD;
		}

		/**
		 * Initialise the particles
		 */
		private function initParticles() : void {
			// setup the base geometry for one particle
			var plane : Geometry = new PlaneGeometry(16, 16, 1, 1, false);

			// create the particle geometry
			var geometrySet : Vector.<Geometry> = new Vector.<Geometry>();
			//var setTransforms : Vector.<ParticleGeometryTransform> = new Vector.<ParticleGeometryTransform>();
			//var particleTransform : ParticleGeometryTransform;
			//var uvTransform : Matrix;
			for (var i : int = 0; i < _totalParticles; i++) {
				geometrySet.push(plane);
				/*
				particleTransform = new ParticleGeometryTransform();
				
				//uvTransform = new Matrix();
				//uvTransform.scale(0.5, 0.5);
				// uvTransform.translate(int(Math.random() * 2) / 2, int(Math.random() * 2) / 2);
				//uvTransform.translate(0, 0);
				//TODO: turn on when using textureatlas
				//particleTransform.UVTransform = uvTransform;
				//setTransforms.push(particleTransform);
				
				var x:Number =0;
				var z:Number=0;
				
				visibles.push(new Vector3D(1, 1, 1));
				
				//particleTransform.vertexTransform = new Matrix3D(Vector.<Number>([1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, x, 0, z, 1]));
				particleTransform.vertexTransform = new Matrix3D(Vector.<Number>([1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, x, 0, z, 1]));
				particleTransforms.push(particleTransform);
				*/
				
			}

			particleGeometry = ParticleGeometryHelper.generateGeometry(geometrySet, null);
			//particleGeometry = ParticleGeometryHelper.generateGeometry(geometrySet, particleTransforms);

			// create the particle animation set
			particleAnimationSet = new ParticleAnimationSet(true, false, false);
			
			// smooth fixed first missing somehow, bug ?
			particleAnimationSet.addAnimation(particleFollowNode = new ParticleFollowNode(true, false,true));
			
			particleAnimationSet.addAnimation(new ParticleBillboardNode());
			// define the particle animations and init function
			particleAnimationSet.initParticleFunc = initParticleProperties;
			
			
		}

		/**
		 * Initialise the scene objects
		 */
		private function initObjects() : void {
			// create follow targets
			followTarget1 = new Object3D();
			

			// create the particle meshes
			_particleMesh1 = new Mesh(particleGeometry, particleMaterial);
			_particleMesh1.y = 5;
			//_view.scene.addChild(particleMesh1);

			// create and start the particle animators
			animator1 = new ParticleAnimator(particleAnimationSet);
			animator1.autoUpdate = false;
			//animator1.update(-1*1000);
			
			
			_particleMesh1.animator = animator1;
			particleFollowNode.getAnimationState(animator1).followTarget = followTarget1;
			
			animator1.update(-1*1000);
			
			//visibleState = animator1.getAnimationStateByName(ParticleNodeBase.getParticleNodeName(ParticleVisibleNode, ParticlePropertiesMode.LOCAL_DYNAMIC)) as ParticleVisibleState;
			//visibleState.setVisibles(visibles);

		}

		/**
		 * Initialiser function for particle properties
		 */
		private function initParticleProperties(properties : ParticleProperties) : void {
			//properties.
			properties.startTime = properties.index+1;
			properties.duration = _totalParticles+3;
		}

		/**
		 * Mouse down listener for navigation
		 */
		public function start(xPos:Number, zPos:Number) : void {
			_drawPoints = new Vector.<Number>();
			_currentTime=-1;
			//animator1.update(_currentTime*1000);
		}

		public function move(xPos:Number, zPos:Number) : void {
			_drawPoints.push(xPos);
			_drawPoints.push(zPos);
		}

		public function updateDrawPoint():void {
			var lengthDrawPoints:int = _drawPoints.length*0.5;
			
			if (_currentTime+1<lengthDrawPoints) {
				_currentTime+=1;
				positionTarget(_drawPoints[_currentTime*2],_drawPoints[((_currentTime*2)+1)]);
				animator1.update((_currentTime)*1000);
			}
			
			//visibleState.setVisibles(visibles);
		}

		private function positionTarget(xPos:Number, zPos:Number):void {
			followTarget1.x = xPos;
			followTarget1.z = zPos;
			followTarget1.y = 0;
		}

		public function stop() : void {
			
			//_currentTime=-1;
			//animator1.update(_currentTime);
			
//			var index:int=int(Math.random() * visibles.length);
//			visibles[index].x = 0;
//			visibles[index].y = 0;
//			visibles[index].z = 0;
			//visibleState.setVisibles(visibles);
			
		}


		public function get particleMesh1() : Mesh {
			return _particleMesh1;
		}

		public function set particleMesh1(particleMesh1 : Mesh) : void {
			this._particleMesh1 = particleMesh1;
		}

	}
}