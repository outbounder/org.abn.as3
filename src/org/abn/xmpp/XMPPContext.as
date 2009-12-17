package org.abn.xmpp
{
	import org.jivesoftware.xiff.core.XMPPConnection;

	public class XMPPContext
	{
		protected var _username:String;
		protected var _password:String;
		protected var _server:String;
		protected var _connection:XMPPConnection;
		
		public function XMPPContext(username:String, password:String, server:String)
		{
			this._username = username;
			this._password = password;
			this._server = server;
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
		
		public function connect():Boolean
		{
			this._connection = new XMPPConnection();
			this._connection.server = this.server;
			this._connection.username = this.username;
			this._connection.password = this.password;
			return this._connection.connect();
		}
		
		public function createChatContext(recipientJID:String):ChatContext
		{
			return new ChatContext(recipientJID,this);
		}
	}
}