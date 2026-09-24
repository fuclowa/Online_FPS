void process_enemy(String[] data_array) {//サーバーからの情報を処理
  for (int i = 1; i < data_array.length; i++) {
    String str[] = data_array[i].split(",");
    if (int(str[0]) == player.id) continue;
    if (player.id != -1) {
      if (find_enemies(int(str[0])) == -1) {
        enemies.add(new Enemy(int(str[0]), new PVector(float(str[1]), float(str[2]), float(str[3])), float(str[4])));
      } else {
        int index = find_enemies(int(str[0]));
        Enemy e = enemies.get(index);
        e.pos = new PVector(float(str[1]), float(str[2]), float(str[3]));
        e.yaw = float(str[4]);
      }
    }
  }
}

void process_enemy_2() {//描画などの処理
  for (int i = 0; i < enemies.size(); i++) {
    Enemy e = enemies.get(i);
    e.display();
  }
}

class Enemy {
  int id;
  PVector pos;
  float yaw;
  Enemy(int id, PVector pos, float yaw) {
    this.id = id;
    this.pos = pos;
    this.yaw = yaw;
  }
  void display() {
    push();
    fill(255, 0, 0);
    translate(pos.x - cos(radians(yaw))*40, pos.y, pos.z - sin(radians(yaw)) * 40);
    rotateY(-radians(yaw));
    box(player.w, player.h, player.d);
    pop();
  }
}

int find_enemies(int id) {
  for (int i = 0; i < enemies.size(); i++) {
    Enemy e = enemies.get(i);
    if (e.id == id)return i;
  }
  return -1;
}

void view_enemies() {
  for (int i = 0; i < enemies.size(); i++) {
    Enemy e = enemies.get(i);
    println(e.id+" "+e.pos);
  }
}
