package org.abn
{
	import org.abn.http.HTTPContext;
	import org.abn.xmpp.XMPPContext;

	public class AppContext extends Context
	{
		public function AppContext(properties:Array)
		{
			super(properties);
		}
		
		public function createHTTPContext(endpoint:String):HTTPContext
		{
			return new HTTPContext(this.getProps(), endpoint);
		}
		
		public function createXMPPContext(id:String):XMPPContext
		{
			return new XMPPContext(this.getProps(), id);
		}
	}
}