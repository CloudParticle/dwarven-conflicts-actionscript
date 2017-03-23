package object
{
	//------------------------------------------------------------------------------
	//
	// Imports
	//
	//------------------------------------------------------------------------------
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	
	import math.Grid;
	import math.Layout;
	
	import se.lnu.mediatechnology.stickossdk.display.IStickOsDisplayObject;
	
	import tile.Tile;
	//------------------------------------------------------------------------------
	//
	// Public class
	//
	//------------------------------------------------------------------------------
	/**
	 *
	 *	Instance of the flag Movie Clip
	 * 
	 *	@author		Chris Shields
	 *	@version 	1.0
	 *
	 */
	public class Flag extends MovieClip implements IStickOsDisplayObject
	{
		//------------------------------------------------------------------------------
		//
		// Private properties
		//
		//------------------------------------------------------------------------------
		private var _Grid		:Grid
		//------------------------------------------------------------------------------
		//
		// Public properties
		//
		//------------------------------------------------------------------------------
		public var flag			:MovieClip 	= new mc_flag();
		public var inCastle		:Boolean 	= true;
		public var flagsPlayer	:int;
		//------------------------------------------------------------------------------
		//
		// Constructor method
		//
		//------------------------------------------------------------------------------
		/**
		 *
		 *	The class constructor.
		 * 	
		 * 	@param $grid:Grid			The instance of the grid for this session.
		 * 
		 *	@return void
		 */
		public function Flag($grid:Grid)
		{
			super();
			_Grid = $grid;
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
			addChild(flag);
		}
		
		/**
		 *
		 * 	Updates every frame automatically.  
		 * 
		 *	@return void
		 *
		 */
		public function update():void
		{
			if(!inCastle){
			this.y 			= this.y + 3;
			checkCollision();
			}
			if(this.y > Grid.STAGE_HEIGHT){
				inCastle 	= true;
				this.y 		= _Grid.layout.worldItems[Layout.TYPE_CASTLE][flagsPlayer].y - this.height/3;
				this.x 		= _Grid.layout.worldItems[Layout.TYPE_CASTLE][flagsPlayer].x + 30
				_Grid.layout.worldItems[Layout.TYPE_CASTLE][flagsPlayer].hasItsflag 	= true;
			}
		}
		
		/**
		 *
		 * 	Cleans method
		 * 
		 *	@return void
		 *
		 */
		public function dealloc():void
		{
			
		}
		
		/**
		 *
		 * 	Cleaner method for Session end.  Only to be used to clean this class at the end of a game sesion. 
		 * 
		 *	@return void
		 *
		 */
		public function deallocFlag():void
		{
			trace("dealloc from flag");
			if(flag)removeChild(flag);
			_Grid 	= null;
			flag 	= null;
		}
		
		//------------------------------------------------------------------------------
		//
		// Private methods
		//
		//------------------------------------------------------------------------------
		/**
		 *
		 * 	Checks collisions while the flag has gravity. 
		 * 
		 *	@return void
		 *
		 */
		private function checkCollision():void
		{
			_Grid.checkTileCollision(this, Tile.TYPE_GROUND, 		onHit);
			_Grid.checkTileCollision(this, Tile.TYPE_EDGE_GROUND, 	onHit);
			_Grid.checkTileCollision(this, Tile.TYPE_BRIDGE1, 		onHit);
			_Grid.checkTileCollision(this, Tile.TYPE_BRIDGE2, 		onHit);
		}
		
		/**
		 *
		 * 	Handles collisions if there are any. 
		 * 
		 * 	@param 	$result:Rectangle. 	Rectanlge representing the width and height of intersection of collision. 
		 * 
		 *	@return void
		 *
		 */
		private function onHit($result:Rectangle):void
		{
			if($result.width > 0 && $result.height){
				this.y = this.y - $result.height;
			}
		}
	}
}