package state.utilitystates
{
	//------------------------------------------------------------------------------
	//
	// Imports
	//
	//------------------------------------------------------------------------------
	import flash.display.MovieClip;
	
	import se.lnu.mediatechnology.stickossdk.application.State;
	import se.lnu.mediatechnology.stickossdk.core.Session;
	import se.lnu.mediatechnology.stickossdk.net.Highscore;
	
	import state.utilitystates.MenuState;
	
	import utils.Register;

	//------------------------------------------------------------------------------
	//
	// Public class
	//
	//------------------------------------------------------------------------------
	/**
	 *
	 *	Builds and populates the high scores list.  This state will not populate if there
	 * 	is no available databse to connect to and if so will use the default values.  
	 * 
	 *	@author		Chris Shields
	 *	@version 	1.0
	 *
	 */
	public class HighScoreState extends State
	{
		//------------------------------------------------------------------------------
		//
		// Private properties
		//
		//------------------------------------------------------------------------------
		private var _menuState			:MovieClip		= new mc_state();
		private var _highScoreLength	:int 			= 10;
		private var _controlsEnabled	:Boolean 		= false;
		private var _highscoreRows		:Array 			= new Array();
		private var _names				:Array;
		private var _scores				:Array;
		private var _times				:Array;
		private var _rounds				:Array;
		private var _tempHSRow			:HighScoreRow;
		private var _element			:String;
		//------------------------------------------------------------------------------
		//
		// Constructor method
		//
		//------------------------------------------------------------------------------
		/**
		 * 
		 *	The class constructor.
		 * 
		 *	@return void
		 * 
		 */
		public function HighScoreState()
		{
			super();
		}
		
		//------------------------------------------------------------------------------
		//
		// Override public methods
		//
		//------------------------------------------------------------------------------
		
		/**
		 * 
		 *	This method is executed when the state is ready for use
		 * 
		 *	@return void
		 * 
		 */
		public override function init():void
		{
			addChild							(_menuState);
			_menuState.gotoAndStop				("highscoreState");
			enableArrays						();
			initRows							();
			Session.highscore.receive			(Register.gameID, 0,  _highScoreLength, updateNameAndScore);
			Session.application.state.setPause	(1, enableControls);
		}
		
		/**
		 * 
		 *	This method runs automatically for each frame.
		 * 
		 *	@return void
		 * 
		 */
		public override function update():void
		{
			if(keyboard.anyKeyIsPressed() && _controlsEnabled){
				state = new MenuState();
			}
		}
		
		/**
		 * 
		 *	Use this method to clean up the class before it is removed. If 
		 * 	you use your own event listeners, remove them here.
		 * 
		 *	@return void
		 * 
		 */
		public override function dealloc():void
		{
			trace("dealloc from HighScoreState");
			super.dealloc();
			removeChild(_menuState);
			_tempHSRow		= null;
			_menuState 		= null;
			_highscoreRows 	= null;
			_names 			= null;
			_scores 		= null;
			_times 			= null;
			_rounds			= null;
			_tempHSRow 		= null;
		}
		
		//------------------------------------------------------------------------------
		//
		// Override public methods
		//
		//------------------------------------------------------------------------------
		
		/**
		 * 
		 *	Initates all the rows for the high score list.  Each row is treated as an
		 * 	object and is therefore a new instance of highScoreRow.as. 
		 * 
		 *	@return void
		 * 
		 */
		private function initRows():void
		{
			for (var i:int = 0; i < _highScoreLength; i++){
				var newRow:HighScoreRow 	= new HighScoreRow();
				_highscoreRows.push			(newRow);
				newRow 						= null;
			}
		}
		
		/**
		 * 
		 *	Updates the rows with the name and score recieved from XML response.
		 * 	The date is also pushed into highscore row as it is needed to match up
		 * 	each entry.  The date is the identifier for each row and will connect
		 * 	the scores from each seperate table to the correct player.  
		 * 
		 * 	@param $result:XML  The XML object from the call to the database
		 * 
		 *	@return void
		 * 
		 */
		private function updateNameAndScore($result:XML):void
		{
			for (var i:int = 0; i < $result["items"]["item"].length(); i++) {
				_tempHSRow 					= new HighScoreRow();
				_highscoreRows[i].name		= $result["items"]["item"][i]["name"	];
				_highscoreRows[i].score 	= $result["items"]["item"][i]["score"	].toString();
				_highscoreRows[i].date 		= $result["items"]["item"][i]["date"	].toString();
				_highscoreRows[i].session 	= $result["items"]["item"][i]["session"	].toString();
				_tempHSRow 					= null;
			}
			Session.highscore.receive		(Register.gameID, 1,  _highScoreLength, updateTimeSpent);
		}
		
		/**
		 * 
		 *	Takes the data from table 1 (seconds spent in total rounds) and assigns it 
		 * 	to the necessary row.  The temprorary row created in this function is then
		 * 	deleted.  
		 * 
		 * 	@param $result:XML  The XML object from the call to the database
		 * 
		 *	@return void
		 * 
		 */
		private function updateTimeSpent($result:XML):void
		{
			for (var i:int = 0; i < $result["items"]["item"].length(); i++) {
				_tempHSRow				= new HighScoreRow();
				_tempHSRow.score 		= $result["items"]["item"][i]["score"	].toString();
				_tempHSRow.date 		= $result["items"]["item"][i]["date"	].toString();
				_tempHSRow.session 		= $result["items"]["item"][i]["session"	].toString();
				
				for (var j:int = 0; j < _highscoreRows.length; j++){
					if(_tempHSRow.session == _highscoreRows[j].session){
						_highscoreRows[j].time = _tempHSRow.score;
					}
				}
				_tempHSRow 				= null;
			}
			Session.highscore.receive	(Register.gameID, 2,  _highScoreLength, updateRoundsCompleted);
		}
		
		/**
		 * 
		 *	Takes the data from table 2 (rounds completed) and assigns it 
		 * 	to the necessary row.  The temprorary row created in this function is then
		 * 	deleted.  
		 * 
		 * 	@param $result:XML  The XML object from the call to the database
		 * 
		 *	@return void
		 * 
		 */
		private function updateRoundsCompleted($result:XML):void
		{
			for (var i:int = 0; i < $result["items"]["item"].length(); i++){
				_tempHSRow 			= new HighScoreRow();
				_tempHSRow.score 	= $result["items"]["item"][i]["score"	].toString();
				_tempHSRow.date 	= $result["items"]["item"][i]["date"	].toString();
				_tempHSRow.session 		= $result["items"]["item"][i]["session"	].toString();
				
				for (var j:int = 0; j < _highscoreRows.length; j++) {
					if(_tempHSRow.session == _highscoreRows[j].session){
						_highscoreRows[j].round = _tempHSRow.score;
					}
				}
				_tempHSRow 			= null;
			}
			populateList();
			debugHelper();
		}
		
		/**
		 * 
		 *	Once all tables have been parsed and assigned this method 
		 * 	populates the text instances of the mc_state() with each high
		 * 	score row.  
		 * 
		 *	@return void
		 * 
		 */
		private function populateList():void
		{
			for (var i:int = 0; i < _highScoreLength; i++){
				_names	[i].text	= _highscoreRows[i].name	.toString();
				_scores	[i].text	= _highscoreRows[i].score	.toString();
				_times	[i].text	= _highscoreRows[i].time	.toString() + "s";
				_rounds	[i].text	= _highscoreRows[i].round	.toString() + "/3"; 
			}
		}
		
		/**
		 * 
		 *	This short function is meant for debugging purposes.  It will show
		 * 	each row and its properties.  Does not affect gameplay and is not
		 * 	necessary for functionality.  
		 * 
		 *	@return void
		 * 
		 */
		private function debugHelper():void
		{
			for each(var a:HighScoreRow in _highscoreRows){
				//trace(a.name, "got a score of:", a.score, "in", a.time, "s", "up until round", a.round, "of 3");
			}
		}
		
		/**
		 * 
		 *	Enables controls for this class.  
		 * 
		 *	@return void
		 * 
		 */
		private function enableControls():void
		{
			_controlsEnabled = true;
		}
		
		/**
		 * 
		 *	This uneccesarilly long method sets each text instance of mc_state()'s highscore
		 * 	instance.  Each column in high score has 10 text instances.  They are all set
		 * 	into a respective array here to be looped through in other methods in order to
		 * 	populate the list.  
		 * 
		 * 	TODO: Iterate this method in a more effecient way.  
		 * 
		 *	@return void
		 * 
		 */
		private function enableArrays():void
		{
			_names	= new Array(_menuState.highscore.name_1, 
								_menuState.highscore.name_2, 
								_menuState.highscore.name_3, 
								_menuState.highscore.name_4, 
								_menuState.highscore.name_5, 
								_menuState.highscore.name_6, 
								_menuState.highscore.name_7, 
								_menuState.highscore.name_8, 
								_menuState.highscore.name_9, 
								_menuState.highscore.name_10);
			_scores	= new Array(_menuState.highscore.score_1, 
								_menuState.highscore.score_2, 
								_menuState.highscore.score_3, 
								_menuState.highscore.score_4, 
								_menuState.highscore.score_5, 
								_menuState.highscore.score_6, 
								_menuState.highscore.score_7, 
								_menuState.highscore.score_8, 
								_menuState.highscore.score_9, 
								_menuState.highscore.score_10);
			_times	= new Array(_menuState.highscore.time_1,
								_menuState.highscore.time_2,
								_menuState.highscore.time_3,
								_menuState.highscore.time_4,
								_menuState.highscore.time_5,
								_menuState.highscore.time_6,
								_menuState.highscore.time_7,
								_menuState.highscore.time_8,
								_menuState.highscore.time_9,
								_menuState.highscore.time_10);
			_rounds	= new Array(_menuState.highscore.round_1,
								_menuState.highscore.round_2,
								_menuState.highscore.round_3,
								_menuState.highscore.round_4,
								_menuState.highscore.round_5,
								_menuState.highscore.round_6,
								_menuState.highscore.round_7,
								_menuState.highscore.round_8,
								_menuState.highscore.round_9,
								_menuState.highscore.round_10);
		}
	}
}