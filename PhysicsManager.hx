package;

import flash.display.Sprite;
import flash.geom.Point;

/**
 * ...
 * @author Henry D. Fernández B.
 */

class PhysicsManager 
{
	//private var quadtree : Quadtree;	
	//private var gameObjects : Array<PhysicsObject>;
	
	public function new() 
	{
		//quadtree = new Quadtree(0, new flash.geom.Rectangle(0, 0, GraphicManager.GetWidth(), GraphicManager.GetHeight()),null);
		//gameObjects = new Array<PhysicsObject>();
	}
	
	/*public function AddGameObject(gameObject : PhysicsObject) : Void
	{
		//gameObjects.push(gameObject);
		quadtree.Insert(gameObject);
	}
	
	public function RemoveGameObject(gameObject : PhysicsObject) : Void
	{
		gameObjects.remove(gameObject);
	}*/
	
	public function Update(gameTime : Float) : Void
	{
	}
	
	/*public function UpdateQuadElement(element : PhysicsObject) : Void
	{
		//TODO: check if it was moved from the previous quad
		//If was moved: Remove and Insert again
		//Else: do nothing
	}*/
	
	public function HandleCircleCircleCollision(c1 : Circle, c2 : Circle) : Float
	{		
		var mod,p,rad,pX,pY,nX,nY : Float;
		
		rad = c1.GetRadius() + c2.GetRadius();
		mod = Math.sqrt(Math.pow(c1.x - c2.x, 2) + Math.pow(c1.y - c2.y, 2));
		
		p = mod - rad;
		
		nX = (c1.x - c2.x) / mod;
		nY = (c1.y - c2.y) / mod;
		pX = nX * Math.abs(p);
		pY = nY * Math.abs(p);
		
		return p;
	}
	
	public function GetCollisionNormal(currentCircle : Circle,futureCircle : Circle, rectangle : Rectangle) : Normal
	{
		var cx, cy, cr, rx, ry, rw, rh : Float;
		var value,cTransformed  : Point;
		var ccx, ccy, ccr : Float;
		var transformedCurrentCircle : Point;
		var normal : Normal;
		var dir : Normal.NormalDirection;
		
		//cTransformed = TransformCoordinates(futureCircle, rectangle);
		cTransformed = TransformCoordinates(currentCircle, rectangle);
		value = new Point();
		dir = Normal.NormalDirection.Down;
		cx = cTransformed.x;
		cy = cTransformed.y;		
		cr = futureCircle.GetRadius();
		rx = rectangle.GetPosition().x;
		ry = rectangle.GetPosition().y;
		rw = rectangle.GetNonRotatedWidth();
		rh = rectangle.GetNonRotatedHeight();
		
		transformedCurrentCircle = TransformCoordinates(currentCircle, rectangle);
		ccx = transformedCurrentCircle.x;
		ccy = transformedCurrentCircle.y;		
		ccr = currentCircle.GetRadius();
		
		//inside the rectangle (x axis)
		if (cx - cr <= rx + rw/2 && cx + cr >= rx - rw/2)
		{
			//Up
			if (cy < ry)
			{
				value = rectangle.GetNormalUp();
				dir = Normal.NormalDirection.Up;
			}
			//Down
			else if (cy > ry)
			{
				value = rectangle.GetNormalDown();
				dir = Normal.NormalDirection.Down;
			}
		}
		//inside the rectangle (y axis)
		else if (cy - cr <= ry + rh/2 && cy + cr >= ry - rh/2)
		{
			//Left
			if (cx < rx)
			{
				value = rectangle.GetNormalLeft();
				dir = Normal.NormalDirection.Left;
			}
			//Right
			else if (cx > rx)
			{
				value = rectangle.GetNormalRight();
				dir = Normal.NormalDirection.Right;
			}
		}
		//Corners
		else
		{
			//Up
			if (cy < ry)
			{
				//Left
				if (cx < rx)
				{
					value = rectangle.GetNormalUpLeft();
					dir = Normal.NormalDirection.UpLeft;
				}
				//Right
				else if (cx > rx)
				{
					value = rectangle.GetNormalUpRight();
					dir = Normal.NormalDirection.UpRight;
				}
			}
			//Down
			else if (cy > ry)
			{
				//Left
				if (cx < rx)
				{
					value = rectangle.GetNormalDownLeft();
					dir = Normal.NormalDirection.DownLeft;
				}
				//Right
				else if (cx > rx)
				{
					value = rectangle.GetNormalDownRight();
					dir = Normal.NormalDirection.DownRight;
				}
			}
		}
		
		normal = new Normal(value, dir);
		return normal;
	}
	
	public function HandleCircleOBBCollision(currentCircle : Circle,futureCircle : Circle,rectangle : Rectangle, normal : Normal) : CollisionData
	{
		var rectW, rectH, currCircR,futuCircR, distance : Float;
		var currCircPos, futuCircPos, rectPos, newPos, futuCircDiffRect, futuCircRectClamp, futuCircCollision, currCircDiffRect, currCircRectClamp : Point;
		var collisionData : CollisionData;
		
		//Initial values
		rectPos = rectangle.GetPosition();
		futuCircR = futureCircle.GetRadius();
		currCircR = futureCircle.GetRadius();
		newPos = null;
		collisionData = null;
		//Rectangle real size: width and height
		rectW = rectangle.GetNonRotatedWidth();
		rectH = rectangle.GetNonRotatedHeight();
		
		futuCircPos = TransformCoordinates(futureCircle, rectangle);
		currCircPos = TransformCoordinates(currentCircle, rectangle);
		
		//Position difference between circle and rectangle
		currCircDiffRect = new Point(currCircPos.x - rectPos.x, currCircPos.y - rectPos.y);
		futuCircDiffRect = new Point(futuCircPos.x - rectPos.x, futuCircPos.y - rectPos.y);
		//Clamping vector to rectangle dimensions
		currCircRectClamp = MathHelper.Clamp(currCircDiffRect, new Point(rectW/2, rectH/2));
		futuCircRectClamp = MathHelper.Clamp(futuCircDiffRect, new Point(rectW/2, rectH/2));
		//Collision vector
		futuCircCollision = new Point(futuCircDiffRect.x - futuCircRectClamp.x, futuCircDiffRect.y - futuCircRectClamp.y);
		//Collision distance
		distance = futuCircCollision.length - futuCircR;
		
		if (distance < 0)
		{
			/*//Inside X boundaries
			if (futuCircPos.x + futuCircR >= rectPos.x - rectW / 2 && futuCircPos.x - futuCircR <= rectPos.x + rectW / 2)
			{*/
				//Up collision
				if (currCircPos.y < rectPos.y)
				{
					newPos = new Point();
					newPos.x = futuCircPos.x;
					newPos.y = rectPos.y - rectH / 2 - futuCircR;
				}
				//Down collision
				else
				{
					newPos = new Point();
					newPos.x = futuCircPos.x;
					newPos.y = rectPos.y + rectH / 2 + futuCircR;
				}
			//}
			//Inside Y boundaries
			/*else
			if (futuCircPos.y + futuCircR >= rectPos.y - rectH / 2 && futuCircPos.y - futuCircR <= rectPos.y + rectH / 2)
			{*/
				//Left collision
				if (futuCircPos.x < rectPos.x)
				{
					newPos = new Point();
					newPos.x = rectPos.x - rectW/2 - futuCircR;
					newPos.y = futuCircPos.y;
				}
				//Right collision
				else
				{
					newPos = new Point();
					newPos.x = rectPos.x + rectW/2 + futuCircR;
					newPos.y = futuCircPos.y;
				}
			/*}
			else
			{
				trace("fuera y");
			}*/
			
			newPos = MathHelper.TransformPoint(newPos, rectPos, MathHelper.ConvertDegToRad(rectangle.GetRotationAngle()));
			
			collisionData = new CollisionData(Math.abs(distance),newPos,normal);
		}
			
		return collisionData;
	}
	
	public function HandleCircleOBBCollision2(currentCircle : Circle,futureCircle : Circle,rectangle : Rectangle, normal : Normal) : CollisionData
	{
		var rectW, rectH, currCircR,futuCircR, distance : Float;
		var currCircPos, futuCircPos, rectPos, newPos, futuCircDiffRect, futuCircRectClamp, futuCircCollision, currCircDiffRect, currCircRectClamp : Point;
		var collisionData : CollisionData;
		
		//Initial values
		rectPos = rectangle.GetPosition();
		futuCircR = futureCircle.GetRadius();
		currCircR = futureCircle.GetRadius();
		newPos = null;
		collisionData = null;
		//Rectangle real size: width and height
		rectW = rectangle.GetNonRotatedWidth();
		rectH = rectangle.GetNonRotatedHeight();
		
		futuCircPos = TransformCoordinates(futureCircle, rectangle);
		currCircPos = TransformCoordinates(currentCircle, rectangle);
		
		//Position difference between circle and rectangle
		currCircDiffRect = new Point(currCircPos.x - rectPos.x, currCircPos.y - rectPos.y);
		futuCircDiffRect = new Point(futuCircPos.x - rectPos.x, futuCircPos.y - rectPos.y);
		//Clamping vector to rectangle dimensions
		currCircRectClamp = MathHelper.Clamp(currCircDiffRect, new Point(rectW/2, rectH/2));
		futuCircRectClamp = MathHelper.Clamp(futuCircDiffRect, new Point(rectW/2, rectH/2));
		//Collision vector
		futuCircCollision = new Point(futuCircDiffRect.x - futuCircRectClamp.x, futuCircDiffRect.y - futuCircRectClamp.y);
		//Collision distance
		distance = futuCircCollision.length - futuCircR;
		
		
		var dx, dy : Float;
		
		dx = Math.abs(rectPos.x - futuCircPos.x) - (rectW + futuCircR * 2) / 2;
		dy = Math.abs(rectPos.y - futuCircPos.y) - (rectH + futuCircR * 2) / 2;
		
		if (dx < 0 && dy < 0)
		{
			//Inside X boundaries
			if (currCircPos.y + currCircR < rectPos.y - rectH/2 || currCircPos.y  - currCircR > rectPos.y + rectH/2)
			{
				if (futuCircPos.x + futuCircR >= rectPos.x - rectW / 2 && futuCircPos.x - futuCircR <= rectPos.x + rectW / 2)
				{
					//Up collision
					if (currCircPos.y < rectPos.y)
					{
						newPos = new Point();
						newPos.x = futuCircPos.x;
						newPos.y = rectPos.y - (rectH / 2) - currCircR;
					}
					//Down collision
					else
					{
						newPos = new Point();
						newPos.x = futuCircPos.x;
						newPos.y = rectPos.y + (rectH / 2) + currCircR;
					}
				}
			}
			//Inside Y boundaries
			else if (currCircPos.x + currCircR < rectPos.x - rectW/2 || currCircPos.x  - currCircR > rectPos.x + rectW/2)
			{
				if (futuCircPos.y + futuCircR >= rectPos.y - rectH / 2 && futuCircPos.y - futuCircR <= rectPos.y + rectH / 2)
				{
					//Left collision
					if (futuCircPos.x < rectPos.x)
					{
						newPos = new Point();
						newPos.x = rectPos.x - rectW/2 - futuCircR;
						newPos.y = futuCircPos.y;
					}
					//Right collision
					else
					{
						newPos = new Point();
						newPos.x = rectPos.x + rectW/2 + futuCircR;
						newPos.y = futuCircPos.y;
					}
				}
			}
			else
			{
				if (futuCircPos.x + futuCircR >= rectPos.x - rectW / 2 && futuCircPos.x - futuCircR <= rectPos.x + rectW / 2)
				{
					//Up collision
					if (currCircPos.y < rectPos.y)
					{
						newPos = new Point();
						newPos.x = futuCircPos.x;
						newPos.y = rectPos.y - (rectH / 2) - currCircR;
					}
					//Down collision
					else
					{
						newPos = new Point();
						newPos.x = futuCircPos.x;
						newPos.y = rectPos.y + (rectH / 2) + currCircR;
					}
				}
				else if (futuCircPos.y + futuCircR >= rectPos.y - rectH / 2 && futuCircPos.y - futuCircR <= rectPos.y + rectH / 2)
				{
					//Left collision
					if (futuCircPos.x < rectPos.x)
					{
						newPos = new Point();
						newPos.x = rectPos.x - rectW/2 - futuCircR;
						newPos.y = futuCircPos.y;
					}
					//Right collision
					else
					{
						newPos = new Point();
						newPos.x = rectPos.x + rectW/2 + futuCircR;
						newPos.y = futuCircPos.y;
					}
				}
			}
			
			newPos = MathHelper.TransformPoint(newPos, rectPos, MathHelper.ConvertDegToRad(rectangle.GetRotationAngle()));
			collisionData = new CollisionData(Math.abs(distance),newPos,normal);
		}
			
		return collisionData;
	}
	
	public function HandleAABBCollision(r1 : Rectangle, r2 : Rectangle) : Bool
	{		
		var dx,dy : Float;
		
		dx = Math.abs(r1.GetPosition().x - r2.GetPosition().x) - (r1.GetNonRotatedWidth() + r2.GetNonRotatedWidth()) / 2;
		dy = Math.abs(r1.GetPosition().y - r2.GetPosition().y) - (r1.GetNonRotatedHeight() + r2.GetNonRotatedHeight()) / 2;
			
		return (dx < 0 && dy < 0);
	}
	
	public function HandleAABBCircleCollision(r : Rectangle, c : Circle) : Bool
	{		
		var dx, dy : Float;
		
		dx = Math.abs(r.GetPosition().x - c.GetPosition().x) - (r.GetNonRotatedWidth() + c.GetRadius() * 2) / 2;
		dy = Math.abs(r.GetPosition().y - c.GetPosition().y) - (r.GetNonRotatedHeight() + c.GetRadius() * 2) / 2;
			
		return dx < 0 && dy < 0;
	}
	
	public function Draw(container : Sprite) : Void
	{
		//quadtree.Draw(container);
	}
	
	/*
	 * Transform the circle coordinates compared to the rotated rectangle.
	 * This function is used to perform physics collision between a rotated rectangle and a circle.
	 * 
	 * */
	public static function TransformCoordinates(circle : Circle,rectangle : Rectangle) : Point
	{
		var newX, newY, angle, cx,cy,rx,ry : Float;
		
		cx = circle.GetPosition().x;
		cy = circle.GetPosition().y;
		rx = rectangle.GetPosition().x;
		ry = rectangle.GetPosition().y;
		angle = rectangle.GetRotationAngle();
		
		newX = Math.cos(MathHelper.ConvertDegToRad(-angle)) * (cx - rx) - Math.sin(MathHelper.ConvertDegToRad(-angle)) * (cy - ry) + rx;
		newY = Math.sin(MathHelper.ConvertDegToRad(-angle)) * (cx - rx) + Math.cos(MathHelper.ConvertDegToRad(-angle)) * (cy - ry) + ry;

		
		return new Point(newX,newY);
	}
}