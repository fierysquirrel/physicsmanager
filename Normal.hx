package;

import flash.geom.Point;

enum NormalDirection
{
	Up;
	Down;
	Left;
	Right;
	UpLeft;
	UpRight;
	DownLeft;
	DownRight;
}

/**
 * ...
 * @author Henry D. Fernández B.
 */
class Normal 
{
	var value : Point;
	
	var direction : NormalDirection;
	
	public function new(value : Point, dir : NormalDirection) 
	{	
		this.value = value;
		this.direction = dir;
	}
	
	public function GetValue() : Point
	{
		return value;
	}
	
	public function GetDirection() : NormalDirection
	{
		return direction;
	}
}