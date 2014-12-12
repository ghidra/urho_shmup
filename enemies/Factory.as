#include "Scripts/shmup/enemies/EnemyFactory.as"

class Factory:ScriptObject{

    void generate_enemy_factory(const Vector3&in pos = Vector3(), const String&in etype = "Enemy",const String&in wtype = "Weapon", const String&in btype="Behavior", const float&in fire_rate= 1.0f, const int&in mirror = 0,const float&in active_time=1.0f){
      Node@ node_ = node.CreateChild("Enemy_Factory");
      node_.position=pos;
      EnemyFactory@ node_script_ = cast<EnemyFactory>(node_.CreateScriptObject(scriptFile, "EnemyFactory", LOCAL));
      node_script_.set_parameters(etype,wtype,btype,fire_rate,mirror,active_time);
    }

}
