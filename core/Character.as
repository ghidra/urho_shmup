#include "Scripts/shmup/core/Pawn.as"
#include "Scripts/shmup/weapons/Weapon.as"

//class Character : InputPlayer{
shared class Character:Pawn{
  int temp;
  Character(){
    temp=1;
  }

  void FixedUpdate(float timeStep){
    float my_y = node.position.y;
    if(my_y<0){
      RigidBody@ body_ = node.GetComponent("RigidBody");
      body_.linearVelocity =body_.linearVelocity*Vector3(1.0f,0.0f,1.0f);
      node.position=Vector3(node.position.x,0.0f,node.position.z);
    }
  }

}
