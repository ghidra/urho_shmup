//class Character : ScriptObject{
//#include "Scripts/outlyer/InputPlayer.as"
#include "Scripts/outlyer/Pawn.as"
#include "Scripts/outlyer/ControllerPlayer.as"

//class Character : InputPlayer{
class Character:Pawn{

  RigidBody@ body_;

  ControllerPlayer@ controller_;

  Character(Scene@ scene){

    super(scene,"Character");

    body_ = node_.CreateComponent("RigidBody");
    body_.mass = 0.25f;
    body_.friction = 0.75f;
    body_.linearDamping = 0.6f;
    body_.useGravity = false;

    body_.mass=10.0f;//heavy mass makes it so stuff doesnt effect it as much
    //body_.angularDamping = 1000.0f;
    body_.angularFactor = Vector3(0.0f, 0.0f, 0.0f);
    body_.collisionEventMode = COLLISION_ALWAYS;

    CollisionShape@ shape = node_.CreateComponent("CollisionShape");
    shape.SetBox(Vector3(1.0f, 1.0f, 1.0f));
    //push_object();

    controller_ = ControllerPlayer(scene_,node_);
    //_controller = cast<Controller>(_node.CreateScriptObject(scriptFile, "Controller"));
    //_controller = controller;
    Character_Script@ character_script_ = cast<Character_Script>(node_.CreateScriptObject(scriptFile, "Character_Script"));
    character_script_.set_parameters(this);
  }

}
class Character_Script:ScriptObject{
  Character@ parent_;

  void set_parameters(Character@ parent){
    parent_ = parent;
  }

  void Update(float timeStep){
    float my_y = node.position.y;
    if(my_y<0){
      parent_.body_.linearVelocity = parent_.body_.linearVelocity*Vector3(1.0f,0.0f,1.0f);
      node.position=Vector3(node.position.x,0.0f,node.position.z);
    }
    //node.rotation=Quaternion(0.0f,0.0f,0.0f,1.0f);
  }
}
