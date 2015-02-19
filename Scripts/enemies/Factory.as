#include "Scripts/enemies/EnemyFactory.as"

class Factory:ScriptObject{

    void generate_enemy_factory(Vector3 pos = Vector3(), int spawnamount=5, float spawninterval=1.0f, String etype = "Enemy",String wtype = "Weapon", String btype="Behavior", float fire_rate= 1.0f, int mirror = 0, float active_time=1.0f){
      Node@ node_ = node.CreateChild("Enemy_Factory");
      node_.position=pos;
      EnemyFactory@ node_script_ = cast<EnemyFactory>(node_.CreateScriptObject(scriptFile, "EnemyFactory", LOCAL));
      node_script_.set_parameters(spawnamount,spawninterval,etype,wtype,btype,fire_rate,mirror,active_time);
    }

}
