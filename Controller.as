class Controller{

  Node@ _node;//the node we are controlling
  Scene@ _scene;//the scene
  Node@ _camera_node;//the camera node

  float _speed = 20.0f;
  float _sensitivity = 0.1f;

  Controller(Scene@ scene, Node@ node){
    _scene = scene;
    _node = node;
  }
  void move(Vector3 direction, float timeStep){
    if(_node is null)
      return;
    _node.Translate(direction*_speed*timeStep);
  }
  void move_mouse(IntVector2 mousemove){
    if(_camera_node is null)
      return;
  }
  void left_mouse(){
    if(_node is null)
      return;
  }
  //----
  void set_cameranode(Node@ cameranode){
    _camera_node = cameranode;
  }
}
