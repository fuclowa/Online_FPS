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
  player = new Player(new PVector(0, -200, 0), 50, 150, 50, 0, 0, new Client(this, "192.168.0.18", 5204));
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
}

void draw() {
  main_process();
}

void main_process() {
  background(0);
  process_player();
  process_camera();
  if (player.client.available() > 0) {
    process_enemy();
  }
  process_enemy_2();
  process_Map_objects();
  println(player.id);
}

boolean click;
void mousePressed() {
  click = true;
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
