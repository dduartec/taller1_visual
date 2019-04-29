//canvas
PGraphics pg1;
PGraphics pg2;
//imagen
PImage img;
//libreria para el video
import processing.video.*;
//libreria para input
import controlP5.*;
ControlP5 cp5;
Textfield min,max;
int RangoMin = 0,RangoMax = 255;
//video
Movie mov;
//BOTONES
//escala de grises
Button gs;
//convolucion 1
Button c1;
//convolucion 2
Button c2;
//convolucion 3
Button c3;
//quitar convolucion
Button quitar;
//segmentación
Button s;
boolean greyscale=false;
boolean conv1=false;
boolean conv2=false;
boolean conv3=false;

void setup() {
  size(1000, 1000);
  surface.setResizable(true);
  //seleccion del archivo (video o imagen)
  selectInput("Select a file to process:", "fileSelected");
  PFont font = createFont("arial",20);
  cp5 = new ControlP5(this);
  min = cp5.addTextfield("minimo");
  min.setPosition(20,500)
     .setSize(95,35)
     .setFont(font)
     .setFocus(true)
     .setColor(color(255,0,0))
     ;
  max = cp5.addTextfield("maximo");
  max.setPosition(20,500)
     .setSize(95,35)
     .setFont(font)
     .setFocus(true)
     .setColor(color(255,0,0))
     ;
}

void draw() {
  //IMAGEN
  if (img!=null) {
    pg1=createGraphics(img.width, img.height);
    pg2=createGraphics(img.width, img.height);
    //canvas 1 imagen original
    pg1.beginDraw();
    pg1.image(img, 0, 0);
    pg1.endDraw();    
    image(pg1, 50, 50);
    //Botones
    float widthB=img.width/5;
    gs = new Button("GS", img.width+100, 25, widthB, 20);
    c1 = new Button("C1", img.width+100+widthB, 25, widthB, 20);
    c2 = new Button("C2", img.width+100+widthB+widthB, 25, widthB, 20);
    c3 = new Button("C3", img.width+100+widthB+widthB+widthB, 25, widthB, 20);
    quitar = new Button("Quitar", img.width+100+widthB+widthB+widthB+widthB, 25, widthB, 20);
    gs.Draw();
    c1.Draw();
    c2.Draw();
    c3.Draw();
    quitar.Draw();
    //Todo segmentado
    min.setPosition(img.width+100,50+img.height+5);
    max.setPosition(img.width+100+110,50+img.height+5);
    //s = new Button("S", img.width+100+120+20, 50+img.height+5, widthB, 20);
    s = new Button("Seg", img.width+100+120+100, 50+img.height+6, widthB, 30);
    s.Draw();
    //canvas 2 imagen modificada
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
      //convolucion 1
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
      //convolucion 2
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
      //convolucion 3
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

    //histograma
    int[] hist = new int[256];

    // Calculate the histogram
    for (int i = 0; i < pg2.width; i++) {
      for (int j = 0; j < pg2.height; j++) {
        int bright = int(brightness(pg2.get(i, j)));
        hist[bright]++;
        if(bright < RangoMin || bright > RangoMax){
          int loc = i + j*pg2.width;
          color c = color(0);
          pg2.pixels[loc] = c;
        }
      }
    }

    pg2.updatePixels();
    pg2.endDraw();  
    image(pg2, img.width+100, 50);

    int histMax = max(hist);
    // Draw half of the histogram (skip every second value)
    for (int i = 0; i < pg2.width; i += 2) {
      stroke(255);
      // Map i (from 0..img.width) to a location in the histogram (0..255)
      int which = int(map(i, 0, pg2.width, 0, 255));
      if(which >= RangoMin && which <= RangoMax){
        stroke(255,0,0);
      }
      // Convert the histogram value to a location between 
      // the bottom and the top of the picture
      int y = int(map(hist[which], 0, histMax, pg2.height, 0));
      line(i+pg2.width+100, pg2.height+50, i+pg2.width+100, y+50);
    }
  } else if (mov!=null) {
    //VIDEO
    mov.play();
    if (mov.width>0) {
      pg1=createGraphics(mov.width, mov.height);
      pg2=createGraphics(mov.width, mov.height);
    } else {
      pg1=createGraphics(640, 360);
      pg2=createGraphics(640, 360);
    }
    //canvas 1 video original
    pg1.beginDraw();
    pg1.image(mov, 0, 0);
    pg1.endDraw();
    image(pg1, 50, 50, 640, 360);
    //botones
    float widthB=640/4;
    gs = new Button("GS", 640+100, 25, widthB, 20);
    c1 = new Button("C1", 640+100+widthB, 25, widthB, 20);
    c2 = new Button("C2", 640+100+widthB+widthB, 25, widthB, 20);
    c3 = new Button("C3", 640+100+widthB+widthB+widthB, 25, widthB, 20);
    quitar = new Button("Quitar", 640+100+widthB+widthB+widthB, 25, widthB, 20);
    gs.Draw();
    c1.Draw();
    c2.Draw();
    c3.Draw();
    quitar.Draw();
    //Todo segmentado
    min.setPosition(640+100,50+360+5);
    max.setPosition(640+100+110,50+360+5);
    s = new Button("Seg", 640+100+100+120+100, 50+360+6, widthB, 30);
    s.Draw();
    //canvas 2
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
      //convolucion 1
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
      //convolucion 2
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
      //convolucion 3
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

    //histograma
    int[] hist = new int[256];

    // Calculate the histogram
    for (int i = 0; i < pg2.width; i++) {
      for (int j = 0; j < pg2.height; j++) {
        int bright = int(brightness(pg2.get(i, j)));
        hist[bright]++;
        if(bright < RangoMin || bright > RangoMax){
          int loc = i + j*pg2.width;
          color c = color(0);
          pg2.pixels[loc] = c;
        }
      }
    }    
    pg2.updatePixels();   
    pg2.textSize(map(3,0,100,0,mov.width));
    //frame actual
    pg2.text(getFrame() + " / " + (getLength() - 1), map(10,0,640,0,mov.width), map(30,0,640,0,mov.width));
    //frames por segundo
    pg2.text(this.frameRate, mov.width-map(50,0,640,0,mov.width), map(30,0,640,0,mov.width));
    pg2.endDraw(); 
    image(pg2, 640+100, 50,640,360);

    int histMax = max(hist);
    stroke(255);
    // Draw half of the histogram (skip every second value)
    for (int i = 0; i < 640; i += 2) {
      stroke(255);
      // Map i (from 0..mov.width) to a location in the histogram (0..255)
      int which = int(map(i, 0, 640, 0, 255));
      if(which >= RangoMin && which <= RangoMax){
        stroke(255,0,0);
      }
      // Convert the histogram value to a location between 
      // the bottom and the top of the picture
      int y = int(map(hist[which], 0, histMax, 360, 0));
      line(i+640+100,360+50, i+640+100, y+50);
    }
  }
  stroke(255);
}

void movieEvent(Movie m) {
  m.read();
}

int getLength() {
  return int(mov.duration() * mov.frameRate);
}

int getFrame() {    
  //return ceil(mov.time() * 30) - 1;
  return ceil(mov.time() * mov.frameRate) - 1;
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
//sleccion de archivo
void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
    exit();
  } else {
    //videos UNICAMENTE formato MP4 Y MOV
    if (selection.getAbsolutePath().contains(".mp4")||selection.getAbsolutePath().contains(".mov")) {
      mov = new Movie(this, selection.getAbsolutePath());
      //360 sera la resolucion de los canvas para video
      //Modificacion tamaño de la ventana
      surface.setSize(640*2 +150, 360+100);
    } else {
      //Imagenes
      img=  loadImage(selection.getAbsolutePath());
      //Modificacion tamaño de la ventana
      surface.setSize((img.width*2)+150, img.height+120);
    }
  }
}
//Funcion pulsacion de los botones
void mousePressed()
{
  if (quitar.MouseIsOver()) {
    greyscale=false;
    conv1=false;
    conv2=false;
    conv3=false;
    RangoMin = 0;
    RangoMax = 255;
    println("Sin efectos");
  }else if (gs.MouseIsOver()) {
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
  }else if (s.MouseIsOver()) {
    if(!isNumeric(min.getText()) || !isNumeric(max.getText())){
      println("Solo ingrese numeros!!");
      return;
    }
    if(min.getText().equals("") || max.getText().equals("")){
      println("Ingrese el rango!!");
      return;
    }
    if(parseInt(min.getText()) > parseInt(max.getText())){
      println("Ingrese un rango valido!!");
      return;
    }
    RangoMin = parseInt(min.getText());
    RangoMax = parseInt(max.getText());
    println("Segmentar entre rango ["+RangoMin+","+RangoMax+"]");
  }
  //println(greyscale+","+conv1+","+conv2+","+conv3);
}
public static boolean isNumeric(String str) { 
  try {  
    Double.parseDouble(str);  
    return true;
  } catch(NumberFormatException e){  
    return false;  
  }  
}
//Clase botones : http://blog.startingelectronics.com/a-simple-button-for-processing-language-code/
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
