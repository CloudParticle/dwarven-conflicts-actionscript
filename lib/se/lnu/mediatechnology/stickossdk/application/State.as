﻿////////////////////////////////////////////////////////////////////////////////////  LINNAEUS UNIVERSITY//  Copyright 2012 Linnaeus university, Media Technology, sweden.//  Some Rights Reserved.////  NOTICE: LNU Media Technology permits you to use and modify this file//  in accordance with the terms of the license agreement accompanying it.//////////////////////////////////////////////////////////////////////////////////package se.lnu.mediatechnology.stickossdk.application{	//--------------------------------------------------------------------------	//	// Imports	//	//--------------------------------------------------------------------------		// IMPORT FROM STICKOS SDK		import se.lnu.mediatechnology.stickossdk.core.Session;	import se.lnu.mediatechnology.stickossdk.display.IStickOsDisplayObject;	import se.lnu.mediatechnology.stickossdk.input.Keyboard;	import se.lnu.mediatechnology.stickossdk.media.SoundManager;	import se.lnu.mediatechnology.stickossdk.net.Highscore;	import se.lnu.mediatechnology.stickossdk.ui.ScreenKeyboard;	import se.lnu.mediatechnology.stickossdk.utils.List;		import flash.display.DisplayObject;	import flash.display.Stage;
	//--------------------------------------------------------------------------	//	// Abstract class	//	//--------------------------------------------------------------------------		/**	 * 	 *	Base class for game states. Primarily used for separating the different 	 *	parts of the game, such as menu or game state. Note that this is an 	 *	abstract class and is not meant to be instantiated directly.	 * 	 *	@author	Henrik Andersen	 *	@version 1.0	 * 	 */  	public class State	{		//-----------------------------------------------------------------------		//		// Private properties		//		//-----------------------------------------------------------------------				/**		 * 		 *	A list containing all the display objects placed on the stage by this 		 *	game state. Used to automatically Update game objects, and keep track 		 *	of the items displayed on the stage.		 * 		 */		private var _stageObjects:List;				//-----------------------------------------------------------------------		//		// Constructor method		//		//-----------------------------------------------------------------------				/**		 * 		 *	The class constructor.		 * 		 *	@return void		 *  		 */		public function State():void		{			this._stageObjects	= new List();			this.stage.focus	= stage;		}				//--------------------------------------------------------------------------		//		// Public setter methods		//		//--------------------------------------------------------------------------				/**		 *		 *	Contains an instance of the current game state. If the variable is changed, 		 *	it will also replace the current game state.		 * 		 *	@return void		 *		 */		public function set state(state:State):void 		{			Session.application.state = state;		}				//--------------------------------------------------------------------------		//		// Public getter methods		//		//--------------------------------------------------------------------------				/**		 *		 *	Contains an instance of the current game state. If the variable is changed, 		 *	it will also replace the current game state.		 *		 */		public function get state():State 		{			return Session.application.state;		}				/**		 *		 *	The application's main stage. Note that this is primarily a reference object 		 *	in order to access the application width, height, etc.. Use the game states 		 *	addChild method to place objects on the stage.		 *		 */		public function get stage():Stage 		{			return Session.application.stage;		}				/**		 *		 *	The current width of the application, based on the width of the main stage.		 *		 */		public function get width():Number 		{			return this.stage.stageWidth;		}				/**		 *		 *	The current height of the application, based on the width of the main stage.		 * 		 */		public function get height():Number 		{			return this.stage.stageHeight;		}				/**		 *		 *	A static keyboard reference. Use it to listen to keystrokes.		 *		 */		public function get keyboard():Keyboard 		{			return Session.keyboard;		}				/**		 *		 *	The current frame rate of the application.		 *		 */		public function get frameRate():Number 		{			return Session.application.stage.frameRate;		}				/**		 *		 *	The system's Sound Manager for managing and playback of audio and music 		 *	files.		 *		 */		public function get sound():SoundManager 		{			return Session.sound;		}				/**		 *		 *	Screen keyboard for text entry.		 *		 */		public function get screenKeyboard():ScreenKeyboard 		{			return Session.screenKeyboard;		}				/**		 *		 *	DESC..		 *		 */		public function get numChildren():int 		{			return Session.application.numChildren;		}				/**		 *		 *	DESC..		 *		 */		public function get stageObjects():List 		{			return this._stageObjects;		}				/**		 *		 *	DESC..		 * 		 */		public static function get highscore():Highscore		{			return Session.highscore;		}				//-----------------------------------------------------------------------		//		// Public methods		//		//-----------------------------------------------------------------------				/**		 *		 *	This method is designed to act as a class constructor 		 *	for game states.		 * 		 *	@return void		 *		 */		public function init():void		{			// Override this method to set up your game state.		}				/**		 *		 *	Automatically goes through and calls update on each 		 *	<code>DisplayObject</code> placed on the <code>stage</code>.		 *		 *	@return void		 *		 */		public function update():void		{			_stageObjects.update();		}				/**		 *		 *	Adds objects that are not display objects in StickOs's 		 *	stage object list. This method is very experimental.		 * 		 *	@return void		 *		 */		public function addObject(object:IStickOsDisplayObject):void		{			_stageObjects.add(object);			object.init();		}				/**		 *		 *	Adds and instantiates game objects on the stage.		 * 		 *	@param	child	The DisplayObject's to be placed on the stage.		 * 		 *	@return	void		 *		 */		public function addChild(child:*):void		{			if(child.stage) return;						_stageObjects.add(child);			Session.application.addChild(child);						if( child is IStickOsDisplayObject){				child.init();			}		}				/**		 *		 *	Adds a DisplayObject with a given child index to the stage.		 * 		 *	@param	child	The DisplayObject's to be placed on the stage.		 *	@param	index	The given child index.		 * 		 *	@return void		 *		 */		public function addChildAt(child:*, index:uint):void		{			if(child.stage) return;						_stageObjects.add(child);			Session.application.addChildAt(child, index);						if( child is IStickOsDisplayObject){				child.init();			}		}				/**		 *		 *	Removes a display object from the stage.		 * 		 *	@param	child	The DispalyObject to be removed from the stage.		 *		 *	@return void		 *		 */		public function removeChild(child:*):void		{			var tmpChild:* = _stageObjects.remove(child);						if(tmpChild != null){								if( tmpChild is IStickOsDisplayObject){					tmpChild.dealloc();				}								tmpChild.parent.removeChildAt(Session.application.getChildIndex(tmpChild));			}		}				public function swapChild(child1:*, child2:*):void		{			Session.application.swapChildren(child1, child2);		}				/**		 *		 *	Runs a specified method after a specified delay (in seconds).		 *		 *	@param	delay		The requested delay in seconds.		 *	@param	callback	The requested callback function.		 *		 * 	@return void		 *		 */		public function setPause(delay:Number, callback:Function):void		{			Session.setPause(delay, callback);		}				/**		 *		 *	Cleans up the game state before it is terminated. The method can be overridden, 		 *	but do not forget to clean up unnecessary instances that should not exist in the 		 *	next game state.		 * 		 *	@return void		 *		 */		public function dealloc():void		{			this._stageObjects.clear();			this.sound.removeAll();			this.screenKeyboard.quit();		}	}}