
Agent[]agents;

PImage pic;  //底图

void setup() {
  size(1080, 1080);


  pic=loadImage("che.png");

  pic.filter(THRESHOLD, 0.3);
  pic.resize(width, height);

  agents=new Agent[1400];  //屏幕上有1400个Agent

  for (int i=0; i<agents.length; i++) {
    agents[i]=new Agent();
  }


  for (int i=0; i<agents.length; i++) {
    agents[i].drawFullShape();
  }
}




class Agent {

  int num;  //多少个正弦波叠加成一个随机周期波形

  float[]phase;  //正弦波的相位偏移
  float[]freq;  //频率
  float[]amp;    //振幅

  PVector start;  //波的其实位置，小坐标系的原点
  float angle;    //小坐标系的倾斜角度
  float axis_len;  //小坐标系横轴的长度，波的"宽度"
  float gasoline=0;  //汽油数量



  boolean longTail=false;  //汽油消耗方式，决定了Agent 是长尾还是短尾
  
  boolean prev_loc_is_white=true;  //上一个位置是否在白色区，用于"加锁"

  Agent() {
    num=int(random(10, 20));
    phase=new float[num];
    freq=new float[num];
    amp=new float[num];

    for (int i=0; i<num; i++) {  //随机出每个正弦波的参数
      phase[i]=random(1000);
      freq[i]=random(0.0, 0.08);
      amp[i]=random(6, 12);
    }


    start=new PVector(random(width), random(height));
    angle=random(TWO_PI);
    axis_len=random(width/8, width*1.414);


    if (random(1)<0.10) {  //有10%概率是长尾
      longTail=true;
    }
  }


  float get_wave_value(float xpos) {  //算出小坐标系下的 y 值
    float y=0;
    for (int i=0; i<num; i++) {
      y+=sin(phase[i]+xpos*freq[i])*amp[i];
    }
    return y;
  }
  
  PVector get_global_loc(float x, float y) {  //用小坐标系下的 x,y 值换算出全局坐标
    float gx=start.x+cos(angle)*x;
    float gy=start.y+sin(angle)*x;

    gx+=cos(angle-PI/2)*y;
    gy+=sin(angle-PI/2)*y;

    return new PVector(gx, gy);
  }


  void drawFullShape() {  //画 Agent 轨迹

    PVector loc=get_global_loc(0, get_wave_value(0));  //agent 的初始位置
    PVector prev=loc.copy();    //agent 的上一个位置，初始时和 loc 相同

    for (float i=1; i<axis_len; i++) {  //沿着小坐标系横轴，获取曲线上每个位置的坐标

      loc=get_global_loc(i, get_wave_value(i));

      if (loc.x<0 || loc.x>width || loc.y<0 || loc.y>height) {  //如果出了屏幕，则停止绘制
        break;
      }

      float bright=brightness(pic.get(int(loc.x), int(loc.y)));  //获取当前位置的底图颜色

      if (bright==0) {
        if (prev_loc_is_white)gasoline+=50;  //如果刚刚进入黑色区域，则赠送50点能量
        gasoline+=dist(prev.x, prev.y, loc.x, loc.y)*1.;  //在黑色区域每一步都积攒能量
      } else {

        if (gasoline>10 && !longTail) {  //如果能量值大于10，且Agent为短尾类型，则按比例消耗能量
          gasoline*=0.6;
        }
        gasoline-=1*(dist(prev.x, prev.y, loc.x, loc.y));  //普通的每走一步都消耗能量
        gasoline=max(0, gasoline);  //能量值不能为负
      }

      if (gasoline>0) {  
        float wt=sqrt(gasoline)*0.06;  //根据能量值决定线宽
        strokeWeight(wt);
        stroke(40);
        line(prev.x, prev.y, loc.x, loc.y);
      }

      if (bright==0) {    //更新"锁"的状态
        prev_loc_is_white=false;
      } else {
        prev_loc_is_white=true;
      }

      prev=loc.copy();
    }
  }

  
}
