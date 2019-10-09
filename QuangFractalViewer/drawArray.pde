void drawArray() {
  clear();
  fimg.loadPixels();
  for (int y = 0; y < height; y++) {
    for (int x = 0; x  < height; x ++) {
      int i = img[x][y];
      if (i == 0) {
        fimg.pixels[x+y*height] = color(0,0,0);
        //stroke(0, 0, 0);
        //point(x, y);
      } else {
        fimg.pixels[x+y*height] = color((i*360/inv_colour_density)%360, 255, 255);
        //stroke((i*360/inv_colour_density)%360, 255, 255);
        //point(x, y);
      }
    }
  }
  fimg.updatePixels();
  image(fimg,0,0);
}
