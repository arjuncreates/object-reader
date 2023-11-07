//Digital Reader made on 12th August, 2021. Blob detection by Daniel Schiffman.

PFont myFont; 
PImage img; 

import processing.video.*;

Capture video;

color trackColor; 
float threshold = 20;
float distThreshold = 75;

ArrayList<Blob> blobs = new ArrayList<Blob>();

float Tx = 0; 
float Ty = 0; 

void setup() {
  myFont = createFont ( "Bitter-Regular.ttf", 12); 
  img = loadImage ("Flights.jpg"); 
 img.resize(width,0); 
 smooth(); 
  size(640, 480);
  String[] cameras = Capture.list();
  printArray(cameras);
  video = new Capture(this); 
  video.start();
  trackColor = color(255, 0, 0);
}


void captureEvent(Capture video) {
  video.read();
}

void keyPressed() {
  if (key == 'a') {
    distThreshold++;
  } else if (key == 'z') {
    distThreshold--;
  }
  //println(distThreshold);

}



void draw() {
  video.loadPixels();
  image(video, 0, 0);
 
 

  blobs.clear();

  //threshold = map(mouseX, 0, width, 0, 100);
  threshold = 20;

  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x++ ) {
    for (int y = 0; y < video.height; y++ ) {
      int loc = x + y * video.width;
      // What is current color
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);
      
       

      float d = distSq(r1, g1, b1, r2, g2, b2); 

      if (d < threshold*threshold) {

        boolean found = false;
        for (Blob b : blobs) {
          if (b.isNear(x, y)) {
            b.add(x, y);
            found = true;
            break;
          }
        }

        if (!found) {
          Blob b = new Blob(x, y);
          blobs.add(b);
        }
      }
    }
  }

  for (Blob b : blobs) {
    if (b.size() > 2) {
      b.show();
    }
  }
  //Text
  textFont (myFont); 
  textSize (12); 
  fill (0); 
  textAlign (LEFT); 
  
    if (key == 'x'){
      image (img, 0, 0-Ty); 
     // stroke (#3726d3); 
     // strokeWeight (10); 
     // point (23, Ty); 
     noStroke(); 
     //fill (#3726d3); 
     fill (#b3b3b3, 80); 
     rectMode (CENTER); 
    
     rect (23, Ty, 5, 60, 5); 
  }


}



float distSq(float x1, float y1, float x2, float y2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1);
  return d;
}


float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
}



void mousePressed() {
  // Save color where the mouse is clicked in trackColor variable
  int loc = mouseX + mouseY*video.width;
  trackColor = video.pixels[loc];
}
