package state.substates.flagstates.actionstates
{
	//------------------------------------------------------------------------------
	//
	// Imports
	//
	//------------------------------------------------------------------------------
	import flash.display.MovieClip;
	
	import interfaces.actionState;
	//------------------------------------------------------------------------------
	//
	// Public class
	//
	//------------------------------------------------------------------------------
	
	/**
	 *
	 *	The dropflag state for the dwarf.  Currently not in use.  For future edits.    
	 * 
	 *	@author		Chris Shields
	 *	@version 	1.0
	 *
	 */
	public class IsDroppingFlag extends MovieClip implements actionState
	{
		//--------------------------------------------------------------------------
		//
		// Private properties
		//
		//--------------------------------------------------------------------------
		private var _dwarf:MovieClip;
		//--------------------------------------------------------------------------
		//
		// Constructor method
		//
		//--------------------------------------------------------------------------
		/**
		 *	The constructor for the dropping flag state of the dwarf.  
		 *
		 *	@param 	$dwarf	Must be an instance of noFlag
		 * 
		 *	@return void
		 *
		 */
		public function IsDroppingFlag($dwarf:MovieClip)
		{
			super();
			_dwarf = $dwarf
		}
		
		//--------------------------------------------------------------------------
		//
		// Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *	 
		 * 	Method called when entering this state.  
		 * 
		 *	@return void
		 *
		 */
		public function onEnter():void{}
		
		/**
		 *	  	
		 * 	Method called when entering this state.  
		 * 
		 *	@return void
		 *
		 */
		public function onExit():void{}
		
		/**
		 *	 
		 * 	Use this method to checks for the enemies flag in this state. 	
		 * 
		 *	@return void
		 *
		 */
		public function checkForFlag():void{}
		
		/**
		 *	 
		 * 	Use this method to enable bridge building in this state.
		 * 
		 *	@return void
		 *
		 */
		public function build():void{}
		
		/**
		 *	  	
		 * 	Use this method to update in this state 
		 * 
		 *	@return void
		 *
		 */
		public function thisUpdate():void{}
		
		/**
		 *	  	
		 * 	Updates the controls while in this state. 
		 * 
		 * 
		 *	@return void
		 *
		 */
		public function updateControls():void{}
		
		/**
		 *
		 *  Cleaner method. 
		 * 
		 *	@return void
		 *
		 */
		public function dealloc():void
		{
			trace("dealloc from isDroppingFlag");
			_dwarf = null;
		}
		//--------------------------------------------------------------------------
		//
		// Private methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *	  	
		 * 	Initiates the class' references.  
		 * 
		 *	@return void
		 *
		 */
		private function init():void{}
	
	}
}