package org.abn.http
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;

	public class RequestContext extends HTTPContext
	{
		private var responseHandler:Function;
		
		public function RequestContext(context:HTTPContext)
		{
			super(context.endpoint);
		}
		
		public function sendRequest(urlAddon:String, responseHandler:Function, params:URLVariables = null, method:String = "GET"):URLLoader
		{
			if(this.responseHandler != null)
				throw new Error("request context already send");
			this.responseHandler = responseHandler;
			
			var loader:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest(this.endpoint+"/"+urlAddon);
			request.method = method;
			request.data = params;
			loader.addEventListener(Event.COMPLETE, onRequestComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onRequestIOError);
			loader.load(request);
			
			return loader;
		}
		
		private function onRequestComplete(e:Event):void
		{
			var response:ResponseContext = new ResponseContext((e.target as URLLoader).data, this);
			this.responseHandler(response);
		}
		
		private function onRequestIOError(e:IOErrorEvent):void
		{
			var response:ResponseContext = new ResponseContext(e.toString(), this);
			this.responseHandler(response);
		}
	}
}