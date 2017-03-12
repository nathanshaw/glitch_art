// Raspberry Pi Version of the Slit Scan Code
import processing.video.*;
Capture cam;

int onPi = 0;
int buttonPins[] = {22, 5, 6, 17};
int ledRed = 13;
int ledGreen = 26;
int ledBlue = 16;


//fifo buffer for storing image frames
int num_frames = 256;
int overfill_amount = 1;
PImage queue[] = new PImage[num_frames*overfill_amount];
int queue_size = num_frames*overfill_amount;
int write_idx = 0;

// to determine which maps are active
int mapMode = 0;
int numMapModes = 6;

PImage blue_map; //image for storing gradient map
PImage green_map; //image for storing gradient map
PImage red_map; //image for storing gradient map
boolean show_red_map; //for displaying gradient map
boolean show_green_map; //for displaying gradient map
boolean show_blue_map; //for displaying gradient map

int screenShotNum;

void setup() {
  size(1280, 720, P2D);
  //fullScreen(P2D);
  /*
    String[] devices = GLCapture.list();
   println("Devices:");
   printArray(devices);
   if (0 < devices.length) {
   String[] configs = GLCapture.configs(devices[0]);
   println("Configs:");
   printArray(configs);
   }
   cam = new GLCapture(this, devices[0], 640, 360, 25);
   cam.play();
   */
  cam = new Capture(this, 1280, 720, 60);
  cam.start();

  //initialize buffer with empty images
  for (int i = 0; i < queue_size; i++) {
    queue[i] = createImage(width, height, RGB);
  }
  newMaps();
  frameRate(25);
}

void newMaps() {
  if (mapMode == 0) {
    print("" + mapMode + " - ");
    println("Perlin Noise: Independent Color Masks");
    red_map = makeNoiseMap();
    green_map = makeNoiseMap();
    blue_map = makeNoiseMap();
  }
  if (mapMode == 1) {
    print("" + mapMode + " - ");
    println("Perlin Noise: Single Mask");
    red_map = makeNoiseMap();
    green_map = red_map;
    blue_map = red_map;
  }
  if (mapMode == 2) {
    print("" + mapMode + " - ");
    println("Vertical Map: Single Mask");
    red_map = makeVertMap();
    green_map = red_map;
    blue_map = red_map;
  }
  if (mapMode == 3) {
    print("" + mapMode + " - ");
    println("Vertical Map: Multiple Mask");
    red_map = makeVertMap();
    green_map = makeVertMap();
    blue_map = makeVertMap();
  }
  if (mapMode == 4) {
    print("" + mapMode + " - ");
    println("Red = Hor - Green = Noise - blue = box");
    red_map = makeBoxMap();
    green_map = makeBoxMap();
    blue_map = makeBoxMap();
  }
  if (mapMode == 5) {
    print("" + mapMode + " - ");
    println("blended noise map");
    red_map = makeDoubleNoiseMap();
  }
}

boolean isRed() {
  int totalRed = 0;
  int totalBlue = 0;
  for (color pix : pixels) {
    totalRed +=  (pix >> 16) & 0xFF;
    totalBlue +=  pix & 0xFF;
  };
  if (totalRed > totalBlue) {
    println("More red than blue");
    return true;
  }
  println("More blue than red");
  return false;
}

void saveScreenShot() {
  //save the current frame
  String tempFileName = "" + screenShotNum + ".png";
  saveFrame(tempFileName);
  println("saved file : " + tempFileName);
  screenShotNum++;
  // determine if there is more red or blue and tweet accordingly
  if (isRed() == true) {
    tweet("Red "  + screenShotNum);
  } else {
    tweet("Blue " + screenShotNum);
  }
}

void tweet(String msg) {
  println("PRETEND LIKE I JUST TWEETED  : ", msg);
}

void checkButtonsAndKeys() {
  // check keys
  if (show_red_map) image(red_map, 0, 0);
  if (show_green_map) image(green_map, 0, 0);
  if (show_blue_map) image(blue_map, 0, 0);
  // checkButtons
  /*
    for (int pin : buttonPins) {
   if (GPIO.digitalRead(pin) == GPIO.HIGH) {
   if (pin == 22) {
   GPIO.digitalWrite(ledGreen, GPIO.HIGH);
   // go to the next mapModes
   mapMode++;
   if (mapMode >= numMapModes) {
   mapMode = 0;
   }
   newMaps();
   } else if (pin == 5) {
   GPIO.digitalWrite(ledBlue, GPIO.HIGH);
   newMaps();
   } else if (pin == 6) {
   GPIO.digitalWrite(ledRed, GPIO.HIGH);
   saveScreenShot();
   }
   } else {
   if (pin == 22) {
   GPIO.digitalWrite(ledGreen, GPIO.LOW);
   } else if (pin == 5) {
   GPIO.digitalWrite(ledBlue, GPIO.LOW);
   } else if (pin == 6) {
   GPIO.digitalWrite(ledRed, GPIO.LOW);
   }
   }
   }
   */
}

void updateCam() {
  if (cam.available()) {
    cam.read();
    PImage cam_image = cam.get();
    for (int i = 0; i < overfill_amount; i++) {
      updateQueue(cam_image); //update buffer with new camera frame
    }
  } else {
    println("New Camera image not available");
  }
}

void draw() {  
  updateCam();
  slitscan(); //perform time displacement
  // check the buttons
  checkButtonsAndKeys();
  //println(frameRate);
}

void keyPressed() {
  if (key == 'r') show_red_map = !show_red_map;
  if (key == 'g') show_green_map = !show_green_map;
  if (key == 'b') show_blue_map = !show_blue_map;
  if (key == 'n') {
    newMaps();
  }
  if (key == 'm') {
    // go to the next mapModes
    mapMode++;
    if (mapMode >= numMapModes) {
      mapMode = 0;
    }
    newMaps();
  }
  if (key == 't') {
    saveScreenShot();
  }
}

void slitscan() {
  loadPixels();
  for (int i = 0; i < pixels.length; i++) {

    //pull value (0-255) from gradient
    int red_grad = (red_map.pixels[i] >> 16) & 0xFF;
    int green_grad = (green_map.pixels[i] >> 16) & 0xFF;
    int blue_grad = (blue_map.pixels[i] >> 16) & 0xFF;

    //map gradient value to buffer index
    int red_idx = (write_idx - red_grad - 1) & (queue_size - 1);
    int green_idx = (write_idx - green_grad - 1) & (queue_size - 1);
    int blue_idx = (write_idx - blue_grad - 1) & (queue_size - 1);

    int r = (queue[red_idx].pixels[i] >> 16) & 0xFF;
    int g = (queue[green_idx].pixels[i] >> 8)& 0xFF;
    int b = queue[blue_idx].pixels[i] & 0xFF;

    int argb = 255 << 24 | r << 16| g << 8| b;

    pixels[i] = argb;
  }
  updatePixels();
}

void updateQueue(PImage write_frame) {
  queue[write_idx] = write_frame;
  write_idx = (write_idx + 1) & (queue_size - 1);
}