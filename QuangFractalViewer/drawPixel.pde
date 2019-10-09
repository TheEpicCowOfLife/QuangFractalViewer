double zisq;
double zrsq;
double temp;

double dabs(double n) {
  if (n < 0) {
    return -n;
  }
  return n;
}
void drawPixel(int max_i, double cr, double ci, int x, int y) {

  int i = 0; 
  double zr = 0;
  double zi = 0;

  switch(current_f) {


  case 0:
    while (zr * zr + zi * zi < 4 && i <= max_i) {
      temp = zr * zr - zi * zi + cr;
      zi = 2*zr*zi+ci;
      zr = temp;
      i+=1;
    }
    break;


  case 1:

    while (zr * zr+ zi * zi < 4 && i <= max_i) {
      temp = 2*dabs(zi*zr)+ci;
      zr = zr * zr - zi * zi + cr;
      zi = temp;
      i+=1;
    }  
    break;


  case 2:
    while (zr * zr+ zi * zi < 4 && i <= max_i) {
      temp = 2*zi*zr+ci;
      zr = dabs(zr * zr - zi * zi) + cr;
      zi = temp;
      i+=1;
    }



  case 3:
    while (zr * zr+ zi * zi < 4 && i <= max_i) {
      temp = 2*dabs(zi*zr)+ci;
      zr = dabs(zr * zr - zi * zi) + cr;
      zi = temp;
      i+=1;
    }

  case 4:
    while (zr * zr + zi * zi < 4 && i <= max_i) {
      zisq= zi * zi;
      zrsq = zr * zr;
      temp = ((zrsq * 3) - zisq) * zi + ci;
      zr = (zrsq - (zisq * 3)) * zr + cr;
      zi = temp;
      i+=1; 
    }


  case 5:
    while (zr * zr + zi * zi < 4 && i <= max_i) {
      
      zisq= zi * zi;
      zrsq = zr * zr;
      temp = 4 * zr * zi * (zrsq - zisq) + ci;
      zr = zrsq * zrsq + zisq * zisq - 6 * zrsq * zisq + cr;
      zi = temp;
      i+= 1;
    }
  }

  //println(c.real, c.imag,x,y,i);
  if (i > max_i) {
    img[x][y] = 0;
  } else {
    img[x][y] = i;
  }
}