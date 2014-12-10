#include "Scripts/shmup/enemies/EnemyFactory.as"

class Factory:ScriptObject{

    Array<EnemyFactory> factories_;
    Array<float> spawn_times_;

    float spawn_timer_;//just tracks the time, so I can spawn factories based on time


    //void Start(){
      //spawn_enemy("Character","Enemy",Vector3(5.0f,0.0f,5.0f));
      //spawn_timer_ = spawn_interval_;//this just lets me spawn immediatly
    //}

    void FixedUpdate(float timeStep){

      spawn_timer_+=timeStep;
      /*if(spawn_timer_>=spawn_interval_){
        if(spawn_increment_< spawn_amount_){
          spawn_enemy("Character","Enemy",Vector3(5.0f,0.0f,5.0f));
          spawn_timer_=0;
          spawn_increment_+=1;
        }
      }*/

    }

}
