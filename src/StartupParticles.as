package 
{
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    
    import starling.core.Starling;
    
    [SWF(width="640", height="480", frameRate="60", backgroundColor="#222222")]
    public class StartupParticles extends Sprite
    {
        private var mStarling:Starling;
        
        public function StartupParticles()
        {
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            
            mStarling = new Starling(Demo, stage);
            mStarling.enableErrorChecking = false;
            mStarling.showStats = true;
            mStarling.start();
        }
    }
}