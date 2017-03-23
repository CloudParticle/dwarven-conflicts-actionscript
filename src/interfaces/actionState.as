package interfaces
{
	public interface actionState
	{
		function onEnter():void;
		function onExit():void;
		function thisUpdate():void;
		function build():void;
		function checkForFlag():void;
		function updateControls():void;
		function dealloc():void;
	}
}