package interfaces
{
	public interface flagState
	{
		function thisUpdate():void;
		function build():void;
		function onEnter():void;
		function onExit():void;
		function updateControls():void;
		function setFaceDirection():void;
		function checkForFlag():void;
		function dropFlag():void;
		function dealloc():void;
	}
}