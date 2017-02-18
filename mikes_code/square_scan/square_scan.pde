import processing.video.*;
Capture cam;

//fifo buffer for storing image frames
int num_frames = 256;
PImage queue[] = new PImage[num_frames];
int write_idx = 0;

PImage map; //image for storing gradient map
boolean show_map; //for displaying gradient map

void setup(){
  size(640, 480);
  
  cam = new Capture(this, 640, 480);
  cam.start();
  
  //initialize buffer with empty images
  for (int i = 0; i < num_frames; i++){
    queue[i] = createImage(width, height, RGB);
  }
  
  //create horizontal gradient map
  map = createImage(width, height, RGB);
  map.loadPixels();
  for (int x = 0; x < map.width; x++){
    for (int y = 0; y < map.height; y++){
      int r = x%255;
      if (x % 3 == 2) {
         r = y%255; 
      }
      if (y % 5 == 3){
         r = int(random(0,200)); 
      }
      int g = int((((float(map.width - x)/width) + (float(map.height - y)/height))/2 * 255) + random(0,1));
      int b = int(float(g+r)*0.5);
      int argb = 255 << 24 | r << 16 | g << 8 | b; 
      map.pixels[x + y*width] = argb;
    }
  }
  map.updatePixels();
}

void draw(){  
  if (cam.available()){
    cam.read();
    updateQueue(cam.get()); //update buffer with new camera frame
  }
  
  slitscan(); //perform time displacement
  
  if (show_map) image(map, 0, 0);
}

void keyPressed(){
  if (key == 's') show_map = !show_map;
}

void slitscan(){
  loadPixels();
  for (int i = 0; i < pixels.length; i++){
    
    //pull value (0-255) from gradient
    int grad = (map.pixels[i] >> 16) & 0xFF;
    
    //map gradient value to buffer index
    int idx = (write_idx - grad - 1) & (num_frames - 1);
    
    pixels[i] = queue[idx].pixels[i]; //update slitscanned pixel
  }
  updatePixels();
}

void updateQueue(PImage write_frame){
  queue[write_idx] = write_frame;
  write_idx = (write_idx + 1) & (num_frames - 1);
}