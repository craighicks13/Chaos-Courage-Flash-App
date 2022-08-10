package models
{
	public class DecisionVO
	{
		public var fullAnswer:String;
		public var scene:uint;
		public var decision:uint;
		public var answer:String;
		
		public function set reply(value:String):void
		{
			this.fullAnswer = value;
			this.scene = int(value.substr(1, 1));
			this.decision = int(value.substr(3, 1));
			this.answer = value.substr(4);
		}
	}
}