package org.abn.xmpp
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class MessageRequest
	{
		public var xmppContext:XMPPContext;
		public var toJID:String;
		
		public var onResponse:Function;
		public var onTimeout:Function;
		public var timeout:int;
		
		private var timer:Timer;
		
		public function MessageRequest(xmppContext:XMPPContext, to:String)
		{
			this.toJID = to;
			this.xmppContext = xmppContext;
		}
		
		public function startTimeoutTimer():void
		{
			if(this.onTimeout == null || this.timer != null)
				return;
			
			this.timer = new Timer(this.timeout, 1);
			this.timer.addEventListener(TimerEvent.TIMER, handleTimeout);
			this.timer.start();
		}
		
		public function stopTimeoutTimer():void
		{
			if(this.timer != null)
			{
				this.timer.removeEventListener(TimerEvent.TIMER, handleTimeout);
				this.timer.stop();
			}
			
			this.timer = null;
		}
		
		private function handleTimeout(e:TimerEvent):void
		{
			this.xmppContext.clearMessageRequest(this.toJID);
			this.stopTimeoutTimer();
			
			this.onTimeout(toJID);
		}
	}
}