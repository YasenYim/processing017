
PImage pic;

void setup(){
  size(540,540);
  
  pic=loadImage("bw2.jpg");
  pic.resize(width,height);
  

}

void draw(){
  float factor=map(mouseX,0,width,0,1);  //鼠标水平位置控制阈值
  
  image(pic,0,0);        //先把图片显示在窗口上，
  filter(THRESHOLD,factor);  //再对窗口内容添加滤镜
  
  fill(0,0,255);
  textSize(32);
  text(factor,mouseX,mouseY);
}
