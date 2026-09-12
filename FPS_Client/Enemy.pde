void process_enemy() {//サーバーからの情報を処理
  String data = player.client.readString();
  println(data);
  String[] data_array = data.split("\\|");
  if (data_array[0].equals("Players")) {
    for (int i = 1; i < data_array.length; i++) {
      String str[] = data_array[i].split(",");
      if (int(str[0]) == player.id) continue;
      if(find_enemies(int(str[0])) == -1){
        enemies.add(new Enemy(int(str[0]),new PVector(float(str[1]), float(str[2]), float(str[3]))));
      }else{
        int index = find_enemies(int(str[0]));
        Enemy e = enemies.get(index);
        e.pos = new PVector(float(str[1]), float(str[2]), float(str[3]));
      }
    }
  }
}

void process_enemy_2(){//描画などの処理
    for (int i = 0; i < enemies.size(); i++) {
    Enemy e = enemies.get(i);
    e.display();
  }
}

class Enemy {
  int id;
  PVector pos;
  float yaw;
  Enemy(int id,PVector pos) {
    this.id = id;
    this.pos = pos;
  }
  void display() {
    push();
    fill(255, 0, 0);
    translate(pos.x, pos.y, pos.z);
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
