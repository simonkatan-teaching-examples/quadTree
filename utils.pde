class AABB
{
  PVector center;
  float halfDimension;

  AABB(PVector _center, float _halfDimension)
  {
    center = new PVector();
    center = _center.copy();
    halfDimension = _halfDimension;
  }
  
  boolean containsPoint(PVector Point)
  {
    if(Point.x >= center.x - halfDimension
    && Point.x <= center.x + halfDimension)
    {
      if(Point.y >= center.y - halfDimension
      && Point.y <= center.y + halfDimension)
      {
        return true;
      }
      
    }
    return false;
  }
  
  boolean intersectsAABB(AABB other) 
  {
    PVector c = other.center;
    float h = other.halfDimension;
    
    if(containsPoint(new PVector(c.x - h, c.y - h)))return true;
    if(containsPoint(new PVector(c.x - h, c.y + h)))return true;
    if(containsPoint(new PVector(c.x + h, c.y - h)))return true;
    if(containsPoint(new PVector(c.x + h, c.y + h)))return true;
    
    if(other.containsPoint(new PVector(center.x - halfDimension, center.y - halfDimension)))return true;
    if(other.containsPoint(new PVector(center.x - halfDimension, center.y + halfDimension)))return true;
    if(other.containsPoint(new PVector(center.x + halfDimension, center.y - halfDimension)))return true;
    if(other.containsPoint(new PVector(center.x + halfDimension, center.y + halfDimension)))return true;
    
    return false;
  }
  
  void draw(){
       rect(
      center.x, center.y, 
      halfDimension * 2 , 
      halfDimension * 2
      );

  }
  
};