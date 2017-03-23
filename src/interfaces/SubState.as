package interfaces
{
	import flash.geom.Rectangle;
	
	import state.substates.SubstateController;

	public interface SubState
	{
		function jump($explosion:int):void
		function thisUpdate():void
		function onEnter():void;
		function onExit():void;
		function onHitXL(result:Boolean):void;
		function onHitXR(result:Boolean):void;
		function changeState(state:flagState):void
	}
}