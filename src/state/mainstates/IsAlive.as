package state.mainstates
{
	//------------------------------------------------------------------------------
	//
	// Imports
	//
	//------------------------------------------------------------------------------
	import flash.display.MovieClip;
	
	import interfaces.IState;
	import interfaces.SubState;
	
	import math.Grid;
	import math.Layout;
	
	import object.Flag;
	import object.PlayerBase;
	
	import se.lnu.mediatechnology.stickossdk.core.Session;
	
	import state.substates.IsJumping;
	import state.substates.IsRunning;
	import state.substates.IsStanding;
	import state.substates.SubstateController;

	//------------------------------------------------------------------------------
	//
	// Public class
	//
	//------------------------------------------------------------------------------
	
	/**
	 *
	 *	Acts as the alive state for the dwarf.  Is a part of the dwarfs finite state machine.   
	 * 
	 *	@author		Chris Shields
	 *	@version 	1.0
	 *
	 */
	public class IsAlive extends MovieClip implements IState
	{
		//--------------------------------------------------------------------------
		//
		// Private properties
		//
		//--------------------------------------------------------------------------
		private var _flag			:Flag;
		//--------------------------------------------------------------------------
		//
		// Public properties
		//
		//--------------------------------------------------------------------------	
		public var alerter			:MovieClip 				= new mc_alert();
		public var singlePlayer		:Boolean 				= false;
		public var aliveDwarf		:PlayerBase;			 // An instance of the base player class.  
		public var currentState		:SubState;
		public var subController	:SubstateController;
		//--------------------------------------------------------------------------
		//
		// Constructor method
		//
		//--------------------------------------------------------------------------
		
		/**
		 *	The constructor for the alive state of the dwarf.  
		 *
		 *	@param 	$player	Must be an instance of the playerBase class.  	
		 * 
		 *	@return void
		 *
		 */
		public function IsAlive($player:PlayerBase)
		{
			super();
			aliveDwarf = $player;
			init();
		}
		
		//--------------------------------------------------------------------------
		//
		// Public methods
		//
		//--------------------------------------------------------------------------	
		
		/**
		 *	The class's initiator.  Substates instanciated here, beginning state and the players
		 * 	flag are also set here. 	
		 * 
		 *	@return void
		 *
		 */
		public function init():void
		{
			initializeSubStates();
			currentState	= subController.isJumpingState;
			_flag 			= aliveDwarf.map.layout.worldItems[Layout.TYPE_FLAG][aliveDwarf.playerNum]
			
		}
		
		/**
		 *	Method called when entering this state.  Calls forward this method on any substates of
		 * 	isAlive.  	
		 * 
		 *	@return void
		 *
		 */
		public function onEnter():void
		{
			subController.moveLeft 	= false;
			subController.moveRight = false;
			currentState.onEnter();
			currentState.changeState(subController.noFlagState);
			
		}
		
		/**
		 *	Method called when exiting this state.  Calls forward this method on any substates of
		 * 	isAlive.  	
		 * 
		 *	@return void
		 *
		 */
		public function onExit():void
		{
			currentState.onExit();
		}
		
		/**
		 *	Allows the player to jump.  Passes the jump method down to substates.  
		 * 
		 * 	@param $explosion:int	This is the number that defines an explosion hit or not
		 * 							It is only sent if the dynamite explodes over the player 
		 * 							and will result in this numbers addition to the ySpeed of the
		 * 							player upon jump mode.  Is other wise defaulted to 0.
		 * 
		 *	@return void
		 * 
		 */
		public function jump($explosion:int = 0):void
		{
			currentState.jump($explosion);
		}
		
		/**
		 *	Extends the SDK's update function to each state.  This method enables movement 
		 * 	and checks if the dwarf has fallen off the level or has had its flag stolen.  	
		 * 
		 *	@return void
		 *
		 */
		public function thisUpdate():void
		{
			subController.movePlayer(); // Moves the player from substateController. 
			checkForDeath();
			checkMyFlag();	
			reclaimFlag();
			checkForFlag();
			currentState.thisUpdate();
		}
		
		/**
		 *	The class's state changer.  Allows an exit and enter method to be called 
		 * 	from each state respectively.  	
		 * 
		 * 	@param	$state	The state to switch into.  Must be an instance of SubState.  
		 * 
		 *	@return void
		 *
		 */
		public function changeState ($state:SubState):void 
		{
			currentState.onExit();
			currentState = $state;
			currentState.onEnter();
		}
		
		/**
		 *	Use this method to enable flag checks in subsequent sub states. 
		 * 
		 *	@return void
		 *
		 */
		public function checkForFlag():void
		{
			subController.checkForFlag();
		}
		
		/**
		 *	Handles the dynamite exposion effect on the dwarf.
		 * 	Enable this in parent states for it to work.  
		 * 
		 *	@return void
		 *
		 */
		public function knockBack():void
		{
			Session.sound.play		("dwarfHit");
			
			currentState 	 		= subController.isJumpingState;
			jump(2);
			
			if(subController.currentState ==  subController.hasFlagState){
				subController.hasFlagState.dropFlag();
			}
			
			var chance:Number 		= Math.ceil(Math.random()*6);
			aliveDwarf.playerSpeed	= 5;
			if(chance > 3)	{	subController.moveLeft 	= true;}
			else			{	subController.moveRight = true;}
			
			Session.setPause(1, releaseKnockBack);
		}
		
		/**
		 *
		 *  Cleaner method. 
		 * 
		 *	@return void
		 *
		 */
		public function dealloc():void
		{
			trace("dealloc from isAlive");
			subController.dealloc();
			
			if(_flag && _flag.parent != null){Session.application.state.removeChild(alerter);}
			
			_flag 			= null;
			alerter 		= null;
			aliveDwarf 		= null;	
			currentState 	= null;
			subController 	= null;
		}
		
		
		//--------------------------------------------------------------------------
		//
		// Private methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *	Disables the effect of the dynamite knock back.
		 * 
		 *	@return void
		 *
		 */
		private function releaseKnockBack():void
		{
			trace("released");
			aliveDwarf.playerSpeed 	= 3;
			subController.moveLeft 	= false;
			subController.moveRight = false;
		}
		
		/**
		 *	Runs a check to see if the player comes into contact with his
		 * 	flag out on the level.  Calls a call back funciton from the method.
		 * 
		 *	@return void
		 *
		 */
		private function reclaimFlag():void
		{
			if(_flag.parent != null && !_flag.inCastle){
				if(aliveDwarf.dwarf.hitArea.hitTestObject(aliveDwarf.map.layout.worldItems[Layout.TYPE_FLAG][aliveDwarf.playerNum])){
					saveFlag(true);
				}
			}
		}
		
		/**
		 *	Sends the player flag back to his base if it is on the stage and is not in the
		 * 	hands of the other palyer. 
		 * 
		 * 	@param $result:Boolean  True if there is a hit, false if not.  
		 * 
		 *	@return void
		 *
		 */
		private function saveFlag($result:Boolean):void
		{
			if($result){
			Session.sound.play	("flagRetake");
			_flag.x 			= aliveDwarf.map.layout.worldItems[Layout.TYPE_CASTLE][aliveDwarf.playerNum].x + aliveDwarf.map.layout.worldItems[Layout.TYPE_CASTLE][aliveDwarf.playerNum].width/2;
			_flag.y 			= aliveDwarf.map.layout.worldItems[Layout.TYPE_CASTLE][aliveDwarf.playerNum].y - Grid.TILE_HEIGHT;
			_flag.inCastle 		= true;
			aliveDwarf.map.layout.worldItems[Layout.TYPE_CASTLE][aliveDwarf.playerNum].hasItsflag = true;
			}
		}
		
		/**
		 *	Checks to see if the flag is on the stage.  Because the when the dwarf has a flag
		 * 	it is just an animation this means that the flag will not actually be on the stage
		 * 	this way the method controls the alert animation and sound for when an enemy dwarf 
		 * 	has a players flag.  This method also shuts off and removes the alert.  
		 * 
		 *	@return void
		 *
		 */
		private function checkMyFlag():void
		{
			if(alerter != null){ // Prevents weird bug where alerter is added after the state is switched.  
				if(_flag.parent == null && alerter.parent == null){ // If the flag is in the "hands of the dwarf" and there is not already an alert symbol over the dwarf
					Session.application.state.addChild(alerter);
				}
			
				if(alerter){
					alerter.x = aliveDwarf.x + aliveDwarf.width/3;
					alerter.y = aliveDwarf.y - alerter.height/1.5;
					if(alerter.y > Grid.STAGE_HEIGHT - alerter.height){
						Session.application.state.removeChild(alerter);
					}
				}
			
				if(_flag.parent != null){ // If the flag is back on the scene or in the castle
					Session.application.state.removeChild(alerter);	
				}
			}	
		}
		
		/**
		 *	Checks to see if the dwarf has fallen off the stage.   
		 * 
		 *	@return void
		 *
		 */
		protected function checkForDeath():void
		{
			if(aliveDwarf.y > Grid.STAGE_HEIGHT)
			{
				currentState.changeState(subController.noFlagState);
				aliveDwarf.changeState(aliveDwarf.getIsDyingState());
			}
		}
		
		/**
		 *	Initializes isAlives substates.  Because each sub state of isAlive needs
		 * 	to share 2 sub substates a controller mitigates this.  This controller is 
		 * 	substateController and acts as if it were initiating the 3 sub states
		 * 	of this class.  
		 * 
		 *	@return void
		 *
		 */
		protected function initializeSubStates():void
		{
			subController = new SubstateController(this);
		}
		
		//--------------------------------------------------------------------------
		//
		// State Getters
		//
		//--------------------------------------------------------------------------
		
		/**
		 * 
		 * Returns _isRunningState from isAlive through subController.
		 * 
		 * @return SubState
		 */
		public function getIsRunningState():SubState  { return subController.isRunningState;  }
		/**
		 * 
		 * Returns _isJumpingState from isAlive through subController. 
		 * 
		 * @return SubState
		 */
		public function getIsJumpingState():SubState  { return subController.isJumpingState;  }
		/**
		 * 
		 * Returns _isStandingState from isAlive through subController. 
		 * 
		 * @return SubState
		 */
		public function getIsStandingState():SubState { return subController.isStandingState; }
		
		
	
	}
}