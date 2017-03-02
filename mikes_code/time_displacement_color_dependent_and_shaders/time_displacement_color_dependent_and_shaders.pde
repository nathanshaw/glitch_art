import processing.video.*;
Capture cam;

//fifo buffer for storing image frames
int num_frames = 32;
int overfill_amount = 1;
PImage queue[] = new PImage[num_frames];
int write_idx = 0;

PImage blue_map; //image for storing gradient map
PImage green_map; //image for storing gradient map
PImage red_map; //image for storing gradient map
boolean show_red_map; //for displaying gradient map
boolean show_green_map; //for displaying gradient map
boolean show_blue_map; //for displaying gradient map

void setup(){
  size(640, 480);
  
  cam = new Capture(this, 640, 480, 60);
  cam.start();
  
  //initialize buffer with empty images
  for (int i = 0; i < num_frames; i++){
    queue[i] = createImage(width, height, RGB);
  }
  newNoiseMaps();
  frameRate(120);
}

void newNoiseMaps(){
  red_map = makeDiagMap();
  green_map = makeBoxMap();
  blue_map = makeNoiseMap();  
}

PImage makeHorMap(){
 //create horizontal gradient map
  PImage hmap = createImage(width, height, RGB);
  hmap.loadPixels();
  for (int x = 0; x < hmap.width; x++){
    for (int y = 0; y < hmap.height; y++){
      int g = int((float(x)/hmap.width) * 255);
      int argb = 255 << 24 | g << 16 | g << 8 | g; 
      hmap.pixels[x + y*width] = argb;
    }
  }
  hmap.updatePixels();
  return hmap;
}

PImage makeRandMap(){
 //create random gradient map
  PImage rmap = createImage(width, height, RGB);
  rmap.loadPixels();
  for (int x = 0; x < rmap.width; x++){
    for (int y = 0; y < rmap.height; y++){
      int g = int(random(1.0)*255);
      int argb = 255 << 24 | g << 16 | g << 8 | g; 
      rmap.pixels[x + y*width] = argb;
    }
  }
  rmap.updatePixels();
  return rmap;
}

PImage makeNoiseMap() {
   //create noids map
  PImage nmap = createImage(width, height, RGB);
  float xoff = random(0.0,1.0);; // Start xoff at 0
  float detail = random(0.001, 0.1);
  print("detail : ", detail, " - ");
  float increment = pow(random(0.05, 0.5), 2);
  println("increment : ", increment);
  noiseDetail(8, detail);
  
  // For every x,y coordinate in a 2D space, calculate a noise value and produce a brightness value
  for (int x = 0; x < nmap.width; x++) {
    xoff += increment;   // Increment xoff 
    float yoff = 0.0;   // For every xoff, start yoff at 0
    for (int y = 0; y < nmap.height; y++) {
      yoff += increment; // Increment yoff
      
      // Calculate noise and scale by 255
      float bright = noise(xoff, yoff) * 255;

      // Try using this line instead
      //float bright = random(0,255);
      
      // Set each pixel onscreen to a grayscale value
      nmap.pixels[x+y*width] = color(bright);
    }
  }
  
  nmap.updatePixels();
  return nmap;
}

PImage makeDiagMap(){
 //create diagonal gradient map
  PImage dmap = createImage(width, height, RGB);
  dmap.loadPixels();
  for (int x = 0; x < dmap.width; x++){
    for (int y = 0; y < dmap.height; y++){
      int g = int((((float(dmap.width - x)/width) + (float(dmap.height - y)/height))/2 * 255) + random(0,1));
      int argb = 255 << 24 | g << 16 | g << 8 | g; 
      dmap.pixels[x + y*width] = argb;
    }
  }
  dmap.updatePixels();
  return dmap;
}

PImage makeBoxMap(){
 //create horizontal gradient map
  PImage bmap = createImage(width, height, RGB);
  bmap.loadPixels();
  for (int x = 0; x < bmap.width; x++){
    for (int y = 0; y < bmap.height; y++){
      int r = x%255;
      if (x % 3 == 2) {
         r = y%255; 
      }
      if (y % 5 == 3){
         r = int(random(0,200)); 
      }
      int g = int((((float(bmap.width - x)/width) + (float(bmap.height - y)/height))/2 * 255) + random(0,1));
      int b = int(float(g+r)*0.5);
      int argb = 255 << 24 | r << 16 | g << 8 | b; 
      bmap.pixels[x + y*width] = argb;
    }
  }
  bmap.updatePixels();
  return bmap;
}

void draw(){  
  if (cam.available()){
    cam.read();
    PImage cam_image = cam.get();
    for (int i = 0; i < overfill_amount; i++){
      updateQueue(cam_image); //update buffer with new camera frame
    }
  }
  
  slitscan(); //perform time displacement
  
  if (show_red_map) image(red_map, 0, 0);
    if (show_green_map) image(green_map, 0, 0);
      if (show_blue_map) image(blue_map, 0, 0);
}

void keyPressed(){
  if (key == 'r') show_red_map = !show_red_map;
  if (key == 'g') show_green_map = !show_green_map;
  if (key == 'b') show_blue_map = !show_blue_map;
  if (key == 'n') {
    newNoiseMaps();
  }
}

void slitscan(){
  loadPixels();
  for (int i = 0; i < pixels.length; i++){
    
    //pull value (0-255) from gradient
    int red_grad = (red_map.pixels[i] >> 16) & 0xFF;
    int green_grad = (green_map.pixels[i] >> 16) & 0xFF;
    int blue_grad = (blue_map.pixels[i] >> 16) & 0xFF;
    
    //map gradient value to buffer index
    int red_idx = (write_idx - red_grad - 1) & (num_frames - 1);
    int green_idx = (write_idx - green_grad - 1) & (num_frames - 1);
    int blue_idx = (write_idx - blue_grad - 1) & (num_frames - 1);
    
    pixels[i] = color((queue[red_idx].pixels[i] >> 16)& 0xFF,
                               (queue[green_idx].pixels[i] >> 8 )& 0xFF,
                               queue[blue_idx].pixels[i] & 0xFF);
    
    //pixels[i] = queue[idx].pixels[i]; //update slitscanned pixel
  }
  updatePixels();
}

void updateQueue(PImage write_frame){
  queue[write_idx] = write_frame;
  write_idx = (write_idx + 1) & (num_frames - 1);
}