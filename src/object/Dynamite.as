package object
{
	//------------------------------------------------------------------------------
	//
	// Imports
	//
	//------------------------------------------------------------------------------
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import math.Grid;
	import math.Layout;
	
	import se.lnu.mediatechnology.stickossdk.core.Session;
	import se.lnu.mediatechnology.stickossdk.display.IStickOsDisplayObject;
	
	import tile.Tile;
	
	import ui.Score;
	//------------------------------------------------------------------------------
	//
	// Public class
	//
	//------------------------------------------------------------------------------
	/**
	 *
	 *	Instance of the dynamite Movie Clip
	 * 
	 *	@author		Chris Shields
	 *	@version 	1.0
	 *
	 */
	public class Dynamite extends MovieClip implements IStickOsDisplayObject
	{
		//------------------------------------------------------------------------------
		//
		// Private properties
		//
		//------------------------------------------------------------------------------
		private var _previous		:Point 		= new Point;
		private var _throwSpeed		:Number 	= 3;
		private var _ySpeed			:Number 	= 5;
		private var _direction		:Boolean;
		private var _dynamite		:MovieClip;
		private var _map			:Grid;
		private var _playerNumber	:int;
		private var _ui				:Score;
		//------------------------------------------------------------------------------
		//
		// Public properties
		//
		//------------------------------------------------------------------------------
		public var isOnStage		:Boolean 	= true;
		//------------------------------------------------------------------------------
		//
		// Constructor method
		//
		//------------------------------------------------------------------------------
		/**
		 *
		 *	The class constructor.
		 * 
		 * 	@param $x:int				X position of the dwarf who initiated this dynamite
		 * 	@param $y:int				Y position of the dwarf who initiated this dynamite
		 * 	@param $palyerNumber:int	The player number of the dwarf who initiated this dynamite
		 * 	@param $grid:Grid			The instance of the grid for this session. 
		 * 	@param	$ui:Score			The instance of Score for the dwarf who initiated this dynamite.
		 * 
		 * 
		 *	@return void
		 *
		 */
		public function Dynamite(x:int, y:int, dir:Boolean, $playerNumber:int, $grid:Grid, $ui:Score)
		{
			super();
			_map 			= $grid;
			_direction 		= dir
			_ui 			= $ui;
			_playerNumber 	= $playerNumber;
		}
		
		//------------------------------------------------------------------------------
		//
		// Public methods
		//
		//------------------------------------------------------------------------------
		/**
		 * 
		 *	A secondary constructor.  Initiates the class. 
		 * 
		 *	@return void
		 * 
		 */
		public function init():void
		{
			Session.sound.play		("dynamiteFuse");
			_dynamite 				= new mc_dynamite();
			isOnStage 				= true;
			addChild				(_dynamite);
			_dynamite.gotoAndStop	("lit");
			
		}
		
		/**
		 *
		 * 	Overrides super class to add gravity to this class.
		 * 	Runs automatically each frame. 
		 * 
		 *	@return void
		 *
		 */
		public function update():void
		{
			enableGravity();
			
			checkForInitialCollisions();
			
			this._previous.x = this.x;
			this._previous.y = this.y;
			
			checkIfDynamiteLeftStage();
		}
		
		/**
		 *
		 * 	Overrides super class. Method to clean up the class before it is removed. 
		 * 	Event listeners are removed here.
		 * 
		 *	@return void
		 *
		 */
		public function dealloc():void
		{
			trace("dealoc from dynamite");
			if(_dynamite)removeChild(_dynamite);
			_previous 	= null;
			_dynamite 	= null;
			_map 		= null;
			_ui 		= null;
			
		}
		//------------------------------------------------------------------------------
		//
		// Private methods
		//
		//------------------------------------------------------------------------------
		
		/**
		 *
		 * 	Checks collisions against the flyings stick of dynamite. 
		 * 
		 *	@return void
		 *
		 */
		private function checkForInitialCollisions():void
		{
			_map.checkTileCollision(this, Tile.TYPE_BRIDGE1, onHit);
			_map.checkTileCollision(this, Tile.TYPE_BRIDGE2, onHit);
			_map.checkTileCollision(this, Tile.TYPE_GROUND, onHit);
			_map.checkTileCollision(this, Tile.TYPE_EDGE_AIR, onHit);
			checkRockCollision();
		}
		
		/**
		 *
		 * 	Checks to see if the dynamite has fallen below the stage height.  
		 *	@return void
		 *
		 */
		private function checkIfDynamiteLeftStage():void
		{
			if( this.y > Grid.STAGE_HEIGHT)
			{
				Session.sound.stop						("dynamiteFuse");
				resetDynamiteIcon();
				isOnStage								= false;
				Session.application.state.removeChild	(this);	
			}
		}
		
		/**
		 * 
		 *	Checks collision against rock blocks in singleplayer.  
		 * 
		 *	@return void
		 * 
		 */
		private function checkRockCollision():void
		{
			for (var i:int = 0; i < _map.layout.worldItems[Layout.TYPE_ROCK].length; i++) {
				if(this.hitTestObject(_map.layout.worldItems[Layout.TYPE_ROCK][i])){
					var rec:Rectangle 	= new Rectangle(0,0,10,1)
					onHit				(rec);
				}
			}
			rec = null;
		}
		
		/**
		 * 
		 *	Handles gravity and y axis movement for the dynamite stick.    
		 * 
		 *	@return void
		 * 
		 */
		private function enableGravity():void
		{
			if(_direction)		{this.x 		= this.x + (_throwSpeed);}
			if(!_direction)		{this.x			= this.x - (_throwSpeed);}
			
			this.y 								= this.y+2;
			this.y 								= this.y - (_ySpeed);	
			_ySpeed 							-= .05;
			_throwSpeed							-= .01;
			
			if(_throwSpeed < 0)	{_throwSpeed 	= 0.001;}
		}
		
		
		
		/**
		 * 
		 *	Adjusts the players UI bar when throwing dynamite. 
		 * 
		 *	@return void
		 * 
		 */
		private function resetDynamiteIcon():void
		{
			_ui.dynamiteAlpha = true;		
		}
		
		
		
		/**
		 *
		 * 	Checks for collision once the dynamite has exploded. This
		 * 	is where the explosion collision is handled.  Not to be confused
		 * 	with the dynamite stick collision.  
		 * 
		 *	@return void
		 *
		 */
		private function checkForHits():void
		{
			_map.explodeRock	(this);
			_map.explodeBridge	(this, Tile.TYPE_BRIDGE1);
			_map.explodeBridge	(this, Tile.TYPE_BRIDGE2);
		}
		
		/**
		 *
		 * 	Enacted when the dynamite explodes.  Sets UI and stage 
		 * 	variables appropriately and removes this class from the stage.   
		 * 
		 *	@return void
		 *
		 */
		private function explodeDynamite():void
		{
			resetDynamiteIcon();
			isOnStage	= false;
			checkForHits();
			Session.application.state.removeChild(this);
		}
		
		/**
		 *
		 * 	Enacted when the dynamite has hit something.  
		 * 	Begins the explision process of the dynamite.   
		 * 
		 * 	@param $result:Rectangle. 	Rectanlge representing the width and height of intersection of collision. 	
		 * 
		 *	@return void
		 *
		 */
		private function onHit($result:Rectangle):void
		{	
			if ($result.width > 0 && $result.height > 0) {
				if ($result.width > $result.height) {
					
					if(this._previous.y == 0){this._previous.y = this.y};
					
					this.y 					= this._previous.y;
					_throwSpeed 			= .4;
					_dynamite.gotoAndStop	("explosion");
					if(isOnStage){
						Session.sound.stop					("dynamiteFuse");
						Session.sound.play					("explosion", 0.2);
						Session.application.state.setPause	(.5, explodeDynamite);
					}
					isOnStage 				= false;	
				}
				else if ($result.height > $result.width) {
					
					if(this._previous.x == 0){this._previous.x = this.x};
					
					this.x 					= this._previous.x;
					_throwSpeed 			= 0;
				}	
			}
		}	
	}
}