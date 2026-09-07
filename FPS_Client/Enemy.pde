void process_enemy() {
  String data = player.client.readString();
  String[] data_array = split(trim(data), "|");
  for (int i = 0; i < data_array.length-1; i++) {
    String pos[] = data_array[i].split(",");
    push();
    fill(255, 0, 0);
    translate(float(pos[0]), float(pos[1]), float(pos[2]));
    rotateY(-radians(float(pos[3])));
    box(player.w, player.h, player.d);
    pop();
  }
}
