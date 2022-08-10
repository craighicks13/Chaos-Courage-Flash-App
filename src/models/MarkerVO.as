package models
{
	public class MarkerVO
	{
		public var scene:String;
		public var frame:uint;
		
		function MarkerVO(s:String, f:uint)
		{
			this.scene = s;
			this.frame = f;
		}
	}
}