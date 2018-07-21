import processing.video.*;

final int NUM_BAL = 20;
final int RESAMP = 5;

Capture camera;
PImage bg, show, cur;

Balloon[] bals;

void setup(){
  size(480, 360);
  camera = new Capture(this, width, height, 12);
  camera.start();
  
  //bg2 = new int[width*height/2];
  bg = createImage(width, height, ARGB);
  show = createImage(width, height, ARGB);
  cur = createImage(width, height, ARGB);
  
  bals = new Balloon[NUM_BAL];
  for (int i=0; i<NUM_BAL; i++) {
    bals[i] = new Balloon( random(width), random(height/2), 100, 100, color( random(100,255), random(100,255), random(100,255), 150));
  }
}


void draw() {
  if (camera.available() == true) {
    camera.read();
  }
  
  scale(-1, 1);
  
  image(camera, -width, 0);
  //show.copy(camera, 0, 0, width, height/2, 0, 0, width, height/2);
  cur = get(0, 0, width, height);
  show.copy(cur, 0, 0, cur.width, cur.height, 0, 0, show.width, show.height); 
  
  
  scale(-1, 1);
  
  if (bg != null) {
    float a1, a2, a3, b1, b2, b3, la, lb;
    for (int y=0; y<height/2; y++) {
      for (int x=0; x<width; x++) {
        int idx = y*width + x;
        a1 = red(cur.pixels[idx])-127;
        a2 = green(cur.pixels[idx])-127;
        a3 = blue(cur.pixels[idx])-127;
        b1 = red(bg.pixels[idx])-127;
        b2 = green(bg.pixels[idx])-127;
        b3 = blue(bg.pixels[idx])-127;
        la = sqrt(pow(a1,2) + pow(a2,2) + pow(a3,2));
        lb = sqrt(pow(b1,2) + pow(b2,2) + pow(b3,2));
        a1 /= la;
        a2 /= la;
        a3 /= la;
        b1 /= lb;
        b2 /= lb;
        b3 /= lb;
        float dot = a1*b1 + a2*b2 + a3*b3;
        
        float TH = 0.5;
        if (dot < TH) {
          //show.pixels[idx] = color(255,0,0);
          show.pixels[idx] = color(0, 0, 255);
          
          for (int i=0; i<NUM_BAL; i++) {
            if (bals[i].isIn(x,y) == true) bals[i].trig();
          }
        }
      }
    }
  }
  
  // draw background (camera)
  image(show, 0, 0);
  //if (bg != null) image(bg, 0, height/2);
  //if (bg2 != null) image(bg2, 0, height/2);
  
  
  // draw balloon & update
  for (int i=0; i<NUM_BAL; i++) {
    if (bals[i].dead() == true)
      bals[i] = new Balloon( random(width), random(height/2), 100, 100, color( random(100,255), random(100,255), random(100,255), 150));
    bals[i].draw();
  }
  
  
  
  // update
  bg.copy(cur, 0, 0, cur.width, cur.height, 0, 0, bg.width, bg.height);
}

/*
void keyPressed() {
  if (key==' ') {
    //bg = get(0, 0, width, height/2);
    bg = createImage(width, height/2, ARGB);
    bg.copy(cur, 0, 0, cur.width, cur.height, 0, 0, bg.width, bg.height);
    //bg2 = camera.pixels; 
  }
}
*/
  


/*
final int LEN = 10;
Balloon[] bals;
int count;

void setup() {
  size(500, 500);
  
  bals = new Balloon[LEN];
  count = 0;
  
  for (int i=0; i<LEN; i++) {
    color c = color(random(255), random(255), random(255));
    bals[i] = new Balloon(random(width), random(height), 100, 100, c);
  }
}

void draw() {
  background(0);
  
  for (int i=0; i<LEN; i++) {
    if (bals[i]==null);
    else {
      if (bals[i].isIn(mouseX, mouseY)) {
        bals[i].trig();
      }
      bals[i].draw();
    }
  }
}

void mouseClicked() {
  bals[count] = new Balloon(mouseX, mouseY, 100, 100, color(255, 0, 0));
}
*/