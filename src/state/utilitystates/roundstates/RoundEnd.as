package state.utilitystates.roundstates
{
	//------------------------------------------------------------------------------
	//
	// Imports
	//
	//------------------------------------------------------------------------------
	import flash.display.MovieClip;
	
	import gamesound.Sounds;
	
	import se.lnu.mediatechnology.stickossdk.application.State;
	import se.lnu.mediatechnology.stickossdk.core.Session;
	import se.lnu.mediatechnology.stickossdk.net.Highscore;
	
	import state.utilitystates.GameState;
	import state.utilitystates.MenuState;
	
	import utils.Register;

	//------------------------------------------------------------------------------
	//
	// Public class
	//
	//------------------------------------------------------------------------------
	
	/**
	 *
	 *	Screen at the end of a single player round.  Shows the statistics, time and score of the players round.  
	 * 
	 *	@author		Chris Shields
	 *	@version 	1.0
	 *
	 */
	public class RoundEnd extends State
	{
		//--------------------------------------------------------------------------
		//
		// Private properties
		//
		//--------------------------------------------------------------------------	
		private var totalPoints		:int;
		private var timeRemaining	:int;
		private var timeSpent		:int;
		private var roundPoints		:int;
		private var currentRound	:int;
		private var nextRound		:int;
		private var singleWinState	:MovieClip 	= new mc_state();
		private var pointText		:MovieClip 	= new single_text();
		private var controlsEnabled	:Boolean 	= false;
		private var _sounds			:Sounds;
		private var _background		:MovieClip	= new mc_background();
		private var _bgFrame		:String
		private var _gameState		:GameState
		private var _sessionID		:int;
		//------------------------------------------------------------------------------
		//
		// Constructor method
		//
		//------------------------------------------------------------------------------
		/**
		 * 
		 *	The class constructor.
		 * 
		 *	@param $timeRemaining:int	The time remaining in the round just played.
		 * 	@param $round:int			The current round number just played. 
		 * 
		 *	@return	void
		 * 
		 */
		public function RoundEnd($timeRemaining:int, $round:int, $backgroundFrame:String, $gameState:GameState)
		{
			super();
			
			_gameState		= $gameState;
			timeRemaining 	= $timeRemaining;
			currentRound	= $round;
			_bgFrame		= $backgroundFrame;
			_gameState.uiBar.playerOne.dealloc();
			
			
		}
		
		//------------------------------------------------------------------------------
		//
		// Override public methods
		//
		//------------------------------------------------------------------------------
		
		/**
		 * 
		 *	This method is executed when the state is ready for use.
		 * 	This init method also works as a switchboard for the class.
		 * 	The apporpriate values are used and save in the Register 
		 * 	class depending on which round was just played.  
		 * 
		 *	@return void
		 * 
		 */
		override public function init():void 
		{
			_sounds 							= new Sounds();
			if(timeRemaining > 0){
				Session.sound.play					("fanfare");
			}
			else
			{
				Session.sound.play("failFanFare");
			}
			singleWinState.gotoAndStop			("singleWin");
			Session.application.state.addChild	(singleWinState);
			addChild(_background);
			_background.gotoAndStop(_bgFrame);
			switch(currentRound){
				case 1:
					Register.totalTimeSpent 	+= Register.roundOneTime - timeRemaining;
					Register.roundOnePoints 	= timeRemaining * 50;
					writeScore					(Register.roundOnePoints);
					break;
				case 2:
					if(timeRemaining > 0){
						Register.totalTimeSpent += Register.roundTwoTime - timeRemaining;
					}
					Register.roundTwoPoints 	= timeRemaining * 300;
					writeScore					(Register.roundTwoPoints);
					break;
				case 3:
					if(timeRemaining > 0){
						Register.totalTimeSpent += Register.roundThreeTime - timeRemaining;
					}
					Register.roundThreePoints	= timeRemaining * 600;
					writeScore					(Register.roundThreePoints);
					break;
			}
			
			updateRound();
			Session.application.state.setPause(3, enableControls);
		}
		
		/**
		 * 
		 *	This method runs automatically for each frame.    
		 * 
		 *	@return void
		 * 
		 */
		override public function update():void 
		{
			if(controlsEnabled){
				updateControls();
			}
		}
		
		/**
		 * 
		 *	Method to clean up the class before it is removed. Remove Event
		 * 	Listeners here.  
		 * 
		 *	@return void
		 * 
		 */
		override public function dealloc():void 
		{
			trace("dealloc from roundEnd");
			super.dealloc();
			if(_gameState.uiBar)_gameState.uiBar.dealloc();
			removeChild(singleWinState);
			removeChild(pointText);
			removeChild(_background);
			
			controlsEnabled	= false;
			
			singleWinState	= null;
			pointText 		= null;
			_background		= null;
			_gameState		= null;
			_sounds			= null;
		}
		
		//------------------------------------------------------------------------------
		//
		// Private methods
		//
		//------------------------------------------------------------------------------
		
		/**
		 * 
		 *	Updates the round count.  This way the next instantiation of game state will
		 * 	know what round is to be handled.  
		 * 
		 *	@return void
		 * 
		 */
		private function updateRound():void
		{	
			nextRound = currentRound + 1;
		}	
		
		/**
		 * 
		 *	This method essentially prints all the results to the screen and positions the
		 * 	respective movie clips and text instances.  Register values are also updated here. 
		 * 
		 * 	@param $roundPoitns:int	The total points for the specific round just played.  
		 * 
		 *	@return void
		 * 
		 */
		private function writeScore($roundPoints:int):void
		{
			roundPoints 						= $roundPoints;
			
			pointText.round.text 				= "Round " + currentRound + " / 3";		//The round that was played upon calling this state.
			pointText.points.text 				= roundPoints +"p";
			pointText.timeRemaining.text 		= timeRemaining.toString();
			pointText.round_1.text				= (Register.roundOnePoints).toString();
			pointText.round_2.text				= (Register.roundTwoPoints).toString();
			pointText.round_3.text				= (Register.roundThreePoints).toString();
			totalPoints							= Register.roundOnePoints + Register.roundTwoPoints + Register.roundThreePoints;
				
			pointText.total_points.text 		= totalPoints.toString();
			
			pointText.x							= 0;
			pointText.y							= 0;
			Session.application.state.addChild	(pointText);
		}
		
		/**
		 * 
		 *	Updates the controls.  This method doubles as a switchboard for the next
		 * 	necessary state depending on whether the user is to continue in the game round
		 * 	, quit back to the main menu because they failed or quit back to the main menu
		 * 	beacuse they won all 3 rounds.  Highscore input is also initiated here.  
		 * 
		 *	@return void
		 * 
		 */
		private function updateControls():void
		{
			_sessionID = Math.round(new Date().time / 1000);
			if(Session.keyboard.anyKeyIsPressed()){
				if(roundPoints == 0){
					if(totalPoints > 0){
						controlsEnabled 			= false;
						Session.highscore.smartSend	(Register.gameID, 0, totalPoints, 10, _sessionID, endGame);	
					}
					else{endGame()}
				}
				else if(nextRound == 4){trace("this point reached");controlsEnabled = false; currentRound = 4; Session.highscore.smartSend	(Register.gameID, 0, totalPoints, 10, _sessionID, endGame);	}
				else 	state 	= new GameState(nextRound)
			}
		}
		
		/**
		 * 
		 *	Ends the game and sends the highscores off to the database.
		 * 	Because the rounds are over the game register is also reset.  
		 * 	
		 * 	@param xml:XML the required received paramater from the databse request. Default is null.
		 * 
		 *	@return void
		 * 
		 */
		private function endGame(xml:XML = null):void
		{
			
			if(xml){
			trace(xml);
			var highScore:String = xml["header"]["success"];
			}
			if(totalPoints > 0 && highScore == "true"){
				Session.highscore.submit	(Register.gameID, 1, Register.totalTimeSpent,	"dwarf",	_sessionID);
				Session.highscore.submit	(Register.gameID, 2, currentRound-1, 			"dwarf",	_sessionID);
			}
			Register.roundOnePoints 	= 0;
			Register.roundTwoPoints		= 0;
			Register.roundThreePoints 	= 0;
			Register.totalTimeSpent 	= 0;
			state 						= new MenuState();
		}
		
		/**
		 * 
		 *	Enables controls for the class. 
		 * 
		 *	@return void
		 * 
		 */
		private function enableControls():void
		{
			controlsEnabled = true;
		}
	}
}