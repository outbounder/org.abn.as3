package org.abn.bot
{
	import org.abn.AppContext;
	import org.abn.xmpp.XMPPContext;
	
	public class BotContext extends AppContext
	{
		private var xmppContext:XMPPContext;
		
		public function BotContext(properties:Array)
		{
			super(properties);
		}
		
		public function openXMPPConnection(id:String, onConnected:Function, onConnectFailed:Function, onIncomingMessage:Function):Boolean
		{
			this.xmppContext = this.createXMPPContext(id);
			return this.xmppContext.connect(onConnected,onConnectFailed, onIncomingMessage);
		}
		
		public function closeXMPPConnection():void
		{
			this.xmppContext.disconnect();
		}
		
		public function getXMPPContext():XMPPContext
		{
			return this.xmppContext;	
		}
	}
}