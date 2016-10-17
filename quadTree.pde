//based on https://ericandrewlewis.github.io/how-a-quadtree-works/

QuadTree root; 
QuadTree currentNode = null;
ArrayList<PVector> selected = null;
AABB search;
AABB res;
PVector np;
float bestDistance;
PVector mp;

void setup() 
{
  size(512, 512); 
  rectMode(CENTER);
  root = new QuadTree(new AABB(new PVector(width/2, height/2), width/2),null);
  
  for(int i = 0; i < 1000; i ++)
  {
    root.insert(new PVector(random(width), random(height)));
  }
  
  search = new AABB(new PVector(0,0),20);
  bestDistance = root.boundary.hy;
  
}

void draw() 
{
  
  background(255);
  
  root.draw();
  fill(255,0,0);
  noStroke();
  
  //if(selected != null)
  //{
  //  for(int i =0; i < selected.size(); i ++)
  //  {
  //    PVector p = selected.get(i);
  //    ellipse(p.x, p.y ,3,3);
  //  }
  //}
  
  fill(0);
  text("fps: " + frameRate, 20,20);
  
  stroke(255);
  fill(0,0,255,50);
  //search.draw();
  //if(res != null)res.draw();
  
  if(currentNode != null)
  {
  fill(255,0,0,100);
  rect(currentNode.boundary.center.x , 
        currentNode.boundary.center.y,
        currentNode.boundary.halfDimension * 2,
        currentNode.boundary.halfDimension * 2);
  }
  
  fill(255,0,0);
  stroke(0,0,0);
  if(np != null)ellipse(np.x, np.y ,10,10);
  fill(0,0,0);
  if(mp != null)ellipse(mp.x, mp.y ,5,5);
}

void mouseMoved(){
  
}

void mousePressed()
{
    //search.center.set(mouseX, mouseY);
    //selected = root.queryRange(search);
    mp = new PVector(mouseX,mouseY);
    
  
    
}

void keyPressed(){
    visitNextNode(mp);
}

void selectNextNode(PVector p) {
  
  // First time through, set the current node to root.
  if ( currentNode == null ) {
    currentNode = root;
    return;
  }
  
  QuadTree parent = currentNode;
  ArrayList<QuadTree> children = currentNode.getChildren();

  // given the clicked coordinate, find the child node that the coordinate would
  // fall into to. then recurse on this child first.
  int rl = currentNode.boundary.isRight(p) ? 1 : 0;//right or left
  int bt = currentNode.boundary.isBottom(p) ? 1 : 0; // bottom or top
  
  println("/////////////");
  println("isright", rl); //<>//
  println("isbottom", bt);

  // If we're still interested in children...
  if ( ! currentNode.ignore && children.size() > 0 ) {
    // Select a child to drill down into with priority to the one that contains
    // the click. Don't visit if it's already been visited.
    if (children.get(bt*2+rl).points.size() > 0 && ! children.get(bt*2+rl).visited)  {
      println("priority " + (bt*2+rl));
      currentNode = children.get(bt*2+rl);
    } else if (children.get(bt*2+(1-rl)).points.size() > 0 && ! children.get(bt*2+(1-rl)).visited) {
      currentNode = children.get(bt*2+(1-rl));
    } else if (children.get((1-bt)*2+rl).points.size() > 0 && ! children.get((1-bt)*2+rl).visited) {
      currentNode = children.get((1-bt)*2+rl);
    } else if (children.get((1-bt)*2+(1-rl)).points.size() > 0 && ! children.get((1-bt)*2+(1-rl)).visited ) {
      currentNode = children.get((1-bt)*2+(1-rl));
    } else {
      // If all children have been visited, we want to go to the next node,
      // or perhaps just set the current node up one in the tree and re-run this function.
      currentNode = currentNode.parent;
      selectNextNode(p);
      return;
    }
    
  } else {
    // If all children have been visited, we want to go to the next node,
    // or perhaps just set the current node up one in the tree and re-run this function.
    this.currentNode = currentNode.parent;
    selectNextNode(p);
    return;
  }
  
 
}   

void visitNextNode(PVector p) {
  selectNextNode(p);
  QuadTree node = currentNode;
  //x = this.x, y = this.y, x1 = node.x1, y1 = node.y1, x2 = node.x2, y2 = node.y2;
  float x1 = node.boundary.center.x - node.boundary.halfDimension;
  float x2 = node.boundary.center.x + node.boundary.halfDimension;
  float y1 = node.boundary.center.y - node.boundary.halfDimension;
  float y2 = node.boundary.center.y + node.boundary.halfDimension;
  node.visited = true;
  // exclude node if point is farther away than best distance in either axis
  if (p.x < x1 - bestDistance || p.x > x2 + bestDistance || p.y < y1 - bestDistance || p.y > y2 + bestDistance) {
      node.ignore = true;
      println("ignore");
      return;
  }
  
  
  // test point if there is one, potentially updating best

  if (node.points.size() > 0) {
    //p.scanned = true;
    PVector pt = node.points.get(0);
    float distance = PVector.dist(pt, p);
    if (distance < bestDistance) {
      bestDistance = distance;
      np = pt; //<>//
      println(np);
    }
  }

}

   