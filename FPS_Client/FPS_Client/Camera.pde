float cameraX, cameraY, cameraZ;
void process_camera() {
  cameraX = player.pos.x + cos(radians(player.yaw)) * 50;
  cameraZ = player.pos.z + sin(radians(player.yaw)) * 50;
  cameraY = player.pos.y - 50;
  set_mouse();
  set_angle();
  set_camera();
}
void set_camera() {
  float centerX = cameraX + cos(radians(player.yaw)) * cos(radians(player.pitch));
  float centerZ = cameraZ + sin(radians(player.yaw)) * cos(radians(player.pitch));
  float centerY = cameraY + sin(radians(player.pitch)) * 1;
  camera(cameraX, cameraY, cameraZ, centerX, centerY, centerZ, 0, 1, 0);
}

float dcx;
float dcy;
void set_mouse() {
  int windowX = window.getX();
  int windowY = window.getY();
  int cx = width / 2;
  int cy = height / 2;

  dcx = mouseX - cx;
  dcy = mouseY - cy;

  robot.mouseMove(
    windowX + cx,
    windowY + cy
    );
}

void set_angle() {
  player.yaw += dcx/6.0;
  player.pitch += dcy / 6.0;
  player.pitch = constrain(player.pitch, -89, 89);
}
