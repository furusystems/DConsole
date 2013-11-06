package com.furusystems.dconsole2.plugins.monitoring 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import com.furusystems.dconsole2.core.gui.DropDown;
	import com.furusystems.dconsole2.core.gui.DropDownOption;
	import com.furusystems.dconsole2.core.gui.events.DropDownEvent;
	import com.furusystems.dconsole2.core.gui.Window;
	/**
	 * ...
	 * @author Andreas Roenning
	 */
	public class GraphWindow extends Window
	{
		private static const colors:Vector.<uint> = new Vector.<uint>;
		private var graphs:Vector.<StatGraph> = new Vector.<StatGraph>;
		private const dims:Rectangle = new Rectangle(0, 0, 300, 100);
		private var content:Sprite = new Sprite();
		private var graphChoiceDropdown:DropDown;
		public function GraphWindow(windowName:String = "Graph") 
		{
			var windowDims:Rectangle = dims.clone();
			windowDims.width += 50;
			var minDims:Rectangle = windowDims.clone();
			minDims.width = 100;
			minDims.height = 50;
			super(windowName, windowDims, content,null, minDims,true, false, true);
			graphChoiceDropdown = new DropDown("Views");
			graphChoiceDropdown.y = dims.height-2;
			graphChoiceDropdown.x = 1;
			graphChoiceDropdown.visible = false;
			graphChoiceDropdown.addEventListener(DropDownEvent.SELECTION, onSelection);
			addChild(graphChoiceDropdown);
			
			colors.push(0xFFF2B31E);
			colors.push(0xFF5CB900);
			colors.push(0xFF800000);
			colors.push(0xFFFF0080);
			colors.push(0xFF8000FF);
			colors.push(0xFF000080);
			
			//TODO: Render all graphs to same bitmapdata
			
		}
		
		private function onSelection(e:DropDownEvent):void 
		{
			for (var i:int = 0; i < graphs.length; i++) 
			{
				graphs[i].current = (e.selectedOption.index == i);
			}
			graphChoiceDropdown.setTitle(e.selectedOption.title);
		}
		override protected function onClose(e:MouseEvent):void 
		{
			for (var i:int = 0; i < graphs.length; i++) 
			{
				graphs[i].kill();
			}
			graphs = new Vector.<StatGraph>;
			parent.removeChild(this);
			super.onClose(e);
		}
		override protected function onResize():void 
		{
			for (var i:int = 0; i < graphs.length; i++) 
			{
				graphs[i].resize(viewRect);
			}
			graphChoiceDropdown.y = viewRect.height-2;
		}
		public function addGraph(g:StatGraph):void {
			for (var i:int = 0; i < graphs.length; i++) 
			{
				graphs[i].current = false;
			}
			content.addChild(g);
			graphs.push(g);
			g.resize(viewRect);
			g.current = true;
			g.graphColor = colors[graphs.length - 1];
			redraw(viewRect);
			graphChoiceDropdown.addOption(new DropDownOption("Graph " + (graphs.length - 1)));
			graphChoiceDropdown.setTitle("Graph " + (graphs.length - 1));
			if (graphs.length > 1) {
				graphChoiceDropdown.visible = true;
			}
		}
		
	}

}