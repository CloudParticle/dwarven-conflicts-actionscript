package state.mainstates
{
	//------------------------------------------------------------------------------
	//
	// Imports
	//
	//------------------------------------------------------------------------------
	import interfaces.IState;
	
	import math.Grid;
	import math.Layout;
	
	import object.Castle;
	import object.Flag;
	import object.PlayerBase;
	
	import se.lnu.mediatechnology.stickossdk.core.Session;
	
	//------------------------------------------------------------------------------
	//
	// Public class
	//
	//------------------------------------------------------------------------------
	
	/**
	 *
	 *	Acts as the state when the dwarf falls into the chasm as part of the finite state machine. 
	 * 
	 *	@author		Chris Shields
	 *	@version 	1.0
	 *
	 */
	public class IsDying implements IState
	{
		//--------------------------------------------------------------------------
		//
		// Private properties
		//
		//--------------------------------------------------------------------------
		private var _flag		:Flag;
		private var _enemyTower	:Castle;
		//--------------------------------------------------------------------------
		//
		// Public properties
		//
		//--------------------------------------------------------------------------	
		public var player		:PlayerBase;
		//--------------------------------------------------------------------------
		//
		// Constructor method
		//
		//--------------------------------------------------------------------------
		
		/**
		 *	The constructor for the dead state of the dwarf.  
		 *
		 *	@param 	$player	Must be an instance of the playerBase class.  	
		 * 
		 *	@return void
		 *
		 */
		public function IsDying($player:PlayerBase)
		{
			trace("isDying state exists");
			player = $player;
		}
		
		//--------------------------------------------------------------------------
		//
		// Public methods
		//
		//--------------------------------------------------------------------------	
		
		/**
		 *	Method called when entering this state.  Sets the needed class parameters 
		 * 	and calls the respawning state after 1 second.  
		 * 
		 *	@return void
		 *
		 */
		public function onEnter():void
		{	
			_enemyTower 		= player.map.layout.worldItems[Layout.TYPE_CASTLE][player.enemyFlag];
			_flag 				= player.map.layout.worldItems[Layout.TYPE_FLAG][player.enemyFlag];
			if(_flag.parent 	== null)
			{
				respawnEnemyFlag();
			}
			Session.application.state.setPause(1, resetPlayer);
		}
		
		/**
		 *	Method called when entering this state.  Calls forward this method on any substates of
		 * 	isDyin.  	
		 * 
		 *	@return void
		 *
		 */
		public function onExit():void{}
		
		/**
		 *	Use this method to enable jump in this state.  This is a
		 * 	method of the interface.  	
		 * 
		 *	@return void
		 *
		 */
		public function jump():void{}
		
		/**
		 *	Use this method to enable update in this state.  	
		 * 
		 *	@return void
		 *
		 */
		public function thisUpdate():void{}
		
		/**
		 *	Use this method to enable knockback in this state.  	
		 * 
		 *	@return void
		 *
		 */
		public function knockBack():void{}
		
		/**
		 *	Cleaner method.  	
		 * 
		 *	@return void
		 *
		 */
		public function dealloc():void
		{
			trace("dealloc from isDying");
			_flag 		= null;
			_enemyTower = null;
			player		= null;
		}
		
		//--------------------------------------------------------------------------
		//
		// Private methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *	Sets the players state to respawning.  
		 * 
		 *	@return void
		 *
		 */
		private function resetPlayer():void
		{
			player.changeState(player.getIsRespawningState());
		}
		
		/**
		 *	Returns the flag to the enemies castle if the dwarf had it when he died.  
		 * 
		 *	@return void
		 *
		 */
		private function respawnEnemyFlag():void
		{
			Session.application.state.addChild	(_flag);
			_flag.x 							= _enemyTower.x + _enemyTower.width/2;
			_flag.y 							= _enemyTower.y - Grid.TILE_HEIGHT;
			_flag.inCastle 						= true;
			_enemyTower.hasItsflag 				= true;
		}
	}
}