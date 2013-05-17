package nu.strafwerk.supernanny.core {
	import flash.geom.Point;
	import away3d.events.MouseEvent3D;
	import nu.strafwerk.supernanny.gamecomponents.Playground;
	import away3d.containers.Scene3D;
	import nu.strafwerk.supernanny.gamecomponents.Bully;
	import nu.strafwerk.supernanny.gamecomponents.GameObject;
	import nu.strafwerk.supernanny.gamecomponents.Toddler;
	import away3d.containers.View3D;

	import nu.strafwerk.supernanny.assets.ShareAssets;
	import nu.strafwerk.supernanny.gamecomponents.physics.PhysicEngine;
	import nu.strafwerk.supernanny.levels.AbstractLevel;

	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;

	/**
	 * @author admin
	 */
	public class Gamelogic extends Sprite {
		private var _stage : Stage;
		private var _currentLevel : AbstractLevel;
		private var _physicEngine : PhysicEngine;
		private var _view : View3D;
		private var _scene : Scene3D;
		private var _characterObjects:Vector.<GameObject>;
		private var _playground:Playground;


		private var _currentSelectedGameObjectId:int = -1;
		private var _currentSelectedPoint:Point = new Point();
		private var _storePoint:Point = new Point();


		public function Gamelogic() {
			_stage = ShareAssets.instance.stage;
			_currentLevel = ShareAssets.instance.currentLevel;
			_physicEngine = ShareAssets.instance.physicEngine;
			_view = ShareAssets.instance.view;
			_playground = ShareAssets.instance.currentLevel.playground;
			_scene = _view.scene;
			init();
		}

		private function init() : void {
			setupCharacters();
		}
		
		public function start():void {
			startEventListeners();
		}

		private function startEventListeners() : void {
			
			_physicEngine.selectedToddler.add(onToddlerSelected);
			
			// playground mouse enabled to control the toddlers		
			_playground.mesh.mouseEnabled = true;
			_playground.mesh.addEventListener(MouseEvent3D.MOUSE_DOWN, onMouseDown);
			_playground.mesh.addEventListener(MouseEvent3D.MOUSE_UP, onMouseUp);
			
			
			// Setup resize handler
			this.addEventListener(Event.ENTER_FRAME, frameLoop);
		}

		private function frameLoop(event : Event) : void {
			updateCharacters();
			_currentLevel.update();
			_physicEngine.update();
			_view.render();
		}

		private function updateCharacters():void {
			var totalGameObjects:int= _characterObjects.length;
			for (var i:int=0;i<totalGameObjects;i++) {
				_characterObjects[i].update();
			}
		}

		/*
		 * Setup characters
		 * TODO: move this to a character control class
		 */
		private function setupCharacters() : void {
			
			_characterObjects = new Vector.<GameObject>();
			
			// Setup toddlers
			// z = 350 is about the top z=-350 bottom
			for (var i:int;i<20;i++) {
				
				var toddler:Toddler = new Toddler(-350+Math.random()*700, -350+Math.random()*700,12,"toddler"+i.toString(), i, Math.random()*2, false);
				_scene.addChild(toddler.container);
				toddler.container.rotationY = Math.random()*360;
				_characterObjects.push(toddler);
			}

			// setup bully
			var bully1:Bully = new Bully(0,-370,16,"bully1",false);
			bully1.container.rotationY = 180;
			_view.scene.addChild(bully1.container);
			_characterObjects.push(bully1);
		}


		public function get characterObjects() : Vector.<GameObject> {
			return _characterObjects;
		}

		public function set characterObjects(characterObjects : Vector.<GameObject>) : void {
			_characterObjects = characterObjects;
		}
		
		/**
		 * Playground - on mouse down
		 * Check if there's a toddler under the mouse
		 */
		private function onMouseDown(event : MouseEvent3D) : void {
			trace(event.scenePosition.x, event.scenePosition.z);
			
			_currentSelectedPoint.x = event.scenePosition.x;
			_currentSelectedPoint.y = event.scenePosition.z;
			_physicEngine.checkPoint(event.scenePosition.x, event.scenePosition.z);
		}

		/**
		 * Playground - on mouse move
		 * The toddler was selected now record the points for the path
		 */	
		private function onMouseMove(event : MouseEvent3D) : void {
			_storePoint.x  = event.scenePosition.x;
			_storePoint.y  = event.scenePosition.z;
			var distance:Number = ShareAssets.instance.distanceTwoPoints(_storePoint.x,_currentSelectedPoint.x,_storePoint.y,_currentSelectedPoint.y);
			//trace("distance:", distance);

			// to avoid recording lots points record based on distance
			if (distance > 10) {
				Toddler(characterObjects[_currentSelectedGameObjectId]).userPath.push(new Point(event.scenePosition.x, event.scenePosition.z));
				_currentSelectedPoint.x = _storePoint.x;
				_currentSelectedPoint.y = _storePoint.y;
			}
		}

		/**
		 * Playground - on mouse up
		 * Deselect the toddler and movement will be change to PATH 
		 */	
		private function onMouseUp(event : MouseEvent3D) : void {
			_playground.mesh.removeEventListener(MouseEvent3D.MOUSE_MOVE, onMouseMove);
			
			_currentSelectedGameObjectId = -1;
			
			var characterObjects:Vector.<GameObject> = ShareAssets.instance.gamelogic.characterObjects;
			var characterObjectsLength:int=characterObjects.length;
			for (var i:int = 0;i<characterObjectsLength;i++) {
				GameObject(characterObjects[i]).setSelected(false);
			}
		}


		private function onToddlerSelected(gameObjectId:int):void {
			_currentSelectedGameObjectId = gameObjectId;
			Toddler(characterObjects[gameObjectId]).startRecordingUserPath();
			_playground.mesh.addEventListener(MouseEvent3D.MOUSE_MOVE, onMouseMove);
		}


	}
}