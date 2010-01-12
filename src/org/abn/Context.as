package org.abn
{
	public class Context
	{
		private var properties:Array;
		
		public function Context(properties:Array)
		{
			this.properties = properties;
		}
		
		public function getProps():Array
		{
			return this.properties;
		}
		
		public function hasProp(name:String):Boolean
		{
			return properties[name] != null;
		}
		
		public function getProp(name:String):Object
		{
			return this.properties[name];
		}
		
		public function setProp(name:String, value:Object):void
		{
			this.properties[name] = value;
		}
	}
}