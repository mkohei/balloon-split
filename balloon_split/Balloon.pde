class Balloon {
  
  final static int GOAL_CNT = 10;
  final static int START_CNT = -50;
   
  float x, y;
  float rx, ry;
  color c;
  
  int cnt;
  
  Balloon(float _x, float _y, float _rx, float _ry, color _c) {
    this.x = _x;
    this.y = _y;
    this.rx = _rx;
    this.ry = _ry;
    this.c = _c;
    
    //this.cnt = 0;
    this.cnt = START_CNT;
  }
  
  void draw() {
    noStroke();
    fill(this.c);
    
    if (cnt<0) cnt++;
    if (cnt<=0) {
      //ellipse(this.x, this.y, this.rx, this.ry);
      float ratio = ((float)cnt/(float)START_CNT);
      float _rx = (1-ratio) * this.rx;
      fill(red(this.c), green(this.c), blue(this.c), 100*(1-ratio));
      ellipse(this.x, this.y, _rx, _rx);
    } else if (cnt <= GOAL_CNT) {
      float da = PI / 10;
      float l = rx+cnt*5;
      float r = rx/(1+((float)cnt/(float)GOAL_CNT)*6);
      for (int i=0; i<20; i++) {
        ellipse(x+l*cos(i*da), y+l*sin(i*da), r, r);
      }
      cnt++;
    } else {
      // dead
    }
  }
  
  void trig() {
    if (cnt==0) cnt = 1;
  }
  
  boolean isIn(float x, float y) {
    return pow(this.x-x,2)+pow(this.y-y,2) <= pow(this.rx/2,2);
  }
  
  boolean dead() {
    return cnt >= GOAL_CNT;
  }
}