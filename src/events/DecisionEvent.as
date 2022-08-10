package events
{
	import flash.events.Event;
	
	public class DecisionEvent extends Event
	{
		public static const DECISION_MADE:String = "decision made";
		public static const CHECK_ENABLED:String = "check enabled";
		public var result:Object;
		
		public function DecisionEvent(type:String, result:Object, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.result = result;
		}
		
		public override function clone():Event
		{
			return new DecisionEvent(type, result, bubbles, cancelable);
		}
	}
}