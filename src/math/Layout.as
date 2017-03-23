package math
{
	//------------------------------------------------------------------------------
	//
	// Imports
	//
	//------------------------------------------------------------------------------
	import flash.display.MovieClip;
	
	import object.Bridge;
	import object.Castle;
	import object.Flag;
	import object.RockBlock;
	import object.Tree;
	
	import se.lnu.mediatechnology.stickossdk.core.Session;
	
	import tile.Tile;
	//------------------------------------------------------------------------------
	//
	// Public class
	//
	//------------------------------------------------------------------------------
	/**
	 *
	 *	Layout is responisble for building the physical world of the level.  Islands
	 * 	and the grid tiles are initiated and established here.  
	 * 
	 *	@author		Chris Shields
	 *	@version 	1.0
	 *
	 */
	public class Layout 
	{
		//--------------------------------------------------------------------------
		//
		// Public Static Constants
		//
		//--------------------------------------------------------------------------
		public static const TYPE_CASTLE	:int	= 0;
		public static const TYPE_ISLAND	:int 	= 1;
		public static const TYPE_CHEST	:int	= 2;
		public static const TYPE_ROCK	:int	= 3;
		public static const TYPE_FLAG	:int	= 4;
		public static const TYPE_TREE	:int	= 5;
		//--------------------------------------------------------------------------
		//
		// Public properties
		//
		//--------------------------------------------------------------------------
		public var NUM_ISLS			:int 		= 3; // Number of Islands that can be added to the stage
		public var worldObjects		:Array 		= new Array();
		public var bridgeObjects	:Array 		= new Array();
		public var worldItems		:Array 		= new Array();
		public var ISLAND_GRID_X	:Array 		= new Array();  	
		public var ISLAND_GRID_Y	:Array		= new Array();
		//--------------------------------------------------------------------------
		//
		// Private properties
		//
		//--------------------------------------------------------------------------
		private var _overlapp		:Boolean 		= false;
		private var _island			:MovieClip;
		private var _treeMarker		:MovieClip;
		
		private var _col			:int;
		private var _row			:int;
		private var _islX			:int;
		private var _islY			:int;
		private var _xOffset		:int;
		private var _type			:int;
			
		private var _mapX			:Array;
		private var _mapY			:Array;
		
		private var _tile			:Tile;
		private var _islandSystem	:DiceNumbers
		//------------------------------------------------------------------------------
		//
		// Constructor method
		//
		//------------------------------------------------------------------------------
		/**
		 * 
		 *	The class constructor. Only accesable via sharedInstance.
		 * 
		 *	@return void
		 * 
		 */
		public function Layout()
		{
			initializeVectors();
		}
		//------------------------------------------------------------------------------
		//
		// Public methods
		//
		//------------------------------------------------------------------------------
		/**
		 * 
		 *	Builds 2 arrays with x and y positions respectively.  These x and y positions
		 * 	are in column and row numbers and not actual pixels.  The numbers are generated
		 * 	for the specified number of islands in the level and are generated with respect
		 * 	to the pre set probability system in diceNumbers.     
		 * 
		 *	@return void
		 * 
		 */
		public function RandomizeIslandTiles():void
		{
			ISLAND_GRID_X.splice(0); // Empty these 2 grids before generating new island x and y Numbers.  Not Coordinates.  These are the tilemap numbers.  
			ISLAND_GRID_Y.splice(0);
			
			_islandSystem 			= new DiceNumbers();
			
			for (var i:int = 0; i < NUM_ISLS; i++){
				_col 				= _islandSystem.getDiceFunctionX(i);
				_row 				= _islandSystem.getDiceFunctionY();
				ISLAND_GRID_X.push	(_col);
				ISLAND_GRID_Y.push	(_row);
			}
			checkForOverlappingIslands();	
		}
		
		/**
		 * 
		 *	Builds the tilemap to the stage using the dimensions and type of the 
		 * 	tile instance. The map itself is an array of numbers representing
		 * 	each tile in its position to be on the stage. This method also 
		 * 	save each tiles x and y position on the stage to the worldTiles 
		 * 	array.  
		 * 
		 * 	@param 	$map		Array	The map in arrays of numbers
		 * 
		 *	@return void
		 * 
		 */
		public function load($map:Array):void
		{
			
			for (var i:int = 0; i < $map.length; i++){
				_mapX 		= $map[i];
				_xOffset 	= 0;
				
				for (var j:int = 0; j < _mapX.length; j++){
					_type		= _mapX[j];
					_tile		= new Tile(_type);
					_tile.y 	= _tile.height * i;
					_tile.x		= _xOffset;
					_xOffset 	+= _tile.width 
					
					Session.application.state.addChild	(_tile);
					worldObjects[_type].push			(_tile);
				}
			}
		}
		
		/**
		 * 
		 *	Method to add the island Movie clips to the stage.  These MC's have no collision effect
		 * 	and are graphic representations of the islands physical space.  The islands x and y 
		 * 	positions are retrieved through a mathematical statement using constants of the level
		 * 	to calculate out its pixel coordinates.  A small offset is used to allow for a 3D effect.
		 * 
		 *	@return void
		 * 
		 */
		public function addIslandOverlay():void
		{
			
			for (var m:int = 0; m < NUM_ISLS; m++){
				_col		= ISLAND_GRID_X[m];
				_row		= ISLAND_GRID_Y[m];
				_islX		= Grid.HORIZONTAL_EDGE_BLOCK + ((_col-1) * Grid.TILE_LENGTH);
				_islY		= (_row * Grid.TILE_HEIGHT) - 8; // 8 is the offset for a fake 3D effect
				addIsland	(m);	
			}
		}
		
		/**
		 * 
		 *	This method uses the total tiles along the x and y axis pre set respectively as consants.
		 * 	The method builds a map of numbers representing tiles for the singleplayer level.  Each number represents a different
		 * 	tile type.  These tile types are declared in Tile.  Using again the constants pre set in this
		 * 	class mathematical statements are used to check for the right tile type and placement.  Any changes
		 * 	to the tile amount or dimensions should be done by changing the constants.
		 * 
		 *	@return	mapY	Array	An array containing the entire tile map system in whole numbers.
		 * 
		 */
		public function assignTileMapArray():void
		{
			_mapY = new Array();
			
			for (var i:int = 0; i < Grid.TOTAL_TILE_SPACES_Y; i++) 
			{
				_mapX = new Array();
				
				for (var j:int = 0; j < Grid.TOTAL_TILE_SPACES_X; j++){
					_mapX[j] = Tile.TYPE_AIR;
					
					if(j==0 && i < ((Grid.TOTAL_TILE_SPACES_Y-1) - Grid.CLIFF_HEIGHT))	_mapX[j] = Tile.TYPE_EDGE_AIR;
					
					if(j==0 && i >= ((Grid.TOTAL_TILE_SPACES_Y-1) - Grid.CLIFF_HEIGHT))	_mapX[j] = Tile.TYPE_EDGE_GROUND;
					
					if(j==1 && i >= ((Grid.TOTAL_TILE_SPACES_Y-1) - Grid.CLIFF_HEIGHT))	_mapX[j] = Tile.TYPE_GROUND;
					
					_mapY[i]=_mapX;
				}
			}
			_mapY 						= updateTileMapArrayWithIslandTiles(_mapY);
			var tileMapString:String 	= buildTileMapString(_mapY);
			trace						(tileMapString);
			load						(_mapY);
		}
		
		/**
		 * 
		 *	This method uses the total tiles along the x and y axis pre set respectively as consants.
		 * 	The method builds a map of numbers representing tiles for the mulitplayer level.  Each number represents a different
		 * 	tile type.  These tile types are declared in Tile.  Using again the constants pre set in this
		 * 	class mathematical statements are used to check for the right tile type and placement.  Any changes
		 * 	to the tile amount or dimensions should be done by changing the constants.
		 * 
		 *	@return	mapY	Array	An array containing the entire tile map system in whole numbers.
		 * 
		 */
		public function assignMulitplayerTiles():void
		{
			_mapY = new Array();
			
			for (var i:int = 0; i < Grid.TOTAL_TILE_SPACES_Y; i++) 
			{
				_mapX = new Array();
				
				for (var j:int = 0; j < Grid.TOTAL_TILE_SPACES_X; j++) 
				{
					_mapX[j] = Tile.TYPE_AIR;
					
					if(j==0 &&	i	<	((Grid.TOTAL_TILE_SPACES_Y-1) - Grid.CLIFF_HEIGHT) || j== Grid.TOTAL_TILE_SPACES_X -1 && i	<	((Grid.TOTAL_TILE_SPACES_Y-1) - Grid.CLIFF_HEIGHT)){
						_mapX[j] = Tile.TYPE_EDGE_AIR;
					}
					if(j==0 &&	i	>=	((Grid.TOTAL_TILE_SPACES_Y-1) - Grid.CLIFF_HEIGHT) || j== Grid.TOTAL_TILE_SPACES_X -1 && i	>=	((Grid.TOTAL_TILE_SPACES_Y-1) - Grid.CLIFF_HEIGHT)){
						_mapX[j] = Tile.TYPE_EDGE_GROUND;
					}
					if(j==1 &&	i	>=	((Grid.TOTAL_TILE_SPACES_Y-1) - Grid.CLIFF_HEIGHT) || j== Grid.TOTAL_TILE_SPACES_X -2 && i	>=	((Grid.TOTAL_TILE_SPACES_Y-1) - Grid.CLIFF_HEIGHT)){
						_mapX[j] = Tile.TYPE_GROUND;
					}
					_mapY[i]=_mapX;
				}
			}
			
			_mapY 						= updateTileMapArrayWithIslandTiles(_mapY);
			var tileMapString:String 	= buildTileMapString(_mapY);
			trace						(tileMapString);
			load						(_mapY);
		}
		
		/**
		 * 
		 *	Cleaner method for this class
		 * 
		 *	@return void
		 * 
		 */
		public function dealloc():void
		{
			deallocWorldItems();
			deallocBridges();
			deallocTiles();
			if(_island)		{Session.application.state.removeChild(_island);}
			if(_treeMarker)	{Session.application.state.removeChild(_treeMarker);}
			worldObjects 	= null;
			bridgeObjects 	= null;
			worldItems 		= null;
			ISLAND_GRID_X 	= null;
			ISLAND_GRID_Y 	= null;
			_island 		= null;
			_treeMarker 	= null;
			_mapX			= null;
			_mapY			= null;
			_tile			= null;
			_islandSystem 	= null;
		}
		
		/**
		 * 
		 *	Iterates and cleans all tiles.
		 * 
		 *	@return void
		 * 
		 */
		private function deallocTiles():void
		{
			for (var i:int = 0; i < worldObjects.length; i++) 
			{
				for (var j:int = 0; j < worldObjects[i].length; j++) 
				{
					worldObjects[i][j].dealloc();
				}
			}
		}
		
		/**
		 * 
		 *	Iterates and cleans all bridges.  
		 * 
		 *	@return void
		 * 
		 */
		private function deallocBridges():void
		{
			for (var i:int = 0; i < bridgeObjects[Tile.TYPE_BRIDGE1].length; i++){
				bridgeObjects[Tile.TYPE_BRIDGE1][i].dealloc();
			}
			for (var j:int = 0; j < bridgeObjects[Tile.TYPE_BRIDGE2].length; j++){
				bridgeObjects[Tile.TYPE_BRIDGE2][j].dealloc();
			}
			
		}
		
		/**
		 * 
		 *	Iterates and cleans all objects not accessible from state.   
		 * 
		 *	@return void
		 * 
		 */
		private function deallocWorldItems():void
		{
			for (var i:int = 0; i < worldItems[TYPE_ROCK].length; i++){
				worldItems[TYPE_ROCK][i].dealloc();
			}
			for (var j:int = 0; j < worldItems[TYPE_TREE].length; j++){
				worldItems[TYPE_TREE][j].dealloc();
			}
		}
		//------------------------------------------------------------------------------
		//
		// Private methods
		//
		//------------------------------------------------------------------------------	
		/**
		 * 
		 *	Establishes all vector arrays for each world object that 
		 * 	is required for the level.  
		 * 
		 *	@return void
		 * 
		 */
		private function initializeVectors():void
		{
			worldObjects[Tile.TYPE_AIR]				= new Vector.<Tile>();
			worldObjects[Tile.TYPE_GROUND]			= new Vector.<Tile>();
			worldObjects[Tile.TYPE_BRIDGE1]			= new Vector.<Tile>();
			worldObjects[Tile.TYPE_BRIDGE2]			= new Vector.<Tile>();
			worldObjects[Tile.TYPE_EDGE_AIR]		= new Vector.<Tile>();
			worldObjects[Tile.TYPE_EDGE_GROUND]		= new Vector.<Tile>();
			worldObjects[Tile.TYPE_EDGE_BRIDGE1]	= new Vector.<Tile>();
			worldObjects[Tile.TYPE_EDGE_BRIDGE2]	= new Vector.<Tile>();
			
			bridgeObjects[Tile.TYPE_BRIDGE1]		= new Vector.<Bridge>();
			bridgeObjects[Tile.TYPE_BRIDGE2] 		= new Vector.<Bridge>();
			
			worldItems[TYPE_FLAG] 					= new Vector.<Flag>();
			worldItems[TYPE_CASTLE] 				= new Vector.<Castle>();
			worldItems[TYPE_CHEST] 					= new Vector.<MovieClip>();
			worldItems[TYPE_ROCK] 					= new Vector.<RockBlock>();
			worldItems[TYPE_ISLAND] 				= new Vector.<MovieClip>();
			worldItems[TYPE_TREE]					= new Vector.<Tree>();
		}
		
		
		
		/**
		 * 
		 *	Adds the actual Island Movie clip to the stage and saves it in the 
		 * 	worldItems array.  This method also enables functionality for the 
		 * 	tree marker if the parameter matches the conditional.  
		 * 
		 * 	@param	$m	int	An integer representing the current loop from the islandOverlay method.  
		 * 
		 *	@return	void
		 * 
		 */
		private function addIsland($m:int):void
		{
			_island		= new mc_island()
			_island.x	= _islX;
			_island.y 	= _islY;
			
			Session.application.state.addChild	(_island);
			worldItems[TYPE_ISLAND].push		(_island);
			_island.gotoAndStop					("island");
			
			if($m == 1){
				_island.gotoAndStop("tree");
				addTree();
			}
		}
		
		/**
		 * 
		 *	Adds the tree marker to the stage.  Tree marker is used for the hit area
		 * 	in which the player can swing his hammer to collect wood.  The tree marker
		 * 	is not viewable and is a representative movieclip.    
		 * 
		 *	@return	void
		 * 
		 */
		private function addTree():void
		{
			_treeMarker 	= new Tree();
			_treeMarker.x	= _islX+_island.width/3;
			_treeMarker.y 	= _islY-_island.height/4;
			
			Session.application.state.addChild	(_treeMarker);	
			worldItems[TYPE_TREE].push			(_treeMarker);
		}
		
		/**
		 * 
		 *	Simple method using a nested for loop to check each islands x and y position
		 * 	to check against themselves in case of an overlapp.  If there is an overlapp
		 * 	The islands are re randomized through calling RandomizeIslandTiles again.
		 * 
		 *	@return void
		 * 
		 */
		private function checkForOverlappingIslands():void
		{

			for (var j:int = 0; j < NUM_ISLS; j++){
				_col = ISLAND_GRID_X[j];
				_row = ISLAND_GRID_Y[j];
				for (var k:int = j+1; k < NUM_ISLS; k++){
					if(_col == ISLAND_GRID_X[k] && _row == ISLAND_GRID_Y[k]){
						_overlapp = true;	
					}						
				}
			}
			if(_overlapp){ // There is an overlapp
				_overlapp = false;
				RandomizeIslandTiles();	
			}	
		}
		
		
		
		/**
		 * 
		 *	Short method to update the tiles in the complete tile map array for the randomized islands.
		 * 	Island tile positions are already calculated in randomizeIslandTiles. 
		 * 
		 * 	@param	$mapY	Array	the tile map for the lvel
		 * 
		 *	@return $mapY	Array 	the updated tile map with the randomized levels. 
		 * 
		 */
		private function updateTileMapArrayWithIslandTiles($mapY:Array):Array
		{
			for (var k:int = 0; k < NUM_ISLS; k++){
				$mapY[ISLAND_GRID_Y[k]][ISLAND_GRID_X[k]] 	= Tile.TYPE_GROUND;
				$mapY[ISLAND_GRID_Y[k]+1][ISLAND_GRID_X[k]] = Tile.TYPE_GROUND;
			}
			return $mapY;
			
		}
		
		/**
		 * 
		 *	This method has no functionality for the game and is simply to help in debugging.
		 * 	Returns a string that can be traced to show the tile map in number form
		 * 
		 * 	@param	$mapY	Array	the tile map for the lvel
		 * 
		 *	@return result	String 	A string representing the tile map in numbers.
		 * 
		 */
		private function buildTileMapString($mapY:Array):String
		{
			var result:String = "";
			for each(var a:Array in $mapY)
			{
				result += a.join() + "\n";
			}
			return result;
		}
		
	

	}
}