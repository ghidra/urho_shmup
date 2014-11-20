//OBSOLETE DELETE THIS CLASS


#include "Scripts/shmup/Controller.as"
#include "Scripts/shmup/CameraLogic.as"
#include "Scripts/shmup/ProjectileExploder.as"

class ControllerPlayer : Controller{

  Graph@ graph_;

  ControllerPlayer(Scene@ scene, Node@ node){
    super(scene, node);
  }
  void move(Vector3 direction, float timeStep){
    if(node_ is null)
      return;
    RigidBody@ body_ = node_.GetComponent("RigidBody");
    body_.linearVelocity = body_.linearVelocity+(direction*speed_*timeStep);
  }
  void move_mouse(IntVector2 mousemove){
    if(camera_node_ is null)
      return;
    CameraLogic@ camera_logic_ = cast<CameraLogic>(camera_node_.GetScriptObject("CameraLogic"));
    if(camera_logic_ is null)
      return;
    camera_logic_.move_mouse(mousemove,sensitivity_);
  }
  void left_mouse(){
    if(node_ is null)
      return;
    //here i get to use the location on the grid to determine where to fire my projectile
    Vector3 direction = graph_.hit_-node_.position;
    //direction.Normalize();

    spawn_projectile(node_.position, direction,graph_.hit_);
  }

  //------specific method
  void set_graph(Graph@ graph){
    graph_ = graph;
  }

  //------spawn a projectile
  void spawn_projectile(Vector3 pos, Vector3 dir, Vector3 hit){
    const float OBJECT_VELOCITY = 4.5f;
    ProjectileExploder@ projectile_ = ProjectileExploder(scene_,pos,dir,OBJECT_VELOCITY,hit);
  }
}
