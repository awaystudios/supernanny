package nu.strafwerk.supernanny.core.physics {
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.b2Fixture;

	import nu.strafwerk.supernanny.core.Gamelogic;
	import nu.strafwerk.supernanny.gamecomponents.Toddler;

	/**
	 * @author admin
	 */
	public class CustomContactListener extends b2ContactListener {
		
		private var _gameLogic:Gamelogic;
		private var fixtureA : b2Fixture;
		private var fixtureB : b2Fixture;
		
		
		public function CustomContactListener() {
			
		}
		
		override public function BeginContact(contact:b2Contact):void {
			fixtureA = contact.GetFixtureA();
			fixtureB = contact.GetFixtureB();

			// If any of the two fixtures doesn't have the user data object then return,
			// as we need 'hero' and 'oneSidedPlatform' objects only.
			if (!fixtureA.GetUserData() || !fixtureB.GetUserData()) return;

			var nameA : String = UserDataInfo(fixtureA.GetUserData()).name;
			var gameObjectIdA : int = UserDataInfo(fixtureA.GetUserData()).gameObjectId;
			
			var nameB : String = UserDataInfo(fixtureB.GetUserData()).name;
			var gameObjectIdB : int = UserDataInfo(fixtureB.GetUserData()).gameObjectId;
			
			//trace(fixtureA.IsSensor(),fixtureB.IsSensor());
			
			// Two toddlers crashed into each other make them sit, exclude sensor vs sensor
			if 	(!fixtureA.IsSensor() && gameObjectIdA>=0 && gameObjectIdB>=0) {
				Toddler(_gameLogic.characterObjects[gameObjectIdA]).currentMovement = 2;
				Toddler(_gameLogic.characterObjects[gameObjectIdB]).currentMovement = 2;	 
			}

			// no sensors
			if	(!fixtureA.IsSensor() && !fixtureB.IsSensor()) {
				if (gameObjectIdA>=0 && gameObjectIdB>=0) {
					
				}
				else if (gameObjectIdA>=0 || gameObjectIdB>=0) {
					// toddler vs object
					var toddlerIndex:int;
					
					// toddler walk into entrance ?
					var toddlerWalkInEntrance:Boolean = false;
					
					if (gameObjectIdA>=0) {
						toddlerIndex = gameObjectIdA;
						if (nameB.substring(0,8) == "entrance") {
							toddlerWalkInEntrance = true;
						}
					}
					else {
						if (nameA.substring(0,8) == "entrance") {
							toddlerWalkInEntrance = true;
						}
						toddlerIndex = gameObjectIdB;
					}
					
					if (toddlerWalkInEntrance) {
						//trace("ENTRANCE!!!");
						Toddler(_gameLogic.characterObjects[toddlerIndex]).reSpawn();
					}
					else {
						// turn the toddler
						Toddler(_gameLogic.characterObjects[toddlerIndex]).turnToddler();
					}
				}
			}
			
			//trace("begincontact A name:", nameA + " gameobjectId:" + gameObjectIdA + " | B name:", nameB + " gameobjectId:" + gameObjectIdB);
			
		}

		public function get gameLogic() : Gamelogic {
			return _gameLogic;
		}

		public function set gameLogic(gameLogic : Gamelogic) : void {
			_gameLogic = gameLogic;
		}

/*
		override public function PreSolve(contact : b2Contact, oldManifold : b2Manifold) : void {
			//trace("Presolve");
			var fixtureA : b2Fixture = contact.GetFixtureA();
			var fixtureB : b2Fixture = contact.GetFixtureB();

			// If any of the two fixtures doesn't have the user data object then return,
			// as we need 'hero' and 'oneSidedPlatform' objects only.
			if (!fixtureA.GetUserData() || !fixtureB.GetUserData()) return;

			var nameA : String = UserDataInfo(fixtureA.GetUserData()).name;
			var nameB : String = UserDataInfo(fixtureB.GetUserData()).name;
			//trace("nameA:", nameA + " nameB: ", nameB );

			if (nameA != "kid" && nameB != "kid") return;
			if (nameA.indexOf("oneSidedPlatform") == -1 && nameB.indexOf("oneSidedPlatform") == -1) return;

			// Now find out which is hero and which is platform and get their position and height.
			var heroPos : b2Vec2, platformPos : b2Vec2;
			var heroHeight : Number, platformHeight : Number;

			if (nameA == "kid") {
				heroPos = fixtureA.GetBody().GetPosition();
				heroHeight = (fixtureA.GetUserData() as UserDataInfo).height;

				platformPos = fixtureB.GetBody().GetPosition();
				platformHeight = (fixtureB.GetUserData() as UserDataInfo).height;
			} else {
				platformPos = fixtureA.GetBody().GetWorldCenter();
				platformHeight = (fixtureA.GetUserData() as UserDataInfo).height;

				heroPos = fixtureB.GetBody().GetWorldCenter();
				heroHeight = (fixtureB.GetUserData() as UserDataInfo).height;
			}

			// If the bottom part of the hero is under a top part of a platform then do not create collision.
			// As the hero position is in the middle of the hero object we need to add half of his height
			// to get the position at the bottom of his legs. Similar for platform but we need to substract
			// half of it's height to get the position of the top of it.
			if (heroPos.y + heroHeight / 2 > platformPos.y - platformHeight / 2) {
				contact.SetEnabled(false);
			}
		}
		 
		 */
	}
	  
	 
}