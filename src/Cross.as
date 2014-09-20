package  
{
	import app.core.action.RotatableScalable;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Amit
	 */
	public class Cross extends Sprite
	{
		var xline:Sprite=new Sprite();
		var yline:Sprite=new Sprite();
		var circle:Sprite=new Sprite();
		var _height:Number;
		var _width:Number;
		var _x:Number;
		var _y:Number;
		var field:TextField = new TextField();
		
		public function Cross(_x:Number,_y:Number,_height:Number=100,_width:Number=100)
		{			
			this._x = _x;
			this._y = _y;
			
		//	this.noRotate = true;
		//	this.noScale = true;
			
			var startPointY:Number = _height / 3;
			var startPointX:Number = _width / 3;
			
			xline.graphics.lineStyle(3, 0x006633);
			xline.graphics.moveTo(-startPointX, _y);
			xline.graphics.lineTo(_width, _y);
			this.addChild(xline);
			
			yline.graphics.lineStyle(3, 0x006633);
			yline.graphics.moveTo(_x,-startPointY);
			yline.graphics.lineTo(_x,_height);
			this.addChild(yline);
			
			circle.graphics.beginFill(0xFF0000,1);
			circle.graphics.drawCircle(_x, _y, 13);
			circle.graphics.endFill();
			this.addChild(circle);	
			
			this.addChild(field);
			field.height = 20;
			field.width = 80;
			if (_x > _width - 80)
			{
			field.x = _x -14-80;
			}
			else
			{
			field.x = _x + 14;
			}
			field.y = _y + 14;
			var format:TextFormat = new TextFormat("Arial", 12, 0x00FF33);
			field.defaultTextFormat = format;
			field.background = true;
			field.backgroundColor = 0x000000;
			field.text = "(" + Utils.round(_x,10) + "," + Utils.round(_y,10) + ")";
		}
		

		public function clear()
		{
			xline.graphics.clear();
			yline.graphics.clear();
			circle.graphics.clear();
			this.parent.removeChild(this);
		}
		
	}
		
	}