#include "Scripts/outlyer/Controller.as"
#include "Scripts/outlyer/CameraLogic.as"
#include "Scripts/outlyer/Projectile.as"

class ControllerPlayer : Controller{

  Graph@ _graph;

  ControllerPlayer(Scene@ scene, Node@ node){
    super(scene, node);
  }
  void move(Vector3 direction, float timeStep){
    if(_node is null)
      return;
    RigidBody@ _body = _node.GetComponent("RigidBody");
    _body.linearVelocity = _body.linearVelocity+(direction*_speed*timeStep);
  }
  void move_mouse(IntVector2 mousemove){
    if(_camera_node is null)
      return;
    CameraLogic@ _camera_logic = cast<CameraLogic>(_camera_node.GetScriptObject("CameraLogic"));
    if(_camera_logic is null)
      return;
    _camera_logic.move_mouse(mousemove,_sensitivity);
  }
  void left_mouse(){
    if(_node is null)
      return;
    //here i get to use the location on the grid to determine where to fire my projectile
    Vector3 direction = _graph._hit-_node.position;
    //direction.Normalize();

    spawn_projectile(_node.position, direction);
  }

  //------specific method
  void set_graph(Graph@ graph){
    _graph = graph;
  }

  //------spawn a projectile
  void spawn_projectile(Vector3 pos, Vector3 dir){
    const float OBJECT_VELOCITY = 4.5f;
    Projectile@ _projectile = Projectile(_scene,pos,dir,OBJECT_VELOCITY);
  }
}
