package nu.strafwerk.supernanny.core {
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.OrthographicLens;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.controllers.HoverController;
	import away3d.core.render.DefaultRenderer;
	import away3d.debug.AwayStats;
	import away3d.debug.Trident;

	import nu.strafwerk.supernanny.assets.ShareAssets;
	import nu.strafwerk.supernanny.utils.SimpleGUI;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Vector3D;

	/**
	 * @author admin
	 */
	public class Base3D extends Sprite {
		protected var _view:View3D;
		private var _camera1:Camera3D;
		private var _camera2:Camera3D;
		private var _camera3:Camera3D;
		
		protected var _scene:Scene3D;
		protected var _renderer:DefaultRenderer;
		private var _selectedCamera:int = 1;
		private var _sizeTrident:int;

		protected var _cameras : Vector.<*>;

		private var _fpsStats : AwayStats;

		private var _showSettings:Boolean;

		private var _antiAlias:int;
		private var _showStats:Boolean;
		private var _backgroundColor3D:uint;
		private var _showTrident:Boolean;
		private var _typeController:int;
		protected var _hoverController:HoverController;
		//protected var _flightController: FlightController;
		private var _orthographicLens:OrthographicLens;
		
		private var _trident:Trident;
		private var _fps:int;
		
		protected var _settingsPanel : SimpleGUI;
		
		private var _totalToddlers:int=1;
		
		private var instructions : String = "";
		private var _instructionsCom:Component;
		
		public function Base3D(fps:int,antiAlias:int=2,showStats:Boolean = true,showSettings:Boolean = true, selectedCamera:int = 0, typeController:int = 0, backgroundColor3D:uint = 0x333333,showTrident:Boolean = true,sizeTrident:int = 500) {
			_fps = fps;
			_antiAlias = antiAlias;
			_showStats = showStats;
			_showSettings = showSettings;
			_backgroundColor3D = backgroundColor3D;
			_showTrident = showTrident;
			_typeController = typeController;
			_sizeTrident = sizeTrident;
			_selectedCamera = selectedCamera;
			
    		addEventListener(Event.ADDED_TO_STAGE, init);
		}
					
		private function init(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			setupStage();			
			setup3DEngine();
			//if (_showSettings) { initSettingsPanel(); }
			if (_showStats) { initStats(); }
		}

		private function setupStage() : void {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.LOW;
			stage.frameRate = _fps;
		}


		private function setup3DEngine() : void {
			_scene = new Scene3D();
			
			_cameras = new Vector.<*>();
			_orthographicLens = new OrthographicLens(500);
			//LensBase(_orthographicLens).aspect
			
			_camera1 = new Camera3D(_orthographicLens);
			_camera1.y = 500;
			_camera1.z = -500;
			_camera1.lookAt(new Vector3D(0,0,0));
			
			
			_camera2 = new Camera3D(new PerspectiveLens());
			_camera2.x = 0;
			_camera2.y = 500;
			_camera2.z = -1000;
			PerspectiveLens(_camera2.lens).fieldOfView = 42;
			_camera2.lookAt(new Vector3D(0,0,0));

			// top			
			_camera3 = new Camera3D(new PerspectiveLens());
			_camera3.x = 0;
			_camera3.y = 675;
			_camera3.z = 0;
			_camera3.lookAt(new Vector3D(0,0,0));

			_cameras.push(_camera1);
			_cameras.push(_camera2);
			_cameras.push(_camera3);
			
			_renderer = new DefaultRenderer();
			_view = new View3D();
			_view.scene = _scene;
			_view.camera = _camera1;
			_view.renderer = renderer;
			_view.antiAlias = _antiAlias;
			_view.backgroundColor = _backgroundColor3D;
			this.addChild(_view);

			if (_typeController==1) {
			// hovercontroller		
				//_hoverController = new HoverController(null);//StudioHoverController(_camera1,stage);
			}
			else if (_typeController==2) {
				//_flightController = new FlightController(_camera1, stage);
			}
			
			if(_showTrident) {
				_trident =new Trident(_sizeTrident, true);
				_scene.addChild(_trident);
			}
			
		}

		protected function initSettingsPanel() : void
		{
			//var displaySpriteSettings:Sprite = new Sprite();
			_settingsPanel = new SimpleGUI(this, "");
			//this.addChild(displaySpriteSettings);
			//displaySpriteSettings.scaleX = 1.5;
			//displaySpriteSettings.scaleY = 1.5;

			_settingsPanel.addColumn("Show");
			_settingsPanel.addToggle("toggleStats", {label:"FPS Stats"});

			_settingsPanel.addColumn("Camera");
			_settingsPanel.addComboBox("viewCamera", [{label:"Ortho", data:0}, {label:"Perspective", data:1}, {label:"Top", data:2}], {width:140, defaultLabel:""});
			_settingsPanel.addSlider("cameraFar", 1000, 100000, {label:"FAR", tick:1000});
			_settingsPanel.addSlider("cameraFov", 10, 135, {label:"FOV", tick:2});
			_settingsPanel.addSlider("cameraOrthoHeight", 100, 2000, {label:"OrthoHeight", tick:25});
			
			_settingsPanel.addSlider("cameraX", -2000, 2000, {label:"CamX", tick:25});
			_settingsPanel.addSlider("cameraY", -2000, 2000, {label:"CamY", tick:25});
			_settingsPanel.addSlider("cameraZ", -2000, 2000, {label:"CamZ", tick:25});
			

			_settingsPanel.addColumn("Settings");
			_settingsPanel.addComboBox("antiAlias", [{label:"none", data:0}, {label:"2x", data:2}, {label:"4x", data:4}, {label:"8x", data:8},], {width:140, defaultLabel:""});

			_settingsPanel.addButton("Add toddler", {callback:addToddler, width:160});

			_settingsPanel.addToggle("togglePhysics", {label:"Physics"});

			//_settingsPanel.addColumn("Instructions");
			instructions = "";
			instructions = "Supernanny\n" + 1 + " toddler in game ";

		 	_instructionsCom = _settingsPanel.addControl(Label, {text : instructions});
			
			//_settingsPanel.addLabel(instructions);
			_settingsPanel.show();
			_settingsPanel.hide();
		}
		
		private function addToddler():void {
			ShareAssets.instance.gamelogic.addToddler();
			_totalToddlers+=1;
			instructions = "Supernanny\n" + _totalToddlers + " toddlers in game";
			Label(_instructionsCom).text  = instructions;
		}

		protected function initStats() : void
		{
			_fpsStats = new AwayStats(_view, false, false, 0, true, true);
			this.addChild(_fpsStats);
			_fpsStats.x = 10;
			_fpsStats.y = stage.stageHeight - _fpsStats.height - 10;
			if (!_showStats) {
				_fpsStats.visible = false;
			}
		}

		public function set cameraFar(value : Number) : void {
			_cameras[_selectedCamera].lens.far = value;
		}

		public function get cameraFar() : Number {
			return _cameras[_selectedCamera].lens.far;
		}


		public function set cameraOrthoHeight(value : Number) : void {
			if (_selectedCamera==0) {
				_orthographicLens.projectionHeight=value;
			}
		}

		public function get cameraOrthoHeight() : Number {
			if (_selectedCamera==0) {
				return _orthographicLens.projectionHeight;
			}
			return 0;
		}


		public function set cameraFov(value : Number) : void {
			if (_selectedCamera==1) {
				_cameras[_selectedCamera].lens.fieldOfView = value;
			}
		}

		public function get cameraFov() : Number {
			if (_selectedCamera==1) {
				return _cameras[_selectedCamera].lens.fieldOfView;
			}
			return 0;
		}

		public function set cameraX(value : Number) : void {
				_cameras[_selectedCamera].x = value;
		}

		public function get cameraX() : Number {
				return _cameras[_selectedCamera].x;
		}

		public function set cameraY(value : Number) : void {
				_cameras[_selectedCamera].y  = value;
		}

		public function get cameraY() : Number {
				return _cameras[_selectedCamera].y;
		}

		public function set cameraZ(value : Number) : void {
				_cameras[_selectedCamera].z  = value;
		}

		public function get cameraZ() : Number {
				return _cameras[_selectedCamera].z;
		}



		public function get antiAlias() : uint {
			return _view.antiAlias;
		}

		public function set antiAlias(value : uint) : void {
			_view.antiAlias = value;
		}

		public function get viewCamera() : uint {
			return _selectedCamera;
		}

		public function set viewCamera(value : uint) : void {
			_selectedCamera = value;
			_view.camera = _cameras[_selectedCamera];
		}



		public function set togglePhysics(value : Boolean) : void {
			ShareAssets.instance.physicEngine.usePhysics = value;
		}

		public function get togglePhysics() : Boolean {
			return ShareAssets.instance.physicEngine.usePhysics;
		}


		public function set toggleStats(value : Boolean) : void {
			_showStats = value;
			if (_showStats)
				_fpsStats.visible = true;
			else
				_fpsStats.visible = false;
		}

		public function get toggleStats() : Boolean {
			return _showStats;
		}

		
		public function render3D() : void {
			
			_view.render();
		}

		public function get view() : View3D {
			return _view;
		}

		public function set view(view : View3D) : void {
			_view = view;
		}

		public function get scene() : Scene3D {
			return _scene;
		}

		public function set scene(scene : Scene3D) : void {
			_scene = scene;
		}

		public function get renderer() : DefaultRenderer {
			return _renderer;
		}

		public function set renderer(renderer : DefaultRenderer) : void {
			_renderer = renderer;
		}

		public function get hoverController() : HoverController {
			return _hoverController;
		}

		public function set hoverController(hoverController : HoverController) : void {
			_hoverController = hoverController;
		}

		public function get fpsStats() : AwayStats {
			return _fpsStats;
		}

		public function set fpsStats(fpsStats : AwayStats) : void {
			_fpsStats = fpsStats;
		}

		public function get showSettings() : Boolean {
			return _showSettings;
		}

		public function set showSettings(showSettings : Boolean) : void {
			_showSettings = showSettings;
		}

	}
}