import processing.net.*;

Server server;
int id = -1;

ArrayList<Player> players;

void setup() {
  server = new Server(this, 5204);
  players = new ArrayList<Player>();
}

void draw() {
  background(255);

  Client client;

  while ((client = server.available()) != null) {
    int index = find_player(client);
    if (index == -1) {
      id ++;
      players.add(new Player(client, id));
      client.write("ID|"+id);
      index = players.size() -1;
    }
    String data = client.readString();
    if (data != null) {
      String[] data_array = split(trim(data), "|");
      if (data_array[0].equals("Pos")) {
        data_array[1] = data_array[1].replace("[", "").replace("]", "");
        String[] str = data_array[1].split(",");

        PVector pos = new PVector(
          float(str[0]),
          float(str[1]),
          float(str[2])
          );
        players.get(index).yaw = float(data_array[2]);
        players.get(index).pos = pos;
      }
      String data_to_send = "";
      for (int i = 0; i < players.size(); i++) {
        Player p = players.get(i);
        if (p.client == client)continue;
        if (i == 0)data_to_send = p.id +"," +p.pos.x + "," + p.pos.y + "," + p.pos.z + "," + p.yaw;
        else data_to_send += "|" + p.id +"," + p.pos.x + "," + p.pos.y + "," + p.pos.z + "," + p.yaw;
      }
      if (frameCount % 2 == 0) {
        client.write("Players|"+data_to_send);
      }
    }
  }

  view_players();
  fill(0);
}

int find_player(Client client) {
  for (int i = 0; i < players.size(); i++) {
    Player p = players.get(i);
    if (p.client == client)return i;
  }
  return -1;
}

void view_players() {
  for (int i = 0; i < players.size(); i++) {
    Player p = players.get(i);
    println(p.id+" "+p.pos);
  }
}
