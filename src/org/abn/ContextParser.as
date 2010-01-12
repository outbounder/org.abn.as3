package org.abn
{
	public class ContextParser
	{
		private var currentChain:String;
		
		public function ContextParser()
		{
		}
		
		public function getContext(fast:XML):Context
		{
			this.currentChain = "";
			var properties:Array = new Array();
			for each(var item:XML in fast.children())
			{
				this.pushItem(properties, item);
			}
			return new Context(properties);
		}
		
		private function pushItem(properties:Array, item:XML):void
		{
			var original:String = this.currentChain;
			
			if (!item.hasSimpleContent())
			{
				if(this.currentChain.length != 0)
					this.currentChain += "." + item.name();
				else
					this.currentChain += item.name();
			}
			
			for each(var elem:XML in item.children())
			{
				if (!elem.hasSimpleContent())
				{
					this.pushItem(properties, elem);
				}
				else
				{
					if (properties[this.currentChain + "." + elem.name()] == null)
					{
						properties[this.currentChain + "." + elem.name()] =  elem.toString();
					}
					else 
					{
						var property:Object = properties[this.currentChain + "." + elem.toString()];
						var pl:Array;
						if (property is Array)
						{
							pl = property as Array;
							pl.push(elem.toString());
						}
						else
						{
							pl = new Array();
							pl.push(properties[this.currentChain + "." + elem.name()]);
							pl.push(elem.toString());
							properties[this.currentChain + "." + elem.name()] = pl;
						}
					}
				}
			}
			
			this.currentChain = original;
		}
	}
}