class Controller{

  Node@ node_;//the node we are controlling
  Scene@ scene_;//the scene
  Node@ camera_node_;//the camera node

  float speed_ = 20.0f;
  float sensitivity_ = 0.1f;

  Controller(Scene@ scene, Node@ node){
    scene_ = scene;
    node_ = node;
  }
  void move(Vector3 direction, float timeStep){
    if(node_ is null)
      return;
    node_.Translate(direction*speed_*timeStep);
  }
  void move_mouse(IntVector2 mousemove){
    if(camera_node_ is null)
      return;
  }
  void left_mouse(){
    if(node_ is null)
      return;
  }
  //----
  void set_cameranode(Node@ cameranode){
    camera_node_ = cameranode;
  }
}
