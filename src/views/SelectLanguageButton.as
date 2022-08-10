package views
{
	import flash.geom.Rectangle;
	
	import models.Assets;
	
	import starling.display.Button;
	import starling.utils.Color;
	import starling.utils.HAlign;
	
	public class SelectLanguageButton extends Button
	{
		public function SelectLanguageButton(text:String="")
		{
			super(Assets.getTextureAtlas().getTexture("play_language_up"), text, Assets.getTextureAtlas().getTexture("play_language_down"));
			this.fontName = "RotisSansSerif";
			this.fontColor = Color.WHITE;
			this.textHAlign = HAlign.LEFT;
			this.textBounds = new Rectangle(70, 0, 295, this.height);
			this.fontColor = 0xFFFFFF;
			this.fontSize = 22;
		}
	}
}