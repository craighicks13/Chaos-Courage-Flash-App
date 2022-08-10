package views
{
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import models.Constants;
	
	public class NextButton extends SimpleButton
	{
		public function NextButton()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function onNextButtonDown(event:MouseEvent):void
		{
			dispatchEvent(new Event(Constants.PLAY_CLIP, true));
		}
		
		protected function init(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			addEventListener(MouseEvent.MOUSE_DOWN, onNextButtonDown, false, 0, true);
		}
	}
}