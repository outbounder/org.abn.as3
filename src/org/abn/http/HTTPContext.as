package org.abn.http
{
	public class HTTPContext
	{
		private var _endpoint:String;
		
		public function HTTPContext(endpoint:String)
		{
			this._endpoint = endpoint;
		}
		
		public function get endpoint():String
		{
			return this._endpoint;
		}
		
		public function createRequestContext():RequestContext
		{
			return new RequestContext(this);
		}
	}
}