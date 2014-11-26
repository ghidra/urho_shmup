#include "Scripts/shmup/Actor.as"

shared class Explosion{

  Node@ node_;

	Explosion(Scene@ scene, Vector3 pos, Vector3 dir, float speed = 0.0f){
    node_ = scene.CreateChild("Explosion");
    node_.position = pos;

    StaticModel@ object_ = node_.CreateComponent("StaticModel");
    object_.model = cache.GetResource("Model", "Models/Sphere.mdl");
    object_.material = cache.GetResource("Material", "Materials/StoneEnvMapSmall.xml");

    //i am putting this stuff in here to try and collide with, but didnt seem to work
    //i need to come up with a way to determine if I am inside this object or not.
    attach_script(node_);
  }
  void attach_script(Node@ node){
    Explosion_Script@ explosion_script_ = cast<Explosion_Script>(node.CreateScriptObject(scriptFile, "Explosion_Script"));
  }

}

shared class Explosion_Script:Actor{
  float radius_;
  void Update(float timeStep){
    radius_ = 1.0f;
  }
}
