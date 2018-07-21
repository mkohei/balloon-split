import processing.video.*;
import ddf.minim.*;

final int NUM_BAL = 10;
final int RESAMP = 10;

Capture camera;
Minim minim;
AudioSample split;

PImage bg, show, cur, resize, resbg;

Balloon[] bals;

void setup(){
  //size(480, 360);
  size(640, 480);
  String[] cams = Capture.list();
  for (String str: cams) println(str);
  //camera = new Capture(this, width, height, cams[0]);
  camera = new Capture(this, width, height, 12);
  camera.start();
  
  //bg2 = new int[width*height/2];
  bg = createImage(width, height, ARGB);
  resbg = createImage(width/RESAMP, height/RESAMP, ARGB);
  resize = createImage(width/RESAMP, height/RESAMP, ARGB);
  
  
  show = createImage(width, height, ARGB);
  cur = createImage(width, height, ARGB);
  
  bals = new Balloon[NUM_BAL];
  for (int i=0; i<NUM_BAL; i++) {
    bals[i] = new Balloon( random(width), random(height), 100, 100, color( random(100,255), random(100,255), random(100,255), 150));
  }
  
  // sound
  minim = new Minim(this);
  //split = minim.loadSample("src/bs.mp3", 2048);
  split = minim.loadSample("src/bs2.mp3", 2048);
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
    // resize
    /*
    for (int y=0; y<resize.height; y++) {
      for (int x=0; x<resize.width; x++) {
        
        float r=0, g=0, b=0, N=pow(RESAMP,2);
        for (int dy=0; dy<RESAMP; dy++) {
          for (int dx=0; dx<RESAMP; dx++) {
            r += red  (cur.pixels[ (y+dy)*width + (x+dx) ]);
            g += green(cur.pixels[ (y+dy)*width + (x+dx) ]);
            b += blue (cur.pixels[ (y+dy)*width + (x+dx) ]);
          }
        }
        resize.pixels[y*resize.width + x] = color(r/N, g/N, b/N);
        
      }
    }
    */
    resize.copy(cur, 0, 0, cur.width, cur.height, 0, 0, resize.width, resize.height);
    
    // diff
    float a1, a2, a3, b1, b2, b3, la, lb;
    // resized size
    image(cur, 0, 0);
    noStroke();
    fill(0, 0, 255);
    for (int y=0; y<resize.height; y++) {
      for (int x=0; x<resize.width; x++) {
        int idx = y*resize.width + x;
        a1 = red(resize.pixels[idx])-127;
        a2 = green(resize.pixels[idx])-127;
        a3 = blue(resize.pixels[idx])-127;
        b1 = red(resbg.pixels[idx])-127;
        b2 = green(resbg.pixels[idx])-127;
        b3 = blue(resbg.pixels[idx])-127;
        la = sqrt(pow(a1,2) + pow(a2,2) + pow(a3,2));
        lb = sqrt(pow(b1,2) + pow(b2,2) + pow(b3,2));
        a1 /= la;
        a2 /= la;
        a3 /= la;
        b1 /= lb;
        b2 /= lb;
        b3 /= lb;
        float dot = a1*b1 + a2*b2 + a3*b3;
        
        float TH = 0;
        if (dot < TH) {
          float wx=x*RESAMP+RESAMP/2, wy=y*RESAMP+RESAMP/2;
          ellipse(wx, wy, RESAMP, RESAMP);
          
          for (int i=0; i<NUM_BAL; i++) {
            if (bals[i].isIn(wx,wy) == true) 
              if (bals[i].trig())
                //split.trigger()
                ;
          }
        }
      }
    }
    /*
    // origin(frame) size
    for (int y=0; y<height; y++) {
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
        
        float TH = 0.0;
        TH = -0.8;
        if (dot < TH) {
          //show.pixels[idx] = color(255,0,0);
          show.pixels[idx] = color(0, 0, 255);
          
          for (int i=0; i<NUM_BAL; i++) {
            if (bals[i].isIn(x,y) == true) 
              if (bals[i].trig())
                //split.trigger()
                ;
          }
        }
      }
    }
    */
  }
  
  // draw background (camera)
  //image(show, 0, 0);
  //if (bg != null) image(bg, 0, height/2);
  //if (bg2 != null) image(bg2, 0, height/2);
  
  
  // draw balloon & update
  for (int i=0; i<NUM_BAL; i++) {
    if (bals[i].dead() == true)
      bals[i] = new Balloon( random(width), random(height), 100, 100, color( random(100,255), random(100,255), random(100,255), 150));
    bals[i].draw();
  }
  
  // DEBUG
  //image(resize, 0, 0);
  
  
  
  // update
  bg.copy(cur, 0, 0, cur.width, cur.height, 0, 0, bg.width, bg.height);
  resbg.copy(resize, 0, 0, resize.width, resize.height, 0, 0, resbg.width, resbg.height); 
}


void keyPressed() {
  if (key==' ') {
    //split.trigger();
  }
}

void stop() {
  //
  split.close();
  minim.stop();
  super.stop();
}