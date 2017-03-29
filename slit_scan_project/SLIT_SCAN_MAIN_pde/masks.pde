
void newMaps() {
  if (mapMode == 0) {
    if (color_separated) {
      print("" + mapMode + " - ");
      println("Perlin Noise: separated");
      red_map = makeNoiseMap();
      green_map = makeNoiseMap();
      blue_map = makeNoiseMap();
    } else {
      print("" + mapMode + " - ");
      println("Perlin Noise: not separated");
      green_map = blue_map = red_map = makeNoiseMap();
    }
  }
  if (mapMode == 1) {
    if (color_separated) {
      print("" + mapMode + " - ");
      println("Vertical Maps: separated");
      red_map = makeVertMap();
      green_map = makeVertMap();
      blue_map = makeVertMap();
    } else {
      print("" + mapMode + " - ");
      println("Vertical Map: not separated");
      green_map = blue_map = red_map = makeVertMap();
    }
  }
  if (mapMode == 2) {
    if (color_separated) {
      print("" + mapMode + " - ");
      println("Horizontal Maps: separated");
      red_map = makeHorMap();
      green_map = makeHorMap();
      blue_map = makeHorMap();
    } else {
      print("" + mapMode + " - ");
      println("Horizontal Maps: not separated");
      green_map = blue_map = red_map = makeHorMap();
    }
  }
  /*
  if (mapMode == 3) {
   if (color_separated) {
   print("" + mapMode + " - ");
   println("Box Masks: separated");
   red_map = makeBoxMap();
   green_map = makeBoxMap();
   blue_map = makeBoxMap();
   } else {
   print("" + mapMode + " - ");
   println("Box Masks: not separated");
   green_map = blue_map = red_map = makeBoxMap();
   }
   }
   */
  if (mapMode == 3) {
    if (color_separated) {
      print("" + mapMode + " - ");
      println("Double Noise - separated");
      red_map = makeDoubleNoiseMap();
      green_map = makeDoubleNoiseMap();
      blue_map = makeDoubleNoiseMap();
    } else {
      print("" + mapMode + " - ");
      println("Double Noise - not separated");
      red_map = makeDoubleNoiseMap();
      green_map = blue_map = red_map;
    }
  }
  /*
  if (mapMode == 4) {
    if (color_separated) {
      print("" + mapMode + " - ");
      println("Circle map - separated");
      red_map = makeCircleMap();
      green_map = makeCircleMap();
      blue_map = makeCircleMap();
    } else {
      print("" + mapMode + " - ");
      println("Circle map - not separated");
      red_map = makeCircleMap();
      green_map = blue_map = red_map;
    }
  }
  */
  if (mapMode == 4) {
    if (!color_separated) {
      print("" + mapMode + " - ");
      println("Whisk map");
      red_map = makeWhiskMap();
      green_map = blue_map = red_map;
    } else {
      print("" + mapMode + " - ");
      println("Whisk map");
      red_map = makeWhiskMap();
      blue_map = makeWhiskMap();
      green_map = makeWhiskMap();
    }
  }
  if (mapMode == 5) {
    if (color_separated) {
      print("" + mapMode + " - ");
      println("Vertical/Hor Maps: separated");
      red_map = makeVertMap();
      green_map = makeHorMap();
      if (random(1) < 0.5) {
        blue_map = makeHorMap();
      } else {
        blue_map = makeVertMap();
      }
    } else {
      print("" + mapMode + " - ");
      println("Vertical Map: not separated");
      green_map = blue_map = red_map = makeVertMap();
    }
  }
  if (mapMode == 6) {
    if (color_separated) {
      print("" + mapMode + " - ");
      println("Feedback: separated");
      red_map = makeCurrentFrameMap();
      green_map = makeCurrentFrameMap();

      blue_map = makeCurrentFrameMap();
    } else {
      print("" + mapMode + " - ");
      println("Feedback: not separated");
      green_map = blue_map = red_map = makeCurrentFrameMap();
    }
  }
  if (mapMode == 7) {
    if (color_separated) {
      print("" + mapMode + " - ");
      println("Diag Maps: separated");
      red_map = makeDiagMap();
      green_map = makeDiagMap();
      blue_map = makeDiagMap();
    } else {
      print("" + mapMode + " - ");
      println("Diag Maps: not separated");
      green_map = blue_map = red_map = makeDiagMap();
    }
  }
}

PImage makeCircleMap() {
  PImage cMap = createImage(width, height, RGB);
  cMap.loadPixels();
  for (int x = 0; x < cMap.width; x++) {
    int factor = int(random(256));
    for (int y = 0; y < cMap.height; y++) {
      int step = int((float(x)/cMap.width)*factor) + int((float(y)/cMap.height)*127);
      if (x%2 == 1) {
        cMap.pixels[x + y*width] = 255 << 24 | step << 16 | step << 8 | step;
      } else {
        cMap.pixels[x*height + y] = 255 << 24 | step << 16 | step << 8 | step;
      }
    }
  }
  cMap.updatePixels();
  return cMap;
}

PImage makeWhiskMap() {
  PImage cMap = createImage(width, height, RGB);
  cMap.loadPixels();
  for (int x = 0; x < cMap.width; x++) {
    int factor = int(random(256));
    for (int y = 0; y < cMap.height; y++) {
      int step = int((float(x)/cMap.width)*factor) + int((float(y)/cMap.height)*127);
      cMap.pixels[x*height + y] = 255 << 24 | step << 16 | step << 8 | step;
    }
  }
  cMap.updatePixels();
  return cMap;
}

PImage makeTVVisionMap() {
  //create horizontal gradient map
  int direction = int(random(2));
  println(direction);
  PImage hmap = createImage(width, height, RGB);
  hmap.loadPixels();
  int time_length = int(random(70, 256));
  int random_amount = 1;
  if (random(10) < 2) {
    random_amount = int(random(0, 10));
  }
  for (int x = 0; x < hmap.width; x++) {
    for (int y = 0; y < hmap.height; y++) {
      int g;
      if (direction == 0) {
        g = int((float(y)/hmap.height) * time_length) - random_amount + int(random(random_amount));
      } else {
        g = int(((height - float(y))/hmap.height) * time_length) - random_amount + int(random(random_amount));
      }
      int argb = 255 << 24 | g << 16 | g << 8 | g; 
      hmap.pixels[x*height + y] = argb;
    }
  }
  hmap.updatePixels();
  return hmap;
}

PImage makeHorMap() {
   //create vertical gradient map
  PImage dmap = createImage(width, height, RGB);
  dmap.loadPixels();
  // 255 is max, more than 255 will leave gaps
  int direction = int(random(2));
  print("direction : ", direction, " ");
  int time_length = int(random(70, 256));
  int random_amount = 1;
  if (random(10) < 2) {
    random_amount = int(random(0, 10));
  }
  println("times length is :", time_length, " - random_amount is : ", random_amount);
  int g;
  for (int x = 0; x < dmap.width; x++) {
    for (int y = 0; y < dmap.height; y++) {
      if (direction == 0) {
        g = int((float(dmap.width - x)/width)*time_length) - random_amount + int(random(random_amount));// + (float(dmap.height - y)/height))/2 * 255) + random(0, 1));
      } else {
        g = int((float(x)/width)*time_length) - random_amount + int(random(random_amount));// + (float(dmap.height - y)/height))/2 * 255) + random(0, 1));
      }
      int argb = 255 << 24 | g << 16 | g << 8 | g; 
      dmap.pixels[x*height + y] = argb;
    }
  }
  dmap.updatePixels();
  return dmap;
}

PImage makeCurrentFrameMap() {
  PImage currentFrame = createImage(width, height, RGB);
  currentFrame.loadPixels();
  for (int i = 0; i < pixels.length; i++) {
    currentFrame.pixels[i] = pixels[i];
  }
  currentFrame.updatePixels();
  return currentFrame;
}

PImage makeVertMap() {
  //create vertical gradient map
  PImage dmap = createImage(width, height, RGB);
  dmap.loadPixels();
  // 255 is max, more than 255 will leave gaps
  int direction = int(random(2));
  print("direction : ", direction, " ");
  int time_length = int(random(70, 256));
  int random_amount = 1;
  if (random(10) < 2) {
    random_amount = int(random(0, 10));
  }
  println("times length is :", time_length, " - random_amount is : ", random_amount);
  int g;
  for (int x = 0; x < dmap.width; x++) {
    for (int y = 0; y < dmap.height; y++) {
      if (direction == 0) {
        g = int((float(dmap.width - x)/width)*time_length) - random_amount + int(random(random_amount));// + (float(dmap.height - y)/height))/2 * 255) + random(0, 1));
      } else {
        g = int((float(x)/width)*time_length) - random_amount + int(random(random_amount));// + (float(dmap.height - y)/height))/2 * 255) + random(0, 1));
      }
      int argb = 255 << 24 | g << 16 | g << 8 | g; 
      dmap.pixels[x + y*width] = argb;
    }
  }
  dmap.updatePixels();
  return dmap;
}

PImage makeDoubleNoiseMap() {
  //create noids map
  PImage nmap = makeNoiseMap();
  PImage nmap2 = makeNoiseMap();
  //PImage finalMap = nmap * nmap2;
  for (int i =0; i < nmap.pixels.length; i++){
    nmap.pixels[i] = (nmap.pixels[i]|nmap2.pixels[i]);
  }
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
  float increment = pow(random(0.09125, 0.25), 2);
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
  int time_length = int(random(70, 256));
  int random_amount = 1;
  if (random(10) < 2) {
    random_amount = int(random(0, 10));
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
  int factor1 = int(random(1, 10));
  int factor11 = int(random(1, 10));
  int factor2 = int(random(30, 90) + 50);
  int factor3 = int(random(100) + 155);
  println("factors : ", factor1, "-", factor11, "-", factor2, "-", factor3);
  for (int x = 0; x < bmap.width; x++) {
    for (int y = 0; y < bmap.height; y++) {
      int r = x%factor3;
      if (x % factor11 < 4) {
        r = y%255;
      }
      if (y % factor2 < 6) {
        r = int(random(0, factor3));
      }
      int g = int((((float(bmap.width - x)/width) + (float(bmap.height - y)/height))/2 * factor3) + random(0, 1));
      r = (r*g)/255;
      int argb = 255 << 24 | r << 16 | r << 8 | r; 
      bmap.pixels[x + y*width] = argb;
    }
  }
  bmap.updatePixels();
  return bmap;
}