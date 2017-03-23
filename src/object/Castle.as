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
	 *	Instance of the caslte Movie Clip
	 * 
	 *	@author		Chris Shields
	 *	@version 	1.0
	 *
	 */
	public class Castle extends MovieClip implements IStickOsDisplayObject
	{
		//------------------------------------------------------------------------------
		//
		// Public properties
		//
		//------------------------------------------------------------------------------
		public var playerCastle		:MovieClip 	= new mc_tower;
		public var hasItsflag		:Boolean 	= true;
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
		public function Castle()
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
			addChild(playerCastle);
		}
		
		/**
		 * 
		 *	Updates every frame automatically. 
		 * 
		 *	@return void
		 * 
		 */
		public function update():void{}
		
		/**
		 * 
		 *	Method to clean up the class before it is removed. Event listeners
		 *  are removed here.
		 * 
		 *	@return void
		 * 
		 */
		public function dealloc():void
		{
			trace("dealloc from castle");
			removeChild(playerCastle);
			playerCastle = null;
		}
	}
}