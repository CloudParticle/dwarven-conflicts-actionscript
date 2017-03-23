package ui
{
	//------------------------------------------------------------------------------
	//
	// Imports
	//
	//------------------------------------------------------------------------------
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import se.lnu.mediatechnology.stickossdk.core.Session;

	//------------------------------------------------------------------------------
	//
	// Public class
	//
	//------------------------------------------------------------------------------
	/**
	 *
	 *	This class represents the respective players statistics and counts.  The color
	 * 	of the player as well as their wood count, dynamite count, dynamite alpha, treasure
	 * 	count and timer are all represented and handled here.  This class must have the 
	 * 	players number and the uiParent class ( UserInterface ) to run.  
	 * 	 
	 * 
	 *	@author		Chris Shields
	 *	@version 	1.0
	 *
	 */
	public class Score extends MovieClip 
	{
		//------------------------------------------------------------------------------
		//
		// Private properties
		//
		//------------------------------------------------------------------------------
		private var _woodCount		:int;
		private var _dynamiteCount	:int;
		private var _treasureCount	:int;
		private var	_treasureTotal	:int;
		
		private var _roundTimer		:Timer;
		private var _roundLength	:int;
		private var	_roundTimeSpent	:int;
		
		private var _playerColor	:String;
		private var _player			:int;
		private var _uiBar			:MovieClip;
		//------------------------------------------------------------------------------
		//
		// Private constants
		//
		//------------------------------------------------------------------------------
		private const PLAYER_ONE	:int 		= 0;
		private const PLAYER_TWO	:int 		= 1;
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
		public function Score($player:int, $uiBar:MovieClip)
		{
			super	();
			_player	= $player;
			_uiBar 	= $uiBar;
			init	();
		}
		//------------------------------------------------------------------------------
		//
		// Public setter methods
		//
		//------------------------------------------------------------------------------
		
		/**
		 * 
		 *	Length of the round to be. In seconds.
		 * 
		 * 	@param $length:int	seconds.  
		 * 
		 *	@return void
		 * 
		 */
		public function set roundLength($length:int):void
		{
			_roundLength	= $length;
		}
		
		/**
		 * 
		 *	Wood count for the round to be.
		 * 
		 * 	@param $amount:int 	woodCount.
		 * 
		 *	@return void
		 * 
		 */
		public function set woodCount($amount:int):void
		{
			_woodCount						= $amount;
			if(_player == PLAYER_ONE){
				_uiBar.woodCount_p1.text	= _woodCount.toString();
				return
			}
			_uiBar.woodCount_p2.text		= _woodCount.toString();	
		}
		
		/**
		 * 
		 *	Dynamite count for the round to be.
		 * 
		 * 	@param $amount:int Dynamite count.
		 * 
		 *	@return void
		 * 
		 */
		public function set dynamiteCount($amount:int):void
		{
			_dynamiteCount				= $amount;
			_uiBar.dynamCount_p1.text	= _dynamiteCount.toString();
		}
		
		/**
		 * 
		 *	Color of the player 
		 * 
		 * 	@param	$color:String.  Color of the player (red, yellow, blue, green).
		 * 
		 *	@return void
		 * 
		 */
		public function set playerColor($color:String):void
		{
			_playerColor 					= $color;
			if(_player == PLAYER_ONE){
				_uiBar.color_p1.gotoAndStop	(_playerColor);
				return
			}
			_uiBar.color_p2.gotoAndStop		(_playerColor);
		}
		
		/**
		 * 
		 *	Alpha level of the dynamite. Represents whether a player can throw his dynamite or not. 
		 * 
		 * 	@param	$case:Boolean	True for available.  False for in use. 
		 * 
		 *	@return void
		 * 
		 */
		public function set dynamiteAlpha($case:Boolean):void
		{
			switch($case){
				case true:
					if(_player == PLAYER_ONE){
						_uiBar.dynam_p1.alpha	= 1;
						break;
					}
					_uiBar.dynam_p2.alpha		= 1;
					break;
				default:
					if(_player == PLAYER_ONE){
						_uiBar.dynam_p1.alpha	= 0.25;
						break;
					}
					_uiBar.dynam_p2.alpha		= 0.25;
					break;
			}
		}
		
		/**
		 * 
		 *	Treasure to be collected for the round to be.  
		 * 
		 * 	@param	$amount:int	 Treasures to collect.
		 * 
		 *	@return void
		 * 
		 */
		public function set treasureTotal($amount:int):void
		{
			_treasureTotal = $amount;
		}
		
		//------------------------------------------------------------------------------
		//
		// Public getter methods
		//
		//------------------------------------------------------------------------------
		
		/**
		 * 
		 *	Current wood count of the player. 
		 * 
		 *	@return _woodCount:int
		 * 
		 */
		public function get woodCount():int
		{
			return _woodCount;
		}
		
		/**
		 * 
		 *	The current players color.
		 * 
		 *	@return _playerColor:String
		 * 
		 */
		public function get playerColor():String
		{
			return _playerColor;
		}
		
		/**
		 * 
		 *	The current players treasure count.  
		 * 
		 *	@return _treasureCount:int
		 * 
		 */
		public function get treasuerCount():int
		{
			return _treasureCount;
		}
		
		/**
		 * 
		 *	The current players dynamite count.  
		 * 
		 * 
		 *	@return _dynamiteCount:int
		 * 
		 */
		public function get dynamiteCount():int
		{
			return _dynamiteCount;
		}
		
		/**
		 * 
		 *	Total time spent in the current single player round
		 * 		 
		 * 
		 *	@return _roundTimeSpent:int
		 * 
		 */
		public function get roundTimeSpent():int
		{
			return _roundTimeSpent;
		}
		
		//------------------------------------------------------------------------------
		//
		// Public methods
		//
		//------------------------------------------------------------------------------
		
		/**
		 * 
		 *	Initiates the class.  
		 * 
		 * 
		 *	@return void
		 * 
		 */
		public function init():void
		{
			if(_player == PLAYER_ONE){
				_uiBar.dynam_p1.gotoAndStop	("normal");
				return
			}
			_uiBar.dynam_p2.gotoAndStop		("normal");
		}
		
		public function dealloc():void
		{
			if(_roundTimer) _roundTimer.removeEventListener(TimerEvent.TIMER, countdownTick);
			trace("dealloc from Score");
			_roundTimer = null;
			_uiBar 		= null;
		}
		
		/**
		 * 
		 *	Updates the wood count of the current player.
		 * 
		 * 	@param $method:String 	The determinant for the function. "--" to subtract a wood 
		 * 							"++" to add a wood	
		 * 
		 *	@return void
		 * 
		 */
		public function updateWoodCount($method:String):void
		{
			_woodCount 						= getNewAmount($method, _woodCount);
			if(_player == PLAYER_ONE){
				_uiBar.woodCount_p1.text	= _woodCount.toString();
				return
			}
			_uiBar.woodCount_p2.text		= _woodCount.toString();
		}
		
		/**
		 * 
		 *	Updates the treasure count of the current player.  
		 * 
		 * 	@param $method:String	The determinant for the function. "--" to subtract a treasure 
		 * 							"++" to add a treasure	
		 * 
		 *	@return void
		 * 
		 */
		public function updateTreasureCount($method:String):void
		{
			_treasureCount 					= getNewAmount($method, _treasureCount);
			_uiBar.treasureCount_p1.text	= _treasureCount.toString() + " / " + _treasureTotal.toString();
		}
		
		/**
		 * 
		 *	Updates the dynamite count of the current player.  
		 * 
		 * 	@param $method:String	The determinant for the function. "--" to subtract a dynamite 
		 * 							"++" to add a dynamite	
		 *	@return void
		 * 
		 */
		public function updateDyanmiteCount($method:String):void
		{
			_dynamiteCount 				= getNewAmount($method, _dynamiteCount);
			_uiBar.dynamCount_p1.text 	= _dynamiteCount.toString();
		}	
		
		/**
		 * 
		 *	Begins the timer for the single player round.  
		 * 
		 *	@return void
		 * 
		 */
		public function startTimer():void
		{
			_roundTimeSpent 				= _roundLength;
			_roundTimer 					= new Timer(1000, _roundLength);
			_roundTimer.addEventListener	(TimerEvent.TIMER, countdownTick);
			_roundTimer.start				();
		}
		
		//------------------------------------------------------------------------------
		//
		// Private methods
		//
		//------------------------------------------------------------------------------
		
		/**
		 * 
		 *	This helper method updates the desired resource of the player.  
		 * 
		 * 	@param $method:String	Indicator for the function.  "--" to subtract a resource or "++" to add a resource
		 * 	@param $method:int		The amount before iteration.  
		 * 
		 *	@return $resource:int	The amount after iteration.  
		 * 
		 */
		private function getNewAmount($method:String, $resource:int):int
		{
			switch($method){
				case "--": $resource--; break;
				case "++": $resource++; break;
			}
			return $resource;
		}
		
		/**
		 * 
		 *	Updates for every tick of the timer.  Every Second.  
		 * 
		 * 	@param e:TimerEvent
		 * 
		 *	@return void
		 * 
		 */
		private function countdownTick($e:TimerEvent):void
		{
			if(!_uiBar){return;}
			_roundTimeSpent--;
			_uiBar.timeCount.text 	= _roundTimeSpent.toString();
			tenSecondAlert();
		}
		
		/**
		 * 
		 *	Plays a flash animation every ten seconds on the clock movie clip 
		 * 	beginning on the 40s mark.  This is to help notify the player of
		 * 	their remaining time.  
		 * 
		 *	@return void
		 * 
		 */
		private function tenSecondAlert():void
		{
			switch(_roundTimeSpent){
				case 40:
				case 30:
				case 20:
				case 10:
				case 9:
				case 8:
				case 7:
				case 6:
				case 5:
				case 4:
				case 3:
				case 2:
				case 1:
					Session.sound.play("timeAlert");
					_uiBar.flash.gotoAndPlay(0);
					break;
			}
		}	
	}
}