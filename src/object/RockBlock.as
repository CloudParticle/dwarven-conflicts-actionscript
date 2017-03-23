package object
{
	
	//------------------------------------------------------------------------------
	//
	// Imports
	//
	//------------------------------------------------------------------------------
	import flash.display.MovieClip;
	
	import se.lnu.mediatechnology.stickossdk.display.IStickOsDisplayObject;
	//------------------------------------------------------------------------------
	//
	// Public class
	//
	//------------------------------------------------------------------------------
	/**
	 *
	 *	An instance of the rock block movie clip
	 * 
	 *	@author		Chris Shields
	 *	@version 	1.0
	 *
	 */
	public class RockBlock extends MovieClip implements IStickOsDisplayObject
	{
		//------------------------------------------------------------------------------
		//
		// Private properties
		//
		//------------------------------------------------------------------------------
		private var rock	:MovieClip 	= new mc_rockFormation();
		private var chest	:MovieClip 	= new mc_treasure();	
		//------------------------------------------------------------------------------
		//
		// Public properties
		//
		//------------------------------------------------------------------------------
		public var rockLife	:int 		= 2;
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
		 */
		public function RockBlock()
		{
			super();
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
			addChild	(rock);
			addChild	(chest);
			chest.x 	= rock.width/4;
			chest.y 	= rock.height/4;
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
			if(rockLife == 2)	rock.gotoAndStop("complete");
			
			if(rockLife == 1)	rock.gotoAndStop("damaged");	
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
			trace("dealloc from rockBlock");
			rock 	= null;
			chest 	= null;
		}
	}
}