//rawdata_vis

//modified/simplified version of Phillip Stearns' dataViz
//https://github.com/phillipdavidstearns/aYearInCode/tree/master/Processing%202.2.1/dataViz

//input file for visualization
String input_path = ""; //file path
String input_filename = "test"; //file name
String input_ext = ".gif"; //file extension

byte[] raw_bytes, raw_bits; //byte arrays to store input data

// sets number of bits to be packed into color channel values
int chan_depth = 8; 
int pixel_depth = chan_depth*3;

void setup() {
  size(512, 512);

  loadData(input_path + input_filename + input_ext);
}

void draw() {
  bits_to_pixels();
}

void loadData(String path) {
  raw_bytes = loadBytes(path);
  raw_bits = new byte[raw_bytes.length*8];
  bytes_to_bits();
}

void bytes_to_bits() { //seperate data into bits
  for (int i = 0; i < raw_bytes.length; i++) {    
    for (int j = 0; j < 8; j++) {    
      raw_bits[(i * 8) + j] = byte((raw_bytes[i] >> j) & 1);
    }
  }
}

void bits_to_pixels() {
  loadPixels();

  for (int i = 0; i < pixels.length; i++) {
    int red = 0;
    int green = 0; 
    int blue = 0;

    //pack bits into channel values
    if (i * pixel_depth+pixel_depth < raw_bits.length) {
  
      //per channel, iterate over number of bits in channel depth
      //and pack bits into bytes
      for (int x = 0; x < chan_depth; x++) {
        red |=  (raw_bits[(i * pixel_depth) + x] << x);
      }
      red *= (255/(pow(2, (chan_depth)) - 1)); //scale to 0-255

      for (int y = 0; y < chan_depth; y++) {
        green |=  (raw_bits[(i * pixel_depth) + chan_depth + y] << y);
      }
      green *= (255/(pow(2, (chan_depth))-1)); //scale to 0-255

      for (int z = 0; z < chan_depth; z++) {
        blue |=  (raw_bits[(i * pixel_depth) + chan_depth + chan_depth + z] << z);
      }
      blue *= (255/(pow(2, (chan_depth)) - 1)); //scale to 0-255
      
      //assemble channel values into single pixel
      pixels[i] = 255 << 24 |red << 16 | green << 8 | blue;
      
    } else {
      pixels[i] = color(0); //set pixel to black if more pixels than data
    }
  }
  updatePixels();
}