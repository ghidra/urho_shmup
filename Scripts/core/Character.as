#include "Scripts/core/Pawn.as"
//#include "Scripts/weapons/Weapon.as"

//class Character : InputPlayer{
shared class Character:Pawn{
  Vector2 bounds_ = Vector2(-1.0f,-1.0f);
  Character(){
    //mesh_="Cone";
    mesh_="spaceship_02_shiponly";
    speed_=20.0f;
    //weapon_offsets_.Resize(1);

    weapon_offsets_.Resize(6);
    weapon_offsets_.Clear();
    weapon_offsets_.Push( Vector3(1.5f,0.0f,0.75f));
    weapon_offsets_.Push( Vector3(-1.5f,0.0f,0.75f));
    weapon_offsets_.Push( Vector3(2.25f,0.0f,-0.5f));
    weapon_offsets_.Push( Vector3(-2.25f,0.0f,-0.5f));
    weapon_offsets_.Push( Vector3(3.0f,0.0f,-2.0f));
    weapon_offsets_.Push( Vector3(-3.0f,0.0f,-2.0f));
    //weapon_rotations_.Resize(1);
    weapon_rotations_.Resize(6);
    weapon_rotations_.Clear();
    weapon_rotations_.Push( Vector3(0.0f,0.0f,0.0f));
    weapon_rotations_.Push( Vector3(0.0f,0.0f,0.0f));
    weapon_rotations_.Push( Vector3(0.0f,10.0f,0.0f));
    weapon_rotations_.Push( Vector3(0.0f,-10.0f,0.0f));
    weapon_rotations_.Push( Vector3(0.0f,30.0f,0.0f));
    weapon_rotations_.Push( Vector3(0.0f,-30.0f,0.0f));
  }
  void Start(){
    build_geo(mesh_,material_,0.2);
    mesh_material_.shaderParameters["ObjectBlend"]=Variant(1.0f);//single quotes didnt work
    //build_weapon("Weapon");

    WeaponBank@ wb = get_weaponbank();
    wb.set_weapon(1);
    wb.set_weapon(2);
    wb.set_weapon(3);
    wb.set_weapon(4);
    wb.set_weapon(5);
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
