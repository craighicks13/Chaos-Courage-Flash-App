package views
{
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	import models.Assets;
	import models.MarkerVO;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class TimelineNode extends Sprite
	{
		private static const UP_STATE:Number = 0;
		private static const OVER_STATE:Number = 1;
		private static const DOWN_STATE:Number = 2;
		private static const DISABLED_STATE:Number = 3;
		
		private var mOverState:Texture;
		private var mDisabledState:Texture;
		private var mUpState:Texture;
		private var mDownState:Texture;
		
		private var mState:uint = 0;
		
		private var mMarker:MarkerVO;
		
		public var id:uint;
		public var isEnd:Boolean = false;
		
		private var img:Image;
		private var isEnabled:Boolean = false;
		
		
		/** Creates a button with textures for up-, over-, down- and disabled states (or text). */
		public function TimelineNode($id:uint, $end:Boolean = false)
		{
			super();
			this.id = $id;
			
			mUpState = Assets.getTextureAtlas().getTexture("node_1");
			mOverState = Assets.getTextureAtlas().getTexture("node_2");
			mDownState = Assets.getTextureAtlas().getTexture("node_2");
			mDisabledState = $end ? Assets.getTextureAtlas().getTexture("node_end") : Assets.getTextureAtlas().getTexture("node_off");
			
			this.isEnd = $end;
			
			img = new Image(mDisabledState);
			addChild(img);
			
			this.pivotX = img.width * .5;
			this.pivotY = img.height * .5;
			
			mState = UP_STATE;
			
			this.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function setContents(state:uint):void
		{
			mState = state;
			switch(mState)
			{
				case DOWN_STATE:
					img.texture = mOverState;
					break;
				case UP_STATE:
					img.texture = mUpState;
					break;
				case OVER_STATE:
					img.texture = mOverState;
					break;
				case DISABLED_STATE:
					img.texture = mDisabledState;
					break;
			}
		}
		
		protected function onTouch(event:TouchEvent):void
		{
			Mouse.cursor = (enabled && event.interactsWith(this)) ? MouseCursor.BUTTON : MouseCursor.AUTO;
			
			var touch:Touch = event.getTouch(this);
			var outTouch:Touch = event.getTouch(event.target as DisplayObject, TouchPhase.HOVER);
			if(enabled && touch == null && outTouch == null && mState != UP_STATE)
			{
				setContents(UP_STATE);
				return;
			}
			
			if (!enabled || touch == null) return;
			
			if (touch.phase == TouchPhase.HOVER && mState != OVER_STATE)
			{
				setContents(OVER_STATE);
			}
			else if (touch.phase == TouchPhase.BEGAN && mState < DOWN_STATE)
			{
				setContents(DOWN_STATE);
				//mIsDown = true;
			}
			else if (touch.phase == TouchPhase.MOVED && mState == DOWN_STATE)
			{
				// reset button when user dragged too far away after pushing
				var buttonRect:Rectangle = getBounds(stage);
				buttonRect.inflate(50, 50);
				if (!buttonRect.contains(touch.globalX, touch.globalY))
				{
					setContents(UP_STATE);
				}
			}
			else if (touch.phase == TouchPhase.ENDED && (mState == DOWN_STATE || mState == OVER_STATE))
			{
				setContents(UP_STATE);
				dispatchEventWith(Event.TRIGGERED, true);
			}
		}
		
		public function set enabled(value:Boolean):void
		{
			if (isEnabled != value)
			{
				isEnabled = value;
				setContents(value ? UP_STATE : DISABLED_STATE);
			}
		}
		
		public function get enabled():Boolean { return isEnabled; }
		
		public function set marker(value:MarkerVO):void
		{
			mMarker = value;
		}
		
		public function get marker():MarkerVO { return mMarker }
	}
}