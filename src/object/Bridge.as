package object
{
	//------------------------------------------------------------------------------
	//
	// Imports
	//
	//------------------------------------------------------------------------------
	import flash.display.MovieClip;
	
	import se.lnu.mediatechnology.stickossdk.core.Session;
	import se.lnu.mediatechnology.stickossdk.display.IStickOsDisplayObject;

	//------------------------------------------------------------------------------
	//
	// Public class
	//
	//------------------------------------------------------------------------------
	/**
	 *
	 *	Instance of the bridge Movie Clip
	 * 
	 *	@author		Chris Shields
	 *	@version 	1.0
	 *
	 */
	public class Bridge extends MovieClip implements IStickOsDisplayObject
	{
		//------------------------------------------------------------------------------
		//
		// Public properties
		//
		//------------------------------------------------------------------------------
		public var bridge				:MovieClip 	= new mc_bridge();
		public var bridgeHP				:int 		= 2;
		//------------------------------------------------------------------------------
		//
		// Private properties
		//
		//------------------------------------------------------------------------------
		private var _playSoundOnlyOnce	:Boolean;
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
		public function Bridge()
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
			addBridge();	
		}
		
		/**
		 * 
		 *	Updates every frame automatically. 
		 * 
		 *	@return void
		 * 
		 */
		public function update():void
		{
			if(bridgeHP == 2)
			{
				this.bridge.gotoAndStop	("complete");
			}
			if(bridgeHP == 1)
			{
				if(!_playSoundOnlyOnce){
					Session.sound.play	("bridgeBreak");
					_playSoundOnlyOnce 	= true;
				}
				this.bridge.gotoAndStop	("damaged");
				
			}
		}
		
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
			trace("dealloc from Bridge");
			removeChild(bridge);
			bridge 			= null;
		}
		
		//------------------------------------------------------------------------------
		//
		// Private methods
		//
		//------------------------------------------------------------------------------
		
		/**
		 * 
		 *	Simple method that adds the bridge movie clip.
		 * 
		 *	@return void
		 * 
		 */
		private function addBridge():void
		{
			addChild			(bridge);
			bridge.gotoAndStop	("complete");
		}
	}
}