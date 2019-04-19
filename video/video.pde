
import processing.video.*;
Movie mov;
PGraphics pg;

void setup() {
  size(640, 360);
  mov = new Movie(this, "totoro.mp4");
}

void draw() {   
  mov.play();
  pg=createGraphics(640, 360);
  pg.beginDraw();
  pg.image(mov, 0, 0); 
  
  pg.loadPixels();
  float[][] matrix = { { -2, -1, 0 }, 
    { -1, 1, 1 }, 
    { 0, 1, 2 } }; 
  int matrixsize = 3;
  for (int x = 0; x < mov.width; x++) {
    for (int y = 0; y < mov.height; y++ ) {
      color c = convolution(x, y, matrix, matrixsize, mov);
      int loc = x + y*pg.width;
      pg.pixels[loc] = c;
    }
  }
  pg.updatePixels();
  pg.text(getFrame() + " / " + (getLength() - 1), 10, 30);
  pg.text(mov.frameRate, mov.width-50, 30);
  pg.endDraw();
  image(pg, 0, 0);
}

// Called every time a new frame is available to read
void movieEvent(Movie m) {
  m.read();
}

int getLength() {
  return int(mov.duration() * mov.frameRate);
}

int getFrame() {    
  return ceil(mov.time() * 30) - 1;
}

color convolution(int x, int y, float[][] matrix, int matrixsize, Movie mov)
{
  float rtotal = 0.0;
  float gtotal = 0.0;
  float btotal = 0.0;
  int offset = matrixsize / 2;
  for (int i = 0; i < matrixsize; i++) {
    for (int j= 0; j < matrixsize; j++) {
      // What pixel are we testing
      int xloc = x+i-offset;
      int yloc = y+j-offset;
      int loc = xloc + mov.width*yloc;
      // Make sure we haven't walked off our image, we could do better here
      loc = constrain(loc, 0, mov.pixels.length-1);
      // Calculate the convolution
      rtotal += (red(mov.pixels[loc]) * matrix[i][j]);
      gtotal += (green(mov.pixels[loc]) * matrix[i][j]);
      btotal += (blue(mov.pixels[loc]) * matrix[i][j]);
    }
  }
  // Make sure RGB is within range
  rtotal = constrain(rtotal, 0, 255);
  gtotal = constrain(gtotal, 0, 255);
  btotal = constrain(btotal, 0, 255);
  mov.updatePixels();
  // Return the resulting color
  return color(rtotal, gtotal, btotal);
}
