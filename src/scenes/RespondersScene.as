package scenes
{

    public class RespondersScene extends Scene
    {
        
        public function RespondersScene()
        {
			Scene.SWF_FILE = 'fla/responders.swf';
			Scene.AUDIO_FILE = 'audio/michif.xml';
			super();
        }
                
        public override function dispose():void
        {
            super.dispose();
        }
    }
}