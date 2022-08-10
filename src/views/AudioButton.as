package views
{
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import events.AudioEvent;
	
	public class AudioButton extends SimpleButton
	{
		public function AudioButton()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function onDecisionMade(event:MouseEvent):void
		{
			dispatchEvent(new AudioEvent(AudioEvent.AUDIO_REQUESTED, this.name));
		}
		
		protected function init(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(MouseEvent.MOUSE_DOWN, onDecisionMade, false, 0, true);
		}
	}
}