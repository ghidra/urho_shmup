#include "Scripts/shmup/core/Actor.as"
#include "Scripts/shmup/weapons/Weapon.as"

shared class Pawn:Actor{

  String mesh_ = "Sphere";
  String material_ = "shmup/Pixel";
  bool physical_movement_ = false;

  //---------------------
  //---------------------

  void move(Vector3 direction, float timestep){
    if(physical_movement_){
      RigidBody@ body_ = node.GetComponent("RigidBody");
      body_.linearVelocity = body_.linearVelocity+(direction*speed_*timestep);
    }else{
      node.position = node.position+(direction*speed_*timestep);
    }
  }
  //this is called from the inputPLayer class
  void fire(Vector3 target_position,float timestep = 0.0f){
    //lets check that we have a weapon class
    //Weapon@ weapon = cast<Weapon>(node.children[0].GetScriptObject(weapon_type_));
    //Weapon@ weapon = cast<Weapon>(node.children[0].scriptObject);
    Weapon@ weapon = cast<Weapon>(node.GetChild("Weapon").scriptObject);
    if(weapon !is null){//if we have a weapon, we can fire that bitch
      weapon.fire(target_position,timestep);
    }
  }
  void release_fire(){
    //Weapon@ weapon = cast<Weapon>(node.children[0].GetScriptObject(weapon_type_));
    //Weapon@ weapon = cast<Weapon>(node.children[0].scriptObject);
    Weapon@ weapon = cast<Weapon>(node.GetChild("Weapon").scriptObject);
    if(weapon !is null){//if we have a weapon, we can fire that bitch
      weapon.release_fire();
    }
  }

  //-----------------------
  //--  Build the actual pawn, mesh anf weapons
  //-----------------------

  void build_geo(const String&in mesh = "Cone",const String&in mat = "shmup/Normal", const float&in scl = 1.0){
    //mesh and materail, later rigid settings
    //make a new node to hold the character mesh
    Node@ chnode = node.CreateChild("Geometry");

    StaticModel@ chsm_ = chnode.CreateComponent("StaticModel");
    chsm_.model = cache.GetResource("Model", "Models/"+mesh+".mdl");
    chsm_.material = cache.GetResource("Material", "Materials/"+mat+".xml");
    chsm_.castShadows = true;

    chnode.Scale(scl);

    RigidBody@ chrb_ = node.CreateComponent("RigidBody");
    chrb_.mass = 0.25f;
    chrb_.friction = 0.75f;
    chrb_.linearDamping = 0.6f;
    chrb_.linearFactor = Vector3(1.0f,0.0f,1.0f);
    chrb_.angularFactor = Vector3(0.0f,0.0f,0.0f);
    chrb_.useGravity = false;
    chrb_.collisionLayer=collision_layer_;
    chrb_.collisionMask=collision_mask_;
    CollisionShape@ chcs = node.CreateComponent("CollisionShape");
    chcs.SetBox(Vector3(1.0f, 1.0f, 1.0f));

    //place a waiting empty weapon node
    Node@ weapon_ = node.CreateChild("Weapon");
    weapon_.position=Vector3(1.0f,0.0f,0.0f);
  }

  void build_weapon(const String&in wclass = "Weapon"){
    //Node@ weapon_node_ = node.children[0];
    Node@ weapon_node_ = node.GetChild("Weapon");

    Weapon@ wpso = cast<Weapon>(weapon_node_.CreateScriptObject(scriptFile,wclass));

    StaticModel@ wpsm_ = weapon_node_.CreateComponent("StaticModel");
    wpsm_.model = cache.GetResource("Model", "Models/"+wpso.meshtype_+".mdl");
    wpsm_.material = cache.GetResource("Material", "Materials/"+wpso.mattype_+".xml");
    weapon_node_.CreateScriptObject(scriptFile,wclass);
  }

}
