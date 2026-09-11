void process_enemy() {
  String data = player.client.readString();
  String[] data_array = data.split( "|");
  for (int i = 0; i < data_array.length-1; i++) {
    String str[] = data_array[i].split(",");
    if (int(str[0]) == player.id) continue;
      println(str[0] +","+str[1]+","+str[2]);
      push();
      fill(255, 0, 0);
      translate(float(str[0]), float(str[1]), float(str[2]));
      rotateY(-radians(float(str[3])));
      box(player.w, player.h, player.d);
      pop();
    }
  }
