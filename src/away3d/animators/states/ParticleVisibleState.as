package away3d.animators.states {
	import away3d.animators.ParticleAnimator;
	import away3d.animators.data.AnimationRegisterCache;
	import away3d.animators.data.AnimationSubGeometry;
	import away3d.animators.nodes.ParticleVisibleNode;
	import away3d.arcane;
	import away3d.cameras.Camera3D;
	import away3d.core.base.IRenderable;
	import away3d.core.managers.Stage3DProxy;

	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	use namespace arcane;
	
	/**
	 * ...
	 */
	public class ParticleVisibleState extends ParticleStateBase
	{
		private var _particleVisibleNode:ParticleVisibleNode;
		
		public function getVisibles():Vector.<Vector3D>
		{
			return _dynamicProperties;
		}
		
		public function setVisibles(value:Vector.<Vector3D>):void
		{
			_dynamicProperties = value;
			
			_dynamicPropertiesDirty = new Dictionary(true);
		}
		
		public function ParticleVisibleState(animator:ParticleAnimator, particleVelocityNode:ParticleVisibleNode)
		{
			super(animator, particleVelocityNode);
			
			_particleVisibleNode = particleVelocityNode;
		}
		
		override public function setRenderState(stage3DProxy:Stage3DProxy, renderable:IRenderable, animationSubGeometry:AnimationSubGeometry, animationRegisterCache:AnimationRegisterCache, camera:Camera3D) : void
		{
			if (!_dynamicPropertiesDirty[animationSubGeometry])
				updateDynamicProperties(animationSubGeometry);
			
			var index:int = animationRegisterCache.getRegisterIndex(_animationNode, ParticleVisibleNode.VISABLE_INDEX);
			animationSubGeometry.activateVertexBuffer(index, _particleVisibleNode.dataOffset, stage3DProxy, Context3DVertexBufferFormat.FLOAT_3);
		}
	}
}