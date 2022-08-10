package views
{
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import events.DecisionEvent;
	
	public class DecisionButton extends SimpleButton
	{
		public function DecisionButton()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public override function set enabled(value:Boolean):void
		{
			super.enabled = value;
			this.alpha = value ? 1 : .4;
			if(!value && hasEventListener(MouseEvent.CLICK))
				removeEventListener(MouseEvent.CLICK, onDecisionMade);
		}
		
		protected function onDecisionMade(event:MouseEvent):void
		{
			dispatchEvent(new DecisionEvent(DecisionEvent.DECISION_MADE, this.name));
		}
		
		protected function init(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			addEventListener(MouseEvent.CLICK, onDecisionMade, false, 0, true);
			dispatchEvent(new DecisionEvent(DecisionEvent.CHECK_ENABLED, this.name));
		}
	}
}