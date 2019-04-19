  
import processing.video.*;
Movie mov;

void setup() {
  size(1000, 1000);
  mov = new Movie(this, "totoro.mp4");
  surface.setResizable(true);
  
}

void draw() {
  background(0);
  image(mov, 0, 0, mov.width, mov.height);
  surface.setSize(mov.width, mov.height);
  fill(255);
  mov.play();
  text(getFrame() + " / " + (getLength() - 1), 10, 30);
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
