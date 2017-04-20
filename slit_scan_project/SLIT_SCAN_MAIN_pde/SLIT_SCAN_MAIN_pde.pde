// Raspberry Pi Version of the Slit Scan Code
import processing.video.*;
import processing.serial.*;
import java.lang.ProcessBuilder;
import gohai.simpletweet.*;

SimpleTweet simpletweet;
Capture cam;
//fifo buffer for storing image frames
// has to be a power of 2...
int num_frames = 128;
int overfill_amount = 256/num_frames;
PImage queue[] = new PImage[num_frames*overfill_amount];
int queue_size = num_frames*overfill_amount;
int write_idx = 0;

// to determine which maps are active
int mapMode = 0;
int numMapModes = 9;
int difference = 0;

Serial arduinoPort;
int val;

PImage blue_map; //image for storing gradient map
PImage green_map; //image for storing gradient map
PImage red_map; //image for storing gradient map
boolean show_red_map; //for displaying gradient map
boolean show_green_map; //for displaying gradient map
boolean show_blue_map; //for displaying gradient map

boolean color_separated = true;

int screenShotNum;

void setup() {
  size(1280, 720, P2D);
  cam = new Capture(this, 1280, 720, 60);
  cam.start();


  //initialize buffer with empty images
  for (int i = 0; i < queue_size; i++) {
    queue[i] = createImage(width, height, RGB);
  }
  newMaps();
  frameRate(25);
  println(Serial.list());
  String portName = Serial.list()[3];
  arduinoPort = new Serial(this, portName, 57600);
  simpletweet = new SimpleTweet(this);
  simpletweet.setOAuthConsumerKey("YftisSMGITwVf9zyLnfz0HRVz");
  simpletweet.setOAuthConsumerSecret("OCw264vOXl4yCVFmoisZhyxqn3ujHOUM5GapTjL22gGy4IOrcs");
  simpletweet.setOAuthAccessToken("846790274500067329-l4RiS4s4JBP0xba355sXQYZj4kAPnA0");
  simpletweet.setOAuthAccessTokenSecret("07OuQYM5pIMAuQ5o3axQ2HhixbHBPfIRsCLyEGPEs3K3u");
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
  surface.setTitle(str(frameRate));
  readArduinoButtons();
}

void slitscan() {
  loadPixels();
  if (difference == 0) {
    for (int i = 0; i < pixels.length; i++) {
      //pull value (0-255) from gradient
      int red_grad = (red_map.pixels[i] >> 16) & 0xFF;
      int green_grad = (green_map.pixels[i] >> 8) & 0xFF;
      int blue_grad = (blue_map.pixels[i] >> 0) & 0xFF;

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
  } else {
    for (int i = 0; i < pixels.length; i++) {
      //pull value (0-255) from gradient
      int red_grad = red_map.pixels[i] & 0xFF;
      int green_grad = green_map.pixels[i] & 0xFF;
      int blue_grad = blue_map.pixels[i] & 0xFF;

      //map gradient value to buffer index
      int red_idx = (write_idx - red_grad - 1) & (queue_size - 1);
      int green_idx = (write_idx - green_grad - 1) & (queue_size - 1);
      int blue_idx = (write_idx - blue_grad - 1) & (queue_size - 1);

      int r = queue[red_idx].pixels[i] & 0xFF;
      int g = queue[green_idx].pixels[i] & 0xFF;
      int b = queue[blue_idx].pixels[i] & 0xFF;

      int argb = 255 << 24 | r << 16| g << 8| b;
      pixels[i] = argb;
    }
  }
  updatePixels();
}

void updateQueue(PImage write_frame) {
  queue[write_idx] = write_frame;
  write_idx = (write_idx + 1) & (queue_size - 1);
}