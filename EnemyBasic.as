#include "Scripts/outlyer/Pawn.as"
#include "Scripts/outlyer/ControllerEnemyBasic.as"

class EnemyBasic{

  ControllerEnemyBasic@ controller_;

  //-------------from old pawn
  Node@ node_;
  Scene@ scene_;
  Node@ enemytarget_;//this is a target that we might want to aim at
  RigidBody@ body_;
  //----------------------------

  EnemyBasic(Scene@ scene){

    //super(scene,"EnemyBasic");
    //---------------from old pawn
    scene_ = scene;

    node_ = scene_.CreateChild("Character");
    //_node_name = node_name;

    StaticModel@ coneObject = node_.CreateComponent("StaticModel");
    coneObject.model = cache.GetResource("Model", "Models/Cone.mdl");
    coneObject.material = cache.GetResource("Material", "Materials/StoneTiled.xml");
    //---------------------------

    body_ = node_.CreateComponent("RigidBody");
    body_.mass = 0.25f;
    body_.friction = 0.75f;
    body_.linearDamping = 0.6f;
    body_.useGravity = false;
    CollisionShape@ shape = node_.CreateComponent("CollisionShape");
    shape.SetBox(Vector3(1.0f, 1.0f, 1.0f));
    //push_object();

    controller_ = ControllerEnemyBasic(scene_,node_);
  }

  //override
  void set_enemytarget(Node@ target){
    enemytarget_ = target;
    controller_.set_enemytarget(target);
  }

  //-------from old pawn
  void set_position(Vector3 pos){
    node_.position = pos;
  }

  /*void set_enemytarget(Node@ target){
    enemytarget_ = target;
  }*/
  //----------------------

}
