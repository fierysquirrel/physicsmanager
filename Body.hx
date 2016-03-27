package;

import flash.display.Sprite;
import flash.geom.Point;

/**
 * ...
 * @author Henry D. Fernández B.
 */
class Body extends Sprite
{
	/*
	 * Debugging center radius size.
	 * */
	private static var CENTER_RADIUS : Int = 5;
	
	/*
	 * Debugging center color.
	 * */
	private static var CENTER_COLOR : Int = 0xec1b1b;
	
	/*
	 * Debugging line thickness.
	 * */
	private static var LINE_THICKNESS : Int = 1;
	
	/*
	 * Debugging line color.
	 * */
	private static var LINE_COLOR : Int = 0x000000;
	
	/*
	 * Debugging line alpha.
	 * */
	private static var LINE_ALPHA : Float = 1;
	
	/*
	 * Debugging line thickness.
	 * */
	private static var BODY_LINE_THICKNESS : Int = 1;
	
	/*
	 * Debugging line color.
	 * */
	private static var BODY_LINE_COLOR : Int = 0xec1b1b;
	
	/*
	 * Debugging line alpha.
	 * */
	private static var BODY_LINE_ALPHA : Float = 2;
	
	/*
	 * Body's name.
	 * This is used to identify each class derived from Body.
	 * */
	private var bodyName : String;
	
	/*
	 * Body's velocity.
	 * */
	private var velocity : Point;
	
	/*
	 * Body's acceleration.
	 * */
	private var acceleration : Point;
	
	/*
	 * Body's color.
	 * */
	private var color : Int;
	
	/*
	 * Is it debugging?
	 * */
	private var isDebugging : Bool = true;
	
	private var bounding : Sprite;
	
	/*
	 * Constructs a new body.
	 *
	 * @param name unique identifier to distinguishe the derived classes.
	 * @param position initial position.
	 * @param color body's color.
	 * @param velocity initial velocity.
	 * */
	public function new(name : String,position : Point,color : Int, velocity : Point = null, acceleration : Point = null) 
	{	
		super();
			
		var center : Sprite;
		
		this.bodyName = name;
		this.color = color;
		this.velocity = velocity != null ? velocity : new Point();
		this.acceleration = acceleration != null ? acceleration : new Point();
		
		SetPosition(position);
		
		if (isDebugging)
		{
			bounding = new Sprite();
			#if windows
			addChild(bounding);
			#end
			center = new Sprite();
			//center
			center.graphics.beginFill(CENTER_COLOR);
			center.graphics.drawCircle(0,0,CENTER_RADIUS);
			center.graphics.endFill();
			
			#if windows
			addChild(center);
			#end
		}
		
		this.alpha = 0.6;
	}
	
	/*
	 * Gets body's name.
	 * This is used to identify each class derived from Body.
	 * 
	 * @return Body's name (unique).
	 * */
	public function GetName() : String
	{
		return bodyName;
	}
	
	/*
	 * Gets current position (respect to the screen).
	 * 
	 * @return current position.
	 * */
	public function GetPosition() : Point
	{
		return new Point(x,y);
	}
	
	/*
	 * Sets the current position to 'value'.
	 * currentPosition = position
	 * 
	 * @param value the X position and Y position to set as new position.
	 * */
	public function SetPosition(value :Point) : Void
	{
		x = value.x;
		y = value.y;
	}
	
	/*
	 * Gets current velocity.
	 * 
	 * @return current velocity.
	 * */
	public function GetVelocity() : Point
	{
		return velocity;
	}
	
	/*
	 * Set the current velocity to 'value'.
	 * currentVelocity = velocity
	 * 
	 * @param value the X speed and Y speed to set as new velocity.
	 * */
	public function SetVelocity(value :Point) : Void
	{
		this.velocity = value;
	}
	
	/*
	 * Set the current velocity to 'value'.
	 * currentVelocity = velocity
	 * 
	 * @param value the X speed and Y speed to set as new velocity.
	 * */
	public function SetVelocityX(value :Float) : Void
	{
		this.velocity.x = value;
	}
	
	/*
	 * Set the current velocity to 'value'.
	 * currentVelocity = velocity
	 * 
	 * @param value the X speed and Y speed to set as new velocity.
	 * */
	public function SetVelocityY(value :Float) : Void
	{
		this.velocity.y = value;
	}
	
	/*
	 * Set the current velocity to 'value'.
	 * currentVelocity = velocity
	 * 
	 * @param value the X speed and Y speed to set as new velocity.
	 * */
	public function SetPositionX(value :Float) : Void
	{
		x = value;
	}
	
	/*
	 * Set the current velocity to 'value'.
	 * currentVelocity = velocity
	 * 
	 * @param value the X speed and Y speed to set as new velocity.
	 * */
	public function SetPositionY(value :Float) : Void
	{
		y = value;
	}
	
	/*
	 * Gets current acceleration.
	 * 
	 * @return current acceleration.
	 * */
	public function GetAcceleration() : Point
	{
		return acceleration;
	}
	
	/*
	 * Set the current acceleration to 'value'.
	 * currentAcceleration = acceleration
	 * 
	 * @param value the value as new acceleration.
	 * */
	public function SetAcceleration(value :Point) : Void
	{
		this.acceleration = value;
	}
	
	/*
	 * Updates the current position using 'position'.
	 * currentPosition += position
	 * 
	 * @param position the X position and Y position to add to the current position.
	 * */
	public function UpdatePosition(position : Point) : Void
	{
		x += position.x;
		y += position.y;
	}
	
	/*
	 * Updates the current velocity using 'velocity'.
	 * currentVelocity += velocity
	 * 
	 * @param velocity the X speed and Y speed to add to the current velocity.
	 * */
	public function UpdateVelocity(velocity : Point) : Void
	{
		this.velocity.x += velocity.x;
		this.velocity.y += velocity.y;
	}
	
	/*
	 * Updates the current acceleration using 'acceleration'.
	 * currentAcceleration += acceleration
	 * 
	 * @param acceleration the value to add to the current acceleration.
	 * */
	public function UpdateAcceleration(acceleration : Point) : Void
	{
		this.acceleration.x += acceleration.x;
		this.acceleration.y += acceleration.y;
	}
	
	/*
	 * Updates the body position based on its velocity.
	 * position += velocity
	 * */
	public function Update(gameTime : Float) : Void
	{
		velocity.x += acceleration.x;
		velocity.y += acceleration.y;
		
		x += velocity.x;
		y += velocity.y;
	}
}