package events
{
	import flash.events.Event;
	
	public class AudioEvent extends Event
	{
		public static const AUDIO_REQUESTED:String = "audio requested";
		public var result:Object;
		
		public function AudioEvent(type:String, result:Object, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.result = result;
		}
		
		public override function clone():Event
		{
			return new AudioEvent(type, result, bubbles, cancelable);
		}
	}
}