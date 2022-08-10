package 
{
    import flash.ui.Keyboard;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;
    
    import models.Assets;
    
    import scenes.RespondersScene;
    import scenes.Scene;
    
    import starling.animation.Transitions;
    import starling.animation.Tween;
    import starling.core.Starling;
    import starling.display.BlendMode;
    import starling.display.Button;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.KeyboardEvent;
    import starling.text.TextField;
    import starling.utils.VAlign;
    
    import views.SelectLanguageButton;

    public class Main extends Sprite
    {
        private var mMainMenu:Sprite;
        private var mCurrentScene:Scene;
        
        public function Main()
        {
            // The following settings are for mobile development (iOS, Android):
            //
            // You develop your game in a *fixed* coordinate system of 320x480; the game might 
            // then run on a device with a different resolution, and the assets class will
            // provide textures in the most suitable format.
            
            Starling.current.stage.stageWidth  = 1490;
            Starling.current.stage.stageHeight = 826;
            Assets.contentScaleFactor = Starling.current.contentScaleFactor;
			
			Starling.current.nativeStage.frameRate = 24;
            
            // load general assets
            
            Assets.loadBitmapFonts();
            
            // create and show menu screen
            
            var bg:Image = new Image(Assets.getTexture("Background"));
            bg.blendMode = BlendMode.NONE;
            addChild(bg);
            
            mMainMenu = new Sprite();
			mMainMenu.x = 150;
			mMainMenu.y = 158
            addChild(mMainMenu);
            
            var frame:Image = new Image(Assets.getTexture("MenuFrame"));
            mMainMenu.addChild(frame);
			
			var banner:Button = new Button(Assets.getTextureAtlas().getTexture("story_banner_01"), "", Assets.getTextureAtlas().getTexture("story_banner_02"));
			banner.x = 324;
			banner.y = 5;
			//banner.addEventListener(Event.TRIGGERED, onBannerSelected);
			banner.scaleWhenDown = .99;
			mMainMenu.addChild(banner);
			
			var intro:Image = new Image(Assets.getTexture("IntroText"));
			intro.x = 12;
			intro.y = 30;
			mMainMenu.addChild(intro);
			
			banner.alphaWhenDisabled = 1;
			banner.enabled = false;
			buildLanguages();
		}
		
		protected function onBannerSelected(event:Event):void
		{
			event.target.removeEventListener(Event.TRIGGERED, onBannerSelected);
			buildLanguages();
		}
		
		private function buildLanguages():void
		{
            var scenesToCreate:Array = [
                ["Play In Michif", RespondersScene]
            ];
            
            var count:int = 0;
            
            for each (var sceneToCreate:Array in scenesToCreate)
            {
                var sceneTitle:String = sceneToCreate[0];
                var sceneClass:Class  = sceneToCreate[1];
                
                var button:SelectLanguageButton = new SelectLanguageButton(sceneTitle);
                button.x = 1000;
                button.y = 15 + int(count) * 52;
                button.name = getQualifiedClassName(sceneClass);
                button.addEventListener(Event.TRIGGERED, onButtonTriggered);
				button.scaleWhenDown = 1;
				button.alpha = 0;
                mMainMenu.addChild(button);
				
				var tween:Tween = new Tween(button, .5, Transitions.EASE_OUT);
				tween.animate('x', 815);
				tween.animate('alpha', 100);
				tween.delay = .25 * count;
				
				Starling.juggler.add(tween);
                ++count;
            }
            
            addEventListener(Scene.CLOSING, onSceneClosing);
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
            
            // show information about rendering method (hardware/software)
            
            var driverInfo:String = Starling.context.driverInfo;
            var infoText:TextField = new TextField(310, 64, driverInfo, "Verdana", 10);
            infoText.x = 5;
            infoText.y = 475 - infoText.height;
            infoText.vAlign = VAlign.BOTTOM;
            infoText.touchable = false;
            mMainMenu.addChild(infoText);
        }
        
        private function onAddedToStage(event:Event):void
        {
            stage.addEventListener(KeyboardEvent.KEY_DOWN, onKey);
        }
        
        private function onRemovedFromStage(event:Event):void
        {
            stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKey);
        }
        
        private function onKey(event:KeyboardEvent):void
        {
            if (event.keyCode == Keyboard.SPACE)
                Starling.current.showStats = !Starling.current.showStats;
            else if (event.keyCode == Keyboard.X)
                Starling.context.dispose();
        }
        
        private function onButtonTriggered(event:Event):void
        {
            var button:Button = event.target as Button;
            showScene(button.name);
        }
        
        private function onSceneClosing(event:Event):void
        {
            mCurrentScene.removeFromParent(true);
            mCurrentScene = null;
            mMainMenu.visible = true;
        }
        
        private function showScene(name:String):void
        {
            if (mCurrentScene) return;
            
            var sceneClass:Class = getDefinitionByName(name) as Class;
            mCurrentScene = new sceneClass() as Scene;
            mMainMenu.visible = false;
            addChild(mCurrentScene);
        }
    }
}