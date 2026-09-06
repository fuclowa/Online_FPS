import processing.net.*;

Server server;

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
      players.add(new Player(client));
      index = players.size() -1;
    }
    String data = client.readString();
    if (data != null) {
      String[] data_array = split(trim(data), "|");
      if (data_array[0].equals("Pos")) {
        data_array[1] = data_array[1].replace("[", "").replace("]", "").trim();
        String[] str = data_array[1].split(",");

        PVector pos = new PVector(
          float(str[0]),
          float(str[1]),
          float(str[2])
          );
        players.get(index).pos = pos;
      }
      //println("received"+"  "+client);
      server.write(data);
    }
  }

  view_players();
  fill(0);
}

int find_player(Client client) {
  for (int i = 0; i < players.size() - 1; i++) {
    Player p = players.get(i);
    if (p.client == client)return i;
  }
  return -1;
}

void view_players() {
  for (int i = 0; i < players.size() - 1; i++) {
    Player p = players.get(i);
    println(p.client+" "+p.pos);
  }
}
