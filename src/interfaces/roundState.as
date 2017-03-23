package interfaces
{
	public interface roundState
	{
		function onEnter():void;
		function onExit():void;
		function thisUpdate():void;
		function endRound(timeRemaining:int):void;
	}
}