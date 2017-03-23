package interfaces
{
	public interface IState
	{
		function thisUpdate():void;
		function onEnter():void;
		function onExit():void;	
		function knockBack():void;
		function dealloc():void;
	}
}