package away3d.animators.nodes
{
	import flash.geom.*;
	
	import away3d.*;
	import away3d.animators.*;
	import away3d.animators.data.*;
	import away3d.animators.states.*;
	import away3d.materials.compilation.*;
	import away3d.materials.passes.*;
	
	use namespace arcane;
	
	/**
	 * A particle animation node used to set the starting velocity of a particle.
	 */
	public class ParticleVisibleNode extends ParticleNodeBase
	{
		/** @private */
		arcane static const VISABLE_INDEX:int = 0;
		
		/**
		 * Reference for velocity node properties on a single particle (when in local property mode).
		 * Expects a <code>Vector3D</code> object representing the direction of movement on the particle.
		 */
		public static const VISABLE:String = "VISABLE";
		
		public function ParticleVisibleNode()
		{
			super("ParticleVisible", ParticlePropertiesMode.LOCAL_DYNAMIC, 3,ParticleAnimationSet.POST_PRIORITY);
			
			_stateClass = ParticleVisibleState;
		}
		
		override public function getAGALVertexCode(pass:MaterialPassBase, animationRegisterCache:AnimationRegisterCache) : String
		{
			var visibleValue:ShaderRegisterElement = animationRegisterCache.getFreeVertexAttribute();
			animationRegisterCache.setRegisterIndex(this, VISABLE_INDEX, visibleValue.index);

			var code:String = "";
			code += "mul " + animationRegisterCache.scaleAndRotateTarget + ".xyz," + visibleValue + ".xyz," + animationRegisterCache.scaleAndRotateTarget + ".xyz\n";
			return code;
		}
		
		override arcane function generatePropertyOfOneParticle(param:ParticleProperties):void
		{
			var _tempVelocity:Vector3D = param[VISABLE];
			if (!_tempVelocity)
				throw new Error("there is no " + VISABLE + " in param!");
			_oneData[0] = _tempVelocity.x;
			_oneData[1] = _tempVelocity.y;
			_oneData[2] = _tempVelocity.z;
		}
	}
}