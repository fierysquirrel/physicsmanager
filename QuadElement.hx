package;

import flash.display.Sprite;


/**
 * ...
 * @author Henry D. Fernández B.
 */

class QuadElement
{
	private var gameObject : PhysicsObject;
	private var elements : Array<QuadElement>;
	private var parent : Quadtree;
 
	public function new(gameObject : PhysicsObject,elements : Array<QuadElement>, parent : Quadtree) 
	{
		this.gameObject = gameObject;
		this.elements = elements;
		this.parent = parent;
	}
	
	/*
	* Clears the quadtree
	*/
	public function Clear() : Void
	{
		//Clean
		for (o in objects)
			objects.remove(o);
		//objects.splice(0,objects.length);
		
		for (n in nodes) 
		{
			if (n != null) 
			{
				n.Clear();
				nodes.remove(n);
				//n = null;
			}
		}
	}
	
	/*
	* Splits the node into 4 subnodes
	*/
	private function Split() : Void
	{
		var subWidth, subHeight, x, y : Float;
		
		subWidth = bounds.width / 2;
		subHeight = bounds.height / 2;
		x = bounds.x;
		y = bounds.y;
 
		nodes[0] = new Quadtree(level+1, new flash.geom.Rectangle(x + subWidth, y, subWidth, subHeight),this);
		nodes[1] = new Quadtree(level+1, new flash.geom.Rectangle(x, y, subWidth, subHeight),this);
		nodes[2] = new Quadtree(level+1, new flash.geom.Rectangle(x, y + subHeight, subWidth, subHeight),this);
		nodes[3] = new Quadtree(level+1, new flash.geom.Rectangle(x + subWidth, y + subHeight, subWidth, subHeight),this);
	}
	
	/*
	* Determine which node the object belongs to. -1 means
	* object cannot completely fit within a child node and is part
	* of the parent node
	*/
	private function GetIndices(gameObj : PhysicsObject) : Array<Int>
	{
		var indices : Array<Int>;
		var verticalMidpoint, horizontalMidpoint : Float;
		var topQuadrant, bottomQuadrant : Bool;
		var pRect : flash.geom.Rectangle;
		
		pRect = new flash.geom.Rectangle(gameObj.GetPosition().x, gameObj.GetPosition().y, gameObj.GetW(), gameObj.GetH());
		indices = new Array<Int>();
		verticalMidpoint = bounds.x + (bounds.width / 2);
		horizontalMidpoint = bounds.y + (bounds.height / 2);
		
		//Top-Right quadrant: 0
		if (pRect.x + (pRect.width / 2) >= verticalMidpoint && pRect.x - (pRect.width / 2) <= verticalMidpoint + (bounds.width / 2))
		{
			if (pRect.y + (pRect.height / 2) >= horizontalMidpoint - (bounds.height / 2) && pRect.y - (pRect.height / 2) <= horizontalMidpoint)
				indices.push(0);
		}
		
		//Top-Left quadrant: 1
		if (pRect.x + (pRect.width / 2) >= verticalMidpoint - (bounds.width/2) && pRect.x - (pRect.width / 2) <= verticalMidpoint)
		{
			if (pRect.y + (pRect.height / 2) >= horizontalMidpoint - (bounds.height / 2) && pRect.y - (pRect.height / 2) <= horizontalMidpoint)
				indices.push(1);
		}
		
		//Bottom-Left quadrant: 2
		if (pRect.x + (pRect.width / 2) >= verticalMidpoint - (bounds.width/2) && pRect.x - (pRect.width / 2) <= verticalMidpoint)
		{
			if (pRect.y + (pRect.height / 2) >= horizontalMidpoint && pRect.y - (pRect.height / 2) <= horizontalMidpoint + (bounds.height / 2))
				indices.push(2);
		}
		
		//Bottom-Right quadrant: 3
		if (pRect.x + pRect.width / 2 >= verticalMidpoint && pRect.x - pRect.width / 2 <= verticalMidpoint + bounds.width / 2)
		{
			if (pRect.y + (pRect.height / 2) >= horizontalMidpoint && pRect.y - (pRect.height / 2) <= horizontalMidpoint + (bounds.height / 2))
				indices.push(3);
		}
		
		if (indices.length <= 0)
			indices.push( -1);
			
		return indices;
	}
	
	/*
	* Insert the object into the quadtree. If the node
	* exceeds the capacity, it will split and add all
	* objects to their corresponding nodes.
	*/
	public function Insert(gameObj : PhysicsObject) : Void
	{
		var indices : Array<Int>;
		var i : Int;
		var obj : GameObject;
		
		if (nodes[0] != null) 
		{
			indices = GetIndices(gameObj);
			for (ii in indices)
			{
				if (ii != -1) 
				{
					nodes[ii].Insert(gameObj);
				}
			}
			
			return;
		}
		
		objects.push(gameObj);
		
		if (objects.length > MAX_OBJECTS && level < MAX_LEVELS) 
		{
			if (nodes[0] == null)  
				Split();
			
			i = 0;
			while(i < objects.length)
			{
				obj = objects[i];
				indices = GetIndices(obj);
				for (ii in indices)
				{
					if (ii != -1)
					{
						nodes[ii].Insert(obj);
						objects.remove(obj);
					}
					else
						i++;
				}
			}
		}
	}
	
	/*
	* Return all objects that could collide with the given object
	*/
	public function Retrieve(returnObjects : List<PhysicsObject>,gameObj : PhysicsObject) : List<PhysicsObject>
	{
		var indices : Array<Int>;
		
		indices = GetIndices(gameObj);
		
		//It allows objects collide check collision with every child in the tree when they are in the border
		for (i in indices)
		{
			if (nodes[0] != null && i != -1) 
				nodes[i].Retrieve(returnObjects, gameObj);
				
			for (o in objects)
			{
				if(gameObj != o && gameObj.CheckQuadtreeCondition(o))
					returnObjects.add(o);
			}
		}
		
		return returnObjects;
	}
	
	public function Draw(container : Sprite) : Void
	{
		if (container != null)
		{
			container.graphics.lineStyle( 2, 0xffffff, 0.5);
			container.graphics.moveTo(bounds.x + bounds.width/2,bounds.y);
			container.graphics.lineTo(bounds.x + bounds.width / 2, bounds.y + bounds.height);
			
			container.graphics.lineStyle( 2, 0xffffff, 0.5);
			container.graphics.moveTo(bounds.x,bounds.y + bounds.height/2);
			container.graphics.lineTo(bounds.x + bounds.width, bounds.y + bounds.height / 2);
		}
		
		for (n in nodes)
		{
			if(n!=null)
				n.Draw(container);
		}
	}
}