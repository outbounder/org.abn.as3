package org.abn
{
	import org.abn.http.HTTPContext;

	public class AppContext
	{
		public function AppContext()
		{
		}
		
		public function createHTTPContext(endpoint:String):HTTPContext
		{
			return new HTTPContext(endpoint);
		}
	}
}