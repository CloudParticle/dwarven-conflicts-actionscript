package object
{
	//------------------------------------------------------------------------------
	//
	// Imports
	//
	//------------------------------------------------------------------------------
	import flash.display.MovieClip;
	//------------------------------------------------------------------------------
	//
	// Public class
	//
	//------------------------------------------------------------------------------
	/**
	 *
	 *	The tree class is an invisible representation of the tree on one of the islands.  
	 * 	It simply acts as a hit box for the dwarfs hammer swings. 
	 * 
	 *	@author		Chris Shields
	 *	@version 	1.0
	 *
	 */
	public class Tree extends MovieClip
	{
		//------------------------------------------------------------------------------
		//
		// Private properties
		//
		//------------------------------------------------------------------------------
		private var _tree:MovieClip;
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
		public function Tree()
		{
			super();
			buildTree();
		}
		
		//------------------------------------------------------------------------------
		//
		// Public methods
		//
		//------------------------------------------------------------------------------
		/**
		 *
		 * 	Cleans method
		 * 
		 *	@return void
		 *
		 */
		public function dealloc():void
		{
			trace("dealloc from tree");
			removeChild(_tree);
			_tree = null;
		}
		
		//------------------------------------------------------------------------------
		//
		// Private methods
		//
		//------------------------------------------------------------------------------
		
		/**
		 *
		 *	Builds the tree hit box 
		 * 
		 *	@return void
		 */
		private function buildTree():void
		{
			_tree 						= new MovieClip();
			_tree.graphics.beginFill	(0x000000);
			_tree.graphics.drawRect		(0, 0, 23, 35);
			_tree.graphics.endFill();
			_tree.alpha 				= 0;
			addChild					(_tree);	
		}
	}
}