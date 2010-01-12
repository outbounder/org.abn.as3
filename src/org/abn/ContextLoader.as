package org.abn
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class ContextLoader
	{
		private var loader:URLLoader;
		private var onLoadCompleteHandler:Function;
		
		public function ContextLoader()
		{
			this.loader = new URLLoader();
			this.loader.addEventListener(Event.COMPLETE, onLoadComplete);
		}
		
		public function loadContext(url:String, onLoadCompleteHandler:Function):void
		{
			this.onLoadCompleteHandler = onLoadCompleteHandler;
			var request:URLRequest = new URLRequest(url);
			this.loader.load(request);	
		}
		
		private function onLoadComplete(e:Event):void
		{
			var loader:URLLoader = e.target as URLLoader;
			var xmlData:XML = new XML(loader.data);
			var parser:ContextParser = new ContextParser();
			var context:Context = parser.getContext(xmlData);
			this.onLoadCompleteHandler(context);
		}
	}
}