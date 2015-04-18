#include "Scripts/core/Pawn.as"
#include "Scripts/gui/ProgressBar.as"

class Boss:Pawn{
  //ProgressBar@ bar_;
  Node@ target_;//this will likely be the main character that I am firing at
  Node@ healthbar_;

  //float bar_regen_ = 0.001f;
  Boss(){
  //void Start(){
    side_=SIDE_ENEMY;
    speed_=0.1f;
    collision_layer_=16;
    collision_mask_=51;
    mesh_="boss_hand/geo_handbase_08";
    material_="HandBoss_01";
    health_=100;
    maxHealth_=100;
  }
  void Start(){
    SubscribeToEvent(node, "NodeCollision", "HandleNodeCollision");
  }

  //this is called from the enemy factory as soon as it is made, here we need to put it all together
  void set_parameters(float fire_rate=1.0, Vector3 pos=Vector3(), Quaternion rot=Quaternion(), float scl=1.0){//this all comes in from the enemy factory
    //etype, ctype, wtype, btype, firerate (enemy type, class type, weapon type, behavior type, fire rate)
    //build_geo(mesh_,material_,0.2f);
    build_animated_geo(mesh_,material_);

    attach_static_mesh("l_thumb_3","boss_hand/geo_handbase_l_thumbshell_3");
    attach_static_mesh("l_thumb_2","boss_hand/geo_handbase_l_thumbshell_2");

    attach_static_mesh("l_index_3","boss_hand/geo_handbase_l_indexshell_3");
    attach_static_mesh("l_index_2","boss_hand/geo_handbase_l_indexshell_2");
    attach_static_mesh("l_index_1","boss_hand/geo_handbase_l_indexshell_1");

    attach_static_mesh("middle_3","boss_hand/geo_handbase_middle_shell_3");
    attach_static_mesh("middle_2","boss_hand/geo_handbase_middle_shell_2");
    attach_static_mesh("middle_1","boss_hand/geo_handbase_middle_shell_1");

    attach_static_mesh("r_index_3","boss_hand/geo_handbase_r_indexshell_3");
    attach_static_mesh("r_index_2","boss_hand/geo_handbase_r_indexshell_2");
    attach_static_mesh("r_index_1","boss_hand/geo_handbase_r_indexshell_1");

    attach_static_mesh("r_thumb_3","boss_hand/geo_handbase_r_thumbshell_3");
    attach_static_mesh("r_thumb_2","boss_hand/geo_handbase_r_thumbshell_2");
    //build_weapon(wtype);

    //WeaponBank@ wb = get_weaponbank();
    //wb.set_weapon(0,wtype,fire_rate,1);

    healthbar_ = node.CreateChild("healthbar");
    ProgressBar@ bar = cast<ProgressBar>(healthbar_.CreateScriptObject(scriptFile, "ProgressBar"));
    bar.set_parameters(maxHealth_*1.0,maxHealth_*1.0);
  }
  //--------------------
  //--------------------

  void FixedUpdate(float timeStep){

	  Pawn::FixedUpdate(timeStep);

    if(target_ !is null){
      fire(target_.position,timeStep);
    }

  }
  void set_target(Node@ t){
    target_=t;
  }
  //----------------
  //-----
  void ObjectCollision(Actor@ otherObject, VariantMap& eventData){
    //Print("HIT");
    //RigidBody@ body = node.GetComponent("RigidBody");
    //spawn_explosion(node.position,body.linearVelocity);
    //node.Remove();
    Damage(otherObject,2.9);

    ProgressBar@ bar_ = cast<ProgressBar>(healthbar_.scriptObject);
    bar_.set_value(health_);
    //Print(health_);

    if(health_<=0.0){
      die();
    }
  }

  void die(){
    //behavior_=null;
    spawn_explosion(node.worldPosition);
    node.Remove();
  }

  void spawn_explosion(Vector3 pos){//position and magnitude, which we can derive direction and speed from
    Node@ explosionode = scene.CreateChild("EnemyExplosion");
    EnemyExplosion@ explosion = cast<EnemyExplosion>(explosionode.CreateScriptObject(scriptFile,"EnemyExplosion"));
    explosion.set_position(pos);
  }

  void attach_static_mesh(String bonename, String meshname, String materialname="Pixel"){
    //Node@ root = node.GetChild("Geometry");
    //Skeleton@ skel = root.skeleton;
    Node@ bone = node.GetChild(bonename,true);

    Node@ gnode = bone.CreateChild("Geometry");
    StaticModel@ sm = gnode.CreateComponent("StaticModel");
    sm.model = cache.GetResource("Model", "Models/"+meshname+".mdl");
    sm.material = mesh_material_;

    //gnode.parent = bone;
  }


}
