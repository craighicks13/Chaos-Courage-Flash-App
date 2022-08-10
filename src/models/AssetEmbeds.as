package models
{
    public class AssetEmbeds
    {
        // Bitmaps
        [Embed(source = "../../media/images/background.png")]
        public static const Background:Class;
        
        [Embed(source = "../../media/images/menu_frame.png")]
        public static const MenuFrame:Class;
		
		[Embed(source = "../../media/images/IntroText.png")]
		public static const IntroText:Class;
        
        // Compressed textures
        
        [Embed(source = "../../media/textures/1x/compressed_texture.atf", mimeType="application/octet-stream")]
        public static const CompressedTexture:Class;
        
        // Texture Atlas
        
        [Embed(source="../../media/images/atlas.xml", mimeType="application/octet-stream")]
        public static const AtlasXml:Class;
        
        [Embed(source="../../media/images/atlas.png")]
        public static const AtlasTexture:Class;
        
        // Bitmap Fonts
        
        [Embed(source="../../media/fonts/rotisSansBold.fnt", mimeType="application/octet-stream")]
        public static const RotisBoldXml:Class;
        
        [Embed(source = "../../media/fonts/rotisSansBold.png")]
        public static const RotisBoldTexture:Class;
    }
}