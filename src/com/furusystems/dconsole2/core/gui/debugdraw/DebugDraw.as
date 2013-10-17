package com.furusystems.dconsole2.core.gui.debugdraw 
{
	import com.furusystems.dconsole2.core.Notifications;
	import com.furusystems.dconsole2.core.utils.ListIterator;
	import com.furusystems.dconsole2.core.utils.LLNode;
	import com.furusystems.messaging.pimp.PimpCentral;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	/**
	 * Utility class for drawing superimposed symbols on display objects
	 * @author Andreas Ronning
	 */
	public class DebugDraw 
	{
		private var _shape:Shape = new Shape();
		private var _g:Graphics;
		private var colors:Vector.<uint> = Vector.<uint>([0xFF0000, 0xFF0000, 0x00FFFF, 0x0000FF, 0xFF00FF, 0x00FF00]);
		private var currentColor:uint = 0;
		private var _enabled:Boolean = true;
		private var _arrowSize:Number;
		private var default3DFields:Array = ["x", "y", "z", "width", "height", "rotationX", "rotationY", "rotationZ"];
		private var default2DFields:Array = ["x", "y", "width", "height", "rotation"];
		
		private var drawInstructions:LLNode = new LLNode(null);
		private var prevDrawInstructions:LLNode = null;
		
		public function DebugDraw(messaging:PimpCentral) 
		{
			_g = _shape.graphics;
			messaging.addCallback(Notifications.FRAME_UPDATE, onFrameUpdate);
		}
		
		private function onFrameUpdate():void 
		{
			if (!enabled) return;
			clear();
			
			
			//TODO: compare the previous set of instructions to the current and pass in delta if needed
			var iterator:ListIterator = drawInstructions.getIterator();
			for (var data:DrawInstruction = iterator.data; data != null;data = iterator.next()){
				data.draw(g);
			}
			
			prevDrawInstructions = drawInstructions;
			drawInstructions = new LLNode(null); //TODO: This is such bad news
		}
		
		public function get g():Graphics 
		{
			return _g;
		}
		
		public function get shape():Shape 
		{
			return _shape;
		}
		
		public function get enabled():Boolean 
		{
			return _enabled && shape.stage != null;
		}
		
		public function set enabled(value:Boolean):void 
		{
			_enabled = value;
		}
		public function clear():void {
			g.clear();
			currentColor = 0;
		}
		public function drawArrow2D(x:Number, y:Number, angle:Number = 0, color:uint = 0):void {
			drawInstructions.append(new DrawArrowInstruction(x, y, angle, color));
		}
		/**
		 * Draws a path through a list of objects with x/y properties
		 * @param	path
		 * The path to trace in world coordinates. Every item is expected to have xy properties.
		 * @param	color
		 * The color for the wire
		 * @param	cameraOffsetX
		 * The viewpoint's horizontal offset in world coordinates
		 * @param	cameraOffsetY
		 * The viewpoint's vertical offset in world coordinates
		 * @param	directed
		 * Wether to draw arrows at every junction to show the path direction
		 */
		public function drawPath2D(path:Array, color:uint,cameraOffsetX:Number = 0,cameraOffsetY:Number = 0,directed:Boolean = false):void {
			
			for (var i:int = 0; i < path.length; i++) 
			{
				var item:* = path[i];
				
			}
		}
		/**
		 * Draws a 3D path through a list of objects with x/y/z properties
		 * @param	path
		 * The path to trace in world space. Every item is expected to have xyz properties
		 * @param	color
		 * The color for the wire
		 * @param	viewProjection
		 * A matrix combining the view and perspective transforms
		 * @param	directed = false
		 * Wether to draw arrows at every junction to show the path direction
		 */
		public function drawPath3D(path:Array, color:uint, viewProjection:Matrix3D,directed:Boolean = false):void {
			
		}
		public function bracketObject(o:DisplayObject):void {
			if (!enabled) return;
			var pb:Rectangle = o.transform.pixelBounds;
			var outOfBounds:Boolean = false;
			
			var sw:Number = shape.stage.stageWidth;
			var sh:Number = shape.stage.stageHeight;
			
			if (pb.x + pb.width < 0) {
				
				outOfBounds = true;
			}else if (pb.x > sw) {
				outOfBounds = true;
			}
			
			if (pb.y + pb.height < 0) {
				outOfBounds = true;
			}else if (pb.y > sh) {
				outOfBounds = true;
			}
			var color:uint = nextColor();
			if (outOfBounds) {
				var tx:Number = pb.x + pb.width * 0.5;
				var ty:Number = pb.y + pb.height * 0.5;
				var dx:Number = tx - sw * 0.5;
				var dy:Number = ty - sh * 0.5;
				drawArrow2D(Math.max(DrawArrowInstruction.ARROW_SIZE, Math.min(sw - DrawArrowInstruction.ARROW_SIZE, tx)), Math.max(DrawArrowInstruction.ARROW_SIZE, Math.min(sh - DrawArrowInstruction.ARROW_SIZE, ty)), Math.atan2(dy, dx), color);
			}else {
				drawRect(pb,color);
			}
		}
		
		private function drawRect(rect:Rectangle, color:uint):void 
		{
			drawInstructions.append(new DrawRectInstruction(rect, color));
		}
		public function drawMotionVector(o:DisplayObject):void {
			
		}
		public function drawTransform(o:DisplayObject):void {
			var color:uint = nextColor();
			if (o.transform.matrix3D != null) {
				drawMatrix3D(o, color);
			}else {
				drawMatrix2D(o, color);
			}
		}
		private function nextColor():uint {
			return colors[currentColor++ % colors.length];
		}
		private function drawMatrix2D(o:DisplayObject, color:uint):void 
		{
			drawInstructions.append(new DrawMatrix2DInstruction(o, nextColor()));
		}
		
		private function drawMatrix3D(o:DisplayObject, color:uint):void 
		{
			var m3D:Matrix3D = o.transform.getRelativeMatrix3D(o.root);
		}
		public function printInfo(o:DisplayObject, ...fields:Array):void {
			if (fields.length == 0) {
				if(o.transform.matrix3D!=null){
					fields = default3DFields;
				}else {
					fields = default2DFields;
				}
			}
			
		}
		public function lineBetween(o1:DisplayObject, o2:DisplayObject):void {
			if (!enabled) return;
			var color:uint = colors[currentColor++ % colors.length];
			drawInstructions.append(new LineBetweenInstruction(o1, o2, color));
		}
		
	}

}
import com.furusystems.dconsole2.core.interfaces.IDisposable;
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
internal class DrawInstruction implements IDisposable{
	public function draw(g:Graphics, prevInstruction:DrawInstruction = null):void {
		
	}
	
	public function dispose():void 
	{
		
	}
}
internal class LineBetweenInstruction extends DrawInstruction {
	private var _o1:DisplayObject;
	private var _o2:DisplayObject;
	private var _color:uint;
	public function LineBetweenInstruction(o1:DisplayObject, o2:DisplayObject,color:uint) {
		_color = color;
		_o2 = o2;
		_o1 = o1;
	}
	override public function draw(g:Graphics, prevInstruction:DrawInstruction = null):void 
	{
		var pb1:Rectangle = _o1.transform.pixelBounds;
		var pb2:Rectangle = _o2.transform.pixelBounds;
		g.lineStyle(0, _color);
		g.moveTo(pb1.x + pb1.width * 0.5, pb1.y + pb1.height * 0.5);
		g.lineTo(pb2.x + pb2.width * 0.5, pb2.y + pb2.height * 0.5);
	}
}
internal class DrawMatrix2DInstruction extends DrawInstruction {
	private var _color:uint;
	private var _o:DisplayObject;
	public function DrawMatrix2DInstruction(o:DisplayObject, color:uint) {
		_o = o;
		_color = color;
	}
	override public function draw(g:Graphics, prevInstruction:DrawInstruction = null):void 
	{
		var m:Matrix = _o.transform.concatenatedMatrix;
		if (m == null) return;
		var origo:Point = new Point();
		var y:Point = new Point(0, 20);
		var x:Point = new Point(20, 0);
		
		origo = m.transformPoint(origo);
		x = m.transformPoint(x);
		y = m.transformPoint(y);
		
		g.moveTo(origo.x, origo.y);
		g.lineStyle(1, 0xFF0000);
		g.lineTo(x.x, x.y);
		g.moveTo(origo.x, origo.y);
		g.lineStyle(1, 0x00FF00);
		g.lineTo(y.x, y.y);
	}
}
internal class DrawRectInstruction extends DrawInstruction {
	private var _rect:Rectangle;
	private var _color:uint;
	public function DrawRectInstruction(rect:Rectangle, color:uint) {
		_color = color;
		_rect = rect;
	}
	override public function draw(g:Graphics, prevInstruction:DrawInstruction = null):void 
	{
		g.lineStyle(0, _color);
		g.drawRect(_rect.x, _rect.y, _rect.width, _rect.height);
	}
}
internal class DrawArrowInstruction extends DrawInstruction {
	private var _x:Number;
	private var _y:Number;
	private var _angle:Number;
	private var _color:uint;
	public static const ARROW_SIZE:int = 8;
	public function DrawArrowInstruction(x:Number, y:Number, angle:Number, color:uint) {
		_color = color;
		_angle = angle;
		_y = y;
		_x = x;
	}
	override public function draw(g:Graphics, prevInstruction:DrawInstruction = null):void 
	{
		g.lineStyle(1, _color);
		var angleOffset:Number = 0.785;
		g.moveTo(_x + Math.cos(_angle - angleOffset) * -ARROW_SIZE, _y + Math.sin(_angle - angleOffset) * -ARROW_SIZE);
		g.lineTo(_x, _y);
		g.lineTo(_x + Math.cos(_angle + angleOffset) * -ARROW_SIZE, _y + Math.sin(_angle + angleOffset) * -ARROW_SIZE);
	}
}