﻿////////////////////////////////////////////////////////////////////////////////////  LINNAEUS UNIVERSITY//  Copyright 2012 Linnaeus university, Media Technology, sweden.//  Some Rights Reserved.////  NOTICE: LNU Media Technology permits you to use and modify this file//  in accordance with the terms of the license agreement accompanying it.//////////////////////////////////////////////////////////////////////////////////package se.lnu.mediatechnology.stickossdk.debug{	//------------------------------------------------------------------------------	//	// Public class	//	//------------------------------------------------------------------------------		/**	 *	 *	Used to calculate and display the current frame rate of the application. 	 *	Values ​​are visualized in text format.	 * 	 *	@author		Henrik Andersen	 *	@version 	1.0	 *	 */	public class FPSTicker extends Ticker 	{		//--------------------------------------------------------------------------		//		// Constructor method		//		//--------------------------------------------------------------------------				/**		 *		 *	The class constructor.		 * 		 *	@param	x		The object's x position (Default: 10).		 * 	@param	y		The object's y position (Default: 10).		 *	@param	size	The text size (Default: 12).		 *	@param	color	the text color (Default: 0xFFFFFF).		 *	@param	font	the text font (Default: Arial).		 * 		 *	@return void		 *		 */		public function FPSTicker(x:Number = 10, y:Number = 10, size:uint = 12, color:uint = 0xFFFFFF, font:String = 'arial')		{			super(x,y,size,color,font);						this.text = '00.0 FPS';		}				//--------------------------------------------------------------------------		//		// Public methods		//		//--------------------------------------------------------------------------				/**		 *		 *	Shows the current frame rate of the application.		 * 		 *	@return void		 *		 */		protected override function updateText():void		{			var fps:Number = ticks / delta * 1000;			text = fps.toFixed(1) + " FPS";		}	}}