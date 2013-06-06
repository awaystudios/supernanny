/*
 * // _world.QueryPoint(queryCallback,new b2Vec2(_kid.x,-_kid.z));
 */
package nu.strafwerk.supernanny.core.physics {
	import org.osflash.signals.Signal;
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;

	import nu.strafwerk.supernanny.assets.ShareAssets;
	import nu.strafwerk.supernanny.gamecomponents.GameObject;

	import flash.display.Sprite;

	/**
	 * @author admin
	 */
	public class PhysicEngine {
		/*		
		 * 
		 */
		private static var PHYSICS_SCALE : Number = 1;
		private var _world : b2World;
		private var _debugSprite : Sprite;
		private var _debug : Boolean;

		private var _selectedToddler:Signal = new Signal();

		private var _checkPoint:b2Vec2 = new b2Vec2();
		
		private var _customContactListener:CustomContactListener;

		private var _usePhysics:Boolean = true;

		public function PhysicEngine(debug : Boolean) {
			_debug = debug;
			initPhysics();
		}

		private function initPhysics() : void {
			_world = new b2World(new b2Vec2(0, 0), false);

			_customContactListener = new CustomContactListener();
			// Register custom contact listener for one-sided platforms
			_world.SetContactListener(_customContactListener);

			if (_debug) debugDraw();
		}

		private function debugDraw() : void {
			// set debug draw
			var debugDraw : b2DebugDraw = new b2DebugDraw();
			_debugSprite = new Sprite();
			_debugSprite.mouseChildren = false;
			_debugSprite.mouseEnabled = false;
			ShareAssets.instance.stage.addChild(_debugSprite);
			_debugSprite.x = ShareAssets.instance.stage.stageWidth / 2;
			_debugSprite.y = ShareAssets.instance.stage.stageHeight / 2;

			// addChild(debugSprite);
			debugDraw.SetSprite(_debugSprite);
			debugDraw.SetDrawScale(1 / PHYSICS_SCALE);
			debugDraw.SetFillAlpha(0.3);
			debugDraw.SetLineThickness(1.0);
			// b2DebugDraw.e_aabbBit
			debugDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit | b2DebugDraw.e_centerOfMassBit | b2DebugDraw.e_controllerBit);
			_world.SetDebugDraw(debugDraw);
		}

		public function createBox(x : Number, y : Number, width : Number, height : Number, dynamicBody : Boolean, name : String, gameObjectId:int = -1, isSensor:Boolean = false) : b2Body {
			var bodyDefinition : b2BodyDef = new b2BodyDef();
			bodyDefinition.position.Set(x * PHYSICS_SCALE, y * PHYSICS_SCALE);

			if (dynamicBody) {
				bodyDefinition.type = b2Body.b2_dynamicBody;
			}

			var polygon : b2PolygonShape = new b2PolygonShape();
			polygon.SetAsBox((width / 2) * PHYSICS_SCALE, (height / 2) * PHYSICS_SCALE);

			var fixtureDefinition : b2FixtureDef = new b2FixtureDef();
			fixtureDefinition.shape = polygon;
			fixtureDefinition.userData = new UserDataInfo(name, width, height, gameObjectId);

			fixtureDefinition.isSensor = isSensor;

			var body : b2Body = _world.CreateBody(bodyDefinition);
			body.CreateFixture(fixtureDefinition);
			return body;
		}

		public function createCircle(x : Number, y : Number, radius : Number, dynamicBody : Boolean, name : String, gameObjectId:int = -1, isSensor:Boolean = false) : b2Body {
			var bodyDefinition : b2BodyDef = new b2BodyDef();
			bodyDefinition.position.Set(x * PHYSICS_SCALE, y * PHYSICS_SCALE);
			// bodyDefinition.angle = 0.25 * Math.PI;
			if (dynamicBody) {
				bodyDefinition.type = b2Body.b2_dynamicBody;
			}

			var circle : b2CircleShape = new b2CircleShape(radius * PHYSICS_SCALE);

			var fixtureDefinition : b2FixtureDef = new b2FixtureDef();
			fixtureDefinition.shape = circle;
			fixtureDefinition.userData = new UserDataInfo(name, radius * 2, radius * 2, gameObjectId);

			fixtureDefinition.isSensor = isSensor; 
			if (isSensor) {
				fixtureDefinition.filter.categoryBits = 2;
				fixtureDefinition.filter.maskBits = 2;
			}
			else {
				fixtureDefinition.filter.categoryBits = 1;
				fixtureDefinition.filter.maskBits = 1;
			}
			// fixtureDefinition.density = 1.0;
			// Override the default friction.
			// fixtureDefinition.friction = 0.3;
			// fixtureDefinition.restitution = 0.1;

			var body : b2Body = _world.CreateBody(bodyDefinition);
			body.CreateFixture(fixtureDefinition);
			return body;
		}

		public function checkPoint(x:Number,y:Number):void {
			//trace("physicengine checkpoint x/y: " + x,y);
			_checkPoint.x = x * PHYSICS_SCALE;
			_checkPoint.y = -y * PHYSICS_SCALE;
			_world.QueryPoint(queryCallback,_checkPoint);
		}

		// increasing the size of the circle shape
		private function queryCallback(fixture : b2Fixture) : Boolean {
			//trace("queryCallback");
			//var touchedBody : b2Body = fixture.GetBody();
			//trace(UserDataInfo(fixture.GetUserData()).name);
			//trace(UserDataInfo(fixture.GetUserData()).gameObjectId);
			var gameObjectId:int = fixture.GetUserData().gameObjectId;
			if (gameObjectId>=0) {
				//ShareAssets.instance.currentLevel.gameObjects[gameObjectId].mesh.z += 10;
				
				GameObject(ShareAssets.instance.gamelogic.characterObjects[gameObjectId]).setSelected(true);
				_selectedToddler.dispatch(gameObjectId);
			}
			
			/*
			if (touchedBody.GetUserData() != null) {
				var fixture2 : b2Fixture = touchedBody.GetFixtureList();
				var circleDef : b2CircleShape = fixture2.GetShape() as b2CircleShape;
				var radius : Number = circleDef.GetRadius();
				trace("rad:", radius);
				// setting a max radius of 50 pixels for gameplay purpose
				// if (radius<50/PHYSICS_SCALE) {
				circleDef.SetRadius(radius + 10 / PHYSICS_SCALE);
				// }
			}
			 * 
			 */
			return false;
		}

		public function update() : void {
			
			if (_usePhysics) {
				// timestep, iterations, iterations);
				_world.Step(0, 1, 1);
				// TODO: Needed ?
				_world.ClearForces();
				// Render debug
				if (_debug)	_world.DrawDebugData();
			}
		}

		public function get world() : b2World {
			return _world;
		}

		public function set world(world : b2World) : void {
			_world = world;
		}

		public function get selectedToddler() : Signal {
			return _selectedToddler;
		}

		public function set selectedToddler(selectedToddler : Signal) : void {
			_selectedToddler = selectedToddler;
		}

		public function get customContactListener() : CustomContactListener {
			return _customContactListener;
		}

		public function set customContactListener(customContactListener : CustomContactListener) : void {
			_customContactListener = customContactListener;
		}

		public function get usePhysics() : Boolean {
			return _usePhysics;
		}

		public function set usePhysics(usePhysics : Boolean) : void {
			_usePhysics = usePhysics;
		}
	}
}