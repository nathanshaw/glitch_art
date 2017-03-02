// Raspberry Pi Version of the Slit Scan Code
import gohai.glvideo.*;
import processing.io.*;

int buttonPins[] = {22, 5, 6, 17};
int ledRed = 13;
int ledGreen = 26;
int ledBlue = 16;
GLCapture cam;


//fifo buffer for storing image frames
int num_frames = 16;
int overfill_amount = 1;
PImage queue[] = new PImage[num_frames];
int write_idx = 0;

// to determine which maps are active
int mapMode = 0;
int numMapModes = 1;

PImage blue_map; //image for storing gradient map
PImage green_map; //image for storing gradient map
PImage red_map; //image for storing gradient map
boolean show_red_map; //for displaying gradient map
boolean show_green_map; //for displaying gradient map
boolean show_blue_map; //for displaying gradient map

int screenShotNum;

void setup() {
  size(640, 360, P2D);
  //fullScreen(P2D);
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


  //initialize buffer with empty images
  for (int i = 0; i < num_frames; i++) {
    queue[i] = createImage(width, height, RGB);
  }
  newMaps();

  GPIO.pinMode(ledRed, GPIO.OUTPUT); 
  GPIO.pinMode(ledGreen, GPIO.OUTPUT); 
  GPIO.pinMode(ledBlue, GPIO.OUTPUT);
  GPIO.digitalWrite(ledRed, GPIO.HIGH);
  GPIO.digitalWrite(ledBlue, GPIO.LOW);
  GPIO.digitalWrite(ledGreen, GPIO.HIGH);
  for (int i : buttonPins) {
    GPIO.pinMode(i, GPIO.INPUT);
  }
  GPIO.digitalWrite(ledRed, GPIO.LOW);
  GPIO.digitalWrite(ledGreen, GPIO.LOW);

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
    println("Diag Map: Single Mask");
    red_map = makeDiagMap();
    green_map = red_map;
    blue_map = red_map;
  }
  if (mapMode == 3) {
    print("" + mapMode + " - ");
    println("Red = Hor - Green = Noise - blue = box");
    red_map = makeHorMap();
    green_map = makeNoiseMap();
    blue_map = makeBoxMap();
  }
}

boolean isRed() {
    int totalRed = 0;
  int totalBlue = 0;
  for (int i = 0; i < pixels.length; i++) {
    totalRed +=  (queue[red_idx].pixels[i] >> 16)& 0xFF;
    totalBlue +=  queue[blue_idx].pixels[i] & 0xFF;
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
  if (isRed(tempFileName) == true) {
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
}

void keyPressed() {
  if (key == 'r') show_red_map = !show_red_map;
  if (key == 'g') show_green_map = !show_green_map;
  if (key == 'b') show_blue_map = !show_blue_map;
  if (key == 'n') {
    newMaps();
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
    int red_idx = (write_idx - red_grad - 1) & (num_frames - 1);
    int green_idx = (write_idx - green_grad - 1) & (num_frames - 1);
    int blue_idx = (write_idx - blue_grad - 1) & (num_frames - 1);

    pixels[i] = color((queue[red_idx].pixels[i] >> 16)& 0xFF, 
      (queue[green_idx].pixels[i] >> 8 )& 0xFF, 
      queue[blue_idx].pixels[i] & 0xFF);
  }
  updatePixels();
}

void updateQueue(PImage write_frame) {
  queue[write_idx] = write_frame;
  write_idx = (write_idx + 1) & (num_frames - 1);
}