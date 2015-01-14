#include "Scripts/shmup/core/Pawn.as"
//#include "Scripts/shmup/weapons/Weapon.as"

//class Character : InputPlayer{
shared class Character:Pawn{
  Vector2 bounds_ = Vector2(-1.0f,-1.0f);
  Character(){
    //mesh_="Cone";
    mesh_="shmup/spaceship_02_shiponly";
    speed_=20.0f;
  }
  void Start(){
    build_geo(mesh_,material_);
    build_weapon("Weapon");
  }


  //----------------------
  //----------------------

  void FixedUpdate(float timeStep){
    RigidBody@ body_ = node.GetComponent("RigidBody");

    //clamp x and z planes if we have set bounds
    if(bounds_.x>0 && bounds_.y>0){
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
  }

  void set_bounds(const Vector2 b){
    bounds_ = b;
  }

}
