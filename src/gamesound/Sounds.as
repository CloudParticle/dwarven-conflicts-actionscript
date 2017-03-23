package gamesound
{
	//------------------------------------------------------------------------------
	//
	// Imports
	//
	//------------------------------------------------------------------------------
	import flash.display.MovieClip;
	import flash.media.Sound;
	
	import se.lnu.mediatechnology.stickossdk.core.Session;
	import se.lnu.mediatechnology.stickossdk.media.SoundManager;
	
	
	
	//------------------------------------------------------------------------------
	//
	// Public class
	//
	//------------------------------------------------------------------------------
	/**
	 *
	 *	Handles the sounds for the game. Use play("sound name"); to play a sound.
	 * 
	 *	@author		P�r Strandberg
	 *	@version 	1.1
	 *
	 */
	
	public class Sounds 
	{
		
		//--------------------------------------------------------------------------
		//
		// Private properties
		//
		//--------------------------------------------------------------------------
		//--------------------------------------------------------------------------
		//
		// Public properties
		//
		//--------------------------------------------------------------------------		
		//--------------------------------------------------------------------------
		//
		// Public static properties
		//
		//--------------------------------------------------------------------------
		//--------------------------------------------------------------------------
		//
		// Constructor method
		//
		//--------------------------------------------------------------------------
		
		/**
		 *
		 *	The class constructor.
		 *
		 *	AVAILABLE SOUNDS:
		 * 	"bridgeBreak"
		 *	"bridgeCollapse"
		 *	"dynamiteFuse"
		 *	"explosion"
		 *	"flagCapture"
		 *	"flagRetake"
		 *	"hammerHit"
		 *	"rockBreak"
		 *	"menuMusic"
		 *	"gameMusic"
		 * 
		 *	@return void
		 *
		 */
		public function Sounds(state:String = "null") {
			initSoundBank();
			switch(state){
			case ("game"):
				Session.application.state.sound.play("gameMusic",1,0,100);
				break;
			
			case ("menu"):
				Session.application.state.sound.play("menuMusic",1,0,100);
				break;
			
			case("credit"):
				Session.application.state.sound.play("creditMusic",1,0,100);
			}
		}
		
		private function initSoundBank():void {
		//Bridge
			Session.sound.add(sound_bridgeBreak, 		"bridgeBreak");
			
			Session.sound.add(sound_bridgeCollapse, 	"bridgeCollapse");
			
		//Dynamite
			Session.sound.add(sound_dynamiteFuse, 		"dynamiteFuse");
			Session.sound.add(sound_explosion, 			"explosion");
			
		//Flag
			Session.sound.add(sound_flagCapture, 		"flagCapture");
			Session.sound.add(sound_flagRetake, 		"flagRetake");
			
		//Hammer
			Session.sound.add(sound_hammerHit, 			"hammerHit");
			
		//Rocks
			Session.sound.add(sound_rockBreak, 			"rockBreak");
			
		//Music
			Session.sound.add(music_menuMusic,			"menuMusic");
			Session.sound.add(music_gameMusic,			"gameMusic");
			Session.sound.add(music_creditMusic,		"creditMusic");
			Session.sound.add(music_winFanfare,			"fanfare");

			Session.sound.add(sound_menuNavigation,		"menuMove");
			Session.sound.add(dwarf_hit,				"dwarfHit");
			Session.sound.add(dwarf_jump,				"dwarfJump");
			Session.sound.add(dwarf_needWood,			"needWood");
			Session.sound.add(dwarf_throw,				"dwarfThrow");
			Session.sound.add(sound_timeAlert,			"timeAlert");
			Session.sound.add(sound_failFanfare,		"failFanFare");
			
		}
	
	}
}