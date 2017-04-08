StringList reds = new StringList("Proud to be loving Trump today!", "GOP Forever, proud to be american!");
StringList blues = new StringList("Feel the Bern", "Proud to be a Democrat!");

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
  // determine if there is more red or blue and tweet accordingly
  if (isRed() == true) {
    tweet(reds.get(int(random(reds.size()))));
  } else {
    tweet(blues.get(int(random(blues.size()))));
  }
}

void tweet(String msg){
  String tweet = simpletweet.tweetImage(get(), msg);
  println("Posted " + tweet);
}