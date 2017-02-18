int tick;

int cell_size = 16;
int grid_width;
int grid_height;

void setup() {
  size(512, 512);

  grid_width = width/cell_size;
  grid_height = height/cell_size;

  background(0);
}

void draw() {
  pixelBytes();
}

void pixelBytes() {
  loadPixels();
  for (int i = 0; i < pixels.length; i++) {
    int t = tick;

    t = t*(((t>>12)|(t>>8))&(63&(t>>4)));

    t = t&255;

    int argb = 255 << 24 | t << 16 | t << 8 | t;

    pixels[i] = argb;

    tick++;
  }
  updatePixels();
}

void drawBytes() {
  for (int x = 0; x < grid_width; x++) {
    for (int y = 0; y < grid_height; y++) {

      int t = tick;

      t = t*(((t>>12)|(t>>8))&(63&(t>>4)));

      t = t&255;

      fill(t);
      noStroke();
      rect(x*cell_size, y*cell_size, cell_size, cell_size);

      tick++;
    }
  }
}