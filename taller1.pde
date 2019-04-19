PGraphics pg1;
PGraphics pg2;
PImage img;
import processing.video.*;
Movie mov;
Button gs;
Button c1;
Button c2;
Button c3;
boolean greyscale=false;
boolean conv1=false;
boolean conv2=false;
boolean conv3=false;
void setup() {
  size(1000, 1000);
  surface.setResizable(true);
  selectInput("Select a file to process:", "fileSelected");
}

void draw() {
  if (img!=null) {
    pg1=createGraphics(img.width, img.height);
    pg2=createGraphics(img.width, img.height);
    pg1.beginDraw();
    pg1.image(img, 0, 0);
    pg1.endDraw();
    float widthB=img.width/4;
    gs = new Button("GS", img.width+100, 25, widthB, 20);
    c1 = new Button("C1", img.width+100+widthB, 25, widthB, 20);
    c2 = new Button("C2", img.width+100+widthB+widthB, 25, widthB, 20);
    c3 = new Button("C3", img.width+100+widthB+widthB+widthB, 25, widthB, 20);
    image(pg1, 50, 50);
    //botones
    gs.Draw();
    c1.Draw();
    c2.Draw();
    c3.Draw();

    pg2.beginDraw();
    pg2.image(img, 0, 0);
    pg2.loadPixels();
    //escala de grises;
    if (greyscale==true) {
      int pixels=pg2.width*pg2.height;
      for (int i=0; i<pixels; i++) {
        float r=red(pg2.pixels[i]);
        float g=green(pg2.pixels[i]);
        float b=blue(pg2.pixels[i]);
        pg2.pixels[i]=color((r+g+b)/3);
      }
    } else if (conv1==true) {
      float[][] matrix = { { -2, -1, 0 }, 
        { -1, 1, 1 }, 
        { 0, 1, 2 } }; 
      int matrixsize = 3;
      for (int x = 0; x < pg2.width; x++) {
        for (int y = 0; y < pg2.height; y++ ) {
          color c = convolution(x, y, matrix, matrixsize, img);
          int loc = x + y*pg2.width;
          pg2.pixels[loc] = c;
        }
      }
    } else if (conv2==true) {
      float[][] matrix = { { -1, -1, -1 }, 
        { -1, 8, -1 }, 
        { -1, -1, -1 } }; 
      int matrixsize = 3;
      for (int x = 0; x < pg2.width; x++) {
        for (int y = 0; y < pg2.height; y++ ) {
          color c = convolution(x, y, matrix, matrixsize, img);
          int loc = x + y*pg2.width;
          pg2.pixels[loc] = c;
        }
      }
    } else if (conv3==true) {
      float[][] matrix = { { 0, -1, 0 }, 
        { -1, 5, -1 }, 
        { 0, -1, 0 } }; 
      int matrixsize = 3;
      for (int x = 0; x < pg2.width; x++) {
        for (int y = 0; y < pg2.height; y++ ) {
          color c = convolution(x, y, matrix, matrixsize, pg1);
          int loc = x + y*pg2.width;
          pg2.pixels[loc] = c;
        }
      }
    }

    pg2.updatePixels();
    pg2.endDraw();  
    image(pg2, img.width+100, 50);

    //histograma
    int[] hist = new int[256];

    // Calculate the histogram
    for (int i = 0; i < pg2.width; i++) {
      for (int j = 0; j < pg2.height; j++) {
        int bright = int(brightness(pg2.get(i, j)));
        hist[bright]++;
      }
    }

    int histMax = max(hist);
    stroke(255);
    // Draw half of the histogram (skip every second value)
    for (int i = 0; i < pg2.width; i += 2) {
      // Map i (from 0..img.width) to a location in the histogram (0..255)
      int which = int(map(i, 0, pg2.width, 0, 255));
      // Convert the histogram value to a location between 
      // the bottom and the top of the picture
      int y = int(map(hist[which], 0, histMax, pg2.height, 0));
      line(i+pg2.width+100, pg2.height+50, i+pg2.width+100, y+50);
    }
  } else if (mov!=null) {
    mov.play();
    pg1=createGraphics(640, 360);
    pg1.beginDraw();
    pg1.image(mov, 0, 0);
    pg1.endDraw();
    float widthB=mov.width/4;
    gs = new Button("GS", mov.width+100, 25, widthB, 20);
    c1 = new Button("C1", mov.width+100+widthB, 25, widthB, 20);
    c2 = new Button("C2", mov.width+100+widthB+widthB, 25, widthB, 20);
    c3 = new Button("C3", mov.width+100+widthB+widthB+widthB, 25, widthB, 20);
    image(pg1, 50, 50);
    //botones
    gs.Draw();
    c1.Draw();
    c2.Draw();
    c3.Draw();
    pg2=createGraphics(640, 360);
    pg2.beginDraw();
    pg2.image(mov, 0, 0); 

    pg2.loadPixels();
    //escala de grises;
    if (greyscale==true) {
      int pixels=pg2.width*pg2.height;
      for (int i=0; i<pixels; i++) {
        float r=red(pg2.pixels[i]);
        float g=green(pg2.pixels[i]);
        float b=blue(pg2.pixels[i]);
        pg2.pixels[i]=color((r+g+b)/3);
      }
    } else if (conv1==true) {
      float[][] matrix = { { -2, -1, 0 }, 
        { -1, 1, 1 }, 
        { 0, 1, 2 } }; 
      int matrixsize = 3;
      for (int x = 0; x < mov.width; x++) {
        for (int y = 0; y < mov.height; y++ ) {
          color c = convolution(x, y, matrix, matrixsize, mov);
          int loc = x + y*pg2.width;
          pg2.pixels[loc] = c;
        }
      }
    } else if (conv2==true) {
      float[][] matrix = { { -1, -1, -1 }, 
        { -1, 8, -1 }, 
        { -1, -1, -1 } }; 
      int matrixsize = 3;
      for (int x = 0; x < mov.width; x++) {
        for (int y = 0; y < mov.height; y++ ) {
          color c = convolution(x, y, matrix, matrixsize, mov);
          int loc = x + y*pg2.width;
          pg2.pixels[loc] = c;
        }
      }
    } else if (conv3==true) {
      float[][] matrix = { { 0, -1, 0 }, 
        { -1, 5, -1 }, 
        { 0, -1, 0 } }; 
      int matrixsize = 3;
      for (int x = 0; x < mov.width; x++) {
        for (int y = 0; y < mov.height; y++ ) {
          color c = convolution(x, y, matrix, matrixsize, pg1);
          int loc = x + y*pg2.width;
          pg2.pixels[loc] = c;
        }
      }
    }

    pg2.updatePixels();
    pg2.text(getFrame() + " / " + (getLength() - 1), 10, 30);
    pg2.text(mov.frameRate, mov.width-50, 30);
    pg2.endDraw();  
    image(pg2, mov.width+100, 50);

    //histograma
    int[] hist = new int[256];

    // Calculate the histogram
    for (int i = 0; i < pg2.width; i++) {
      for (int j = 0; j < pg2.height; j++) {
        int bright = int(brightness(pg2.get(i, j)));
        hist[bright]++;
      }
    }

    int histMax = max(hist);
    stroke(255);
    // Draw half of the histogram (skip every second value)
    for (int i = 0; i < pg2.width; i += 2) {
      // Map i (from 0..mov.width) to a location in the histogram (0..255)
      int which = int(map(i, 0, pg2.width, 0, 255));
      // Convert the histogram value to a location between 
      // the bottom and the top of the picture
      int y = int(map(hist[which], 0, histMax, pg2.height, 0));
      line(i+pg2.width+100, pg2.height+50, i+pg2.width+100, y+50);
    }
  }
}

void movieEvent(Movie m) {
  m.read();
}

int getLength() {
  return int(mov.duration() * mov.frameRate);
}

int getFrame() {    
  return ceil(mov.time() * 30) - 1;
}

color convolution(int x, int y, float[][] matrix, int matrixsize, PImage img)
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
      int loc = xloc + img.width*yloc;
      // Make sure we haven't walked off our image, we could do better here
      loc = constrain(loc, 0, img.pixels.length-1);
      // Calculate the convolution
      rtotal += (red(img.pixels[loc]) * matrix[i][j]);
      gtotal += (green(img.pixels[loc]) * matrix[i][j]);
      btotal += (blue(img.pixels[loc]) * matrix[i][j]);
    }
  }
  // Make sure RGB is within range
  rtotal = constrain(rtotal, 0, 255);
  gtotal = constrain(gtotal, 0, 255);
  btotal = constrain(btotal, 0, 255);
  // Return the resulting color
  return color(rtotal, gtotal, btotal);
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
    exit();
  } else {
    if (selection.getAbsolutePath().contains(".mp4")) {
      mov = new Movie(this, selection.getAbsolutePath());
      surface.setSize(640*2 +150, 360+100);
    } else {
      img=  loadImage(selection.getAbsolutePath());
      surface.setSize((img.width*2)+150, img.height+100);
    }
  }
}

void mousePressed()
{
  if (gs.MouseIsOver()) {
    greyscale=true;
    conv1=false;
    conv2=false;
    conv3=false;
  } else if (c1.MouseIsOver()) {
    greyscale=false;
    conv1=true;
    conv2=false;
    conv3=false;
  } else if (c2.MouseIsOver()) {
    greyscale=false;
    conv1=false;
    conv2=true;
    conv3=false;
  } else if (c3.MouseIsOver()) {
    greyscale=false;
    conv1=false;
    conv2=false;
    conv3=true;
  }
  println(greyscale+","+conv1+","+conv2+","+conv3);
}

class Button {
  String label;
  float x;    // top left corner x position
  float y;    // top left corner y position
  float w;    // width of button
  float h;    // height of button

  Button(String labelB, float xpos, float ypos, float widthB, float heightB) {
    label = labelB;
    x = xpos;
    y = ypos;
    w = widthB;
    h = heightB;
  }

  void Draw() {
    fill(218);
    stroke(141);
    rect(x, y, w, h, 10);
    textAlign(CENTER, CENTER);
    fill(0);
    text(label, x + (w / 2), y + (h / 2));
  }

  boolean MouseIsOver() {
    if (mouseX > x && mouseX < (x + w) && mouseY > y && mouseY < (y + h)) {
      return true;
    }
    return false;
  }
}
