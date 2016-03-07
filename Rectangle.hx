package;

import flash.display.Sprite;
import flash.geom.Point;

/**
 * ...
 * @author Henry D. Fernández B.
 */
class Rectangle extends Body
{
	/*
	 * Rectangle identifier.
	 * */
	public static var NAME : String = "RECTANGLE";
	
	/*
	 * Length of the normal lines.
	 * */
	public static var NORMAL_LENGTH : Int = 100;
	
	/*
	 * Normal that points to the 'north' of the rectangle.
	 * If the rectangle rotates, the normal will be recalculated, according.
	 * */
	private var normalUp : Point;
	
	/*
	 * Normal that points to the 'south' of the rectangle.
	 * * If the rectangle rotates, the normal will be recalculated, according.
	 * */
	private var normalDown : Point;
	
	/*
	 * Normal that points to the 'west' of the rectangle.
	 * * If the rectangle rotates, the normal will be recalculated, according.
	 * */
	private var normalLeft : Point;
	
	/*
	 * Normal that points to the 'east' of the rectangle.
	 * * If the rectangle rotates, the normal will be recalculated, according.
	 * */
	private var normalRight : Point;
	
	/*
	 * Normal that points to the 'north-west' of the rectangle.
	 * * If the rectangle rotates, the normal will be recalculated, according.
	 * */
	private var normalUpLeft : Point;
	
	/*
	 * Normal that points to the 'north-east' of the rectangle.
	 * * If the rectangle rotates, the normal will be recalculated, according.
	 * */
	private var normalUpRight : Point;
	
	/*
	 * Normal that points to the 'south-west' of the rectangle.
	 * * If the rectangle rotates, the normal will be recalculated, according.
	 * */
	private var normalDownLeft : Point;
	
	/*
	 * Normal that points to the 'south-east' of the rectangle.
	 * * If the rectangle rotates, the normal will be recalculated, according.
	 * */
	private var normalDownRight : Point;
	
	/*
	 * Rotation angle.
	 * */
	private var angle : Float;
	
	/*
	 * Non rotated width.
	 * Real rectangle's width. This is used because 'Sprite' class width is different.
	 * */
	private var nonRotatedWidth : Float;
	
	/*
	 * Non rotated height.
	 * Real rectangle's width. This is used because 'Sprite' class height is different.
	 * */
	private var nonRotatedHeight : Float;
	
	/*
	 * Normal up sprite line.
	 * Graphic representation.
	 * */
	private var normalUpLine : Sprite;
	
	/*
	 * Normal down sprite line.
	 * Graphic representation.
	 * */
	private var normalDownLine : Sprite;
	
	/*
	 * Normal left sprite line.
	 * Graphic representation.
	 * */
	private var normalLeftLine : Sprite;
	
	/*
	 * Normal right sprite line.
	 * Graphic representation.
	 * */
	private var normalRightLine : Sprite;
	
	/*
	 * Normal upLeft sprite line.
	 * Graphic representation.
	 * */
	private var normalUpLeftLine : Sprite;
	
	/*
	 * Normal upRight sprite line.
	 * Graphic representation.
	 * */
	private var normalUpRightLine : Sprite;
	
	/*
	 * Normal downLeft sprite line.
	 * Graphic representation.
	 * */
	private var normalDownLeftLine : Sprite;
	
	/*
	 * Normal downRight sprite line.
	 * Graphic representation.
	 * */
	private var normalDownRightLine : Sprite;
	
	/*
	 * Constructs a new circle.
	 *
	 * @param position initial position.
	 * @param width rectangle's width.
	 * @param height rectangle's height.
	 * @param rotation initial rotation.
	 * @param velocity initial velocity.
	 * @param color body's color.
	 * */
	public function new(position : Point,width : Float,height : Float, rotation : Float = 0,velocity : Point = null,color : Int = 0xFFFFFF) 
	{
		super(NAME, position, color);
		
		var lineW, lineH : Sprite;
		
		this.nonRotatedWidth = width;
		this.nonRotatedHeight = height;
		this.angle = rotation;
		
		if (isDebugging)
		{
			bounding.rotation = rotation;
			bounding.graphics.lineStyle(Body.BODY_LINE_THICKNESS,Body.BODY_LINE_COLOR,Body.BODY_LINE_ALPHA);
			bounding.graphics.beginFill(0x000000,0);
			bounding.graphics.drawRect(-width/2,-height/2, width, height);			
			bounding.graphics.endFill();
			
			lineW = new Sprite();
			lineH = new Sprite();
			
			//width distance
			lineW.graphics.lineStyle( Body.LINE_THICKNESS, Body.LINE_COLOR, Body.LINE_ALPHA);
			lineW.graphics.moveTo(0,0);
			lineW.graphics.lineTo(width / 2, 0);
			//height distance
			lineH.graphics.lineStyle( Body.LINE_THICKNESS, Body.LINE_COLOR, Body.LINE_ALPHA);
			lineH.graphics.moveTo(0,0);
			lineH.graphics.lineTo(0, height / 2);
			
			normalUpLine = new Sprite();
			normalDownLine = new Sprite();
			normalLeftLine = new Sprite();
			normalRightLine = new Sprite();
			
			normalUpLeftLine = new Sprite();
			normalUpRightLine = new Sprite();
			normalDownLeftLine = new Sprite();
			normalDownRightLine = new Sprite();
			
			#if windows
			//bounding.addChild(lineW);
			//bounding.addChild(lineH);
			/*
			addChild(normalUpLine);
			addChild(normalDownLine);
			addChild(normalLeftLine);
			addChild(normalRightLine);
			
			addChild(normalUpLeftLine);*/
			
			addChild(normalUpRightLine);
			bounding.addChild(normalDownLeftLine);
			bounding.addChild(normalDownRightLine);
			#end
		}
		
		UpdateNormals(angle);
	}
		
	/*
	 * Updates normal values from its new angle.
	 * @param angle a rotation in degrees.
	 * */
	private function UpdateNormals(angle : Float) : Void
	{
		var norX, norY : Float;
		
		norX = -Math.sin(angle * Globals.DEGREE_RAD_CONVERSION);
		norY = Math.cos(angle * Globals.DEGREE_RAD_CONVERSION);
		
		normalUp = new Point( -norX, -norY);
		normalDown = new Point(norX, norY);
		
		norX = -Math.sin((angle + 90) * Globals.DEGREE_RAD_CONVERSION);
		norY = Math.cos((angle + 90) * Globals.DEGREE_RAD_CONVERSION);
		
		normalLeft = new Point(norX, norY);
		normalRight = new Point( -norX, -norY);
		
		norX = -Math.sin((angle + 45) * Globals.DEGREE_RAD_CONVERSION);
		norY = Math.cos((angle + 45) * Globals.DEGREE_RAD_CONVERSION);
		
		normalDownLeft = new Point(norX, norY);
		normalUpRight = new Point( -norX, -norY);
		
		norX = -Math.sin((angle - 45) * Globals.DEGREE_RAD_CONVERSION);
		norY = Math.cos((angle - 45) * Globals.DEGREE_RAD_CONVERSION);
		
		normalDownRight = new Point(norX, norY);
		normalUpLeft = new Point( -norX, -norY);
		
		if (isDebugging)
		{
			normalUpLine.graphics.clear();
			normalUpLine.graphics.lineStyle(Body.LINE_THICKNESS,Body.LINE_COLOR,Body.LINE_ALPHA);
			normalUpLine.graphics.moveTo(0,0);
			normalUpLine.graphics.lineTo(normalUp.x * NORMAL_LENGTH, normalUp.y * NORMAL_LENGTH);
			
			normalDownLine.graphics.clear();
			normalUpLine.graphics.lineStyle(Body.LINE_THICKNESS,Body.LINE_COLOR,Body.LINE_ALPHA);
			normalDownLine.graphics.moveTo(0,0);
			normalDownLine.graphics.lineTo(normalDown.x * NORMAL_LENGTH, normalDown.y * NORMAL_LENGTH);
			
			normalLeftLine.graphics.clear();
			normalUpLine.graphics.lineStyle(Body.LINE_THICKNESS,Body.LINE_COLOR,Body.LINE_ALPHA);
			normalLeftLine.graphics.moveTo(0,0);
			normalLeftLine.graphics.lineTo(normalLeft.x * NORMAL_LENGTH, normalLeft.y * NORMAL_LENGTH);
			
			normalRightLine.graphics.clear();
			normalUpLine.graphics.lineStyle(Body.LINE_THICKNESS,Body.LINE_COLOR,Body.LINE_ALPHA);
			normalRightLine.graphics.moveTo(0,0);
			normalRightLine.graphics.lineTo(normalRight.x * NORMAL_LENGTH, normalRight.y * NORMAL_LENGTH);
			
			normalDownLeftLine.graphics.clear();
			normalUpLine.graphics.lineStyle(Body.LINE_THICKNESS,Body.LINE_COLOR,Body.LINE_ALPHA);
			normalDownLeftLine.graphics.moveTo(0,0);
			normalDownLeftLine.graphics.lineTo(normalDownLeft.x * NORMAL_LENGTH, normalDownLeft.y * NORMAL_LENGTH);
			
			normalUpRightLine.graphics.clear();
			normalUpLine.graphics.lineStyle(Body.LINE_THICKNESS,Body.LINE_COLOR,Body.LINE_ALPHA);
			normalUpRightLine.graphics.moveTo(0,0);
			normalUpRightLine.graphics.lineTo(normalUpRight.x * NORMAL_LENGTH, normalUpRight.y * NORMAL_LENGTH);
			
			normalDownRightLine.graphics.clear();
			normalUpLine.graphics.lineStyle(Body.LINE_THICKNESS,Body.LINE_COLOR,Body.LINE_ALPHA);
			normalDownRightLine.graphics.moveTo(0,0);
			normalDownRightLine.graphics.lineTo(normalDownRight.x * NORMAL_LENGTH, normalDownRight.y * NORMAL_LENGTH);
			
			normalUpLeftLine.graphics.clear();
			normalUpLine.graphics.lineStyle(Body.LINE_THICKNESS,Body.LINE_COLOR,Body.LINE_ALPHA);
			normalUpLeftLine.graphics.moveTo(0,0);
			normalUpLeftLine.graphics.lineTo(normalUpLeft.x * NORMAL_LENGTH, normalUpLeft.y * NORMAL_LENGTH);
		}
	}
	
	public function SetWidth(value : Float) : Void
	{
		nonRotatedWidth = value;
		bounding.width = value;
	}
	
	/*
	 * Gets non rotated width.
	 * The width value regardless its rotation.
	 * 
	 * @return non rotated width.
	 * */
	public function GetNonRotatedWidth() : Float
	{
		return nonRotatedWidth;
	}
	
	/*
	 * Gets non rotated height.
	 * The height value regardless its rotation.
	 * 
	 * @return non rotated height.
	 * */
	public function GetNonRotatedHeight() : Float
	{
		return nonRotatedHeight;
	}
	
	/*
	 * Gets rotation angle in degrees.
	 * 
	 * @return rotation angle (degrees).
	 * */
	public function GetRotationAngle() : Float
	{
		return this.angle;
	}
	
	/*
	 * Sets rotation angle in degrees.
	 * 
	 * @param angle angle value in degrees.
	 * */
	public function SetRotationAngle(angle :Float) : Void
	{
		this.angle = angle;
		UpdateNormals(angle);
		
		if (isDebugging)
			bounding.rotation = angle;
	}
	
	/*
	 * Gets the 'north' pointing normal vector.
	 * 
	 * @return south pointing normal vector.
	 * */
	public function GetNormalUp() : Point
	{
		return normalUp;
	}
	
	/*
	 * Gets the 'south' pointing normal vector.
	 * 
	 * @return 'south' pointing normal vector.
	 * */
	public function GetNormalDown() : Point
	{
		return normalDown;
	}
	
	/*
	 * Gets the 'west' pointing normal vector.
	 * 
	 * @return 'west' pointing normal vector.
	 * */
	public function GetNormalLeft() : Point
	{
		return normalLeft;
	}
	
	/*
	 * Gets the 'east' pointing normal vector.
	 * 
	 * @return 'east' pointing normal vector.
	 * */
	public function GetNormalRight() : Point
	{
		return normalRight;
	}
	
	/*
	 * Gets the 'north-west' pointing normal vector.
	 * 
	 * @return 'north-west' pointing normal vector.
	 * */
	public function GetNormalUpLeft() : Point
	{
		return normalUpLeft;
	}
	
	/*
	 * Gets the 'south-west' pointing normal vector.
	 * 
	 * @return 'south-west' pointing normal vector.
	 * */
	public function GetNormalDownLeft() : Point
	{
		return normalDownLeft;
	}
	
	/*
	 * Gets the 'north-east' pointing normal vector.
	 * 
	 * @return 'north-east' pointing normal vector.
	 * */
	public function GetNormalUpRight() : Point
	{
		return normalUpRight;
	}
	
	/*
	 * Gets the 'south-east' pointing normal vector.
	 * 
	 * @return 'south-east' pointing normal vector.
	 * */
	public function GetNormalDownRight() : Point
	{
		return normalDownRight;
	}
	
	public function GetCurrentNormal(dir : Normal.NormalDirection) : Point
	{
		var normalValue : Point;
		normalValue = new Point();
		switch(dir)
		{
			case Down:
				normalValue = GetNormalDown();
			case DownLeft:
				normalValue = GetNormalDownLeft();
			case DownRight:
				normalValue = GetNormalDownRight();
			case Left:
				normalValue = GetNormalLeft();
			case Right:
				normalValue = GetNormalRight();
			case Up:
				normalValue = GetNormalUp();
			case UpLeft:
				normalValue = GetNormalUpLeft();
			case UpRight:
				normalValue = GetNormalUpRight();
		}
		
		return normalValue;
	}
	
	public function DrawNormal(dir : Normal.NormalDirection)
	{
		var norm : Point;
		switch(dir)
		{
			case Down:
				norm = normalDown;
			case DownLeft:
				norm = normalDownLeft;
			case DownRight:
				norm = normalDownRight;
			case Left:
				norm = normalLeft;
			case Right:
				norm = normalRight;
			case Up:
				norm = normalUp;
			case UpLeft:
				norm = normalUpLeft;
			case UpRight:
				norm = normalUpRight;
		}
		
		graphics.clear();
		graphics.lineStyle(Body.LINE_THICKNESS,Body.LINE_COLOR,Body.LINE_ALPHA);
		graphics.moveTo(0,0);
		graphics.lineTo(norm.x * NORMAL_LENGTH, norm.y * NORMAL_LENGTH);
	}
}