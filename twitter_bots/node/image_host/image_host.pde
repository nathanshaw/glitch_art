// image tweeter

// command line processing
// processing-java name_of_sketch.pde

void setup() {
  size(600,400);
  for (int i = 0; i < 20500; i++) {
     float x = random(width);
     float y = random(height);
     float r = random(100,255);
     float b = random(200,255);
     noStroke();
     fill(r, 0, b);
     ellipse(x, y, random(32), random(32));
  }
  save("output.png");
  exit();
}