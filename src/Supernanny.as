package {
	import nu.strafwerk.supernanny.core.Gamelogic;
	import nu.strafwerk.supernanny.assets.ShareAssets;
	import nu.strafwerk.supernanny.core.Base3D;
	import nu.strafwerk.supernanny.gamecomponents.physics.PhysicEngine;
	import nu.strafwerk.supernanny.levels.AbstractLevel;
	import nu.strafwerk.supernanny.levels.Level1;

	import flash.events.Event;

	/**
	 * @author admin
	 */
	[SWF(backgroundColor="#000000", width="1024", height="768")]
	public class Supernanny extends Base3D {
		
		// debug true will show 2D physics, best to use with selectedCamera 2 the top view camera
		private var _debug:Boolean = false;
		// 0 ortho, 1 perspective, 2 top
		private var _selectedCamera:int = 0;

		private var _physicEngine : PhysicEngine;
		private var _currentLevel : AbstractLevel;
		private var _gameLogic : Gamelogic;

		public function Supernanny() {
			super(60, 2, true, true, _selectedCamera, 1, 0xffffff, false, 100);
			addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(event : Event) : void {
			trace("Supernanny - init");
			removeEventListener(Event.ADDED_TO_STAGE, init);
			loadAssets();
		}

		/*
		 * Setup and load the assets
		 */
		private function loadAssets() : void {
			ShareAssets.instance.initSetup(stage, _view);
			ShareAssets.instance.onAnimationSetsLoaded.add(initAssetsLoaded);
			ShareAssets.instance.loadAssets();
		}

		/*
		 * The assets are loaded continue to setup
		 */
		private function initAssetsLoaded() : void {
			trace("Supernanny - initAssetsLoaded");
			ShareAssets.instance.onAnimationSetsLoaded.remove(initAssetsLoaded);

			initPhysics();
			setupGameLevel();

			_gameLogic = new Gamelogic();
			ShareAssets.instance.gamelogic = _gameLogic;
			_physicEngine.customContactListener.gameLogic = _gameLogic; 
			startEventListeners();
			_gameLogic.start();
			
		}

		private function setupGameLevel() : void {
			_currentLevel = new Level1();
			ShareAssets.instance.currentLevel = _currentLevel; 
		}

		private function initPhysics() : void {
			_physicEngine = new PhysicEngine(_debug);
			ShareAssets.instance.setShares(_physicEngine);
		}

		private function startEventListeners() : void {
			// Setup resize handler
			stage.addEventListener(Event.RESIZE, resizeHandler);
			resizeHandler();
		}

		private function resizeHandler(e : Event = null) : void {
			_view.width = stage.stageWidth;
			_view.height = stage.stageHeight;
			_view.x = (stage.stageWidth - _view.width) * 0.5;
			_view.y = (stage.stageHeight - _view.height) * 0.5;
		}
	}
}