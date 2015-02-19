#include "Scripts/weapons/Weapon.as"

shared class WeaponBank: ScriptObject{

  Array<Node@> weapons_;//the aray of weapons in our bank
  //Array<Vector3> offsets_;
  //Array<Vector3> rotations_;
  //Array<Vector3> d_offsets_ = {Vector3(0.0f,0.0f,0.0f)};

  void set_parameters(Array<Vector3>& offset, Array<Vector3>& rotation, float scl = 1.0f ){
    uint size = offset.length;
    weapons_.Resize(size);
    //offsets_.Resize(size);
    //rotations_.Resize(size);
    for(uint i=0;i<size;i++){
      Node@ weapon_node = node.CreateChild("Weapon"+i);
      //weapon_node.Scale(scl);
      weapon_node.position=offset[i];
      Quaternion q = Quaternion();
      q.FromEulerAngles( rotation[i].x,rotation[i].y,rotation[i].z );
      weapon_node.rotation=q;
      //offsets_[i] = offset[i];
      //rotations_[i] = rotation[i];
    }
  }

  void set_weapon(uint slot = 0, String wclass = "Weapon", float fire_rate=0.25f,uint enemy=0){
    //first we need to make sure that we have a long enough array, otherwise add it to the end
    if(weapons_.length<slot+1){
      Node@ new_weapon = node.CreateChild("Weapon"+weapons_.length);
      weapons_.Push(new_weapon);
    }
    //now we can make the weapon
    build_weapon(slot,wclass,fire_rate,enemy);
  }

  void build_weapon(uint slot, String wclass, float fire_rate,uint enemy){

    Node@ weapon_node = node.GetChild("Weapon"+slot);//the weapon node to work on

    ScriptInstance@ si = weapon_node.GetComponent("ScriptInstance");
    if(si !is null){
      //there was a script objecy on there already, replace it
      si.CreateObject(scriptFile,wclass);
    }else{
      //there was not a script object, i need to create one
      weapon_node.CreateScriptObject(scriptFile,wclass);
    }

    //now set the mesh
    Weapon@ weapon = cast<Weapon>(node.GetChild("Weapon"+slot).scriptObject);
    weapon.set_firerate(fire_rate);
    if(enemy>0){
      weapon.set_enemy();
    }
    //Print(weapon.firing_interval_);
    //Node@ weapon_node_ = node.children[0];
    /*Node@ weapon_node_ = node.GetChild("Weapon");

    Weapon@ wpso = cast<Weapon>(weapon_node_.CreateScriptObject(scriptFile,wclass));*/

    StaticModel@ wpsm_ = weapon_node.CreateComponent("StaticModel");
    wpsm_.model = cache.GetResource("Model", "Models/"+weapon.meshtype_+".mdl");
    //wpsm_.material = cache.GetResource("Material", "Materials/"+weapon.mattype_+".xml");

    Material@ usemat = cache.GetResource("Material", "Materials/"+weapon.mattype_+".xml");
    Material@ mesh_material_ = usemat.Clone();
    Color col = Color(Random(1.0f),Random(1.0f),Random(1.0f),1.0f);
    mesh_material_.shaderParameters["ObjectColor"]=Variant(col);//single quotes didnt work
    mesh_material_.shaderParameters["ObjectBlend"]=Variant(1.0f);
    wpsm_.material = mesh_material_;
    //weapon_node.CreateScriptObject(scriptFile,wclass);


    //Print(weapon_node.scale.x);
    //I NEED TO REMOVE THIS, OR STORE THE SCALE I WANT, SO I CAN APPLY IT AGAIN WHEN I NEED TO
    weapon_node.Scale(0.2f);//setting this again, because if a child node is created after it isnt scaled
    //Print(weapon_node.worldScale.x);
  }

  //--------------------

  void fire(Vector3 target_position,float timestep = 0.0f){
    for(uint i=0;i<weapons_.length;i++){
      Weapon@ weapon = cast<Weapon>(node.GetChild("Weapon"+i).scriptObject);
      if(weapon !is null){
        weapon.fire(target_position,timestep);
      }
    }
  }
  void release_fire(){
    for(uint i=0;i<weapons_.length;i++){
      Weapon@ weapon = cast<Weapon>(node.GetChild("Weapon"+i).scriptObject);
      if(weapon !is null){
        weapon.release_fire();
      }
    }
  }


}
