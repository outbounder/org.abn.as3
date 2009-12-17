package org.abn.xmpp
{
	import org.jivesoftware.xiff.core.JID;
	import org.jivesoftware.xiff.data.Message;
	import org.jivesoftware.xiff.events.MessageEvent;

	public class ChatContext extends XMPPContext
	{
		protected var _recipientJID:String;
		protected var handleChatMessage:Function;
		
		public function ChatContext(recipientJID:String, context:XMPPContext)
		{
			super(context.username, context.password, context.server);
			this._connection = context.connection;
			this._recipientJID = recipientJID;
			this._connection.addEventListener(MessageEvent.MESSAGE, onMessage);
		}
		
		/**
		 * registers listener to the chat context 
		 * @param listener function in form - public function onMessage(msg:String, chatContext:ChatContext):void
		 */
		public function addMessageListener(listener:Function):void
		{
			this.handleChatMessage = listener;
		}
		
		/**
		 * sends message to the recipient
		 * @param msg 
		 */
		public function send(msg:String):void
		{
			var message:Message = new Message(new JID(this._recipientJID), null, msg);
			this._connection.send(message);
		}
		
		protected function onMessage(e:MessageEvent):void
		{
			if(e.data.from.toString() == this._recipientJID)
				this.handleChatMessage(e.data.body, this);
		}
	}
}