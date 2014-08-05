#include "Scripts/outlyer/Controller.as"
class ControllerEnemyBasic:Controller{

  ControllerEnemyBasic(Scene@ scene, Node@ node){
    super(scene, node);
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
