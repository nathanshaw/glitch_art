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
  if (key == 'c') {
    color_separated = !color_separated;
    newMaps();
  }
}

void checkButtonsAndKeys() {
  // check keys
  if (show_red_map) image(red_map, 0, 0);
  if (show_green_map) image(green_map, 0, 0);
  if (show_blue_map) image(blue_map, 0, 0);
}