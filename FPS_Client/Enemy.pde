void process_enemy() {
  String data = player.client.readString();
  println(data);
  String[] data_array = data.split("\\|");
  if (data_array[0].equals("Players")) {
        println("processed");
    for (int i = 1; i < data_array.length; i++) {
      String str[] = data_array[i].split(",");
      if (int(str[0]) == player.id) continue;
      println(str[1] +","+str[2]+","+str[3]);
      push();
      fill(255, 0, 0);
      translate(float(str[1]), float(str[2]), float(str[3]));
      rotateY(-radians(float(str[4])));
      box(player.w, player.h, player.d);
      pop();
    }
        println("processed2");
  }
}

//敵の情報をリストで管理し、その値で描画をすることでちかちかする問題を解決する
