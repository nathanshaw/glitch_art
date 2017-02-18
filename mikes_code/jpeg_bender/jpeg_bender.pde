//jpeg bender by mike leisz
//r to reload

import java.io.*;

PImage src_img, glitch_img;

byte[] jpeg_data; //for storing jpeg data

int num_markers = 8; //for storing relevant jpeg segments
int[] markers = new int[num_markers];
int[] segments = new int[num_markers];

void setup(){
  //kill error console (as best we can)
  System.err.close();
  
  size(720, 720);
  frameRate(24);
  imageMode(CENTER);
  
  //load and display source image
  src_img = loadImage("Mug_Shot.jpg");
  image(src_img, width*0.5, height*0.5);
  
  //resave image as new jpeg
  //we do this so we can know for certain the architecture of the jpeg
  save("data/glitch_input.jpg");
  delay(1000); //give the image some time to save
  
  loadJpegData();
  displayJpeg();
}

void draw(){
  glitchJpeg();
  displayJpeg();
}

void loadJpegData(){
  jpeg_data = loadBytes("glitch_input.jpg");
  exploreJpeg();
}

void glitchJpeg(){
  
  //glitch quantization tables
  //jpeg_data[floor(random(markers[0], segments[0]))] = byte(floor(random(255)));
  //jpeg_data[floor(random(markers[1], segments[1]))] = byte(floor(random(255)));
  
  //glitch display settings
  //jpeg_data[markers[2] + 3] = byte(floor(random(255)));
  
  //glitch compression tables
  //jpeg_data[floor(random(markers[3], segments[3]))] = byte(floor(random(15)));
  //jpeg_data[floor(random(markers[4], segments[4]))] = byte(floor(random(255)));
  //jpeg_data[floor(random(markers[5], segments[5]))] = byte(floor(random(15)));
  //jpeg_data[floor(random(markers[6], segments[6]))] = byte(floor(random(255)));
  
  //glitch image data
  jpeg_data[floor(random(markers[7], segments[7]))] = byte(floor(random(255)));
}

void displayJpeg(){
  //save manipulated jpeg bytes
  saveBytes("data/glitch_output.jpg", jpeg_data);
  
  //reload as new image
  glitch_img = loadImage("glitch_output.jpg");
  
  translate(width*0.5, height*0.5);
  image(glitch_img, 0, 0, width, height);
}

void exploreJpeg() {
  
  int marker = 0;
  int segment = 0;
  
  for (int i = 0; i < jpeg_data.length; i++) {
    //find first relevant marker (quantization table)
    if (jpeg_data[i] == byte(0xFF) && jpeg_data[i + 1] == byte(0xDB)) {
      marker = i;
      break;
    }
  }
  
  //store qtable luma marker
  markers[0] = marker + 2 + 2 + 1; //2 byte marker, 2 byte segment length, 1 byte table id
  
  //store segment length
  segment = int(jpeg_data[marker+2]) + int(jpeg_data[marker+3]);
  
  println("DQT Marker 1 (Luma): " + hex(jpeg_data[marker]) 
                            + " " + hex(jpeg_data[marker+1]) 
                            + " " + hex(jpeg_data[marker+2]) 
                            + " " + hex(jpeg_data[marker+3]) 
                            + " // byte index: " + marker
                            + " // segment length: " + segment);
                            
  marker = marker + 2 + segment; //skip 2 byte length specifier, then advance to next segment
  
  segments[0] = marker; //store end of bendable data per segment
  
  //////////////////////////////RINSE AND REPEAT
           
  //store qtable chroma marker                        
  markers[1] = marker + 2 + 2 + 1;
  
  segment = int(jpeg_data[marker+2]) + int(jpeg_data[marker+3]);
  
  println("DQT Marker 2 (Chroma): " + hex(jpeg_data[marker]) 
                            + " " + hex(jpeg_data[marker+1]) 
                            + " " + hex(jpeg_data[marker+2]) 
                            + " " + hex(jpeg_data[marker+3]) 
                            + " // byte index: " + marker
                            + " // segment length: " + segment);
                            
  marker = marker + 2 + segment;
  
  segments[1] = marker;
  
  //////////////////////////////
  
  //store sof (start of frame) marker //this affects display settings                               
  markers[2] = marker + 2 + 2 + 1;
  
  segment = int(jpeg_data[marker+2]) + int(jpeg_data[marker+3]);
  
  println("SOF Marker: " + hex(jpeg_data[marker]) 
                            + " " + hex(jpeg_data[marker+1]) 
                            + " " + hex(jpeg_data[marker+2]) 
                            + " " + hex(jpeg_data[marker+3]) 
                            + " // byte index: " + marker
                            + " // segment length: " + segment);
  marker = marker + 2 + segment;
  
  segments[2] = markers[2] + 4;
  
  //////////////////////////////
                      
  //store huffman table 1 marker                           
  markers[3] = marker + 2 + 2 + 1 + 16;
  
  segment = int(jpeg_data[marker+2]) + int(jpeg_data[marker+3]);
  
  println("DHT Marker 1: " + hex(jpeg_data[marker]) 
                            + " " + hex(jpeg_data[marker+1]) 
                            + " " + hex(jpeg_data[marker+2]) 
                            + " " + hex(jpeg_data[marker+3]) 
                            + " // byte index: " + marker
                            + " // segment length: " + segment);
                            
  marker = marker + 2 + segment;
  
  segments[3] = marker;
  
  //////////////////////////////  
  
  //store huffman table 2 marker   
  markers[4] = marker + 2 + 2 + 1 + 16;
  segment = int(jpeg_data[marker+2]) + int(jpeg_data[marker+3]);
  
  println("DHT Marker 2: " + hex(jpeg_data[marker]) 
                            + " " + hex(jpeg_data[marker+1]) 
                            + " " + hex(jpeg_data[marker+2]) 
                            + " " + hex(jpeg_data[marker+3]) 
                            + " // byte index: " + marker
                            + " // segment length: " + segment);
                           
  marker = marker + 2 + segment;
  
  segments[4] = marker;
  
  //////////////////////////////
  
  //store huffman table 3 marker   
  markers[5] = marker + 2 + 2 + 1 + 16;
  
  segment = int(jpeg_data[marker+2]) + int(jpeg_data[marker+3]);
  
  println("DHT Marker 3: " + hex(jpeg_data[marker]) 
                            + " " + hex(jpeg_data[marker+1]) 
                            + " " + hex(jpeg_data[marker+2]) 
                            + " " + hex(jpeg_data[marker+3]) 
                            + " // byte index: " + marker
                            + " // segment length: " + segment);
                           
  marker = marker + 2 + segment;
  
  segments[5] = marker;
  
  //////////////////////////////
  
  //store huffman table 4 marker   
  markers[6] = marker + 2 + 2 + 1 + 16;
  segment = int(jpeg_data[marker+2]) + int(jpeg_data[marker+3]);
  
  println("DHT Marker 4: " + hex(jpeg_data[marker]) 
                            + " " + hex(jpeg_data[marker+1]) 
                            + " " + hex(jpeg_data[marker+2]) 
                            + " " + hex(jpeg_data[marker+3]) 
                            + " // byte index: " + marker
                            + " // segment length: " + segment);
                           
  marker = marker + 2 + segment;
  
  segments[6] = marker;
  
  //////////////////////////////
  //this is where the image data starts. i haven't worked this segment out yet.
  //its pretty safe to bend here tho :)
  
  markers[7] = marker; //store sos (start of scan) marker
  segment = int(jpeg_data[marker+2]) + int(jpeg_data[marker+3]);
  
  println("SOS Marker: " + hex(jpeg_data[marker]) 
                            + " " + hex(jpeg_data[marker+1]) 
                            + " " + hex(jpeg_data[marker+2]) 
                            + " " + hex(jpeg_data[marker+3]) 
                            + " // byte index: " + marker
                            + " // segment length: " + segment);
  
  segments[7] = jpeg_data.length - 2; //store end of image marker
}

void mousePressed(){
  glitchJpeg();
  displayJpeg();
}

void keyPressed(){
  if (key == 'r'){
    loadJpegData();
    displayJpeg();
  }
}