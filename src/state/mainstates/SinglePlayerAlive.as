package state.mainstates
{
	import interfaces.IState;
	
	import math.Grid;
	import math.Layout;
	
	import object.PlayerBase;
	
	import se.lnu.mediatechnology.stickossdk.core.Session;
	
	public class SinglePlayerAlive extends IsAlive implements IState
	{
		public function SinglePlayerAlive($player:PlayerBase)
		{
			super($player);
			singlePlayer = true;
			$player = null;
		}
		
		override public function init():void
		{
			initializeSubStates();
			currentState = subController.isJumpingState;
		}
		
		override public function thisUpdate():void
		{
			subController.movePlayer(); // Moves the player from substateController. 
			currentState.thisUpdate();
			checkForDeath();
			lookForChests();
			checkRockCollision();
			
		}
		
		override protected function checkForDeath():void
		{
		
		}
		override public function checkForFlag():void
		{}
		
		private function lookForChests():void
		{
			for (var i:int = 0; i < aliveDwarf.map.layout.worldItems[Layout.TYPE_CHEST].length; i++) 
			{
				if(aliveDwarf.dwarf.hitArea.hitTestObject(aliveDwarf.map.layout.worldItems[Layout.TYPE_CHEST][i])){
					Session.sound.play("flagCapture");
					Session.application.state.removeChild(aliveDwarf.map.layout.worldItems[Layout.TYPE_CHEST][i]);
					aliveDwarf.map.layout.worldItems[Layout.TYPE_CHEST].splice(i, 1);
					aliveDwarf.score.updateTreasureCount("++");
				}
			}
			
		}
		
		private function checkRockCollision():void
		{
			
		}
	}
}