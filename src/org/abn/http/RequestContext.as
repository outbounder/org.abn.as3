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
			super(context.getProps(), context.endpoint);
		}
		
		
		/**
		 * sends request to specified url (endpoint+urlAddon) 
		 * @param urlAddon the addon to be concatinated at the endpoint
		 * @param responseHandler eg. public function handle(response:ResponseContext):void, to be executed upon any response returned.
		 * @param params URLVariables to be passed with the request
		 * @param method GET or POST method of the request
		 * @return URLLoader - the internal loader used to make the request 
		 */
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
			if(this.responseHandler != null)
			{
				var response:ResponseContext = new ResponseContext((e.target as URLLoader).data, this);
				this.responseHandler(response);
			}
		}
		
		private function onRequestIOError(e:IOErrorEvent):void
		{
			trace(e.toString());
			if(this.responseHandler != null)
			{
				var response:ResponseContext = new ResponseContext(e.toString(), this);
				this.responseHandler(response);
			}
		}
	}
}