
PImage makeHorMap() {
  //create horizontal gradient map
  PImage hmap = createImage(width, height, RGB);
  hmap.loadPixels();
  for (int x = 0; x < hmap.width; x++) {
    for (int y = 0; y < hmap.height; y++) {
      int g = int((float(x)/hmap.width) * 255);
      int argb = 255 << 24 | g << 16 | g << 8 | g; 
      hmap.pixels[x + y*width] = argb;
    }
  }
  hmap.updatePixels();
  return hmap;
}

PImage makeVertMap() {
   //create vertical gradient map
  PImage dmap = createImage(width, height, RGB);
  dmap.loadPixels();
  // 255 is max, more than 255 will leave gaps
  int time_length = int(random(70,256));
  int random_amount = 1;
  if (random(10) < 2){
  random_amount = int(random(0,10));
  }
  println("times length is :", time_length, " - random_amount is : ", random_amount);
  for (int x = 0; x < dmap.width; x++) {
    for (int y = 0; y < dmap.height; y++) {
      int g = int((float(dmap.width - x)/width)*time_length) - random_amount + int(random(random_amount));// + (float(dmap.height - y)/height))/2 * 255) + random(0, 1));
      int argb = 255 << 24 | g << 16 | g << 8 | g; 
      dmap.pixels[x + y*width] = argb;
    }
  }
  dmap.updatePixels();
  return dmap; 
}

PImage makeRandMap() {
  //create random gradient map
  PImage rmap = createImage(width, height, RGB);
  rmap.loadPixels();
  for (int x = 0; x < rmap.width; x++) {
    for (int y = 0; y < rmap.height; y++) {
      int g = int(random(1.0)*255);
      int argb = 255 << 24 | g << 16 | g << 8 | g; 
      rmap.pixels[x + y*width] = argb;
    }
  }
  rmap.updatePixels();
  return rmap;
}

PImage makeDoubleNoiseMap() {
  //create noids map
  PImage nmap = makeNoiseMap();
  PImage nmap2 = makeNoiseMap();
  //PImage finalMap = nmap * nmap2;
  nmap.blend(nmap2, 0, 0, 33, 100, 67, 0, 33, 100, ADD);
  nmap.updatePixels();
  return nmap;
}

PImage makeNoiseMap() {
  //create noids map
  PImage nmap = createImage(width, height, RGB);
  float xoff = random(0.0, 1.0);
  // Start xoff at 0
  float detail = random(0.01, 0.15);
  print("detail : ", detail, " - ");
  float increment = pow(random(0.09125, 0.35), 2);
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

      // Set each pixel onscreen to a grayscale value
      nmap.pixels[x+y*width] = color(bright);
    }
  }

  nmap.updatePixels();
  return nmap;
}

PImage makeDiagMap() {
  //create diagonal gradient map
  PImage dmap = createImage(width, height, RGB);
  dmap.loadPixels();
  // 255 is max, more than 255 will leave gaps
  int time_length = int(random(70,256));
  int random_amount = 1;
  if (random(10) < 2){
  random_amount = int(random(0,10));
  }
  println("times length is :", time_length, " - random_amount is : ", random_amount);
  for (int x = 0; x < dmap.width; x++) {
    for (int y = 0; y < dmap.height; y++) {
      int g = int((float(dmap.width - x)/width)*time_length) - random_amount + int(random(random_amount));// + (float(dmap.height - y)/height))/2 * 255) + random(0, 1));
      int argb = 255 << 24 | g << 16 | g << 8 | g; 
      dmap.pixels[x + y*width] = argb;
    }
  }
  dmap.updatePixels();
  return dmap;
}

PImage makeBoxMap() {
  //create horizontal gradient map
  PImage bmap = createImage(width, height, RGB);
  bmap.loadPixels();
  int factor1 = int(random(1,10));
  int factor11 = int(random(1,10));
  int factor2 = int(random(1,50) + 50);
  int factor3 = int(random(300) + 1);
  println("factors : ", factor1, "-", factor11, "-", factor2, "-", factor3);
  for (int x = 0; x < bmap.width; x++) {
    for (int y = 0; y < bmap.height; y++) {
      int r = x%factor3;
      if (x % factor11 == 2) {
        r = y%255;
      }
      if (y % factor2 == 3) {
        r = int(random(0, factor3));
      }
      int g = int((((float(bmap.width - x)/width) + (float(bmap.height - y)/height))/2 * factor3) + random(0, 1));
      int b = int(float(g+r)*0.5);
      int argb = 255 << 24 | r << 16 | g << 8 | b; 
      bmap.pixels[x + y*width] = argb;
    }
  }
  bmap.updatePixels();
  return bmap;
}