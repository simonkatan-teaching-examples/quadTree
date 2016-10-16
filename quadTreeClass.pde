class QuadTree
{
  // Arbitrary constant to indicate how many elements can be stored in this quad tree node
  final int QT_NODE_CAPACITY = 1;

  // Axis-aligned bounding box stored as a center with half-dimensions
  // to represent the boundaries of this quad tree
  AABB boundary;

  // Points in this quad tree node
  ArrayList<PVector> points;
  boolean ignore = false;
  boolean visited = false;

  // Children
  QuadTree northWest; //0
  QuadTree northEast; //1
  QuadTree southWest; //2
  QuadTree southEast; //3
  
  QuadTree parent = null;

  // Methods
  QuadTree(AABB _boundary, QuadTree _parent) 
  {
    boundary = _boundary;

    northWest = null;
    northEast = null;
    southWest = null;
    southEast = null;
    
    parent = _parent;

    points = new ArrayList<PVector>();
  }

  boolean insert(PVector p) {
    // Ignore objects that do not belong in this quad tree
    if (!boundary.containsPoint(p))
      return false; // object cannot be added

    // If there is space in this quad tree, add the object here
    if (points.size() < QT_NODE_CAPACITY)
    {
      points.add(p);
      return true;
    }

    // Otherwise, subdivide and then add the point to whichever node will accept it
    if (northWest == null)
      subdivide();

    if (northWest.insert(p)) return true;
    if (northEast.insert(p)) return true;
    if (southWest.insert(p)) return true;
    if (southEast.insert(p)) return true;

    // Otherwise, the point cannot be inserted for some unknown reason (this should never happen)
    return false;
  }
  
  ArrayList <QuadTree> getChildren()
  {
    ArrayList<QuadTree> children = new ArrayList<QuadTree>();
    
    if (northWest != null)
    {
      children.add(northWest);
      children.add(northEast);
      children.add(southEast);
      children.add(southWest);
    }
      
    return children;
    
  }

  void subdivide() 
  {
    float h = boundary.halfDimension/2;
    // create four children that fully divide this quad into four quads of equal area
    PVector nwc = new PVector();
    nwc = boundary.center.copy().add(-h, -h);
    AABB nwb = new AABB(nwc, h);
    northWest = new QuadTree(nwb, this);

    PVector nec = new PVector();
    nec = boundary.center.copy().add(h, -h);
    AABB neb = new AABB(nec, h);
    northEast = new QuadTree(neb, this);

    PVector sec = new PVector();
    sec = boundary.center.copy().add(h, h);
    AABB seb = new AABB(sec, h);
    southEast = new QuadTree(seb, this);

    PVector swc = new PVector();
    swc = boundary.center.copy().add(-h, h);
    AABB swb = new AABB(swc, h);
    southWest = new QuadTree(swb, this);
  } 


  void draw()
  {
    fill(0, 100, 0, 70); 
    if(!visited)
    {
      stroke(100);

    }
    else
    {
      stroke(255);
    }

    boundary.draw();

    fill(255);
    noStroke();
    for (int i = 0; i < points.size(); i++)
    {
      ellipse(points.get(i).x, points.get(i).y, 4, 4);
    }

    if (northWest != null) {
      northWest.draw();
      northEast.draw();
      southEast.draw();
      southWest.draw();
    }
  }

  ArrayList<PVector> queryRange(AABB range)
  {
    // Prepare an array of results
    ArrayList<PVector> pointsInRange = new ArrayList<PVector>();

    // Automatically abort if the range does not intersect this quad
    if (!boundary.intersectsAABB(range))
      return pointsInRange; // empty list

    // Check objects at this quad level
    for (int p = 0; p < points.size(); p++)
    {
      if (range.containsPoint(points.get(p)))
      {
        pointsInRange.add(points.get(p));
      }
    }

    // Terminate here, if there are no children
    if (northWest == null)
      return pointsInRange;

    // Otherwise, add the points from the children
    pointsInRange.addAll(northWest.queryRange(range));
    pointsInRange.addAll(northEast.queryRange(range));
    pointsInRange.addAll(southWest.queryRange(range));
    pointsInRange.addAll(southEast.queryRange(range));

    return pointsInRange;
  }

  QuadTree lowestQuad(PVector p) {

   //recurse to the lowest quadrant that contains this point
   
    if (northWest != null) {
      if (northWest.boundary.containsPoint(p))
        return northWest.lowestQuad(p);
      else if (northEast.boundary.containsPoint(p))
        return northEast.lowestQuad(p);
      else if (southEast.boundary.containsPoint(p))
        return southEast.lowestQuad(p);
      else //it must be southwest
        return southWest.lowestQuad(p);
    } else {
      //this is the deepest point 
      
      return this;
    }
   
  }
  
  


  
  PVector nearestPoint(PVector p)
  {
    PVector np = p;
    
    float minDist = boundary.hy; 
    
    for(int i = 0; i < points.size(); i++)
    {
      float d = p.dist(points.get(i));
      if(d < minDist)
      {
        minDist = d;
        np = points.get(i);
      }
    }
    
    return np;
  }
}