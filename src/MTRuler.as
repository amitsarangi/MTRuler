package 
{
	import app.core.action.RotatableScalable;
	import flash.display.Sprite;
	import flash.events.TouchEvent;
	import flash.events.TUIO;
	import flash.events.Event;
	import caurina.transitions.Tweener;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.geom.Point;
	import flash.display.StageDisplayState;
	
	[SWF(width="1024", height="768", frameRate="31", backgroundColor="#000000")]

	public class MTRuler extends Sprite 
	{	
		var rect:Sprite    = new Sprite();
		var resultbox:RotatableScalable = new RotatableScalable();
		var pxtextbox:TextField = new TextField();
		var intextbox:TextField = new TextField();
		var cmtextbox:TextField = new TextField();
		var calbtn:MTButton ;
		var tf:TextFormat = new TextFormat("Arial", 15, 0x00FF00);
		var isCaliberating:Boolean = false;
		var x1:Number = stage.fullScreenWidth / 2 - 65;
		var _x:Number;
		var _y:Number;
		var calblobs:Array = new Array();
		
		public function MTRuler()
		{
			TUIO.init(this, 'localhost', 3000, '', true);
			stage.displayState = StageDisplayState.FULL_SCREEN;
			
			rect.graphics.beginFill(0x000000,1);
			rect.graphics.drawRect(0,0,stage.fullScreenWidth,stage.fullScreenHeight);
			this.addChild(rect); 
			
			addComponents();
			
			rect.addEventListener(Event.ENTER_FRAME, update);
			rect.addEventListener(Event.ENTER_FRAME, updateText);
		}	
		
		private function doCaliberate(event:Event=null):void
		{
			if (!isCaliberating)
			{
			Tweener.addTween(calbtn, {x:x1,y:_y,time:2,transition:"linear"} );
			isCaliberating = true;
			}
			else
			{
			Tweener.addTween(calbtn, { x:_x, y:_y, time:2, transition:"linear" } );
			isCaliberating = false;
			}
		}
		
		
		private function addComponents():void
		{
			addResultbox();
		}
		
		
		private function addResultbox():void
		{
			
			resultbox.graphics.beginFill(0x333333, 0.5);
			resultbox.graphics.drawRoundRect(20, 20,160, 100, 15, 15);
			resultbox.graphics.endFill();
			resultbox.noRotate = true;
			resultbox.noMove = false;
			stage.addChild(resultbox);
			
			pxtextbox.selectable = false;
			pxtextbox.width = 130;
			pxtextbox.height = 20;
			pxtextbox.background = false;
			pxtextbox.defaultTextFormat = tf;
			pxtextbox.text = "Pixel : N/A";
			pxtextbox.x = 35;
			pxtextbox.y = 28;
			resultbox.addChild(pxtextbox);
			
			intextbox.selectable = false;
			intextbox.width = 130;
			intextbox.height = 20;
			intextbox.background = false;
			intextbox.defaultTextFormat = tf;
			intextbox.text = "Inches : N/A";
			intextbox.x = 35;
			intextbox.y = 56;
			resultbox.addChild(intextbox);
			
			cmtextbox.selectable = false;
			cmtextbox.width = 130;
			cmtextbox.height = 20;
			cmtextbox.background = false;
			cmtextbox.defaultTextFormat = tf;
			cmtextbox.text = "Cm : N/A";
			cmtextbox.x = 35;
			cmtextbox.y = 84;
			resultbox.addChild(cmtextbox);

			calbtn = new MTButton("Calibrate 6Inch", 130, 25, new TextFormat("Arial", 15, 0xFF0000));
			calbtn.noRotate = true;
			calbtn.noScale = true;
			calbtn.noMove = true;
			calbtn.x = 35;
			calbtn.y = 112;
			_x = 35;
			_y = 112;
			resultbox.addChild(calbtn);
			calbtn.addEventListener(TouchEvent.CLICK, doCaliberate);
		}
		
		public function update(event:Event):void 
		{
			try 
			{
			removeChildAt(0);
			getChildAt(0).clear();
			}
			catch (ex:Error)
			{
				
			}
			
			var blobs:Array = TUIO.returnBlobs();
			if (blobs.length < 3)
			{
			for (var i:Number = 0; i < TUIO.returnBlobs().length; i++)
			{
				addChildAt(new Cross(blobs[i].x, blobs[i].y, stage.fullScreenWidth * 3, stage.fullScreenHeight * 3),0);
			}
			}
		}
		
		public function updateText(event:Event)
		{
			if (!isCaliberating)
			{
			if (TUIO.returnBlobs().length == 2)
			{
				var distance:Number = Point.distance(new Point(TUIO.returnBlobs()[0].x, TUIO.returnBlobs()[0].y), new Point(TUIO.returnBlobs()[1].x, TUIO.returnBlobs()[1].y));
				pxtextbox.text = "Pixel : " + Utils.round(distance, 10);
				if (Utils.Caliberated())
				{
				intextbox.text = "Inches : "+Utils.round(Utils.getInch(distance),10);
				cmtextbox.text = "Cm : "+Utils.round(Utils.getCm(distance),10);
				}
			}
			else
			{
			pxtextbox.text = "Pixel : N/A";
			intextbox.text = "Inches : N/A";
			cmtextbox.text = "Cm : N/A";
			}
			}
			else
			{
				if (TUIO.returnBlobs().length > 2)
				{
					var p1:Point = new Point(TUIO.returnBlobs()[0].x, TUIO.returnBlobs()[0].y);
					var p2:Point = new Point(TUIO.returnBlobs()[1].x, TUIO.returnBlobs()[1].y);
					var dist:Number = Point.distance(p1, p2);
					Utils.setPixPerInch(dist / 6);
					Tweener.addTween(calbtn, { x:_x, y:_y, time:2, transition:"linear" } );
					isCaliberating = false;
				}
			}
			
		}
	}
}