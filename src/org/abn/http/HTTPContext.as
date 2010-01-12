package org.abn.http
{
	import flash.net.URLVariables;
	
	import org.abn.AppContext;

	public class HTTPContext extends AppContext
	{
		private var _endpoint:String;
		
		public function HTTPContext(props:Array, endpoint:String)
		{
			super(props);
			
			this._endpoint = endpoint;
		}
		
		public function get endpoint():String
		{
			return this._endpoint;
		}
		
		public function createRequest(urlAddon:String, responseHandler:Function = null, params:URLVariables = null, method:String = "GET"):void
		{
			this.createRequestContext().sendRequest(urlAddon, responseHandler, params, method);
		}
		
		public function createRequestContext():RequestContext
		{
			return new RequestContext(this);
		}
	}
}