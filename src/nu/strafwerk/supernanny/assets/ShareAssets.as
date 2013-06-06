package nu.strafwerk.supernanny.assets {
	import away3d.animators.VertexAnimationSet;
	import away3d.containers.View3D;
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.library.AssetLibrary;
	import away3d.library.assets.AssetType;
	import away3d.loaders.misc.AssetLoaderContext;
	import away3d.loaders.parsers.AWD2Parser;
	import away3d.loaders.parsers.Parsers;
	import away3d.materials.TextureMaterial;
	import away3d.textures.ATFTexture;

	import nu.strafwerk.supernanny.core.Gamelogic;
	import nu.strafwerk.supernanny.core.physics.PhysicEngine;
	import nu.strafwerk.supernanny.levels.AbstractLevel;

	import org.osflash.signals.Signal;

	import flash.display.Stage;
	import flash.utils.Dictionary;

	public class ShareAssets {
		/*
		 * Assets Singleton
		 */
		// 3D Model Characters
		[Embed(source="../../../../../embeds/BullyAnimationSet.awd", mimeType="application/octet-stream")]
		private var Bully : Class;
		[Embed(source="../../../../../embeds/ToddlerAnimationSet.awd", mimeType="application/octet-stream")]
		private var Toddler : Class;
		// 3D Model Playsets
		[Embed(source="../../../../../embeds/playsetCarousel.awd", mimeType="application/octet-stream")]
		private var PlaysetCarousel : Class;
		[Embed(source="../../../../../embeds/playsetSlide.awd", mimeType="application/octet-stream")]
		private var PlaysetSlide : Class;
		[Embed(source="../../../../../embeds/playsetSwing.awd", mimeType="application/octet-stream")]
		private var PlaysetSwing : Class;
		[Embed(source="../../../../../embeds/playsetRopeBridge.awd", mimeType="application/octet-stream")]
		public var PlaysetRopeBridge : Class;
		[Embed(source="../../../../../embeds/playsetTunnel.awd", mimeType="application/octet-stream")]
		private var PlaysetTunnel : Class;
		[Embed(source="../../../../../embeds/entrance.awd", mimeType="application/octet-stream")]
		private var Entrance : Class;
		// 3d model all kinds
		[Embed(source="../../../../../embeds/playground.awd", mimeType="application/octet-stream")]
		private var Playground : Class;
		[Embed(source="../../../../../embeds/objectTreeThick.awd", mimeType="application/octet-stream")]
		private var TreeThick : Class;
		[Embed(source="../../../../../embeds/objectTreeThin.awd", mimeType="application/octet-stream")]
		private var TreeThin : Class;
		
		// ATF Textures
		[Embed(source="../../../../../embeds/textures/playsetcircleactive.atf", mimeType="application/octet-stream")]
		private var TexturePlaySetCircleActivePng : Class;
		[Embed(source="../../../../../embeds/textures/playsetcirclenormal.atf", mimeType="application/octet-stream")]
		private var TexturePlaySetCircleNormalPng : Class;
		[Embed(source="../../../../../embeds/textures/uvwToddlerBoy.atf", mimeType="application/octet-stream")]
		private var TextureToddlerBoy : Class;
		[Embed(source="../../../../../embeds/textures/uvwToddlerGirl.atf", mimeType="application/octet-stream")]
		private var TextureToddlerGirl : Class;
		[Embed(source="../../../../../embeds/textures/toddler_selected.atf", mimeType="application/octet-stream")]
		private var TextureToddlerSelected : Class;
		[Embed(source="../../../../../embeds/textures/uvwBully.atf", mimeType="application/octet-stream")]
		private var TextureBully : Class;
		[Embed(source="../../../../../embeds/textures/uvwCarousel.atf", mimeType="application/octet-stream")]
		private var TextureCarousel : Class;
		[Embed(source="../../../../../embeds/textures/uvwEntrance.atf", mimeType="application/octet-stream")]
		private var TextureEntrance : Class;
		[Embed(source="../../../../../embeds/textures/uvwplayground.atf", mimeType="application/octet-stream")]
		private var TexturePlayground : Class;
		[Embed(source="../../../../../embeds/textures/uvwRopeBridge.atf", mimeType="application/octet-stream")]
		private var TextureRopeBridge : Class;
		[Embed(source="../../../../../embeds/textures/uvwSlide.atf", mimeType="application/octet-stream")]
		private var TextureSlide : Class;
		[Embed(source="../../../../../embeds/textures/uvwSwing.atf", mimeType="application/octet-stream")]
		private var TextureSwing : Class;
		[Embed(source="../../../../../embeds/textures/uvwTunnel.atf", mimeType="application/octet-stream")]
		private var TextureTunnel : Class;
		[Embed(source="../../../../../embeds/textures/uvwTree.atf", mimeType="application/octet-stream")]
		private var TextureTree : Class;
		[Embed(source="../../../../../embeds/textures/footstep1.atf", mimeType="application/octet-stream")]
		public var TextureFootstep1: Class;
		
		// texture materials
		private var _materialToddlerSelected : TextureMaterial;
		private var _materialPlaysetCircleActive : TextureMaterial;
		private var _materialPlaysetCircleNormal : TextureMaterial;
		private var _materialToddlerBoy : TextureMaterial;
		private var _materialToddlerGirl : TextureMaterial;

		private var _materialBully : TextureMaterial;
		private var _materialCarousel : TextureMaterial;
		private var _materialEntrance : TextureMaterial;
		private var _materialPlayground : TextureMaterial;
		private var _materialRopeBridge : TextureMaterial;
		private var _materialSlide : TextureMaterial;
		private var _materialSwing : TextureMaterial;
		private var _materialTunnel : TextureMaterial;
		private var _materialTree : TextureMaterial;
		
		// animations
		public var _bullyAnimations : VertexAnimationSet;
		public var _toddlerAnimations : VertexAnimationSet;
		private var _totalToLoadAnimationSets : int = 2;
		private  var _loadedAnimationSets : int = 0;
		public var _totalToLoadMeshes : int = 11;
		public var _loadedMeshes : int = 0;
		private  var _onMeshLoaded : Signal;
		private  var _onAnimationSetsLoaded : Signal;
		private var _dictMesh : Dictionary;
		private var _dictAnimationSets : Dictionary;
		// shares
		private var _physicEngine : PhysicEngine;
		private var _stage : Stage;
		private var _view : View3D;
		private var _currentLevel : AbstractLevel;
		private var _gamelogic : Gamelogic;

		public function ShareAssets(enforcer : SingletonEnforcer) {
		}

		// -- INITIALIZATION ---
		public static function get instance() : ShareAssets {
			if (ShareAssets._instance == null) {
				ShareAssets._instance = new ShareAssets(new SingletonEnforcer());
			}
			return ShareAssets._instance;
		}

		private static var _instance : ShareAssets;

		// ----------------------
		public function initSetup(stage : Stage, view : View3D) : void {
			_stage = stage;
			_view = view;

			_onMeshLoaded = new Signal();
			_onAnimationSetsLoaded = new Signal();
			_dictMesh = new Dictionary();
			_dictAnimationSets = new Dictionary();

			setupTextures();
		}

		public function setShares(physicEngine : PhysicEngine) : void {
			_physicEngine = physicEngine;
		}

		public function loadAssets() : void {
			AssetLibrary.addEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete);
			AssetLibrary.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceComplete);
			
			Parsers.enableAllBundled();
			 
			// TODO: bug: mapping to ATF doesn't work ?
			// exapmle: assetLoaderContext.mapUrlToData('uvwBully.jpg', new TextureBully() as ATFData);

			var assetLoaderContext : AssetLoaderContext = new AssetLoaderContext();
			assetLoaderContext.mapUrlToData('uvwToddlerGirl.jpg', TextureToddlerGirl);
			assetLoaderContext.mapUrlToData('uvwBully.jpg', TextureBully);
			assetLoaderContext.mapUrlToData('uvwCarousel.jpg', TextureCarousel);
			assetLoaderContext.mapUrlToData('uvwEntrance.png', TextureEntrance);
			assetLoaderContext.mapUrlToData('uvwplayground.jpg', TexturePlayground);
			assetLoaderContext.mapUrlToData('uvwRopeBridge.jpg', TextureRopeBridge  );
			assetLoaderContext.mapUrlToData('uvwSlide.jpg', TextureSlide  );
			assetLoaderContext.mapUrlToData('uvwSwing.jpg', TextureSwing );
			assetLoaderContext.mapUrlToData('uvwTunnel.jpg', TextureTunnel );
			assetLoaderContext.mapUrlToData('uvwTree.jpg', TextureTree);

			// all kinds
			AssetLibrary.loadData(new Playground(), assetLoaderContext, null, new AWD2Parser());
			AssetLibrary.loadData(new Entrance(), assetLoaderContext, null, new AWD2Parser());

			// playsets
			AssetLibrary.loadData(new PlaysetCarousel(), assetLoaderContext, null, new AWD2Parser());
			AssetLibrary.loadData(new PlaysetSwing(), assetLoaderContext, null, new AWD2Parser());
			AssetLibrary.loadData(new PlaysetSlide(), assetLoaderContext, null, new AWD2Parser());

			AssetLibrary.loadData(new PlaysetRopeBridge(), assetLoaderContext, null, new AWD2Parser());
			AssetLibrary.loadData(new PlaysetTunnel(), assetLoaderContext, null, new AWD2Parser());

			// trees
			AssetLibrary.loadData(new TreeThick(), assetLoaderContext, null, new AWD2Parser());
			AssetLibrary.loadData(new TreeThin(), assetLoaderContext, null, new AWD2Parser());

			// characters
			AssetLibrary.loadData(new Bully(), assetLoaderContext, null, new AWD2Parser());
			
			
			AssetLibrary.loadData(new Toddler(), assetLoaderContext, null, new AWD2Parser());
		}

		private function setupTextures() : void {
			_materialPlaysetCircleNormal = new TextureMaterial(new ATFTexture(new TexturePlaySetCircleNormalPng()));
			_materialPlaysetCircleActive = new TextureMaterial(new ATFTexture(new TexturePlaySetCircleActivePng()));

			// toddlers
			_materialToddlerBoy = new TextureMaterial(new ATFTexture(new TextureToddlerBoy()));
			_materialToddlerGirl = new TextureMaterial(new ATFTexture(new TextureToddlerGirl()));
			_materialToddlerSelected = new TextureMaterial(new ATFTexture(new TextureToddlerSelected()));
			_materialToddlerSelected.bothSides = false;


			_materialBully = new TextureMaterial(new ATFTexture(new TextureBully()));
			_materialCarousel = new TextureMaterial(new ATFTexture(new TextureCarousel()));
			_materialEntrance = new TextureMaterial(new ATFTexture(new TextureEntrance()));
			_materialPlayground = new TextureMaterial(new ATFTexture(new TexturePlayground()));
			_materialRopeBridge = new TextureMaterial(new ATFTexture(new TextureRopeBridge()));
			_materialSlide = new TextureMaterial(new ATFTexture(new TextureSlide()));
			_materialSwing = new TextureMaterial(new ATFTexture(new TextureSwing()));
			_materialTunnel = new TextureMaterial(new ATFTexture(new TextureTunnel()));
			_materialTree = new TextureMaterial(new ATFTexture(new TextureTree()));
		}

		// private var _nodeCnt:int = 0;
		// private var _framesCounter:int = 0;
		private function onAssetComplete(event : AssetEvent) : void {
			// trace("onAssetComplete - event.asset.assetType", event.asset.assetType);
			if (event.asset.assetType == AssetType.MESH) {
				trace("MESH:", Mesh(event.asset).name);

				switch (Mesh(event.asset).name) {
					case "toddler": {
						trace("complete toddler");
						_loadedMeshes += 1;
						_dictMesh["toddler"] = Mesh(event.asset);
						break;
					}
					case "bully": {
						trace("complete bully");
						_dictMesh["bully"] = Mesh(event.asset);
						_dictMesh["bully"].material = _materialBully;
						_loadedMeshes += 1;
						break;
					}
					case "Playground": {
						_dictMesh["Playground"] = Mesh(event.asset);
						_dictMesh["Playground"].material = _materialPlayground;
						_loadedMeshes += 1;
						break;
					}
					case "carousel": {
						_dictMesh["carousel"] = Mesh(event.asset);
						_dictMesh["carousel"].material = _materialCarousel;
						_loadedMeshes += 1;
						break;
					}
					case "swing": {
						_dictMesh["swing"] = Mesh(event.asset);
						_dictMesh["swing"].material = _materialSwing;
						_loadedMeshes += 1;
						break;
					}
					case "treeThick": {
						_dictMesh["treeThick"] = Mesh(event.asset);
						_dictMesh["treeThick"].material = _materialTree;
						_loadedMeshes += 1;
						break;
					}
					case "treeThin": {
						_dictMesh["treeThin"] = Mesh(event.asset);
						_dictMesh["treeThin"].material = _materialTree;
						_loadedMeshes += 1;
						break;
					}
					case "slide": {
						_dictMesh["slide"] = Mesh(event.asset);
						_dictMesh["slide"].material = _materialSlide;
						_loadedMeshes += 1;
						break;
					}
					case "ropeBridge": {
						_dictMesh["ropeBridge"] = Mesh(event.asset);
						_dictMesh["ropeBridge"].material = _materialRopeBridge; 
						_loadedMeshes += 1;
						break;
					}
					case "tunnel": {
						_dictMesh["tunnel"] = Mesh(event.asset);
						_dictMesh["tunnel"].material = _materialTunnel;
						_loadedMeshes += 1;
						break;
					}
					case "entrance": {
						_dictMesh["entrance"] = Mesh(event.asset);
						_dictMesh["entrance"].material = _materialEntrance;
						_loadedMeshes += 1;
						break;
					}
					default: {
						trace("WARNING - Assets - onAssetsComplete - Mesh not found! winame: ", Mesh(event.asset).name);
					}
				}

				if (_loadedMeshes == _totalToLoadMeshes) {
					_onMeshLoaded.dispatch();
				}
			} else if (event.asset.assetType == AssetType.ANIMATION_STATE) {
				// trace("ANIMATION_STATE");
			} else if (event.asset.assetType == AssetType.ANIMATION_NODE) {
				// _nodeCnt += 1;
				// trace("animationNode   = "+_nodeCnt);
				// trace("animationFrames = " + VertexClipNode(event.asset).frames.length);
				// _framesCounter += VertexClipNode(event.asset).frames.length;
			} else if (event.asset.assetType == AssetType.ANIMATION_SET) {
				trace("Assets - onAssetsComplete - Animation set: " + VertexAnimationSet(event.asset).name);
				switch (VertexAnimationSet(event.asset).name) {
					case "toddlerAnimations01": {
						_toddlerAnimations = VertexAnimationSet(event.asset);
						_loadedAnimationSets += 1;
						break;  
					}
					case "bullyAnimations01": {
						_bullyAnimations = VertexAnimationSet(event.asset);
						_loadedAnimationSets += 1;
						break;  
					}
					default: {
						trace("WARNING - Assets - onAssetsComplete - vertexanimation set not found!! name: ", VertexAnimationSet(event.asset).name);
					}
				}

				if (_loadedAnimationSets == _totalToLoadAnimationSets) {
					_onAnimationSetsLoaded.dispatch();
				}
			}
		}

		/**
		 * Listener function for resource complete event on loader
		 */
		private function onResourceComplete(event : LoaderEvent) : void {
			trace("Assets - onResourceComplete");
		}

		public function getMesh(nameMesh : String, clone : Boolean = false) : Mesh {
			if (clone) {
				return _dictMesh[nameMesh].clone() as Mesh;
			} else {
				return _dictMesh[nameMesh] as Mesh;
			}
		}

		public function distanceTwoPoints(x1 : Number, x2 : Number, y1 : Number, y2 : Number) : Number {
			var dx : Number = x1 - x2;
			var dy : Number = y1 - y2;
			return Math.sqrt(dx * dx + dy * dy);
		}


		public function get onMeshLoaded() : Signal {
			return _onMeshLoaded;
		}

		public function set onMeshLoaded(onMeshLoaded : Signal) : void {
			_onMeshLoaded = onMeshLoaded;
		}

		public function get onAnimationSetsLoaded() : Signal {
			return _onAnimationSetsLoaded;
		}

		public function set onAnimationSetsLoaded(onAnimationSetsLoaded : Signal) : void {
			_onAnimationSetsLoaded = onAnimationSetsLoaded;
		}

		public function get physicEngine() : PhysicEngine {
			return _physicEngine;
		}

		public function set physicEngine(physicEngine : PhysicEngine) : void {
			_physicEngine = physicEngine;
		}

		public function get stage() : Stage {
			return _stage;
		}

		public function set stage(stage : Stage) : void {
			_stage = stage;
		}

		public function get view() : View3D {
			return _view;
		}

		public function set view(view : View3D) : void {
			_view = view;
		}

		public function get materialPlaysetCircleNormal() : TextureMaterial {
			return _materialPlaysetCircleNormal;
		}

		public function set materialPlaysetCircleNormal(materialPlaysetCircleNormal : TextureMaterial) : void {
			_materialPlaysetCircleNormal = materialPlaysetCircleNormal;
		}

		public function get materialPlaysetCircleActive() : TextureMaterial {
			return _materialPlaysetCircleActive;
		}

		public function set materialPlaysetCircleActive(materialPlaysetCircleActive : TextureMaterial) : void {
			_materialPlaysetCircleActive = materialPlaysetCircleActive;
		}

		public function get materialToddlerGirl() : TextureMaterial {
			return _materialToddlerGirl;
		}

		public function set materialToddlerGirl(materialToddlerGirl : TextureMaterial) : void {
			_materialToddlerGirl = materialToddlerGirl;
		}

		public function get materialToddlerBoy() : TextureMaterial {
			return _materialToddlerBoy;
		}

		public function set materialToddlerBoy(materialToddlerBoy : TextureMaterial) : void {
			_materialToddlerBoy = materialToddlerBoy;
		}

		public function get currentLevel() : AbstractLevel {
			return _currentLevel;
		}

		public function set currentLevel(currentLevel : AbstractLevel) : void {
			_currentLevel = currentLevel;
		}

		public function get gamelogic() : Gamelogic {
			return _gamelogic;
		}

		public function set gamelogic(gamelogic : Gamelogic) : void {
			_gamelogic = gamelogic;
		}

		public function get materialToddlerSelected() : TextureMaterial {
			return _materialToddlerSelected;
		}

		public function set materialToddlerSelected(materialToddlerSelected : TextureMaterial) : void {
			_materialToddlerSelected = materialToddlerSelected;
		}
	}
}
class SingletonEnforcer {
}