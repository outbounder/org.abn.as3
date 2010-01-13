package org.abn.xmpp
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.abn.AppContext;
	import org.jivesoftware.xiff.core.JID;
	import org.jivesoftware.xiff.core.XMPPConnection;
	import org.jivesoftware.xiff.data.Message;
	import org.jivesoftware.xiff.data.Presence;
	import org.jivesoftware.xiff.events.DisconnectionEvent;
	import org.jivesoftware.xiff.events.LoginEvent;
	import org.jivesoftware.xiff.events.MessageEvent;

	public class XMPPContext extends AppContext
	{
		protected var _username:String;
		protected var _password:String;
		protected var _server:String;
		protected var _connection:XMPPConnection;
		
		private var onIncomingMessage:Function;
		private var onConnected:Function;
		private var onDisconnected:Function;
		
		private var msgRequests:Array;
		private var pingTimer:Timer;
		
		public function XMPPContext(props:Array, id:String)
		{
			super(props);
			this.msgRequests = new Array();
			
			this._username = this.getProp(id+".username") as String;
			this._password = this.getProp(id+".password") as String;
			this._server = this.getProp(id+".server") as String;
			
			this._connection = new XMPPConnection();
			this._connection.server = this.server;
			if(this.username != null && this.password != null)
			{
				this._connection.username = this.username;
				this._connection.password = this.password;
			}
			else
				this._connection.useAnonymousLogin = true;
		}
		
		public function get jid():String
		{
			return this._connection.jid.bareJid.toString();
		}
		
		public function get username():String
		{
			return this._username;
		}
		
		public function get password():String
		{
			return this._password;
		}
		
		public function get server():String
		{
			return this._server; 
		}
		
		public function get connection():XMPPConnection
		{
			return this._connection;
		}
		
		/**
		 * connects the context 
		 * @param onConnected function(e:LoginEvent)
		 * @param onConnectFailed function(e:Object)
		 * @param onIncomingMessage function(from:String, msg:String)
		 * @return connected status
		 */
		public function connect(onConnected:Function, onDisconnected:Function, onIncomingMessage:Function):Boolean
		{
			this.onConnected = onConnected;
			this.onDisconnected = onDisconnected;
			this.onIncomingMessage = onIncomingMessage;
			
			this._connection.addEventListener(LoginEvent.LOGIN, onLoginHandler);
			this._connection.addEventListener(DisconnectionEvent.DISCONNECT, onDisconnect);
			this._connection.addEventListener(MessageEvent.MESSAGE, onMessage);
			
			return this._connection.connect("flash");
		}
		
		public function disconnect():void
		{
			this._connection.disconnect();
		}
		
		private function onLoginHandler(e:LoginEvent):void
		{			
			var p:Presence = new Presence();
			p.show = Presence.SHOW_CHAT;
			this._connection.send(p);
			
			this.pingTimer = new Timer(15*1000);
			this.pingTimer.addEventListener(TimerEvent.TIMER, onPing);
			
			this.onConnected(e);
		}
		
		private function onPing(e:TimerEvent):void
		{
			this._connection.sendKeepAlive();
		}
		
		private function onDisconnect(e:DisconnectionEvent):void
		{
			if(this.pingTimer != null)
				this.pingTimer.stop();
			this.pingTimer = null;
			
			this._connection.removeEventListener(LoginEvent.LOGIN, onLoginHandler);
			this._connection.removeEventListener(DisconnectionEvent.DISCONNECT, onDisconnect);
			this._connection.removeEventListener(MessageEvent.MESSAGE, onMessage);
			
			this.onDisconnected(e);
		}
		
		private function onMessage(e:MessageEvent):void
		{
			if(this.msgRequests[e.data.from.bareJid] == null)
			{
				this.onIncomingMessage(e.data.from.bareJid, e.data.body);
			}
			else
			{
				var msgRequest:MessageRequest = this.msgRequests[e.data.from.bareJid] as MessageRequest;
				msgRequest.stopTimeoutTimer();
				msgRequest.onResponse(e.data.from.bareJid, e.data.body);
				this.msgRequests[e.data.from.bareJid] = null;
			}
		}
		
		/**
		 * sends message 
		 * @param recipientJID only the bare JID (without resource in form <username>@<domain>
		 * @param msg message to be send
		 * @param responseHandler function(from:String, msg:String)
		 * @param timeoutHandler function(from:String)
		 * @param timeout number, defaults to 5000ms
		 * 
		 */
		public function send(recipientJID:String, msg:String, responseHandler:Function = null, 
							 	timeoutHandler:Function = null, timeout:int = 5000):void
		{
			if(this.msgRequests[recipientJID] != null)
				throw new Error("could not send message to recipient while still waiting for its response");
			
			if(responseHandler != null || timeoutHandler != null)
			{
				var msgRequest:MessageRequest = new MessageRequest(this, recipientJID);
				msgRequest.timeout = timeout;
				msgRequest.onResponse = responseHandler;
				msgRequest.onTimeout = timeoutHandler;
				msgRequest.startTimeoutTimer();
				
				this.msgRequests[recipientJID] = msgRequest;
			}
			
			var message:Message = new Message(new JID(recipientJID), null, msg);
			this._connection.send(message);
		}
		
		/**
		 * Clears any registered msgRequest with given base JID 
		 * @param jid
		 */
		public function clearMessageRequest(jid:String):void
		{
			this.msgRequests[jid] = null;
		}
		
	}
}