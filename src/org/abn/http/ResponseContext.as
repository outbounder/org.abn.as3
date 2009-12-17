package org.abn.http
{
	public class ResponseContext extends HTTPContext
	{
		private var _data:String;
		public function ResponseContext(data:String, context:HTTPContext)
		{
			super(context.endpoint);
			this._data = data;
		}
		
		public function get data():String
		{
			return this._data;	
		}
	}
}