double centreX = 0;
double centreY = 0;

double boundY = 2;
boolean drawThreads = false;
int max_int = 1000; //maximum number of 


int num_threads = 8;



int last_thread = 0;
int threadCounter = num_threads;
float inv_colour_density = 64;

int current_f = 0;
int num_f = 6;
int m;
int[][] img;
boolean rising_edge = false;
drawPixelThread[] threads = new drawPixelThread[num_threads];
String[] f_var = new String[num_f];
boolean delayDraw = false;

PImage fimg; //fractal image

void setup() {
  fullScreen();
  //size(800, 450);
  f_var[0] = "Mandelbrot:\nZi = Zr * Zi * 2 + Ci\nZr = Zr^2 - Zi^2 + Cr";
  f_var[1] = "Burning ship:\nZi = abs(Zr * Zi) * 2 + Ci\nZr = Zr^2 - Zi^2 + Cr";
  f_var[2] = "Celtic Mandelbrot:\nZi = Zr * Zi * 2 + Ci\nZr = abs(Zr^2-Zi^2) + Cr";
  f_var[3] = "Buffalo: \nZi = abs(Zr * Zi) * 2 + Ci\nZr = abs(Zr^2-Zi^2) + Cr ";
  f_var[4] = "Cubic Mandelbrot:\nZi = 3 * Zr^2 * Zi - Zi^3 + Ci\nZr = Zr^3 - 3 * Zi^2 * Zr + Cr";
  f_var[5] = "Quartic Mandelbrot:\nZi = 4 * Zr^3 * Zi - 4 * Zr * Zi^3 + Ci\nZr = Zr^4 + Zi^4 - 6 * Zi^2 * Zr^2 + Cr";
  
  img = new int[height][height];
  fimg = createImage(height,height,RGB);
  background(0, 0);
  colorMode(HSB, 360, 255, 255);
  drawThreads = true;

  m = millis();
  //  for (int i = 0; i < num_threads; i++) {
  //    threads[i] = new drawPixelThread(ceil(size/num_threads * i), floor(size/num_threads*(i+1)));
  //    threads[i].start();
  //  }


  for (int i = 0; i < height; i++) {
    double d = i*2*boundY/height+(centreY-boundY);

    for (int j = 0; j < height; j++) {
      double c = j*2*boundY/height+(centreX-boundY);
      drawPixel(max_int, c, d, j, i);
    }
  }
  
  
  drawArray();
  
  fill(0, 0, 0);
  stroke(0, 0, 0);
  rect(13 * height/9, height/8.5, height * 16/9, height/10);

  stroke(0, 0, 255);
  fill(0, 0, 255);

  textSize(height/20);
  text("Quang's Fractal Viewer", height, height/20);
  textSize(height/40);
  text(f_var[current_f], height, height/9);

  m = millis() - m;
  float s = (height * height)*1000/m;
  text("Status: \nDone!", 14 * height/9, height/9);
  text("Centre Pixel's Real Part: " + centreX  + 
    "\nCentre Pixel's Imaginary Part: " + centreY +
    "\nBoundY: " + boundY +
    "\nZoom: "+ 2/boundY +"x" +
    "\nTime Elapsed: " + m + "ms" +
    "\nPixels/s: " + s, height, height/4);
  text("Maximum Iterations: "+ max_int + "\nInverse Colour Density: " + 
    inv_colour_density +"\n\nInstructions: ", height, height/2);
  textSize(height/50);
  text("\nLeft/Right click zooms in/out. Middle click pans image without zooming"+
    "\n\nSpacebar renders the image fully zoomed out." +
    "\n\nQ/W to increase/decrease the maximum number of iterations." +
    "\n\nA/S to increase/decrease the inverse colour density. \n        -A higher number means less contrast, useful for reducing noise." +
    "\n\nZ/X to switch between different fractals." +
    "\n        -Remember to press space once you've selected your fractal." 
    , height, height*5/8);
  textSize(height/40);
}


void mousePressed() {
  if (mouseX < height) {
    fill(0, 0, 0);
    stroke(0, 0, 0);
    rect(14 * height/9, height/8.5, height * 16/9, height/10);
    fill(0, 0, 255);
    text("Status: \nWorking...", 14*height/9, height/9);

    threadCounter = num_threads;


    centreY = mouseY*2*boundY/height+(centreY-boundY);
    centreX = mouseX*2*boundY/height+((centreX-boundY));
    if (mouseButton == LEFT) {
      boundY /= 4;
    } else if (mouseButton == RIGHT) {
      boundY *= 4;
    }
    for (int i = 0; i < num_threads; i++) {
      threads[i] = new drawPixelThread(ceil(height/num_threads * i), 
        floor(height/num_threads*(i+1)));
      threads[i].start();
    }

    drawThreads = false;
  }
}
//a lot of these boolean state shenanigans is so that we can 
void draw() {
  if (drawThreads == false) {
    if (rising_edge == false) {
      m = millis();
      rising_edge = true;
    }
    if (last_thread != threadCounter) {
      fill(0, 0, 0);
      stroke(0, 0, 0);
      rect(14 * height/9, height/8.5, height * 16/9, height/10);
      fill(0, 0, 255);
      text("Status: \nWorking...\nThreads alive:" + threadCounter, 14 * height/9, height/9);
    }
    if (delayDraw == true) {
      fill(0, 0, 0);
      drawArray();
      stroke(0, 0, 0);
      rect(14 * height/9, height/8.5, height * 16/9, height/10);
      fill(0, 0, 255);
      m = millis() - m;
      textSize(height/40);
      float s = (height * height)*1000/m;
      text("Status: \nDone!", 14 * height/9, height/9);
      text("Centre Pixel's Real Part: " + centreX  + 
        "\nCentre Pixel's Imaginary Part: " + centreY +
        "\nBoundY: " + boundY +
        "\nZoom: "+ 2/boundY +"x" +
        "\nTime Elapsed: " + m + "ms" +
        "\nPixels/s: " + s, height, height/4);
      textSize(height/20);
      text("Quang's Fractal Viewer", height, height/20);
      textSize(height/40);
      text(f_var[current_f], height, height/9);
      text("Maximum Iterations: "+ max_int + "\nInverse Colour Density: " + 
        inv_colour_density +"\n\nInstructions: ", height, height/2);
      textSize(height/50);
      text("\nLeft/Right click zooms in/out. Middle click pans image without zooming"+
        "\n\nSpacebar renders the image fully zoomed out." +
        "\n\nQ/W to increase/decrease the maximum number of iterations." +
        "\n\nA/S to increase/decrease the inverse colour density. \n        -A higher number means less contrast, useful for reducing noise." +
        "\n\nZ/X to switch between different fractals." +
        "\n        -Remember to press space once you've selected your fractal." 
        , height, height*5/8);
      textSize(height/40);
      rising_edge = false;
      drawThreads = true;
      delayDraw = false;
    }
    if (threadCounter == 0 && drawThreads == false) {
      fill(0, 0, 0);
      stroke(0, 0, 0);
      rect(14 * height/9, height/8.5, height * 16/9, height/10);
      fill(0, 0, 255);
      text("Status: \nDrawing Array...", 14 * height/9, height/9);
      delayDraw = true;
    }
  }
  last_thread = threadCounter;
}
