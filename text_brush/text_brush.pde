//拖动鼠标写字

String txt;  //超长字符串，所有内容拼合在这里
PFont font;

int index;

PVector prev;
PVector now;

void setup() {
  size(1920, 1080);

  String[]lines=loadStrings("过秦论.txt");//载入所有内容到String 的数组里

  txt="";
  for (int i=0; i<lines.length; i++) {
    txt+=lines[i];  //所有内容拼接在一起
  }
  txt=trim(txt);    //去除内容中多余的空格


  font=createFont("MSYH.TTC", 8);
  textFont(font);


  println(txt);

  index=0;

  now=new PVector(0, 0);  //初始化当前鼠标位置和上一帧鼠标位置
  prev=new PVector();

  background(0);

}

void draw() {

  prev=now.copy();
  now.set(mouseX, mouseY);
  fill(255);

  if (mousePressed){    //按下鼠标的时候，写字
    renderText(prev, now);
  }
}


void renderText(PVector start, PVector end) {  //在给定的两个位置之间写字
  PVector pos=start.copy();  //"光标"位置
  PVector dir=PVector.sub(end, start);

              //获取下一个要显示的字符的宽度。汉字是宽高相同的方块字，这一步没必要；
              //但是英文字母，高度相同时宽度未必相同，比如 i 和 w，这一步就有必要。
  float txtWd=textWidth(txt.charAt(index));  

  while (PVector.dist(pos, end)>txtWd) {  //用 while 循环把光标从起点挪到终点。
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(dir.heading());
    text(txt.charAt(index), 0, 0);

    dir.normalize();
    dir.mult(txtWd);
    pos.add(dir);
    
    index++;
    if (index==txt.length())index=0;
    txtWd=textWidth(txt.charAt(index));
    popMatrix();
  }
}
