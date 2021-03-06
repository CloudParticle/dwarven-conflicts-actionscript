package math
{	
	//------------------------------------------------------------------------------
	//
	// Imports
	//
	//------------------------------------------------------------------------------
	//------------------------------------------------------------------------------
	//
	// Public class
	//
	//------------------------------------------------------------------------------
	/**
	 *
	 *	DiceNumbers is a dynamic class that outputs numbers based on set constants in
	 * 	Grid.as.  Several methods exist that are built on switch cases with predicided
	 * 	result outputs.  This is based on the probability that is wanted for each island
	 * 	to be placed out in a level and how many open tile spaces are available for the
	 * 	islands to be placed in.  The whole class is based around simulating 2 dice rolls
	 * 	that are added together.  This number then dictates the position in column or row 
	 * 	of a tile. 
	 * 
	 *	@author		Chris Shields
	 *	@version 	1.0
	 *
	 */
	public class DiceNumbers 
	{
	
		//------------------------------------------------------------------------------
		//
		// Private properties
		//
		//------------------------------------------------------------------------------
		private var _ISLAND_COLUMN	:Array 		= new Array();  	
		private var _ISLAND_ROW		:Array 		= new Array();
		private var _overSix		:int;
		private var _diceRoll		:int;
		private var _num			:int;
		private var _finalNum		:int;
		private var _firstSplit		:int;
		private var _secondSplit	:int;
		private var _thirdSplit		:int;
		private var _tileRow		:int;
		private var _tileColumn		:int;
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
		public function DiceNumbers()
		{
			buildGrid();
		}
		
		//------------------------------------------------------------------------------
		//
		// Public methods
		//
		//------------------------------------------------------------------------------
		
		/**
		 *
		 *	This method establishes an island position on the x axis based on a random 
		 * 	number generated by the simulaiton of rolling two dice. 
		 * 
		 * 	@param $island:int	The island number the function is to find an x coordinate for. 
		 * 
		 *	@return	num		An integer generated based on the number of tiles along the
		 * 					x axis.  Preset as a constant in Grid.  
		 *
		 */
		public function getDiceFunctionX($island:int):int
		{
			_overSix 					= 0;
			_diceRoll 					= twoDiceRoll();
			if(_diceRoll > 6) _overSix 	= 1; 
			_num						= 4 + ($island*2)-_overSix
				
			return _num;
		}
		
		/**
		 *
		 *	This method acts as a switch board depending on the number of tiles along
		 * 	the y axis of the tile map there are.  This is set and should only be changed 
		 * 	in Grids constants.  This method calls then the corresponding method.  
		 * 
		 *	@return	int	num	an integer generated based on the number of tiles along the
		 * 	y axis.  Preset as a constant in Grid.  
		 *
		 */
		public function getDiceFunctionY():int
		{
			
			_firstSplit 	= twoDiceRoll();
			_secondSplit 	= twoDiceRoll();
			_thirdSplit 	= twoDiceRoll();
			
			switch(_firstSplit){
				case 2:case 3:case 4:case 5:
					_finalNum = 7;
					break;
				case 6:case 7:case 8:
					_finalNum = 13;
					break
				case 9:case 10:case 11:case 12:
					_finalNum = 19;
					break;
			}
			
			switch(_secondSplit){
				case 2:case 3:case 4:case 5:
					_finalNum = _finalNum;
					break;
				case 6:case 7:case 8:
					_finalNum += 2;
					break
				case 9:case 10:case 11:case 12:
					_finalNum += 4;
					break;
			}
			
			switch(_thirdSplit){
				case 2:case 3:case 4:case 5:case 6:
					_finalNum += 0;
					break;
				case 7:case 8:case 9:case 10:case 11:case 12:
					_finalNum += 1;
					break;
			}
			
			return _finalNum;
		}
		
		/**
		 *
		 *	This method	builds 2 arrays, one for a column poisition and the other for a row position.
		 * 	Each array contains the available variables for the tile map columns and rows based
		 * 	on constants set in Grid.  If more or less columns or rows are necessary this should
		 * 	be changed only in Grids constants.  This array is what is accessed to pluck out 
		 * 	appropriate numbers in the diceComp methods.   
		 * 
		 *	@return	void
		 *
		 */
		public function buildGrid():void
		{
			_ISLAND_COLUMN.splice	(0);
			_ISLAND_ROW.splice		(0);
			_tileColumn				= 0;
			_tileRow				= 0;
			
			for (var i:int = 0; i < Grid.OPEN_GRID_X; i++){
				_tileColumn 		= Grid.STARTING_BLOCKX  + i;
				_ISLAND_COLUMN.push	(_tileColumn);
			}
			
			for (var y:int = 0; y < Grid.OPEN_GRID_Y; y++)	{
				_tileRow 			= Grid.STARTING_BLOCKY + y;
				_ISLAND_ROW.push	(_tileRow);
			}
			
		}
		
		public function dealloc():void
		{
			trace("dealloc from diceNumbers");
			_ISLAND_COLUMN 	= null;
			_ISLAND_ROW 	= null;
		}
		
		//------------------------------------------------------------------------------
		//
		// Private methods
		//
		//------------------------------------------------------------------------------
	
		/**
		 *
		 *	Generates a random number between 2 and 12.  This is done by simulating
		 * 	2 dice rolls and adding them together.  
		 * 
		 *	@return	uint number	a random number between 2 and 12 
		 *
		 */
		private function twoDiceRoll():uint
		{
			var number:Number 	= Math.ceil(Math.random()*6);
			number 				+= Math.ceil(Math.random()*6);
			return number
		}
	}
}