class QuadTree
{
  // Arbitrary constant to indicate how many elements can be stored in this quad tree node
  final int QT_NODE_CAPACITY = 1;

  // Axis-aligned bounding box stored as a center with half-dimensions
  // to represent the boundaries of this quad tree
  AABB boundary;

  // Points in this quad tree node
  ArrayList<Point> points;
  boolean ignore = false;
  boolean visited = false;
  boolean isRoot = false;

  QuadTree children [] = new QuadTree[4];

  QuadTree parent = null;

  // Methods
  QuadTree(AABB _boundary, QuadTree _parent) 
  {
    boundary = _boundary;

    for (int i = 0; i < 4; i++)
    {
      children[i] = null;
    }

    parent = _parent;

    points = new ArrayList<Point>();
  }

  boolean insert(PVector p) {
    // Ignore objects that do not belong in this quad tree
    if (!boundary.containsPoint(p))
      return false; // object cannot be added

    // If there is space in this quad tree, add the object here
    if (points.size() < QT_NODE_CAPACITY)
    {
      Point pt = new Point(p); 
      points.add(pt);
      return true;
    }

    // Otherwise, subdivide and then add the point to whichever node will accept it
    if (children[0] == null)
      subdivide();


    for (int i=0; i <4; i++)
    {
      if (children[i].insert(p)) return true;
    }

    // Otherwise, the point cannot be inserted for some unknown reason (this should never happen)
    return false;
  }

  QuadTree[] getChildren()
  {
    return children;
  }

  void subdivide() 
  {
    float h = boundary.halfDimension/2;
    // create four children that fully divide this quad into four quads of equal area
    PVector nwc = new PVector();
    nwc = boundary.center.copy().add(-h, -h);
    AABB nwb = new AABB(nwc, h);
    children[0] = new QuadTree(nwb, this);

    PVector nec = new PVector();
    nec = boundary.center.copy().add(h, -h);
    AABB neb = new AABB(nec, h);
    children[1]  = new QuadTree(neb, this);
    
    PVector swc = new PVector();
    swc = boundary.center.copy().add(-h, h);
    AABB swb = new AABB(swc, h);
    children[2] = new QuadTree(swb, this);

    PVector sec = new PVector();
    sec = boundary.center.copy().add(h, h);
    AABB seb = new AABB(sec, h);
    children[3] = new QuadTree(seb, this);


  } 


  void draw()
  {
    
    stroke(0);
    
    if (!ignore)
    {
      noFill(); 
    } 
    else
    {
      fill(100);
    }

    boundary.draw();

    for (int i = 0; i < points.size(); i++)
    {
      points.get(i).draw();
    }

    if (children[0] != null) {
      for(int i = 0; i < 4; i++)
      {
        children[i].draw();
      }
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
      if (range.containsPoint(points.get(p).pos))
      {
        pointsInRange.add(points.get(p).pos);
      }
    }

    // Terminate here, if there are no children
    if (children[0] == null)
      return pointsInRange;

    // Otherwise, add the points from the children
    for(int i = 0 ; i < 4; i++)
    {
      pointsInRange.addAll(children[i].queryRange(range));
    }

    return pointsInRange;
  }


}