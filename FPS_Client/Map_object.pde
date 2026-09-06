class Map_object {
  float x, y, z, d, w, h;
  Map_object(float x, float y, float z, float w, float h, float d) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.d = d;
    this.w = w;
    this.h = h;
  }
  void display(){
    push();
    translate(x,y,z);
    box(w,h,d);
    pop();
  }
}

void process_Map_objects() {
  for (int i = 0; i < map_objects.size(); i++) {
    Map_object map_object = map_objects.get(i);
    map_object.display();
  }
}

void add_map_objects(){
  map_objects.add(new Map_object(0,50,0,10000,100,10000));
}
