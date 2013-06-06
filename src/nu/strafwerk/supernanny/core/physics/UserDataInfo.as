package nu.strafwerk.supernanny.core.physics{
	/**
	 * @author admin
	 */
	public class UserDataInfo {
		public var name : String;
		public var width : Number, height : Number;
		public var gameObjectId:int;

		public function UserDataInfo(name : String = "", width : Number = 0, height : Number = 0, gameObjectId:int = -1) : void {
			this.gameObjectId = gameObjectId;
			this.name = name;
			this.width = width;
			this.height = height;
		}
	}
}