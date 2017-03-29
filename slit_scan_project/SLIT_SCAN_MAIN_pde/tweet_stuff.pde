import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.io.StringWriter;
import java.io.Writer;

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
  //save the current frame
  String tempFileName = "/Users/nathan/workspace/glitch_art/slit_scan_project/node/output.png";
  saveFrame(tempFileName);
  println("saved file : " + tempFileName);
  // determine if there is more red or blue and tweet accordingly
  if (isRed() == true) {
    tweet("Red");
  } else {
    tweet("Blue");
  }
}

private static String output(InputStream inputStream) throws IOException {
  StringBuilder sb = new StringBuilder();
  BufferedReader br = null;
  try {
    br = new BufferedReader(new InputStreamReader(inputStream));
    String line = null;
    while ((line = br.readLine()) != null) {
      sb.append(line + System.getProperty("line.separator"));
    }
  } 
  finally {
    br.close();
  }
  return sb.toString();
}

void tweet(String msg) {
  //ProcessBuilder pb = new ProcessBuilder();
  //pb.command("/usr/local/bin/node", "/Users/nathan/workspace/glitch_art/slit_scan_project/node/bot.js");  
  //Process p = pb.start();
  println("------ entered tweet ---------");
  try {
    Process p = new ProcessBuilder("/usr/local/bin/node", "/Users/nathan/workspace/glitch_art/slit_scan_project/node/bot.js").start();
    // InputStream shellIn = p.getInputStream();
    /*
    try {
      int errorCode = p.waitFor();
      println("process error code : ", errorCode);
    } 
    catch (InterruptedException t) {
      println("interrupted exception : ", t);
    
    */
    // String response = convertStreamToStr(shellIn);
    // println(response);
  }
  catch (IOException e) {
    println("I just threw a IOEception : ", e);
  }
  println("----- exited tweet --------");
}

public static String convertStreamToStr(InputStream is) throws IOException {

  if (is != null) {
    Writer writer = new StringWriter();

    char[] buffer = new char[1024];
    try {
      Reader reader = new BufferedReader(new InputStreamReader(is, 
        "UTF-8"));
      int n;
      while ((n = reader.read(buffer)) != -1) {
        writer.write(buffer, 0, n);
      }
    } 
    finally {
      is.close();
    }
    return writer.toString();
  } else {
    return "";
  }
}