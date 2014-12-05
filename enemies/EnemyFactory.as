#include "Scripts/shmup/enemies/Enemy.as"

class EnemyFactory:ScriptObject{
  //float timer_total_;
  float spawn_timer_;
  float spawn_interval_ = 1.0f;

  void Start(){
    //spawn_enemy("Character","Enemy",Vector3(5.0f,0.0f,5.0f));
    spawn_timer_ = spawn_interval_;//this just lets me spawn immediatly
  }

  void FixedUpdate(float timeStep){
    //timer_total_+=timeStep;
    //Print();
    spawn_timer_+=timeStep;
    if(spawn_timer_>=spawn_interval_){
      spawn_enemy("Character","Enemy",Vector3(5.0f,0.0f,5.0f));
      spawn_timer_=0;
    }
  }

  Node@ spawn_enemy(const String&in ntype, const String&in ctype, const Vector3&in pos, const Quaternion&in ori = Quaternion()){
    //enemy type, class type, position, orientation

    Node@ main_node_ = node.CreateChild("Enemy");

    StaticModel@ object_ = main_node_.CreateComponent("StaticModel");
    object_.model = cache.GetResource("Model", "Models/Sphere.mdl");
    object_.material = cache.GetResource("Material", "Materials/Stone.xml");

    RigidBody@ body_ = main_node_.CreateComponent("RigidBody");
    body_.mass = 0.25f;
    body_.friction = 0.75f;
    body_.linearDamping = 0.6f;
    body_.useGravity = false;
    body_.collisionLayer=2;
    body_.collisionMask=2;
    CollisionShape@ shape = main_node_.CreateComponent("CollisionShape");
    shape.SetBox(Vector3(1.0f, 1.0f, 1.0f));

    //XMLFile@ xml = cache.GetResource("XMLFile", "Scripts/shmup/nodes/" + ntype + ".xml");
    //Node@ enemy_ = scene.InstantiateXML(xml, pos, ori);
    //Node@ enemy_ = node.LoadXML(xml);

    //i need to set the collision mast to 2 for enmies
    //RigidBody@ rb_ = enemy_.GetComponent("RigidBody");
    //rb_.collisionMask=2;

    //Enemy@ node_script_ = cast<Enemy>(enemy_.CreateScriptObject(scriptFile, ctype, LOCAL));
    Enemy@ node_script_ = cast<Enemy>(main_node_.CreateScriptObject(scriptFile, ctype, LOCAL));

    //node_script_.set_parms(dir,OBJECT_VELOCITY,hit);

    //return enemy_;
    return main_node_;
  }
}
