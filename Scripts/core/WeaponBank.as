#include "Scripts/shmup/weapons/Weapon.as"

shared class WeaponBank: ScriptObject{

  Array<Node@> weapons_;//the aray of weapons in our bank
  //Array<Vector3> offsets_;
  //Array<Vector3> rotations_;
  //Array<Vector3> d_offsets_ = {Vector3(0.0f,0.0f,0.0f)};

  void set_parameters(const Array<Vector3>&in offset, const Array<Vector3>&in rotation, const float&in scl = 1.0f ){
    uint size = offset.length;
    weapons_.Resize(size);
    //offsets_.Resize(size);
    //rotations_.Resize(size);
    for(uint i=0;i<size;i++){
      Node@ weapon_node = node.CreateChild("Weapon"+i);
      weapon_node.Scale(scl);
      weapon_node.position=offset[i];
      Quaternion q = Quaternion();
      q.FromEulerAngles( rotation[i].x,rotation[i].y,rotation[i].z );
      weapon_node.rotation=q;
      //offsets_[i] = offset[i];
      //rotations_[i] = rotation[i];
    }
  }

  void set_weapon(const uint&in slot = 0, const String&in wclass = "Weapon"){
    //first we need to make sure that we have a long enough array, otherwise add it to the end
    if(weapons_.length<slot+1){
      Node@ new_weapon = node.CreateChild("Weapon"+weapons_.length);
      weapons_.Push(new_weapon);
    }
    //now we can make the weapon
    build_weapon(slot,wclass);
  }

  void build_weapon(const uint&in slot = 0, const String&in wclass = "Weapon"){

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

    //Node@ weapon_node_ = node.children[0];
    /*Node@ weapon_node_ = node.GetChild("Weapon");

    Weapon@ wpso = cast<Weapon>(weapon_node_.CreateScriptObject(scriptFile,wclass));*/

    StaticModel@ wpsm_ = weapon_node.CreateComponent("StaticModel");
    wpsm_.model = cache.GetResource("Model", "Models/"+weapon.meshtype_+".mdl");
    wpsm_.material = cache.GetResource("Material", "Materials/"+weapon.mattype_+".xml");
    //weapon_node.CreateScriptObject(scriptFile,wclass);
  }


}
