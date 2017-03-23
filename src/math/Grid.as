package math
{
	//------------------------------------------------------------------------------
	//
	// Imports
	//
	//------------------------------------------------------------------------------
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import object.Bridge;
	import object.Castle;
	import object.Flag;
	import object.RockBlock;
	
	import se.lnu.mediatechnology.stickossdk.core.Session;
	import se.lnu.mediatechnology.stickossdk.debug.Ticker;
	import se.lnu.mediatechnology.stickossdk.display.IStickOsDisplayObject;
	
	import state.utilitystates.MultiplayerGameState;
	
	import tile.Tile;

	//------------------------------------------------------------------------------
	//
	// Public class
	//
	//------------------------------------------------------------------------------
	/**
	 *
	 *	Grid acts as the engine for the game.  Aside from movement and the Finite state machine
	 * 	handled by the player class all events are processed and handled here.  
	 * 
	 *	@author		Chris Shields
	 *	@version 	1.0
	 *
	 */
	public class Grid 
	{
		//--------------------------------------------------------------------------
		//
		// Public Static Constants
		//
		//--------------------------------------------------------------------------
		public static const TOTAL_TILE_SPACES_Y		:int = 30;
		public static const TOTAL_TILE_SPACES_X		:int = 12;
		public static const TILE_LENGTH				:int = 70; // Width of each block in px
		public static const TILE_HEIGHT				:int = 20; // Height of each block in px
		public static const CLIFF_HEIGHT			:int = 15; // Height in tiles of the cliff.  NOTE* Directly related to TILE_HEIGHT
		public static const STAGE_WIDTH				:int = Session.application.state.stage.stageWidth; // Stage Width
		public static const STAGE_HEIGHT			:int = Session.application.state.stage.stageHeight; // Stage Height
		public static const HORIZONTAL_EDGE_BLOCK	:int = 50; // Outer block width in px
		public static const OPEN_GRID_X				:int = 8; // Number of blocks Islands can be added to on the x axis
		public static const OPEN_GRID_Y				:int = 16; // Number of blocks Islands can be added to on the y axis
		public static const STARTING_BLOCKX			:int = 2; // Number of columns to skip before adding in Island x coordinates
		public static const STARTING_BLOCKY			:int = 10; // Number of rows to skip before adding in Island y coordinates
		//--------------------------------------------------------------------------
		//
		// Public properties
		//
		//--------------------------------------------------------------------------
		public var layout	:Layout;
		//--------------------------------------------------------------------------
		//
		// Private properties
		//
		//--------------------------------------------------------------------------
		private var _hit			:Rectangle;
		private var _currentTile	:Tile;
		private var _currentBridge	:Bridge;
		private var _r1				:Rectangle;
		private var _r2				:Rectangle;
		private var _currentRock	:RockBlock;
		private var _objX			:int;
		private var _objY			:int;
		private var _newPos			:int;
		private var _result			:Boolean;
		private var _state			:MultiplayerGameState;
		private var doubleCheckStop:int = 0;
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
		public function Grid($numIslands:int, $state:MultiplayerGameState = null)
		{
			_state 			= $state;
			layout 			= new Layout();
			layout.NUM_ISLS = $numIslands;
			layout.RandomizeIslandTiles();
			layout.addIslandOverlay();
		}
		//------------------------------------------------------------------------------
		//
		// Public methods
		//
		//------------------------------------------------------------------------------	
		//------------------------------------------------------------------------------
		//
		// Tile Collision Checks
		//
		//------------------------------------------------------------------------------
		
		/**
		 * 
		 *	Test collision using intersection of 2 movieclips and extractst the
		 * 	rectangle that represents the intersection of where the 2 objects collide.  
		 * 
		 * 	@param obj		MovieClip	the object to test for collision
		 * 	@param type		Int			the tile type to check for collision against
		 * 	@param callback Function	the function to call after the check is preformed
		 * 
		 *	@return void
		 * 
		 */
		public function checkTileCollision(obj:MovieClip, type:int, callback:Function):void
		{
			for (var i:int = 0; i < layout.worldObjects[type].length; i++) {
				_hit = baseCheck(obj.x, obj.y, obj.width, obj.height, type, i);
				if(_hit.width > 0 && _hit.height > 0){
					callback(_hit);
				}
			}
		}	
		
		/**
		 * 	
		 *	Checks for downward collision on the Y axis against tiles.  .  
		 * 
		 * 	@param $hitArea:Sprite	The hit area of the dwarf to test with.  
		 * 	@param $type:int			The type of tile to compare against.
		 * 	@param $callback		The function to call after the test.  
		 * 
		 *	@return void
		 * 
		 */
		public function checkYAxisCollision($hitArea:Sprite, $type:int, $callback:Function):void
		{
			var obj:Point = $hitArea.localToGlobal(new Point(0,0));
			for (var i:int = 0; i < layout.worldObjects[$type].length; i++) {
				_currentTile			= layout.worldObjects[$type][i];
				
				var upperLeft:Boolean	= _currentTile.hitTestPoint(obj.x + $hitArea.width/8, obj.y + $hitArea.height, false);
				var upperRight:Boolean 	= _currentTile.hitTestPoint(obj.x + (($hitArea.width/8)*7), obj.y + $hitArea.height, false);
				if(upperLeft || upperRight){
					$callback(true);
				}
			}
			obj = null;
		}
		
		/**
		 * 
		 *	Checks for upward collision on the Y axis against tiles.
		 * 
		 * 	@param $hitArea:Sprite	The hit area of the dwarf to test with.  
		 * 	@param $type:int		The type of tile to compare against.
		 * 	@param $callback		The function to call after the test. 
		 * 
		 *	@return void
		 * 
		 */
		public function checkYAxisCollisionUp($hitArea:Sprite, $type:int, $callback:Function):void
		{
			var obj:Point = $hitArea.localToGlobal(new Point(0,0));
			for (var i:int = 0; i < layout.worldObjects[$type].length; i++) {
				_currentTile			= layout.worldObjects[$type][i];
				
				var upperLeft:Boolean	= _currentTile.hitTestPoint(obj.x + $hitArea.width/8, obj.y, false);
				var upperRight:Boolean 	= _currentTile.hitTestPoint(obj.x + (($hitArea.width/8)*7), obj.y, false);
				if(upperLeft || upperRight){
					$callback(_currentTile.y, _currentTile.height);
				}
			}
			obj = null;
		}
		
		/**
		 * 
		 *	Checks for upward collision on the Y axis against bridge movie clips.
		 * 
		 * 	@param $hitArea:Sprite	The hit area of the dwarf to test with.  
		 * 	@param $type:int		The bridge type to compare against.
		 * 	@param $callback		The function to call after the test. 
		 * 
		 *	@return void
		 * 
		 */
		public function checkYAxisCollisionUpObj($hitArea:Sprite, $type:int, $callback:Function):void
		{
			var obj:Point = $hitArea.localToGlobal(new Point(0,0));
			for (var i:int = 0; i < layout.bridgeObjects[$type].length; i++) {
				var currentObj:MovieClip	= layout.bridgeObjects[$type][i];
				
				var upperLeft:Boolean 		= currentObj.hitTestPoint(obj.x + $hitArea.width/8, obj.y, false);
				var upperRight:Boolean 		= currentObj.hitTestPoint(obj.x + (($hitArea.width/8)*7), obj.y, false);
				if(upperLeft || upperRight){
					$callback(currentObj.y, currentObj.height + 2);
				}
			}
			obj 		= null;
			currentObj 	= null;
		}
		
		/**
		 * 
		 *	Checks for left collision on the x axis against tiles.  
		 * 
		 *	@param $hitArea:Sprite	The hit area of the dwarf to test with.  
		 * 	@param $type:int		The tile type to compare against.
		 * 	@param $callback		The function to call after the test. 
		 * 
		 *	@return void
		 * 
		 */
		public function checkXAxisLeftCollision($hitArea:Sprite, $type:int, $callback:Function):void
		{
			var obj:Point = $hitArea.localToGlobal(new Point(0,0));
			for (var i:int = 0; i < layout.worldObjects[$type].length; i++) {
				_currentTile	= layout.worldObjects[$type][i];
				var upperLeft:Boolean = _currentTile.hitTestPoint(obj.x, obj.y + $hitArea.height/2, false);
				var upperRight:Boolean = _currentTile.hitTestPoint(obj.x, obj.y + $hitArea.height-2, false);
				if(upperLeft || upperRight){
					$callback(true);
				}
			}
			obj = null;
		}
		
		/**
		 * 
		 *	Checks for Right collision on the x axis against tiles.  
		 * 
		 *	@param $hitArea:Sprite	The hit area of the dwarf to test with.  
		 * 	@param $type:int		The tile type to compare against.
		 * 	@param $callback		The function to call after the test. 
		 * 
		 *	@return void
		 * 
		 */
		public function checkXAxisRightCollision($hitArea:Sprite, $type:int, $callback:Function):void
		{
			var obj:Point = $hitArea.localToGlobal(new Point(0,0));
			for (var i:int = 0; i < layout.worldObjects[$type].length; i++) {
				_currentTile	= layout.worldObjects[$type][i];
				var upperLeft:Boolean = _currentTile.hitTestPoint(obj.x + $hitArea.width, obj.y + $hitArea.height/2, false);
				var upperRight:Boolean = _currentTile.hitTestPoint(obj.x + $hitArea.width, obj.y + $hitArea.height-2, false);
				if(upperRight || upperLeft){
					$callback(true);
				}
			}
			obj = null;
		}
		
		/**
		 * 
		 *	Checks for general collision against another movie clip.
		 * 
		 * 	@param	$obj:MovieClip		The movie clip of the dwarf to test collision against.  
		 * 	@param 	$type:int			The number that represents the object to test against.
		 * 	@param	$callabck:Function	The function to call after the test.
		 * 
		 *	@return void
		 * 
		 */
		public function checkItemCollision($obj:MovieClip, $type:int, $callback:Function):void
		{
			for (var i:int = 0; i < layout.worldItems[$type].length; i++) {
				_hit = baseCheckItem($obj.x, $obj.y, $obj.width, $obj.height, $type, i);
				if(_hit.width > 0 && _hit.height > 0){
					$callback(_hit);
				}
			}
		}
		
		/**
		 * 
		 *	Checks against all ground tile to see if the dwarf is standing on a surface.  
		 * 
		 * 	@param 	hitArea:Sprite		The hit area box of the dwarf to test collision against.
		 * 	@param 	type1:int			The type of bridge to test against.  
		 * 	@param 	type2:int			The type of tile to test againts.
		 * 	@param	callback:Function	The function to call after the test
		 * 
		 *	@return void
		 * 
		 */
		public function checkForNoGroundCollision($hitArea:Sprite, $type1:int, $type2:int, $callback:Function):void
		{
			var onGround:Boolean = false;
			var obj:Point = $hitArea.localToGlobal(new Point(0,0));
			for (var i:int = 0; i < layout.worldObjects[$type1].length; i++) {
				
				_currentTile	= layout.worldObjects[$type1][i];
				var upperLeft:Boolean = _currentTile.hitTestPoint(obj.x + $hitArea.width/8, obj.y + $hitArea.height + 10, false);
				var upperRight:Boolean = _currentTile.hitTestPoint(obj.x + (($hitArea.width/8)*7), obj.y + $hitArea.height + 10, false);
				if(upperLeft || upperRight){	onGround = true;}
			}
			
			for (var j:int = 0; j < layout.worldObjects[$type2].length; j++) {
				_currentTile	= layout.worldObjects[$type2][j];
				var upperLeft2:Boolean = _currentTile.hitTestPoint(obj.x+ $hitArea.width/8, obj.y + $hitArea.height + 10, false);
				var upperRight2:Boolean = _currentTile.hitTestPoint(obj.x + (($hitArea.width/8)*7), obj.y + $hitArea.height + 10, false);
				if(upperLeft2 || upperRight2){	onGround = true;}
			}
		
			if(!onGround){	$callback(false);	}
			obj = null;
		}	
		
		/**
		 * 
		 *	Checks to see if the dwarfs hammer hits a bridge.
		 * 
		 * 	@param $obj:MovieClip	The dwarfs movie clip to test against
		 * 	@param $type:int		The type of bridge tile to test against.
		 * 	@param $direction 		The direction the dwarf is facing at the time of the test.
		 * 
		 *	@return void
		 * 
		 */
		public function hammerBridge($obj:MovieClip, $type:int, $direction:Boolean):void
		{
			_objX = getDirectionWidth($direction, $obj);
			
			for (var i:int = 0; i < layout.worldObjects[$type].length; i++) {
				
				_currentTile		= layout.worldObjects[$type][i];
				_currentBridge		= layout.bridgeObjects[$type][i];
				_hit 				= baseCheck(_objX, $obj.y + $obj.height - $obj.height/4, $obj.width/2, $obj.height/2, $type, i);
				
				if(_hit.width > 0 && _hit.height > 0){
					
					_currentBridge.bridgeHP -=1;
					
					if(_currentBridge.bridgeHP == 0){
						destroyBridge(_currentTile, _currentBridge, $type, i);
						return
					}
					return;	
				}
			}
			return
		}	
		
		/**
		 * 
		 *	Determines the tile around the dwarf available for a bridge tile.  If the tile around the dwarf
		 * 	is an open air tile that is available this tiles position and the current tile are sent to the 
		 * 	callback function.  
		 * 
		 * 	@param $obj			MovieClip	the object to test around for open air tiles
		 * 	@param $type			Int			the tile type to check for 
		 * 	@param $direction	Boolean		the direction the dwarf is facing.  True is right and False is left
		 * 	@param $callback 	Function	the function to call after the check is preformed
		 * 
		 *	@return void
		 * 
		 */
		public function attemptBridgeBuild($obj:MovieClip, $type:int, $direction:Boolean, $level:String, $bridgeType:int, $enemyBridge:int, $callback:Function):void
		{
			for (var i:int = 0; i < layout.worldObjects[$type].length; i++) 
			{
				_objY 					= setBuildLevel($level, $obj);
				_objX 					= setBuildDirection($direction, $obj);
				_currentTile			= layout.worldObjects[$type][i];
				var isOkToBuild:Boolean	= checkConditions(_currentTile, $obj, $enemyBridge, _objY, _objX);
				
				if(_currentTile.hitTestPoint(_objX, _objY, false) && isOkToBuild){
					
					buildBridge(_currentTile, $bridgeType, $type, i);
					$callback(true);	
					_currentTile		= null;
					return
				}
				else $callback(false);
				
			}
			return;
		}	
		
		
		//------------------------------------------------------------------------------
		//
		// Rock Collision Checks
		//
		//------------------------------------------------------------------------------
		
		/**
		 * 
		 *	This function is used by dynamite to test against the explosion radius specifically for rock blocks. 
		 * 
		 * 	@param $obj		The dynamite blast move clip.
		 * 
		 *	@return void
		 * 
		 */
		public function explodeRock($obj:MovieClip):void
		{
			for (var i:int = 0; i < layout.worldItems[Layout.TYPE_ROCK].length; i++) {
				_currentRock	= layout.worldItems[Layout.TYPE_ROCK][i];
				_hit 			= baseCheckItem($obj.x-Grid.TILE_LENGTH, $obj.y-Grid.TILE_HEIGHT, Grid.TILE_LENGTH*2, Grid.TILE_HEIGHT*2, Layout.TYPE_ROCK, i);
				
				if(_hit.width > 0 && _hit.height > 0){
					_currentRock.rockLife -=1;
					if(_currentRock.rockLife == 0){
						destroyRock(_currentRock, i)
						i--;
					}
				}
			}
		}
			
		/**
		 * 
		 *	Checks to see if the dwarfs hammer hits a rock block.
		 * 
		 * 	@param $obj:MovieClip	The dwarfs movie clip to test against
		 * 	@param $direction 		The direction the dwarf is facing at the time of the test.
		 * 
		 *	@return Boolean	True or False
		 * 
		 */
		public function hammerStones($obj:MovieClip, $direction:Boolean):Boolean
		{
			_objX = getDirectionWidth($direction, $obj);
			
			for (var i:int = 0; i < layout.worldItems[Layout.TYPE_ROCK].length; i++) {
				_currentRock	= layout.worldItems[Layout.TYPE_ROCK][i];
				_hit 		= baseCheckItem(_objX, $obj.y - $obj.height/4, $obj.width/2, $obj.height+$obj.height/2, Layout.TYPE_ROCK, i);
				
				if(_hit.width > 0 && _hit.height > 0){
					_currentRock.rockLife -=1;
					if(_currentRock.rockLife == 0){
						destroyRock(_currentRock, i);
						return true;
					}
					return true;
				}
			}
			return false;
		}
		
		//------------------------------------------------------------------------------
		//
		// Bridge Collision Checks
		//
		//------------------------------------------------------------------------------
		
		/**
		 * 
		 *	Checks if the dynamite radius hits a bridge.  
		 * 
		 * 	@param $obj:MovieClip	The dynamite movie clip to test with.
		 * 	@param $type:int		The type of bridge to compare against. 
		 * 
		 *	@return void
		 * 
		 */
		public function explodeBridge($obj:MovieClip, $type:int):void
		{
			
				
			if(_state && doubleCheckStop < 1){
				var explosionRadius:Rectangle 	= new Rectangle($obj.x-Grid.TILE_LENGTH, $obj.y-Grid.TILE_HEIGHT, Grid.TILE_LENGTH*2, Grid.TILE_HEIGHT*2)
				var dwarf1:Rectangle 			= new Rectangle(_state.dwarfOne.x, _state.dwarfOne.y, _state.dwarfOne.width, _state.dwarfOne.height);
				var dwarf2:Rectangle 			= new Rectangle(_state.dwarfTwo.x, _state.dwarfTwo.y, _state.dwarfTwo.width, _state.dwarfTwo.height);
				if(explosionRadius.intersects(dwarf1)){
					_state.dwarfOne.knockBack();
				}
				if(explosionRadius.intersects(dwarf2)){
					_state.dwarfTwo.knockBack();
				}
			}
			
			doubleCheckStop ++
			if(doubleCheckStop > 1) doubleCheckStop = 0;
				
			for (var i:int = 0; i < layout.worldObjects[$type].length; i++) {
				_currentTile		= layout.worldObjects[$type][i];
				_currentBridge	= layout.bridgeObjects[$type][i];
				_hit 			= baseCheck($obj.x-Grid.TILE_LENGTH, $obj.y-Grid.TILE_HEIGHT, Grid.TILE_LENGTH*2, Grid.TILE_HEIGHT*2, $type, i);
			
				if(_hit.width > 0 && _hit.height > 0){
					layout.bridgeObjects[$type][i].bridgeHP -=1;
					if(layout.bridgeObjects[$type][i].bridgeHP == 0){
						destroyBridge(_currentTile, _currentBridge, $type, i);
						i--
					}
				}
			}
			explosionRadius = null;
			dwarf1 			= null;
			dwarf2 			= null;
		}
		
		//------------------------------------------------------------------------------
		//
		// Caslte Collision Checks
		//
		//------------------------------------------------------------------------------
		/**
		 * 
		 *	Checks if the dwarf has moved against the opposing players castle.
		 * 
		 * 	@param 	obj:MovieClip 	The dwarfs movie clip to test with.
		 * 	@param	type:int		The type of castle to check against.
		 * 	@param	callback		The function to call after the test	
		 * 
		 *	@return void
		 * 
		 */
		public function checkForCastle(obj:MovieClip, type:int, callback:Function):void
		{
			_result = obj.hitTestObject(layout.worldItems[Layout.TYPE_CASTLE][type]);
			if(_result){
				var stolenFlag:Flag = layout.worldItems[Layout.TYPE_FLAG][type];
				callback(_result, stolenFlag);
			}
			stolenFlag = null;
		}
		
		//------------------------------------------------------------------------------
		//
		// Single Player Set Up
		//
		//------------------------------------------------------------------------------
		/**
		 * 
		 *	
		 * 
		 *	@return void
		 * 
		 */
		public function randomizeChestsROne():void
		{
			var newChest:MovieClip = new mc_treasure();
			newChest.x = HORIZONTAL_EDGE_BLOCK + (((layout.ISLAND_GRID_X[0])-1) * TILE_LENGTH) + (TILE_LENGTH/2 ) - newChest.width/2;
			newChest.y = ((layout.ISLAND_GRID_Y[0]) * TILE_HEIGHT) - newChest.height -  5;
			Session.application.state.addChild(newChest);
			layout.worldItems[Layout.TYPE_CHEST].push(newChest);
			newChest = null;
			var arrayX:Array = new Array(5,6,7,8,9,10);
			var arrayY:Array = new Array(4,5,6,7,8,9,10,11,12,13,14,15,16,17,18);
			var numberX:Number;
			var numberY:Number;
			for (var i:int = 0; i < 4; i++) 
			{
				numberX = Math.floor(Math.random()*arrayX.length);
				var tileX:int = arrayX[numberX];
				arrayX.splice(numberX, 1);
				
				numberY = Math.floor(Math.random()*arrayY.length);
				var tileY:int = arrayY[numberY];
				arrayY.splice(numberY, 1);
				
				if(i>1){
				newChest = new mc_treasure();
				newChest.x = HORIZONTAL_EDGE_BLOCK + ((tileX-1) * TILE_LENGTH) + (TILE_LENGTH/2 ) - newChest.width/2;
				newChest.y = ((tileY) * TILE_HEIGHT) - newChest.height -  5;
				Session.application.state.addChild(newChest);
				layout.worldItems[Layout.TYPE_CHEST].push(newChest);
				trace(newChest.x, newChest.y, numberY, numberX);
				newChest = null;
				}
				if(i<2){
				var obst:MovieClip = new RockBlock();
				obst.x = HORIZONTAL_EDGE_BLOCK + ((tileX-1) * TILE_LENGTH) + (TILE_LENGTH/2 ) - obst.width/2;
				obst.y = ((tileY) * TILE_HEIGHT) - obst.height -  5;
				Session.application.state.addChild(obst);
				layout.worldItems[Layout.TYPE_ROCK].push(obst);
				}
				
			}
			
			newChest	= null;
			arrayX		= null;
			arrayY		= null;
			obst 		= null;
			
			
		}
		
		/**
		 * 
		 *	
		 * 
		 *	@return void
		 * 
		 */
		public function randomizeChestsRTwo():void
		{
			var newChest:MovieClip = new mc_treasure();
			newChest.x = HORIZONTAL_EDGE_BLOCK + (((layout.ISLAND_GRID_X[0])-1) * TILE_LENGTH) + (TILE_LENGTH/2 ) - newChest.width/2;
			newChest.y = ((layout.ISLAND_GRID_Y[0]) * TILE_HEIGHT) - newChest.height -  5;
			Session.application.state.addChild(newChest);
			layout.worldItems[Layout.TYPE_CHEST].push(newChest);
			newChest = null;
			var arrayX:Array = new Array(5,6,7,8,9,10);
			var arrayY:Array = new Array(4,5,6,7,8,9,10,11,12,13,14,15,16,17,18);
			var numberX:Number;
			var numberY:Number;
			for (var i:int = 0; i < 5; i++) 
			{
				numberX = Math.floor(Math.random()*arrayX.length);
				var tileX:int = arrayX[numberX];
				arrayX.splice(numberX, 1);
				
				numberY = Math.floor(Math.random()*arrayY.length);
				var tileY:int = arrayY[numberY];
				arrayY.splice(numberY, 1);
				
				trace(numberX, numberY);
				trace(tileX, tileY);
				trace(arrayX + "   " + arrayY);
				if(i>2){
					newChest = new mc_treasure();
					newChest.x = HORIZONTAL_EDGE_BLOCK + ((tileX-1) * TILE_LENGTH) + (TILE_LENGTH/2 ) - newChest.width/2;
					newChest.y = ((tileY) * TILE_HEIGHT) - newChest.height -  5;
					Session.application.state.addChild(newChest);
					layout.worldItems[Layout.TYPE_CHEST].push(newChest);
					newChest = null;
				}
				if(i<3){
					var obst:MovieClip = new RockBlock();
					obst.x = HORIZONTAL_EDGE_BLOCK + ((tileX-1) * TILE_LENGTH) + (TILE_LENGTH/2 ) - obst.width/2;
					obst.y = ((tileY) * TILE_HEIGHT) - obst.height -  5;
					Session.application.state.addChild(obst);
					layout.worldItems[Layout.TYPE_ROCK].push(obst);
				}
			}
			
			newChest	= null;
			arrayX		= null;
			arrayY		= null;
			obst 		= null;
		}
		
		/**
		 * 
		 *	
		 * 
		 *	@return void
		 * 
		 */
		public function randomizeChestsRThree():void
		{
			var newChest:MovieClip = new mc_treasure();
			newChest.x = HORIZONTAL_EDGE_BLOCK + (((layout.ISLAND_GRID_X[0])-1) * TILE_LENGTH) + (TILE_LENGTH/2 ) - newChest.width/2;
			newChest.y = ((layout.ISLAND_GRID_Y[0]) * TILE_HEIGHT) - newChest.height -  5;
			Session.application.state.addChild(newChest);
			layout.worldItems[Layout.TYPE_CHEST].push(newChest);
			newChest = null;
			var arrayX:Array = new Array(5,6,7,8,9,10);
			var arrayY:Array = new Array(4,5,6,7,8,9,10,11,12,13,14,15,16,17,18);
			var numberX:Number;
			var numberY:Number;
			for (var i:int = 0; i < 5; i++) 
			{
				numberX = Math.floor(Math.random()*arrayX.length);
				var tileX:int = arrayX[numberX];
				arrayX.splice(numberX, 1);
				
				numberY = Math.floor(Math.random()*arrayY.length);
				var tileY:int = arrayY[numberY];
				arrayY.splice(numberY, 1);
				
				trace(numberX, numberY);
				trace(tileX, tileY);
				trace(arrayX + "   " + arrayY);
				if(i==5){
					newChest = new mc_treasure();
					newChest.x = HORIZONTAL_EDGE_BLOCK + (10 * TILE_LENGTH) + (TILE_LENGTH/2 ) - newChest.width/2;
					newChest.y = (13 * TILE_HEIGHT) - newChest.height -  5;
					Session.application.state.addChild(newChest);
					layout.worldItems[Layout.TYPE_CHEST].push(newChest);
					newChest = null;
				}
				
				if(i<5){
					var obst:MovieClip = new RockBlock();
					obst.x = HORIZONTAL_EDGE_BLOCK + ((tileX-1) * TILE_LENGTH) + (TILE_LENGTH/2 ) - obst.width/2;
					obst.y = ((tileY) * TILE_HEIGHT) - obst.height -  5;
					Session.application.state.addChild(obst);
					layout.worldItems[Layout.TYPE_ROCK].push(obst);
				}
			}
			newChest	= null;
			arrayX		= null;
			arrayY		= null;
			obst 		= null;
		}
		
		public function dealloc():void
		{
			layout 			= null;
			_hit 			= null;
			_currentTile 	= null;
			_currentBridge 	= null;
			_r1 			= null;
			_r2 			= null;
			_currentRock 	= null;
			_state 			= null;
		}
		
		//------------------------------------------------------------------------------
		//
		// Private methods
		//
		//------------------------------------------------------------------------------
		
		/**
		 * 
		 *	This method sets the build positioning when building a bridge
		 * 	depending on whether the player is tyring to build up down or 
		 * 	straight ahead.
		 * 
		 * 	@param $level:String	The direction the player wants to build in
		 * 	@param $obj:MovieClip	The dwarf that is trying to build the bridge
		 * 
		 *	@return _newPos:int		The revised y position for build attempt.
		 * 
		 */
		private function setBuildLevel($level:String, $obj:MovieClip):int
		{
			switch($level){
				case "up":
					_newPos = $obj.y + ($obj.height/2) + 5;
					break;
				case "front":
					_newPos = $obj.y + (($obj.height/2)+25);
					break;
				case "down":
					_newPos = $obj.y + (($obj.height/2)+50);
					break;
			}
			return _newPos;
		}
		
		/**
		 * 
		 *	This method sets the direction the player is attempting to perform an action in.
		 * 
		 * 	@param $level:String	The direction the player is acting on.
		 * 	@param $obj:MovieClip	The dwarf that is trying perform the aciton.
		 * 
		 *	@return _newPos:int		The revised x position for build attempt.
		 * 
		 */
		private function setBuildDirection($direction:Boolean, $obj:MovieClip):int
		{
			switch($direction){
				case true:
					_newPos = ($obj.x + $obj.width/2) + 40;
					break;
				case false:
					_newPos = ($obj.x + $obj.width/2) - 40;
					break;
			}
			return _newPos;
		}
		
		/**
		 * 
		 *	This method sets the position the player is attempting to perform an action in.
		 * 
		 * 	@param $level:String	The direction the player is acting on.
		 * 	@param $obj:MovieClip	The dwarf that is trying perform the aciton.
		 * 
		 *	@return _newPos:int		The revised x position for build attempt.
		 * 
		 */
		private function getDirectionWidth($direction:Boolean, $obj:MovieClip):int
		{
			switch($direction){
				case true:
					_newPos = $obj.x + $obj.width
					break;
				case false:
					_newPos = $obj.x - $obj.width/2
					break;
			}
			return _newPos;
		}
		
		/**
		 * 
		 *	Checks for an enemy bridge.  Used to prevent building over other player bridges.
		 * 	
		 * 	@param $objY:int		The hit area y position to check against bridges.
		 * 	@param $objX:int		The hit area x position to check against bridges.
		 * 	@param $enemyBridge:int	The enemy bridge tilet type.
		 * 
		 *	@return _result:Boolean	True for a hit false for not.
		 * 
		 */
		private function checkForExistingEnemyBridges($objY:int, $objX:int, $enemyBridge:int):Boolean
		{
			_result = false;
			for (var j:int = 0; j < layout.worldObjects[$enemyBridge].length; j++) 
			{
				if(layout.worldObjects[$enemyBridge][j].hitTestPoint($objX, $objY, false)){
					_result = true;
				}
			}
			return _result;
		}
		
		/**
		 * 
		 *	This is a base method for checking an object for collision with a tile. 
		 * 	The funciton expects to be called from within a loop.  
		 * 	
		 * 	@param $objectX:int		The x position of the object to test with.
		 * 	@param $objectY:int 	The y position of the object to test with. 
		 * 	@param $objectW:int		The width in pixels of the object to test with.
		 * 	@param $objectH:int 	The	hieght in pixels of the object to test with.
		 * 	@param $tileType:int	The type of tile to test against.
		 * 	@param $interval:int	The interval of the loop this baseCheck is run in.  
		 * 
		 *	@return _hit:Rectangle	A rectangle representing the hit area of the object and the tile.  
		 * 
		 */
		private function baseCheck($objectX:int, $objectY:int, $objectW:int, $objectH:int, $tileType:int, $interval:int):Rectangle
		{
			_currentTile	= layout.worldObjects[$tileType][$interval];
			_r1				= new Rectangle(_currentTile.x, _currentTile.y, _currentTile.width, _currentTile.height);
			_r2				= new Rectangle($objectX, 		$objectY, 		$objectW, 			$objectH);
			_hit			= _r2.intersection(_r1);
			
			return _hit;
		}
		
		/**
		 * 
		 *	This is a base method for checking an object for collision with a movie clip. 
		 * 	The funciton expects to be called from within a loop.  
		 * 	
		 * 	@param $objectX:int		The x position of the object to test with.
		 * 	@param $objectY:int 	The y position of the object to test with. 
		 * 	@param $objectW:int		The width in pixels of the object to test with.
		 * 	@param $objectH:int 	The	hieght in pixels of the object to test with.
		 * 	@param $itemType:int	The type of object to test against
		 * 	@param $interval:int	The interval of the loop this baseCheck is run in.  
		 * 
		 *	@return _hit:Rectangle	A rectangle representing the hit area of the object and the tile.  
		 * 
		 */
		private function baseCheckItem($objectX:int, $objectY:int, $objectW:int, $objectH:int, $itemType:int, $interval:int):Rectangle
		{
			var currentItem:Object	= layout.worldItems[$itemType][$interval];
			_r1						= new Rectangle(currentItem.x, 	currentItem.y, 	currentItem.width, 	currentItem.height);
			_r2						= new Rectangle($objectX, 		$objectY, 		$objectW, 			$objectH);
			_hit					= _r2.intersection(_r1);
			
			currentItem = null;
			return _hit;
		}
		
		
		/**
		 * 
		 *	This method removes a bridge movie clip and tile and replaces is it with an air tile.
		 * 	This method is meant to be called form within a for loop.	
		 * 
		 * 	@param 	$currentTile:Tile		The bridge tile to exchange
		 * 	@param 	$currentBridge:Bridge	The bridge class containing the bridge movie clip to remove.   
		 * 	@param 	$type:int				The array position of the bridge tile and bridge movieclip.
		 * 	@param	$i:int					The interval of the loop this method is called from. 
		 * 
		 *	@return void
		 * 
		 */
		private function destroyBridge($currentTile:Tile, $currentBridge:Bridge, $type:int, $i:int):void
		{
			Session.sound.play						("bridgeCollapse");
			Session.application.state.removeChild	($currentTile);
			Session.application.state.removeChild	($currentBridge);
			layout.bridgeObjects	[$type].splice	($i, 1);
			layout.worldObjects		[$type].splice	($i, 1);
			
			var airTile:Tile 						= new Tile(Tile.TYPE_AIR);
			airTile.x 								= $currentTile.x;
			airTile.y 								= $currentTile.y;
			Session.application.state.addChild		(airTile);
			layout.worldObjects[Tile.TYPE_AIR].push	(airTile);
			
			airTile 								= null;
		}
		
		/**
		 * 
		 *	This method removes a rock movie clip and tile and replaces is it with a treasure move clip.
		 * 	This method is meant to be called form within a for loop.	
		 * 
		 * 	@param	$currentRock:MovieClip	The current rock to destroy	
		 * 	@param	$i:int					The current iteration of the loop this method is called from.
		 * 
		 *	@return void
		 * 
		 */
		private function destroyRock($currentRock:MovieClip, $i:int):void
		{
			Session.sound.play							("rockBreak");
			Session.application.state.removeChild		(layout.worldItems[Layout.TYPE_ROCK][$i]);
			layout.worldItems[Layout.TYPE_ROCK].splice	($i, 1);
			
			var newChest:MovieClip 						= new mc_treasure();
			newChest.x 									= $currentRock.x + $currentRock.width/4;
			newChest.y 									= $currentRock.y + $currentRock.height/4;
			Session.application.state.addChild			(newChest);
			layout.worldItems[Layout.TYPE_CHEST].push	(newChest);
			newChest 									= null;
		}
		
		/**
		 * 
		 *	Adds the bridge tile and movie clip to the stage.  Replaces an air tile for a bridge tile.
		 * 	This method expects to be called from a loop. 
		 * 
		 * 	@param 	$currentTile:Tile	The air tile to remove.  
		 * 	@param	$bridgeType:int		The player number for the bridge to be created
		 * 	@param	$type:int			The type of tile to remove.  
		 * 	@param	$i:int				The current iteration of the loop this method is called from.
		 * 
		 *	@return void
		 * 
		 */
		private function buildBridge($currentTile:Tile, $bridgeType:int, $type:int, $i:int):void
		{
			layout.worldObjects[$type].splice		($i, 1);
			Session.application.state.removeChild	($currentTile);
			
			var bridgeTile:Tile = new Tile			($bridgeType);
			bridgeTile.x 							= $currentTile.x;
			bridgeTile.y 							= $currentTile.y;
			Session.application.state.addChild		(bridgeTile);
			layout.worldObjects[$bridgeType].push	(bridgeTile);
			
			var bridge_mc:MovieClip 				= new Bridge();
			bridge_mc.x 							= bridgeTile.x;
			bridge_mc.y 							= bridgeTile.y - 10;
			Session.application.state.addChild		(bridge_mc);
			layout.bridgeObjects[$bridgeType].push	(bridge_mc);
			
			bridgeTile 								= null;
			bridge_mc								= null;
		}
		
		/**
		 * 
		 *	This is a helper method when trying to build a bridge.  This method checks three conditions and 
		 * 	returns true if all conditions are ideal for building a bridge.  One is to make sure the bridge cannot
		 * 	be built in the same tile the dwarf is within.  The second is that the dwarf shall not be able to build	
		 * 	in the tile directly beneath him and thirdly that the dwarf cannot build a bridge over another enemy bridge. 
		 * 
		 * 	@param $currentTile:Tile	The tile the palyer is trying to build into.
		 * 	@param $obj:MovieClip		The dwarf movie clip who is trying to build a bridge.
		 * 	@param	$enemyBridge:int	The enemy players bridge type number. 
		 * 	@param	$objY:int			The y position of where the bridge is to go.
		 * 	@param 	$objX:int			The x poistion of where the bridge is to go.
		 * 
		 *	@return Boolean				True all conditions are acceptable true is returned.  Otherwise false is returned. 
		 * 
		 */
		private function checkConditions($currentTile:Tile, $obj:MovieClip, $enemyBridge:int, $objY:int, $objX:int):Boolean
		{
			var self:Boolean 			= $currentTile.hitTestPoint($obj.x+$obj.width/2, $obj.y + $obj.height/2, false);
			var underTile:Boolean 		= $currentTile.hitTestPoint($obj.x + $obj.width/2, $obj.y + (($obj.height/2)+50), false); 
			
			var _enemyBridge:Boolean	= checkForExistingEnemyBridges($objY, $objX, $enemyBridge)
			
			if(!self && !underTile && !_enemyBridge && $currentTile.y > 80){ return true; }
			else { return false; }
		}
		
	
}
		
	
}
