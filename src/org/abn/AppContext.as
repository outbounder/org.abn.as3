package org.abn
{
	import org.abn.http.HTTPContext;
	import org.abn.xmpp.XMPPContext;

	public class AppContext
	{
		public function AppContext()
		{
		}
		
		public function createHTTPContext(endpoint:String):HTTPContext
		{
			return new HTTPContext(endpoint);
		}
		
		public function createXMPPContext(username:String,password:String,server:String):XMPPContext
		{
			return new XMPPContext(username,password,server);
		}
	}
}