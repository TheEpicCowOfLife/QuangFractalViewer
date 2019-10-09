void keyPressed() {
  if (key == 'q' ) {
    if (max_int < 10){
      max_int ++;
    }else{
    max_int += pow(10,floor(log(max_int)/log(10))-1);
    
    }
    redrawVar();
  } 
  if (key == 'w' && max_int > 3) {
    max_int -= pow(10,floor(log(max_int)/log(10))-1);
    redrawVar();
  }
  if (key == 'a' ) {
    inv_colour_density *= 2;
    redrawVar();
  }
  if (key == 's' ) {
    inv_colour_density /= 2;
    redrawVar();
  }
  if (key == 'z' ) {
    current_f = (current_f + 1) % num_f;
    redrawFText();
  }
  if (key == 'x' ) {
    current_f --; 
    if (current_f == -1){
      current_f = num_f - 1;
    }
      redrawFText();
    
  }

  if (key == ' ') {

    centreX = 0;
    centreY = 0;
    last_thread = 0;
    boundY = 2;
    max_int = 1000;
    threadCounter = num_threads;
    inv_colour_density = 64;
    
    drawThreads = true;
    m = millis();
    
    for (int i = 0; i < num_threads; i++) {
      threads[i] = new drawPixelThread(ceil(height/num_threads * i), 
        floor(height/num_threads*(i+1)));
      threads[i].start();
    }
    drawThreads = false;
  }
}

void redrawVar() {
  fill(0, 0, 0, 255);
  stroke(0, 0, 0);
  rect(height, height * 15/32, width, height *  3/32);
  fill(0, 0, 255);
  text("Maximum Iterations: "+ max_int + "\nInverse Colour Density: " + inv_colour_density, height, height/2);
}
void redrawFText(){
  fill(0, 0, 0, 255);
  stroke(0, 0, 0);
  rect(height, height/11, 5*height/9, height *  4/32);
  fill(0, 0, 255);
  text(f_var[current_f], height, height/9);
}