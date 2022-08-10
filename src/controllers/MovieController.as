package controllers
{
	import flash.display.MovieClip;
	import flash.display.Scene;
	import flash.display.SimpleButton;
	
	import models.DecisionVO;
	import models.MarkerVO;
	
	import starling.events.Event;
	
	import views.NavBar;
	import views.TimelineNode;

	public class MovieController
	{
		private static var clip:MovieClip;
		private static var SCENE_ID:uint = 0;
		private static var TOTAL_FRAMES:uint = 0;
		private static var nodeList:Vector.<TimelineNode> = new Vector.<TimelineNode>();
		private static var nextNode:TimelineNode;
		private static var d01offset:uint = 0;
		private static var d02offset:uint = 0;
		private static var decisions:Vector.<DecisionVO> = new Vector.<DecisionVO>(3);
		
		public static var NAVBAR:NavBar;
		public static var PAUSED:Boolean = false;
		
		public static function resetMovie():void
		{
			clip.gotoAndPlay(1, Scene(clip.scenes[0]).name);
			decisions = new Vector.<DecisionVO>(3);
			for(var i:uint = 0; i < nodeList.length; i++)
			{
				if(nodeList[i].hasEventListener(Event.TRIGGERED))
					nodeList[i].removeEventListener(Event.TRIGGERED, onNodeTriggered);
				
				nodeList[i].enabled = false;
			}
			initNodes();
		}
		
		public static function set currentClip(value:MovieClip):void
		{
			clip = value;
			TOTAL_FRAMES = clip.scenes[0].numFrames;
			
			d01offset = getLabelFrame(clip.scenes[0], 's1d1');
			d02offset = getLabelFrame(clip.scenes[1], 's2d2');
		}
		
		public static function get currentClip():MovieClip
		{
			return clip;
		}
		
		public static function addNode(value:TimelineNode):void
		{
			nodeList.push(value);
		}
		
		public static function initNodes():void
		{
			nodeList[0].enabled = true;
			nodeList[0].marker = new MarkerVO(clip.scenes[0].name, 0);
			nodeList[0].addEventListener(Event.TRIGGERED, onNodeTriggered);
			nextNode = MovieController.nodeList[1];
		}
		
		public static function checkDecisionEnabled(value:String, button:SimpleButton):void
		{
			var decision:DecisionVO = new DecisionVO();
			decision.reply = value;
			
			if(decisions[decision.decision - 1]) 
				button.enabled = decisions[decision.decision - 1].answer == decision.answer;
		}
		
		public static function trackDecision(value:String):void
		{
			var decision:DecisionVO = new DecisionVO();
			decision.reply = value;
			
			decisions[decision.decision - 1] = decision;

			var label:String;
			if(decision.decision == 1 || decision.decision == 2)
			{
				if(decision.answer == "a")
					clip.play();
				else
				{
					label = 's' + (decision.scene + 1).toString() + 'd' + decision.decision;
					d01offset = clip.currentFrame - getLabelFrame(clip.scenes[decision.scene], label);
					clip.gotoAndPlay(label, Scene(clip.scenes[decision.scene]).name); 
				}
			}
			else if(decision.decision == 3)
			{
				if(decision.scene == 1)
				{
					switch(decision.answer)
					{
						case 'a':
							clip.play();
							break;
						case 'b':
							label = 's' + (decision.scene + 1).toString() + 'd' + decision.decision;
							d01offset = clip.currentFrame - getLabelFrame(clip.scenes[decision.scene], label);
							clip.gotoAndPlay(label, Scene(clip.scenes[decision.scene]).name);
							break;
					}
				}
				else
				{
					switch(decision.answer)
					{
						case 'a':
							clip.gotoAndPlay('s1d3', Scene(clip.scenes[0]).name);
							break;
						case 'b':
							clip.play();
							break;
					}
				}
			}
		}
		
		public static function getScrubMax():uint
		{
			return (nextNode) ? nextNode.x : null;
		}
		
		public static function update():void
		{
			if(PAUSED) return;
			
			SCENE_ID = getSceneID();

			var i:uint = 0;
			switch(SCENE_ID)
			{
				case 1:
					i = d01offset;
					break;
				case 2:
					i = d01offset + d02offset;
					break;
				default:
					i = 0;
			}
			
			var sum:uint = clip.currentFrame + i;
			NAVBAR.update(sum / TOTAL_FRAMES);
			
			if(!nextNode.isEnd && NAVBAR.handle.x >= nextNode.x)
			{
				nextNode.enabled = true;
				nextNode.marker = new MarkerVO(clip.currentScene.name, clip.currentFrame);
				nextNode.addEventListener(Event.TRIGGERED, onNodeTriggered);
				nextNode = (nextNode.id < (MovieController.nodeList.length - 1)) ? MovieController.nodeList[nextNode.id + 1] : null;
			}
		}
		
		public static function updateToMarker(value:MarkerVO):void
		{
			clip.gotoAndPlay(value.frame, value.scene);
		}
		
		public static function updateToPercent(value:Number):void
		{
			var f:int, sum:int, i:int, scene:Scene;
			
			f = Math.floor(TOTAL_FRAMES * value) + 1;
			if(f > TOTAL_FRAMES) f = TOTAL_FRAMES;
			
			sum = 0;
			
			for(i = 0; i < clip.scenes.length; i++)
			{
				scene = clip.scenes[i];
				sum += scene.numFrames;
				if(f < sum)
				{
					f = scene.numFrames - (sum - f);
					break;
				}
			}

			clip.gotoAndPlay(f, scene.name);
		}
		
		private static function getSceneID():uint
		{
			for(var i:uint = 0; i < clip.scenes.length; i++)
			{
				if(clip.scenes[i].name == clip.currentScene.name)
				{
					return i;
				}
			}
			return -1;
		}
		
		private static function getLabelFrame(scene:Scene, label:String):uint
		{
			for( var i:int ; i < scene.labels.length ; ++i )
			{
				if( scene.labels[i].name == label )
					return scene.labels[i].frame;
			}
			return -1;
		}
		
		private static function onNodeTriggered(event:Event):void
		{
			var n:TimelineNode = event.target as TimelineNode;
			updateToMarker(n.marker);
			for(var i:uint = (n.id + 1); i < nodeList.length; i++)
			{
				if(nodeList[i].hasEventListener(Event.TRIGGERED))
					nodeList[i].removeEventListener(Event.TRIGGERED, onNodeTriggered);
				
				nodeList[i].enabled = false;
			}
			nextNode = (n.id < (MovieController.nodeList.length - 1)) ? MovieController.nodeList[n.id + 1] : null;
		}
	}
}