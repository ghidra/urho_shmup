#include "Scripts/shmup/enemies/EnemyFactory.as"

class Factory:ScriptObject{

    //Array<EnemyFactory> factories_;//this will hold the factories after i have created them
    //what i need
    //positions, enemy type, enemy behavior, active time

    //float spawn_timer_;//just tracks the time, so I can spawn factories based on time


    //void Start(){
      //spawn_enemy("Character","Enemy",Vector3(5.0f,0.0f,5.0f));
      //spawn_timer_ = spawn_interval_;//this just lets me spawn immediatly

    //}

    //void FixedUpdate(float timeStep){

      //spawn_timer_+=timeStep;
      /*if(spawn_timer_>=spawn_interval_){
        if(spawn_increment_< spawn_amount_){
          spawn_enemy("Character","Enemy",Vector3(5.0f,0.0f,5.0f));
          spawn_timer_=0;
          spawn_increment_+=1;
        }
      }*/

    //}

    void generate_factory(const Vector3&in pos = Vector3(), const String&in etype = "Enemy", const String&in ebehavior="Basic", const float&in active_time=1.0f){
      Node@ node_ = node.CreateChild("Enemy_Factory");
      node_.position=pos;
      EnemyFactory@ node_script_ = cast<EnemyFactory>(node_.CreateScriptObject(scriptFile, "EnemyFactory", LOCAL));
      node_script_.set_parameters(etype,ebehavior,active_time);
    }

}
