package scenes
{
    import flash.display.BitmapData;
    import flash.display.Loader;
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.events.Event;
    import flash.events.ProgressEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    
    import controllers.MovieController;
    
    import events.AudioEvent;
    import events.DecisionEvent;
    
    import models.Assets;
    import models.Constants;
    
    import starling.core.Starling;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.EnterFrameEvent;
    import starling.text.TextField;
    import starling.textures.Texture;
    import starling.utils.Color;
    
    import views.NavBar;
    
    public class Scene extends Sprite
    {
        public static const CLOSING:String = "closing";
        public static var SWF_FILE:String = '';
		public static var AUDIO_FILE:String = '';

        private var pBox:TextField;
        private var mFrameCount:int;
		private var mProgressIndicator:Image;
        
        public function Scene()
        {
           initialize();
        }
		
		protected function initialize():void
		{
			startLoad();
		}
		private function startLoad():void
		{
			mProgressIndicator = new Image(createProgressIndicator());
			mProgressIndicator.pivotX = mProgressIndicator.width * .5;
			mProgressIndicator.pivotY = mProgressIndicator.height * .5;
			mProgressIndicator.x = Constants.AppWidth * .5;
			mProgressIndicator.y = Constants.AppHeight * .5;
			addChild(mProgressIndicator);
			
			pBox = new TextField(300, 50, '0%', "RotisSansSerif", 22, Color.WHITE, true);
			pBox.pivotX = pBox.width * .5;
			pBox.pivotY = pBox.height * .5;
			pBox.x = Constants.AppWidth * .5;
			pBox.y = Constants.AppHeight * .5 + mProgressIndicator.height;
			addChild(pBox);
			
			var xmlLoader:URLLoader = new URLLoader();
			xmlLoader.addEventListener(flash.events.Event.COMPLETE, onXMLLoaded);
			xmlLoader.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			xmlLoader.load(new URLRequest(AUDIO_FILE));
		}
		
		private function onXMLLoaded(event:flash.events.Event):void
		{
			Assets.prepareSounds(new XML(event.target.data));
			
			var mLoader:Loader = new Loader();
			var mRequest:URLRequest = new URLRequest(SWF_FILE);
			mLoader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, onCompleteHandler);
			mLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			mLoader.load(mRequest);
		}
		
		
		private function createProgressIndicator(radius:Number=12, elements:int=8):Texture
		{
			var shape:flash.display.Sprite = new flash.display.Sprite();
			var angleDelta:Number = Math.PI * 2 / elements;
			var x:Number, y:Number;
			var innerRadius:Number = radius / 4;
			var color:uint;
			
			for (var i:int=0; i<elements; ++i)
			{
				x = Math.cos(angleDelta * i) * radius;
				y = Math.sin(angleDelta * i) * radius;
				color = (i+1) / elements * 255;
				
				shape.graphics.beginFill(Color.rgb(color, color, color));
				shape.graphics.drawCircle(x + 15, y + 15, innerRadius); // hardcode to centre of sprite which is 30px by default
				shape.graphics.endFill();
			}
				
			var nBMP_D:BitmapData = new BitmapData(shape.width, shape.height, true, 0x00000000);
			nBMP_D.draw(shape);
				
			var nTxtr:Texture = Texture.fromBitmapData(nBMP_D, false, true);
			
			return nTxtr;
		}
		
		private function onCompleteHandler(loadEvent:flash.events.Event):void
		{
			removeChild(pBox);
			pBox.dispose();
			
			removeChild(mProgressIndicator);
			mProgressIndicator.dispose();
			
			var nav:NavBar = new NavBar();
			nav.y = Constants.AppHeight - 65;
			addChild(nav);
			var clip:MovieClip = loadEvent.currentTarget.content;
			MovieController.currentClip = clip;
			
			//clip.y = 65;
			Starling.current.nativeOverlay.addChild(clip);
			
			MovieController.initNodes();
			clip.addEventListener(Constants.PLAY_CLIP, onProceedClip, false, 0, true);
			clip.addEventListener(DecisionEvent.DECISION_MADE, onDecisionMade, false, 0, true);
			clip.addEventListener(DecisionEvent.CHECK_ENABLED, onCheckEnabled, false, 0, true);
			clip.addEventListener(AudioEvent.AUDIO_REQUESTED, onAudioRequested, false, 0, true);
			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onAudioRequested(event:AudioEvent):void
		{
			Assets.getSound(event.result as String);
		}
		
		protected function onCheckEnabled(event:DecisionEvent):void
		{
			trace(event.result as String, event.target);
			MovieController.checkDecisionEnabled(event.result as String, event.target as SimpleButton);
		}
		
		protected function onDecisionMade(event:DecisionEvent):void
		{
			MovieController.trackDecision(event.result as String);
		}
		
		protected function onProceedClip(event:Event):void
		{
			MovieController.currentClip.play();
		}
		
		protected function onEnterFrame(event:EnterFrameEvent):void
		{
			MovieController.update();
		}
		
		private function onProgressHandler(mProgress:ProgressEvent):void
		{
			if (mFrameCount++ % 5 == 0)
				mProgressIndicator.rotation += 45;
			
			var percent:Number = mProgress.bytesLoaded/mProgress.bytesTotal;
			pBox.text = (Math.floor(percent * 100)).toString() + '%';
		}
    }
}