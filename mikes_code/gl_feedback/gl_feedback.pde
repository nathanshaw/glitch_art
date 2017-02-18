//analog video feedback modeling using glsl shaders
//relevant image processing code is in data/shaders folder

//good tutorial on glsl: thebookofshaders.com

//create shaders
PShader blur;
PShader sharp;

void setup() {
  size(500, 500, P2D);
  frameRate(30);
  
  //load shaders
  blur = loadShader("shaders/blur.glsl");
  sharp = loadShader("shaders/sharp.glsl");
  
  background(0);
}

void draw() {
  //vary color
  noStroke();
  fill(millis()/10 % 256, millis()/11 % 256, millis()/12 % 256);
  ellipse(mouseX, mouseY, 100, 100);
  
  //apply fx shaders in feedback loop
  filter(blur); 
  filter(sharp);
}

//refresh bg if mouse pressed
void mousePressed(){
  background(0);
}