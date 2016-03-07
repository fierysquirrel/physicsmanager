package;

import flash.geom.Point;

/**
 * ...
 * @author Henry D. Fernández B.
 */
class CollisionData//<G> 
{
	/*
	 * Collision normal vector.
	 * */
	var normal : Normal;
	
	/*
	 * Collision distance.
	 * */
	var distance : Float;
	
	//var gameObject : G;
	
	var position : Point;
	
	//public function new(gameObject : G,distance : Float, position : Point, normal : Normal) 
	public function new(distance : Float, position : Point, normal : Normal) 
	{	
		//this.gameObject = gameObject;
		this.normal = normal;
		this.distance = distance;
		this.position = position;
	}
	
	public function GetNormal() : Normal
	{
		return normal;
	}
	
	public function GetDistance() : Float
	{
		return distance;
	}
	
	public function GetPosition() : Point
	{
		return position;
	}
	
	/*public function GetGameObject() : G
	{
		return gameObject;
	}*/
}