package nu.strafwerk.supernanny.levels {
	import nu.strafwerk.supernanny.gamecomponents.LinesParticles;
	import away3d.containers.Scene3D;

	import nu.strafwerk.supernanny.assets.ShareAssets;
	import nu.strafwerk.supernanny.gamecomponents.Playground;
	import nu.strafwerk.supernanny.gamecomponents.PlaysetCarousel;
	import nu.strafwerk.supernanny.gamecomponents.PlaysetCircle;
	import nu.strafwerk.supernanny.gamecomponents.PlaysetEntrance;
	import nu.strafwerk.supernanny.gamecomponents.PlaysetRopeBridge;
	import nu.strafwerk.supernanny.gamecomponents.PlaysetSlide;
	import nu.strafwerk.supernanny.gamecomponents.PlaysetSwing;
	import nu.strafwerk.supernanny.gamecomponents.PlaysetTunnel;
	import nu.strafwerk.supernanny.gamecomponents.TreeThick;
	import nu.strafwerk.supernanny.gamecomponents.TreeThin;
	import nu.strafwerk.supernanny.gamecomponents.physics.PhysicEngine;

	/**
	 * @author admin
	 */
	public class Level1 extends AbstractLevel {
		
		private var _scene:Scene3D;

		private var _playsetCarousel : PlaysetCarousel;
		private var _playsetSwing : PlaysetSwing;
		private var _playsetTunnel : PlaysetTunnel;
		private var _playsetRopeBridge : PlaysetRopeBridge;
		private var _playsetSlide : PlaysetSlide;
		
		private var _physicEngine: PhysicEngine;
		
		
		
		public function Level1() {
			super();
			_physicEngine = ShareAssets.instance.physicEngine;
			_scene = ShareAssets.instance.view.scene;
			init();
		}

		private function init() : void {
			
			setupObjects();
		}

		private function setupObjects() : void {
		
			playground = new Playground(false);
			_scene.addChild(playground.mesh);

			// Playsets
			// Todo: make objectcontainer for the 3 elements
			_playsetCarousel = new PlaysetCarousel(-198,-171,46,"playsetcarousel",false);
			_scene.addChild(_playsetCarousel.mesh);
			var playsetCarouselCircle:PlaysetCircle = new PlaysetCircle(-198,-171, 46, "circlePlaysetCarousel");
			_scene.addChild(playsetCarouselCircle.mesh);
			var playsetCarouselEntrance:PlaysetEntrance = new PlaysetEntrance(-249, -164, 16, "entrancePlaysetCarousel",90);
			_scene.addChild(playsetCarouselEntrance.mesh);


			_playsetSwing = new PlaysetSwing(-100,0,44,"playsetswing",false);
			_scene.addChild(_playsetSwing.mesh);
			var playsetSwingCircle:PlaysetCircle = new PlaysetCircle(-100,0, 44, "circlePlaysetSwing");
			_scene.addChild(playsetSwingCircle.mesh);
			var playsetSwingEntrance:PlaysetEntrance = new PlaysetEntrance(-56, -24, 16, "entrancePlaysetSwing",-45);
			_scene.addChild(playsetSwingEntrance.mesh);


			_playsetTunnel = new PlaysetTunnel(163,-226,52,"playsettunnel",false);
			_scene.addChild(_playsetTunnel.mesh);
			var playsetTunnelCircle:PlaysetCircle = new PlaysetCircle(163,-226, 52, "circlePlaysetTunnel");
			_scene.addChild(playsetTunnelCircle.mesh);
			var playsetTunnelEntrance:PlaysetEntrance = new PlaysetEntrance(154, -171, 16, "entrancePlaysetTunnel",0);
			_scene.addChild(playsetTunnelEntrance.mesh);

			_playsetRopeBridge = new PlaysetRopeBridge(-145,192,46,"playsetropebridge",false);
			_scene.addChild(_playsetRopeBridge.mesh);
			var playsetRopeBridgeCircle:PlaysetCircle = new PlaysetCircle(-145,192, 46, "circlePlaysetRopeBridge");
			_scene.addChild(playsetRopeBridgeCircle.mesh);
			var playsetRopeBridgeEntrance:PlaysetEntrance = new PlaysetEntrance(-117, 232, 16, "entrancePlaysetRopeBridge",45);
			_scene.addChild(playsetRopeBridgeEntrance.mesh);


			_playsetSlide = new PlaysetSlide(141,0,52,"playsetslide",false);
			_scene.addChild(_playsetSlide.mesh);
			var playsetSlideCircle:PlaysetCircle = new PlaysetCircle(151,0, 52, "circlePlaysetSlide");
			_scene.addChild(playsetSlideCircle.mesh);
			var playsetSlideEntrance:PlaysetEntrance = new PlaysetEntrance(100, -37, 16, "entrancePlaysetSlide",45);
			_scene.addChild(playsetSlideEntrance.mesh);

			// trees
			var tree1Thick : TreeThick = new TreeThick(-310,180,16,"tree1thick");
			_scene.addChild(tree1Thick.mesh);

			var tree2Thick : TreeThick = new TreeThick(-315,36,16,"tree2thick");
			_scene.addChild(tree2Thick.mesh);

			// position right bottom
			var tree3Thick : TreeThick = new TreeThick(315,-205,16,"tree3thick");
			_scene.addChild(tree3Thick.mesh);

			// position lefttop
			var tree1Thin : TreeThin = new TreeThin(-268,128,16,"tree1thin");
			_scene.addChild(tree1Thin.mesh);

			// position lefttop2
			var tree2Thin : TreeThin = new TreeThin(-291,-9,16,"tree2thin");
			_scene.addChild(tree2Thin.mesh);

			// position rightmiddle
			var tree3Thin : TreeThin = new TreeThin(315,-5,16,"tree3thin");
			_scene.addChild(tree3Thin.mesh);

			linesParticles = new LinesParticles();
			_scene.addChild(linesParticles.particleMesh1);
			
		}

		
		override public function update():void {
			_playsetCarousel.mesh.rotationY+=1;
			_playsetSwing.mesh.rotationY+=0.5;
			_playsetTunnel.mesh.rotationY += 0.5;
		}



	}
}
