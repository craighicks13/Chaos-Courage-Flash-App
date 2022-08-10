package views
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import controllers.MovieController;
	
	import models.Assets;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class NavBar extends Sprite
	{
		private var sbar:Sprite;
		private var distance:Number;
		public var handle:Button;
		private var xMin:int;
		private var xMax:int;
		
		public function NavBar()
		{
			MovieController.NAVBAR = this;
			
			var nav:Image = new Image(Assets.getTextureAtlas().getTexture("nav_base"));
			addChild(nav);
			
			sbar = new Sprite();
			sbar.x = 60;
			sbar.y = 27;
			addChild(sbar);
			
			var bar:Image = new Image(Assets.getTextureAtlas().getTexture("status_bar"));
			sbar.addChild(bar);
			
			for(var i:uint = 0; i < 10; i++)
			{
				var node:TimelineNode = new TimelineNode(i, i==9);
				node.x = sbar.width / 9 * i + sbar.x;
				node.y = sbar.y + (sbar.height * .5);
				addChild(node);
				MovieController.addNode(node);
			}
			
			handle = new Button(Assets.getTextureAtlas().getTexture("drag_1"), '', Assets.getTextureAtlas().getTexture("drag_2"));
			handle.pivotX = handle.width * .5;
			handle.enabled = false;
			handle.alpha = 0;
			handle.x = sbar.x;
			handle.y = sbar.y + bar.height;
			//handle.addEventListener(TouchEvent.TOUCH, onHandleTouch);
			addChild(handle);
			
			xMin = handle.x;
			xMax = handle.x + bar.width;
				
			var reset:Button = new Button(Assets.getTextureAtlas().getTexture("reset_1"), '', Assets.getTextureAtlas().getTexture("reset_2"));
			reset.x = 1312;
			reset.y = 19;
			reset.addEventListener(Event.TRIGGERED, onResetClicked);
			addChild(reset);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		public function update(value:Number):void
		{
			distance = (xMax - xMin) * value;
			sbar.clipRect = new Rectangle(0, 0, distance, 10);
			handle.x = sbar.x + distance;
		}
		
		protected function onHandleTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(stage);
			var position:Point = touch.getLocation(stage);
			var max:uint;
				
			switch(touch.phase)
			{
				case TouchPhase.BEGAN:
					MovieController.PAUSED = true;
					break;
				case TouchPhase.MOVED:
					max = MovieController.getScrubMax() || xMax;
					handle.x = (position.x < xMin) ? xMin : (position.x > max) ? max : position.x;
					break;
				case TouchPhase.ENDED:
					MovieController.updateToPercent((handle.x - xMin)/(xMax - xMin));
					MovieController.PAUSED = false;
					break;
			}
		}
		
		protected function onResetClicked(event:Event):void
		{
			MovieController.resetMovie();
		}
		
		private function onAddedToStage(event:Event):void
		{
			
		}
		
		private function onRemovedFromStage(event:Event):void
		{
			
		}
	}
}