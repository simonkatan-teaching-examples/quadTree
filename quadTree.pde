//based on https://ericandrewlewis.github.io/how-a-quadtree-works/ //<>// //<>//

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
  root = new QuadTree(new AABB(new PVector(width/2, height/2), width/2), null);

  for (int i = 0; i < 1000; i ++)
  {
    root.insert(new PVector(random(width), random(height)));
  }

  search = new AABB(new PVector(0, 0), 20);
  bestDistance = root.boundary.hy;
}

void draw() 
{

  background(255);

  root.draw();
  fill(255, 0, 0);
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
  text("fps: " + frameRate, 20, 20);

  stroke(255);
  fill(0, 0, 255, 50);
  //search.draw();
  //if(res != null)res.draw();

  if (currentNode != null)
  {

    pushStyle();
    stroke(255,0,0);
    strokeWeight(4);
    noFill();
    rect(currentNode.boundary.center.x, 
      currentNode.boundary.center.y, 
      currentNode.boundary.halfDimension * 2, 
      currentNode.boundary.halfDimension * 2);

    popStyle();
  }

  fill(255, 0, 0);
  stroke(0, 0, 0);
  if (np != null)ellipse(np.x, np.y, 10, 10);
  fill(0, 0, 0);
  if (mp != null)ellipse(mp.x, mp.y, 5, 5);
}

void mouseMoved() {
}

void mousePressed()
{
  //search.center.set(mouseX, mouseY);
  //selected = root.queryRange(search);
  mp = new PVector(mouseX, mouseY);
}

void keyPressed() {
  visitNextNode(mp);
}

void selectNextNode(PVector p) {

  // First time through, set the current node to root.
  if ( currentNode == null ) {
    currentNode = root;
    return;
  }

  QuadTree children[] = currentNode.getChildren();

  // given the clicked coordinate, find the child node that the coordinate would
  // fall into to. then recurse on this child first.
  int rl = currentNode.boundary.isRight(p);//right or left
  int bt = currentNode.boundary.isBottom(p); // bottom or top

  // If we're still interested in children...
  if ( ! currentNode.ignore && children[0] != null ) {
    // Select a child to drill down into with priority to the one that contains
    // the click. Don't visit if it's already been visited.
    if (children[bt*2+rl].points.size() > 0 && ! children[bt*2+rl].visited) {
      println("priority " + (bt*2+rl));
      currentNode = children[bt*2+rl];
    } else if (children[bt*2+(1-rl)].points.size() > 0 && ! children[bt*2+(1-rl)].visited) {
      currentNode = children[bt*2+(1-rl)];
    } else if (children[(1-bt)*2+rl].points.size() > 0 && ! children[(1-bt)*2+rl].visited) {
      currentNode = children[(1-bt)*2+rl];
    } else if (children[(1-bt)*2+(1-rl)].points.size() > 0 && ! children[(1-bt)*2+(1-rl)].visited ) {
      currentNode = children[(1-bt)*2+(1-rl)];
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
    currentNode = currentNode.parent;
    selectNextNode(p);
    return;
  }
}   

void visitNextNode(PVector p) 
{
  selectNextNode(p);

  float x1 = currentNode.boundary.center.x - currentNode.boundary.halfDimension;
  float x2 = currentNode.boundary.center.x + currentNode.boundary.halfDimension;
  float y1 = currentNode.boundary.center.y - currentNode.boundary.halfDimension;
  float y2 = currentNode.boundary.center.y + currentNode.boundary.halfDimension;

  currentNode.visited = true;
  // exclude node if point is farther away than best distance in either axis
  if (p.x < x1 - bestDistance || p.x > x2 + bestDistance 
    || p.y < y1 - bestDistance || p.y > y2 + bestDistance) 
  {
    currentNode.ignore = true;
    return;
  }


  // test point if there is one, potentially updating best

  if (currentNode.points.size() > 0) 
  {
    Point pt = currentNode.points.get(0);
    pt.scanned = true;
    float distance = PVector.dist(pt.pos, p);
    if (distance < bestDistance) 
    {
      bestDistance = distance;
      np = pt.pos;
    }
  }
}