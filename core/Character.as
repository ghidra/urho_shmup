#include "Scripts/shmup/core/Pawn.as"
#include "Scripts/shmup/weapons/Weapon.as"

//class Character : InputPlayer{
shared class Character:Pawn{
  Vector2 bounds_ = Vector2(-1.0f,-1.0f);
  //Character(){}

  void FixedUpdate(float timeStep){
    RigidBody@ body_ = node.GetComponent("RigidBody");
    //clamp the y to stay on 0 plane
    if(node.position.y<0){

      body_.linearVelocity =body_.linearVelocity*Vector3(1.0f,0.0f,1.0f);
      node.position=Vector3(node.position.x,0.0f,node.position.z);
    }
    //clamp x and z planes if we have set bounds
    if(Abs(node.position.x)>bounds_.x){
      body_.linearVelocity =body_.linearVelocity*Vector3(0.0f,0.0f,1.0f);
      float cx = bounds_.x;
      if(node.position.x<0)
        cx = cx*-1;
      node.position=Vector3(cx,0.0f,node.position.z);
    }
    if(Abs(node.position.z)>bounds_.y){
      body_.linearVelocity =body_.linearVelocity*Vector3(1.0f,0.0f,0.0f);
      float cz = bounds_.y;
      if(node.position.z<0)
        cz = cz*-1;
      node.position=Vector3(node.position.x,0.0f,cz);
    }
  }

  void set_bounds(const Vector2 b){
    bounds_ = b;
  }

}
