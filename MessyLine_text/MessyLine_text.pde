
int num=40;
Agent[]as;

PImage img;
boolean playing=true;

String txt;
PFont font;

void setup() {
  size(1400, 1400);
  colorMode(HSB);

  String[]lines=loadStrings("过秦论.txt");
  println(lines.length);
  txt="";
  for (int i=0; i<lines.length; i++) {
    txt+=lines[i];
  }
  println(txt.length());

  font=createFont("MSYH.TTC", 8);
  textFont(font);



  as=new Agent[num];
  for (int i=0; i<num; i++) {
    as[i]=new Agent();
  }

  img=loadImage("bw2.jpg");

  img.resize(width, height);

  img.filter(THRESHOLD, 0.3);


  background(255);
}

void draw() {
  for (int i=0; i<num; i++) {
    as[i].update();
    as[i].display();
  }
}

void mousePressed() {
  playing=!playing;
  if (playing) {
    loop();
  } else {
    noLoop();
  }
}

void keyPressed() {
  if (key==' ') {
    saveFrame(""+frameCount+".jpg");
  }
  if (key=='r') {
    background(255);
  }
}

class Agent {
  PVector center;
  PVector spd;
  PVector loc;
  PVector prev;
  float angle=random(TWO_PI);
  float angleSpd=random(0.05, 0.1);

  float rad=random(60, 280);
  color c=color(random(255), random(50, 120), random(150, 200));
  //color c=color(40);
  int energy;

  float angleOffset=0;
  char charac;
  int charIndex;
  boolean clockwise=true;


  Agent() {
    center=new PVector(random(width), random(height));
    if (random(1)<0.5)angleSpd*=-1;

    spd=PVector.random2D();
    spd.mult(random(0.5, 3));
    loc=new PVector();
    loc.set(center.x+cos(angle)*rad, center.y+sin(angle)*rad);
    prev=loc.copy();

    charIndex=0;
    charac=txt.charAt(charIndex);

    if (random(1)<0.5) {
      clockwise=false;
    }
  }

  void update() {
    center.add(spd);

    angle+=angleSpd;

    loc.set(center.x+cos(angle)*rad, center.y+sin(angle)*rad);

    if (loc.x<0 || loc.x>width || loc.y<0 || loc.y>height) {
      center.set(random(width), random(height));
      loc.set(center.x+cos(angle)*rad, center.y+sin(angle)*rad);
      prev=loc.copy();
      energy=0;
    }
  }

  void display() {
    if (brightness(img.get(int(loc.x), int(loc.y)))==255) {
      energy-=3;
      energy=max(energy, 0);
    } else {
      energy++;
    }

    if (energy>0) {
      fill(c, 255);

      renderText(prev, loc);
    }     
    prev=loc.copy();
  }



  void renderText(PVector start, PVector end) {
    PVector pos=start.copy();
    PVector dir=PVector.sub(end, start);  //用当前位置和上一帧位置，来算出运动方向


    float txtWd=textWidth(txt.charAt(charIndex));

    while (PVector.dist(pos, end)>txtWd) {  //把上一帧位置到当前位置的连线上，填满文字
      pushMatrix();
      translate(pos.x, pos.y);
      rotate(dir.heading());
      text(txt.charAt(charIndex), 0, 0);

      dir.normalize();
      dir.mult(txtWd);
      pos.add(dir);

      charIndex++;
      if (charIndex==txt.length())charIndex=0;
      txtWd=textWidth(txt.charAt(charIndex));
      popMatrix();
    }
  }
}
