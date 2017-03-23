package tile
{
	//------------------------------------------------------------------------------
	//
	// Imports
	//
	//------------------------------------------------------------------------------
	import flash.display.MovieClip;
	
	import math.Grid;
	
	import se.lnu.mediatechnology.stickossdk.core.Session;

	//------------------------------------------------------------------------------
	//
	// Public class
	//
	//------------------------------------------------------------------------------
	
	/**
	 *
	 *	Class for a tile.  Tiles although invisible make up the physical world of the 
	 * 	game.
	 * 
	 *	@author		Chris Shields
	 *	@version 	1.0
	 *
	 */
	public class Tile extends MovieClip
	{
		//------------------------------------------------------------------------------
		//
		// Public static constants
		//
		//------------------------------------------------------------------------------
		public static const TYPE_AIR			:int	= 2;
		public static const TYPE_GROUND			:int	= 3;
		public static const TYPE_BRIDGE1		:int	= 0;
		public static const TYPE_BRIDGE2		:int	= 1;
		
		public static const TYPE_EDGE_AIR		:int	= 4;
		public static const TYPE_EDGE_GROUND	:int	= 5;
		public static const TYPE_EDGE_BRIDGE1	:int	= 6;
		public static const TYPE_EDGE_BRIDGE2	:int	= 7;
		//------------------------------------------------------------------------------
		//
		// Public properties
		//
		//------------------------------------------------------------------------------
		public var type							:int;
		//------------------------------------------------------------------------------
		//
		// Private properties
		//
		//------------------------------------------------------------------------------
		private var _block						:MovieClip;
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
		public function Tile($type:int)
		{
			super			();
			this.type 		= $type;
			initTyleType	();
			addChild		(_block);
		}
		
		//------------------------------------------------------------------------------
		//
		// Public methods
		//
		//------------------------------------------------------------------------------
		/**
		 * 
		 *	Cleans the class.
		 * 
		 *	@return void
		 * 
		 */
		public function dealloc():void
		{
			trace("dealloc from Tile");
			if(_block) Session.application.state.removeChild(_block);
			removeChild(_block);
			_block = null;
		}
		//------------------------------------------------------------------------------
		//
		// Private methods
		//
		//------------------------------------------------------------------------------
		/**
		 * 
		 *	Back up method to establish tile types.  This acts as a switchboard
		 * 	to dictate what type of tile this instance will be.  This back up 
		 * 	method is intended for debugging as the tile is given some opacity
		 * 	and color.  This function should be commented out when debugging is done.
		 * 
		 *	@return void
		 * 
		 */
	/*private function initTyleType():void
		{
			switch(type){
				case TYPE_AIR:
					block = new MovieClip();
					block.graphics.beginFill(0xFF0000FF);
					block.graphics.drawRect(0, 0, Grid.TILE_LENGTH, Grid.TILE_HEIGHT);
					block.alpha = .4;
					break;
				case TYPE_BRIDGE1:
					block = new MovieClip();
					block.graphics.beginFill(0x8B4E24);
					block.graphics.drawRect(0, 0, Grid.TILE_LENGTH, Grid.TILE_HEIGHT);
					block.alpha = .4;
					break;
				case TYPE_BRIDGE2:
					block = new MovieClip();
					block.graphics.beginFill(0x8B4E24);
					block.graphics.drawRect(0, 0, Grid.TILE_LENGTH, Grid.TILE_HEIGHT);
					block.alpha = .4;
					break;
				case TYPE_GROUND:
					block = new MovieClip();
					block.graphics.beginFill(0x43B331);
					block.graphics.drawRect(0, 0, Grid.TILE_LENGTH, Grid.TILE_HEIGHT);
					block.alpha =.4;
					break;
				case TYPE_EDGE_AIR:
					block = new MovieClip();
					block.graphics.beginFill(0x4ACAD8);
					block.graphics.drawRect(0, 0, Grid.HORIZONTAL_EDGE_BLOCK, Grid.TILE_HEIGHT);
					block.alpha =.4;
					break;
				case TYPE_EDGE_GROUND:
					block = new MovieClip();
					block.graphics.beginFill(0x317F25);
					block.graphics.drawRect(0, 0, Grid.HORIZONTAL_EDGE_BLOCK, Grid.TILE_HEIGHT);
					block.alpha =.4;
					break;
				case TYPE_EDGE_BRIDGE1:
					block = new MovieClip();
					block.graphics.beginFill(0xFF0000);
					block.graphics.drawRect(0, 0, Grid.HORIZONTAL_EDGE_BLOCK, Grid.TILE_HEIGHT);
					block.alpha =.4;
					break;
				case TYPE_EDGE_BRIDGE2:
					block = new MovieClip();
					block.graphics.beginFill(0xFF0000);
					block.graphics.drawRect(0, 0, Grid.HORIZONTAL_EDGE_BLOCK, Grid.TILE_HEIGHT);
					block.alpha = .4;
					break;
				
			}
		}*/
		
		/**
		 * 
		 *	This method is a switch board that dicatates what type of tile
		 * 	this instance will be.  All tiles are invisible and represent 
		 * 	only the physical collision aspects of the world.  This tile
		 * 	map is overlaid with movie clips to give graphical representation 
		 * 	to the world.  
		 * 
		 *	@return void
		 * 
		 */
		private function initTyleType():void
		{
			switch(type){
				case TYPE_BRIDGE1:
				case TYPE_AIR:
				case TYPE_BRIDGE2:
				case TYPE_GROUND:
					_block 						= new MovieClip();
					_block.graphics.drawRect	(0, 0, Grid.TILE_LENGTH, Grid.TILE_HEIGHT);
					_block.alpha 				= 0;
					_block.cacheAsBitmap 		= true;
					break;
				case TYPE_EDGE_AIR:
				case TYPE_EDGE_GROUND:
				case TYPE_EDGE_BRIDGE1:
				case TYPE_EDGE_BRIDGE2:
					_block 						= new MovieClip();
					_block.graphics.drawRect	(0, 0, Grid.HORIZONTAL_EDGE_BLOCK, Grid.TILE_HEIGHT);
					_block.alpha 				= 0;
					_block.cacheAsBitmap 		= true;
					break;
				
			}
		}
	}
}