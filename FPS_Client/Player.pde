class Player {
  PVector pos;
  float w, h, d;
  float speed;
  PVector v;
  float yaw, pitch;
  boolean ground;
  int id;
  Client client;

  Player(PVector pos, float w, float h, float d, float yaw, float pitch, Client client) {
    id = -1;
    this.pos = pos;
    this.w = w;
    this.h = h;
    this.d = d;
    this.yaw = yaw;
    this.pitch = pitch;
    this.client = client;
    speed = 5;
    this.v = new PVector(0, 0, 0);
  }

  void update() {
    move();
    if (player.client.available() > 0 && id == -1) {
      String data = client.readString();
      String[] data_array = split(trim(data), "|");
      if (data_array[0].equals("ID")) {
        id = int(data_array[1]);
      }
    }
  }

  void move() {
    v.add(PVector.mult(key_control(), speed));
    v.x = constrain(v.x, -5, 5);
    v.z = constrain(v.z, -5, 5);
    if (ground && keySPACE) {
      v.y = -20;
    }
    v.y += 1;
    pos.x += v.x;
    if (collision()) {
      pos.x -= v.x;
      v.x = 0;
    }
    pos.z += v.z;
    if (collision()) {
      pos.z -= v.z;
      v.z = 0;
    }
    pos.y += v.y;
    if (collision()) {
      ground = true;
      pos.y -= v.y;
      v.y = 0;
    } else {
      ground = false;
    }
    v.x = lerp(v.x, 0, 0.2);
    v.z = lerp(v.z, 0, 0.2);
  }

  void display() {
    push();
    fill(0, 255, 0);
    translate(pos.x, pos.y, pos.z);
    rotateY(-radians(yaw));
    box(w, h, d);
    pop();
  }

  void send_data() {
    client.write("Pos" + "|" + pos + "|" + yaw);
    //println("Pos" + "|" + pos + "|" + yaw);
  }

  boolean collision() {
    for (Map_object map_object : map_objects) {
      if (
        pos.x + w/2 >= map_object.x - map_object.w/2 &&
        pos.x - w/2 <= map_object.x + map_object.w/2 &&

        pos.y + h/2 >= map_object.y - map_object.h/2 &&
        pos.y - h/2 <= map_object.y + map_object.h/2 &&

        pos.z + d/2 >= map_object.z - map_object.d/2 &&
        pos.z - d/2 <= map_object.z + map_object.d/2
        ) {
        return true;
      }
    }
    return false;
  }
}

void process_player() {
  player.update();
  player.display();
  if (frameCount % 2 == 0) {
    player.send_data();
  }
}


PVector key_control() {
  PVector dir = new PVector();

  if (keyW) {
    dir.x += cos(radians(player.yaw));
    dir.z += sin(radians(player.yaw));
  }
  if (keyS) {
    dir.x -= cos(radians(player.yaw));
    dir.z -= sin(radians(player.yaw));
  }
  if (keyD) {
    dir.x += cos(radians(player.yaw + 90));
    dir.z += sin(radians(player.yaw + 90));
  }
  if (keyA) {
    dir.x += cos(radians(player.yaw - 90));
    dir.z += sin(radians(player.yaw - 90));
  }

  if (dir.magSq() > 0) {
    dir.normalize();
  }

  return dir;
}
