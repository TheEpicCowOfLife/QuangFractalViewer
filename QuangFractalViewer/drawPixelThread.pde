class drawPixelThread extends Thread {
  boolean active;
  int start, stop;
  //PGraphics f = new PGraphics();
  drawPixelThread(int start, int stop) {
    active = false;
    this.start = start;
    this.stop = stop;
  }

  void start() {
    active = true;
    super.start();
  }

  void run () {
    execute();
  }

  void execute() {
    for (int i = this.start; i < this.stop; i++) {
      double d = i*2*boundY/height+(centreY-boundY);

      for (int j = 0; j < height; j++) {
        double c = j*2*boundY/height+(centreX-boundY);
        drawPixel(max_int, c, d, j, i);
      }
    }
    active = false;
    threadCounter -= 1;
    //println(threadCounter);
  }

  boolean isActive() {
    return active;
  }

  void quit() {
    active = false;
    interrupt();
  }
}