#include "Scripts/shmup/enemies/Enemy.as"

class EnemyFactory:ScriptObject{

  void Start(){
    //spawn_enemy("Character","Enemy",Vector3(5.0f,0.0f,5.0f));
  }

  Node@ spawn_enemy(const String&in ntype, const String&in ctype, const Vector3&in pos, const Quaternion&in ori = Quaternion()){
    //enemy type, class type, position, orientation

    XMLFile@ xml = cache.GetResource("XMLFile", "Scripts/shmup/nodes/" + ntype + ".xml");
    Node@ enemy_ = scene.InstantiateXML(xml, pos, ori);

    //i need to set the collision mast to 2 for enmies
    RigidBody@ rb_ = enemy_.GetComponent("RigidBody");
    //rb_.collisionMask=2;

    Enemy@ node_script_ = cast<Enemy>(enemy_.CreateScriptObject(scriptFile, ctype, LOCAL));
    //node_script_.set_parms(dir,OBJECT_VELOCITY,hit);

    return enemy_;
  }
}
