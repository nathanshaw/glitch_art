
void readArduinoButtons() {
  if (arduinoPort.available() > 0) {
    val = arduinoPort.read();    
    if (int(val) == 0) {
      increaseFrameRate();
      println("b1 : increaseing 'frame rate'");
    }
    if (int(val) == 1) {
      // new maps
      println("b1 : making new maps");
      newMaps();
    }
    if (int(val) == 2) {
      println("b2 : button does nothing");
    }
    if (int(val) == 3) {
      // generate new maps
      println("b3 : new map mode");
      newMapMode();
    }
    if (int(val) == 4) {
      println("b4 : changed difference");
      changeDifference();
    }
    if (int(val) == 5) {
      // color seperation
      println("b5 : color separation");
      flipColorSeparation();
    }
    if (int(val) == 6) {
      // tweet
      println("b6 : tweeting");
      saveScreenShot();
    }
  }
}

void newMapMode() {
  // go to the next mapModes
  mapMode++;
  if (mapMode >= numMapModes) {
    mapMode = 0;
  }
  newMaps();
}

void flipColorSeparation() {
  color_separated = !color_separated;
  newMaps();
}

void increaseFrameRate() {
  num_frames = num_frames * 2;
  if (num_frames > 256) {
    num_frames = 8;
  }
  overfill_amount = 256 / num_frames;
  print("overfill : ", overfill_amount);
  println(" num_frames : ", num_frames);
}

void decreaseFrameRate() {
  num_frames = num_frames/2;
  if (num_frames < 8) {
    num_frames = 256;
  }
  overfill_amount = 256/num_frames;
  print("overfill : ", overfill_amount);
  println(" num_frames : ", num_frames);
}

void keyPressed() {
  if (key == 'r') show_red_map = !show_red_map;
  if (key == 'g') show_green_map = !show_green_map;
  if (key == 'b') show_blue_map = !show_blue_map;
  if (key == 'n') {
    newMaps();
  }
  if (key == 'm') {
    newMapMode();
  }
  if (key == 't') {
    saveScreenShot();
  }
  if (key == 'c') {
    flipColorSeparation();
  }
  if (key == '=') {
    increaseFrameRate();
  }
  if (key == '-') {
    decreaseFrameRate();
  }
}

void checkButtonsAndKeys() {
  // check keys
  if (show_red_map) image(red_map, 0, 0);
  if (show_green_map) image(green_map, 0, 0);
  if (show_blue_map) image(blue_map, 0, 0);
}