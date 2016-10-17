class Point
{
  
   PVector pos;
   boolean scanned;
   
  Point(PVector _p)
  {
    pos = _p;
    scanned = false;
  }
  
  void draw(){
    noStroke();
   if(scanned)
   {
     fill(200,200,0);
   }
   else
   {
     fill(100);
   }
   ellipse(pos.x, pos.y, 4, 4);
  }
  
}

class AABB
{
  PVector center;
  float halfDimension;
  float hy;

  AABB(PVector _center, float _halfDimension)
  {
    center = new PVector();
    center = _center.copy();
    halfDimension = _halfDimension;
    hy = sqrt(halfDimension * 4);
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
  
  int isBottom(PVector Point){
    return(Point.y >= center.y) ? 1 : 0;
  }
  
  int isRight(PVector Point){
    return(Point.x >= center.x) ? 1 : 0;
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