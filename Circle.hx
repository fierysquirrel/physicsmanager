package;

import flash.display.Sprite;
import flash.geom.Point;

/**
 * ...
 * @author Henry D. Fernández B.
 */
class Circle extends Body
{
	/*
	 * Circle identifier.
	 * */
	public static var NAME : String = "CIRCLE";
	
	/*
	 * Circle's radius.
	 * */
	private var radius : Float;
	
	/*
	 * Constructs a new circle.
	 *
	 * @param position initial position.
	 * @param radius circle's radius.
	 * @param velocity initial velocity.
	 * @param color body's color.
	 * */
	public function new(position : Point,radius : Float,velocity : Point = null, color : Int = 0xFFFFFF) 
	{
		super(NAME, position, color,velocity);
		
		var line : Sprite;
		
		this.radius = radius;
		
		if (isDebugging)
		{
			//body
			bounding.graphics.lineStyle(Body.BODY_LINE_THICKNESS,Body.BODY_LINE_COLOR,Body.BODY_LINE_ALPHA);
			bounding.graphics.beginFill(0x000000,0);
			bounding.graphics.drawCircle(0,0, radius);
			bounding.graphics.endFill();
		
			line = new Sprite();
			
			//radius
			line.graphics.lineStyle(Body.LINE_THICKNESS,Body.LINE_COLOR,Body.LINE_ALPHA);
			line.graphics.moveTo(0,0);
			line.graphics.lineTo(Math.sin(0) * radius, Math.cos(0) * radius);
			
			#if windows
			addChild(line);
			#end
		}
	}
	
	/*
	 * Get the circle's radius.
	 *
	 * @return circle's radius.
	 * */
	public function GetRadius() : Float
	{
		return radius;
	}
	
	public function SetRadius(value : Float) : Void
	{
		radius = value;
	}
}