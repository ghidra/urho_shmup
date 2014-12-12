#include "Scripts/shmup/core/Pawn.as"
#include "Scripts/shmup/weapons/Weapon.as"

//class Character : InputPlayer{
shared class Character:Pawn{
  Vector2 bounds_ = Vector2(-1.0f,-1.0f);
  Character(){
    speed_=20.0f;
  }
  void Start(){
    //Node@ main_node_ = node.CreateChild("Character");

    StaticModel@ chs_ = node.CreateComponent("StaticModel");
    chs_.model = cache.GetResource("Model", "Models/Cone.mdl");
    chs_.material = cache.GetResource("Material", "Materials/Stone.xml");

    RigidBody@ chb_ = node.CreateComponent("RigidBody");
    chb_.mass = 0.25f;
    chb_.friction = 0.75f;
    chb_.linearDamping = 0.6f;
    chb_.linearFactor = Vector3(1.0f,0.0f,1.0f);
    chb_.angularFactor = Vector3(0.0f,0.0f,0.0f);
    chb_.useGravity = false;
    chb_.collisionLayer=1;
    chb_.collisionMask=60;
    CollisionShape@ csb = node.CreateComponent("CollisionShape");
    csb.SetBox(Vector3(1.0f, 1.0f, 1.0f));

    Node@ weapon_ = node.CreateChild("Weapon");
    weapon_.position=Vector3(1.0f,0.0f,0.0f);
    StaticModel@ wps_ = weapon_.CreateComponent("StaticModel");
    wps_.model = cache.GetResource("Model", "Models/Box.mdl");
    wps_.material = cache.GetResource("Material", "Materials/Stone.xml");
    weapon_.CreateScriptObject(scriptFile,"Weapon");
  }

  void FixedUpdate(float timeStep){
    RigidBody@ body_ = node.GetComponent("RigidBody");
    //clamp the y to stay on 0 plane
    if(node.position.y<0){

      body_.linearVelocity =body_.linearVelocity*Vector3(1.0f,0.0f,1.0f);
      node.position=Vector3(node.position.x,0.0f,node.position.z);
    }
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
