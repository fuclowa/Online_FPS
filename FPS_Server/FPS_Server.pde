import processing.net.*;

Server server;
int id = -1;

ArrayList<Player> players;

void setup() {
  server = new Server(this, 5204);
  players = new ArrayList<Player>();
}

String recieveBuffer = "";
void draw() {
  background(255);

  Client client;

  while ((client = server.available()) != null) {
    int index = find_player(client);
    if (index == -1) {
      id ++;
      players.add(new Player(client, id));
      client.write("ID|"+id+":");
      println("ID|"+id);
      index = players.size() -1;
    }

    recieveBuffer += client.readString();
    println(recieveBuffer);
    while (recieveBuffer.indexOf(":") != -1) {

      int index2 = recieveBuffer.indexOf(':');
      String message = recieveBuffer.substring(0, index2);
      recieveBuffer = recieveBuffer.substring(index2 + 1);
      String[] data_array = message.split("\\|");
      
      if (data_array[0].equals("Pos")) {
        String[] str = data_array[1].split(",");
        PVector pos = new PVector(
          float(str[0]),
          float(str[1]),
          float(str[2])
          );
        players.get(index).yaw = float(str[3]);
        players.get(index).pos = pos;
      }
      if (data_array[0].equals("Hit")) {
        players.get(find_player_by_id(int(data_array[1]))).client.write("Hit" + ":");
      }
    }
  }

  String data_to_send = "";
  for (int i = 0; i < players.size(); i++) {
    Player p = players.get(i);
    if (!data_to_send.equals("")) {
      data_to_send += "|";
    }
    data_to_send += p.id + "," + p.pos.x + "," + p.pos.y + "," + p.pos.z + "," + p.yaw;
  }
  if (frameCount%2 == 0) {
    if (!data_to_send.equals(""))server.write("Players|"+data_to_send+":");
    //println("Players|"+data_to_send+":");
  }
  //view_players();
  fill(0);
}

int find_player(Client client) {
  for (int i = 0; i < players.size(); i++) {
    Player p = players.get(i);
    if (p.client == client)return i;
  }
  return -1;
}

int find_player_by_id(int id) {
  for (int i = 0; i < players.size(); i++) {
    Player p = players.get(i);
    if (p.id == id)return i;
  }
  return -1;
}

void view_players() {
  for (int i = 0; i < players.size(); i++) {
    Player p = players.get(i);
    println(p.id+" "+p.pos);
  }
}
