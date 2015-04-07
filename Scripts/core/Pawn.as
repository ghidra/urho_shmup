#include "Scripts/core/Actor.as"
#include "Scripts/weapons/WeaponBank.as"
#include "Scripts/weapons/Weapon.as"

shared class Pawn:Actor{

  //String mesh_ = "Sphere";
  //String material_ = "Pixel";
  Material@ mesh_material_;
  Color color_;//store the color
  //StaticModel@ geo_;
  bool physical_movement_ = false;
  float damp_time_ = 0.5f;//the amount of time it takes to go full speed/tilt
  float damp_increment_ = 0.0f;//a counter specifically for damping
  float bank_degrees_ = 20.f;//how much to bank

  Node@ weapon_bank_;//this will be a node to hold all the weapons
  //Array<Vector3> weapon_offsets_ = {Vector3(0.0f,0.0f,0.0f)};
  //Array<Vector3> weapon_rotations_ = {Vector3(0.0f,0.0f,0.0f)};//use for rotations
  Array<Vector3> weapon_offsets_;
  Array<Vector3> weapon_rotations_;//use for rotations

  //---------------------
  //---------------------

  void move(Vector3 direction, float timestep){
    //use damp time
    damp_increment_+=timestep;
    float fitdamp = fit(damp_increment_,0.0f,damp_time_,0.0f,1.0f);

    if(physical_movement_){
      RigidBody@ body_ = node.GetComponent("RigidBody");
      body_.linearVelocity = body_.linearVelocity+(direction*speed_*timestep);
    }else{
      node.position = node.position+(direction*speed_*timestep);
    }


    //lets do some rotation on it
    Quaternion rot = Quaternion();
    Vector3 dirclamp = direction*Vector3(1.0f,0.0f,0.0f);
    Vector3 rotaxis = dirclamp.CrossProduct(Vector3(0.0f,-1.0f,0.0f));
    float dirdot = direction.DotProduct(Vector3(1.0f,0.0f,0.0f));
    //float fitdirdot = fit(Abs(dirdot),0.0f,1.0f,0.1f,1.0f);
    rot.FromAngleAxis(bank_degrees_*fitdamp*Abs(dirdot),rotaxis);
    //turn off rotation for now
    //node.rotation = rot;
  }
  void stop_move(){
    damp_increment_=0.0f;
    node.rotation = Quaternion();
  }
  /*void FixedUpdate(float timeStep){
    Pawn::FixedUpdate(timeStep);
  }*/
  //this is called from the inputPLayer class
  void fire(Vector3 target_position,float timestep = 0.0f){
    //lets check that we have a weapon class
    //Weapon@ weapon = cast<Weapon>(node.children[0].GetScriptObject(weapon_type_));
    //Weapon@ weapon = cast<Weapon>(node.children[0].scriptObject);
    //Weapon@ weapon = cast<Weapon>(node.GetChild("Weapon").scriptObject);
    //if(weapon !is null){//if we have a weapon, we can fire that bitch
     // weapon.fire(target_position,timestep);
    //}
    WeaponBank@ weaponbank = cast<WeaponBank>(node.GetChild("WeaponBank").scriptObject);
    if(weaponbank !is null){//if we have a weapon, we can fire that bitch
      weaponbank.fire(target_position,timestep);
    }
  }
  void release_fire(){
    //Weapon@ weapon = cast<Weapon>(node.children[0].GetScriptObject(weapon_type_));
    //Weapon@ weapon = cast<Weapon>(node.children[0].scriptObject);
    //Weapon@ weapon = cast<Weapon>(node.GetChild("Weapon").scriptObject);
    //if(weapon !is null){//if we have a weapon, we can fire that bitch
    //  weapon.release_fire();
    //}
    WeaponBank@ weaponbank = cast<WeaponBank>(node.GetChild("WeaponBank").scriptObject);
    if(weaponbank !is null){//if we have a weapon, we can fire that bitch
      weaponbank.release_fire();
    }
  }




  //-----------------------
  //--  Build the actual pawn, mesh anf weapons
  //-----------------------

  void build_geo(const String&in mesh = "Cone",const String&in mat = "Pixel", const float&in scl = 1.0){
    //mesh and materail, later rigid settings
    //make a new node to hold the character mesh
    Node@ chnode = node.CreateChild("Geometry");

    StaticModel@ chsm_ = chnode.CreateComponent("StaticModel");
    chsm_.model = cache.GetResource("Model", "Models/"+mesh+".mdl");

    Material@ usemat = cache.GetResource("Material", "Materials/"+mat+".xml");
    mesh_material_ = usemat.Clone();
    Color col = Color(Random(1.0f),Random(1.0f),Random(1.0f),1.0f);
    mesh_material_.shaderParameters["ObjectColor"]=Variant(col);//single quotes didnt work
    chsm_.material = mesh_material_;

    //chsm_.material = cache.GetResource("Material", "Materials/"+mat+".xml");
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
    if(mesh_convex_ != ""){
      chcs.SetConvexHull( cache.GetResource("Model", "Models/"+mesh_convex_+".mdl") );
    }else{
      chcs.SetBox(Vector3(1.0f, 1.0f, 1.0f));
    }

    //place a waiting empty weapon node
    //Node@ weapon_ = node.CreateChild("Weapon");
    //weapon_.position=Vector3(1.0f,0.0f,0.0f);
    //weapon_.Scale(scl);

    //new weapons system
    weapon_bank_ = node.CreateChild("WeaponBank");
    WeaponBank@ weaponbank_script_ = cast<WeaponBank>(weapon_bank_.CreateScriptObject(scriptFile, "WeaponBank", LOCAL));
    //set the first weapon at least
    weaponbank_script_.set_parameters(weapon_offsets_,weapon_rotations_,scl);
    //weaponbank_script_.set_weapon();

  }

  //build animated geo
  void build_animated_geo(const String&in mesh = "Cone",const String&in mat = "Pixel", const float&in scl = 1.0){
    Node@ chnode = node.CreateChild("Geometry");

    AnimatedModel@ chsm_ = chnode.CreateComponent("AnimatedModel");
    chsm_.model = cache.GetResource("Model", "Models/"+mesh+".mdl");

    Material@ usemat = cache.GetResource("Material", "Materials/"+mat+".xml");
    mesh_material_ = usemat.Clone();
    color_ = Color(Random(1.0f),Random(1.0f),Random(1.0f),1.0f);
    mesh_material_.shaderParameters["ObjectColor"]=Variant(color_);//single quotes didnt work
    chsm_.material = mesh_material_;

    //chsm_.material = cache.GetResource("Material", "Materials/"+mat+".xml");
    chsm_.castShadows = true;

    chnode.Scale(scl);
  }

  WeaponBank@ get_weaponbank(){
    return cast<WeaponBank>(node.GetChild("WeaponBank").scriptObject);
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
