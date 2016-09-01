QuadTree parent; 
ArrayList<PVector> selected = null;
AABB search;
AABB res;

void setup() 
{
  size(512, 512); 
  rectMode(CENTER);
  parent = new QuadTree(new AABB(new PVector(width/2, height/2), width/2));
  
  for(int i = 0; i < 1000; i ++)
  {
    parent.insert(new PVector(random(width), random(height)));
  }
  
  search = new AABB(new PVector(0,0),20);
  
  
}

void draw() 
{
  
  background(255);
  
  parent.draw();
  fill(255,0,0);
  noStroke();
  
  if(selected != null)
  {
    for(int i =0; i < selected.size(); i ++)
    {
      PVector p = selected.get(i);
      ellipse(p.x, p.y ,3,3);
    }
  }
  
  fill(0);
  text("fps: " + frameRate, 20,20);
  
  stroke(255);
  fill(0,0,255,50);
  //search.draw();
  if(res != null)res.draw();
}

void mouseMoved(){
    //search.center.set(mouseX, mouseY);
    //selected = parent.queryRange(search);
    res = parent.lowestQuad(new PVector(mouseX,mouseY)).boundary;

}