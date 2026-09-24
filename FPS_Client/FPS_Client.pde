//IDがうまく割り当てられない
//サーバー側のデータがうまく更新できていない理由にもつながる

{
  System.setProperty("sun.java2d.uiScale", "1.0");
}

import processing.net.*;
import java.awt.Robot;
import com.jogamp.newt.opengl.GLWindow;

GLWindow window;
Robot robot;
Player player;
ArrayList<Map_object> map_objects ;
ArrayList<Enemy> enemies ;

void settings() {
  size(1920, 1080, P3D);
}

void setup() {
  player = new Player(new PVector(0, -200, 0), 50, 150, 50, 0, 0, new Client(this, "172.23.13.217", 5204));
  map_objects = new ArrayList<Map_object>();
  enemies = new ArrayList<Enemy>();
  window = (GLWindow) surface.getNative();

  add_map_objects();

  perspective(PI / 3.0, (float) width / height, 1, 10000);

  try {
    robot = new Robot();
  }
  catch (Exception e) {
    e.printStackTrace();
  }

  noCursor();
}

void draw() {
  main_process();
  //view_enemies();
  debug();
  hint(DISABLE_DEPTH_TEST);
  push();
  camera();
  draw_GUI();
  debug_2();
  pop();
  hint(ENABLE_DEPTH_TEST);
}

String receiveBuffer;
void main_process() {
  background(0);
  process_player();
  process_camera();
  while (player.client.available() > 0) {
    //String data_array[] = player.client.readString().split("\\|");
    //if (data_array[0].equals("Players"))process_enemy(data_array);
    //if (data_array[0].equals("ID")&&player.id == -1)player.recieve_id(data_array);
    //if (data_array[0].equals("Hit"))player.hit(data_array);
    if (player.client.available() > 0) {
      receiveBuffer += player.client.readString();
    }

    while (receiveBuffer.indexOf('\n') != -1) {

      int index = receiveBuffer.indexOf('\n');

      String message = receiveBuffer.substring(0, index);
      receiveBuffer = receiveBuffer.substring(index + 1);

      String[] data_array = message.split("\\|");

      if (data_array[0].equals("ID") && player.id == -1) {
        player.recieve_id(data_array);
      } else if (data_array[0].equals("Players")) {
        process_enemy(data_array);
      } else if (data_array[0].equals("Hit")) {
        player.hit(data_array);
      }
    }
  }
  process_enemy_2();
  process_Map_objects();
  //println(player.id);
}

void debug() {
  float centerX = cameraX + cos(radians(player.yaw)) * cos(radians(player.pitch)) * 100;
  float centerZ = cameraZ + sin(radians(player.yaw)) * cos(radians(player.pitch)) * 100;
  float centerY = cameraY + sin(radians(player.pitch)) * 100;
  line(cameraX,cameraY,cameraZ,centerX,centerY,centerZ);
}

void debug_2(){
  text(player.yaw,100,100);
}

void draw_GUI() {
  line(width/2 - 10, height/2, width/2 + 10, height/2);
  line(width/2, height/2 - 10, width/2, height/2 + 10);
}
boolean click;
void mousePressed() {
  click = true;
  player.shoot();
}
void mouseReleased() {
  click = false;
}

boolean keyW, keyS, keyA, keyD, keySPACE;
void keyPressed() {
  if (key == 'w') {
    keyW = true;
  }
  if (key == 's') {
    keyS = true;
  }
  if (key == 'a') {
    keyA = true;
  }
  if (key == 'd') {
    keyD = true;
  }
  if (key == ' ') {
    keySPACE = true;
  }
}
void keyReleased() {
  if (key == 'w') {
    keyW = false;
  }
  if (key == 's') {
    keyS = false;
  }
  if (key == 'a') {
    keyA = false;
  }
  if (key == 'd') {
    keyD = false;
  }
  if (key == ' ') {
    keySPACE = false;
  }
}
