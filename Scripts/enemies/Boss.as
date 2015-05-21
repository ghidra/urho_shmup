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
    make_ragdoll();
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

  ///---------------------------------
  //ragdoll

  //make the ragdoll geo
  void make_ragdoll(){
    // Create RigidBody & CollisionShape components to bones
    CreateRagdollBone("robotHand_root", SHAPE_BOX, Vector3(7.0f, 2.1f, 5.25f), Vector3(0.0f, 0.0f, 3.0f),Quaternion(0.0f, 0.0f, 0.0f));

    CreateRagdollBone("l_thumb_1", SHAPE_CAPSULE, Vector3(2.3f, 3.0f, 1.25f), Vector3(0.0f, 1.5f, 0.0f),Quaternion(0.0f, 0.0f, 0.0f));
    CreateRagdollBone("l_thumb_2", SHAPE_CAPSULE, Vector3(2.3f, 4.0f, 1.25f), Vector3(0.0f, 2.0f, 0.0f),Quaternion(0.0f, 0.0f, 0.0f));
    CreateRagdollBone("l_thumb_3", SHAPE_CAPSULE, Vector3(2.3f, 3.0f, 1.25f), Vector3(0.0f, 1.5f, 0.0f),Quaternion(0.0f, 0.0f, 0.0f));
  
    CreateRagdollBone("l_index_1", SHAPE_CAPSULE, Vector3(2.3f, 4.0f, 1.25f), Vector3(0.0f, 2.0f, 0.0f),Quaternion(0.0f, 0.0f, 0.0f));
    CreateRagdollBone("l_index_2", SHAPE_CAPSULE, Vector3(2.3f, 3.0f, 1.25f), Vector3(0.0f, 1.5f, 0.0f),Quaternion(0.0f, 0.0f, 0.0f));
    CreateRagdollBone("l_index_3", SHAPE_CAPSULE, Vector3(2.3f, 3.0f, 1.25f), Vector3(0.0f, 1.5f, 0.0f),Quaternion(0.0f, 0.0f, 0.0f));
  
    CreateRagdollBone("middle_1", SHAPE_CAPSULE, Vector3(2.3f, 5.0f, 1.25f), Vector3(0.0f, 2.5f, 0.0f),Quaternion(0.0f, 0.0f, 0.0f));
    CreateRagdollBone("middle_2", SHAPE_CAPSULE, Vector3(2.3f, 4.0f, 1.25f), Vector3(0.0f, 2.0f, 0.0f),Quaternion(0.0f, 0.0f, 0.0f));
    CreateRagdollBone("middle_3", SHAPE_CAPSULE, Vector3(2.3f, 3.0f, 1.25f), Vector3(0.0f, 1.5f, 0.0f),Quaternion(0.0f, 0.0f, 0.0f));

    CreateRagdollBone("r_index_1", SHAPE_CAPSULE, Vector3(2.3f, 4.0f, 1.25f), Vector3(0.0f, 2.0f, 0.0f),Quaternion(0.0f, 0.0f, 0.0f));
    CreateRagdollBone("r_index_2", SHAPE_CAPSULE, Vector3(2.3f, 3.0f, 1.25f), Vector3(0.0f, 1.5f, 0.0f),Quaternion(0.0f, 0.0f, 0.0f));
    CreateRagdollBone("r_index_3", SHAPE_CAPSULE, Vector3(2.3f, 3.0f, 1.25f), Vector3(0.0f, 1.5f, 0.0f),Quaternion(0.0f, 0.0f, 0.0f));
  
    CreateRagdollBone("r_thumb_1", SHAPE_CAPSULE, Vector3(2.3f, 3.0f, 1.25f), Vector3(0.0f, 1.5f, 0.0f),Quaternion(0.0f, 0.0f, 0.0f));
    CreateRagdollBone("r_thumb_2", SHAPE_CAPSULE, Vector3(2.3f, 4.0f, 1.25f), Vector3(0.0f, 2.0f, 0.0f),Quaternion(0.0f, 0.0f, 0.0f));
    CreateRagdollBone("r_thumb_3", SHAPE_CAPSULE, Vector3(2.3f, 3.0f, 1.25f), Vector3(0.0f, 1.5f, 0.0f),Quaternion(0.0f, 0.0f, 0.0f));

    //constraints
    CreateRagdollConstraint("l_thumb_1", "robotHand_root", CONSTRAINT_CONETWIST, Vector3(0.0f, 1.0f, 0.0f),Vector3(0.0f, 0.0f, 1.0f), Vector2(15.0f, 15.0f), Vector2(0.0f, 0.0f));
    CreateRagdollConstraint("l_thumb_2", "l_thumb_1", CONSTRAINT_HINGE, Vector3(0.0f, 0.0f, -1.0f),Vector3(0.0f, 0.0f, -1.0f), Vector2(90.0f, 0.0f), Vector2(0.0f, 0.0f));
    CreateRagdollConstraint("l_thumb_3", "l_thumb_2", CONSTRAINT_HINGE, Vector3(0.0f, 0.0f, -1.0f),Vector3(0.0f, 0.0f, -1.0f), Vector2(90.0f, 0.0f), Vector2(0.0f, 0.0f));
    
    CreateRagdollConstraint("l_index_1", "robotHand_root", CONSTRAINT_CONETWIST, Vector3(0.0f, 1.0f, 0.0f),Vector3(0.0f, 0.0f, 1.0f), Vector2(45.0f, 45.0f), Vector2(0.0f, 0.0f));
    CreateRagdollConstraint("l_index_2", "l_index_1", CONSTRAINT_HINGE, Vector3(0.0f, 0.0f, -1.0f),Vector3(0.0f, 0.0f, -1.0f), Vector2(90.0f, 0.0f), Vector2(0.0f, 0.0f));
    CreateRagdollConstraint("l_index_3", "l_index_2", CONSTRAINT_HINGE, Vector3(0.0f, 0.0f, -1.0f),Vector3(0.0f, 0.0f, -1.0f), Vector2(90.0f, 0.0f), Vector2(0.0f, 0.0f));
    
    CreateRagdollConstraint("middle_1", "robotHand_root", CONSTRAINT_CONETWIST, Vector3(0.0f, 1.0f, 0.0f),Vector3(0.0f, 0.0f, 1.0f), Vector2(45.0f, 45.0f), Vector2(0.0f, 0.0f));
    CreateRagdollConstraint("middle_2", "middle_1", CONSTRAINT_HINGE, Vector3(0.0f, 0.0f, -1.0f),Vector3(0.0f, 0.0f, -1.0f), Vector2(90.0f, 0.0f), Vector2(0.0f, 0.0f));
    CreateRagdollConstraint("middle_3", "middle_2", CONSTRAINT_HINGE, Vector3(0.0f, 0.0f, -1.0f),Vector3(0.0f, 0.0f, -1.0f), Vector2(90.0f, 0.0f), Vector2(0.0f, 0.0f));
   
    CreateRagdollConstraint("r_index_1", "robotHand_root", CONSTRAINT_CONETWIST, Vector3(0.0f, 1.0f, 0.0f),Vector3(0.0f, 0.0f, 1.0f), Vector2(45.0f, 45.0f), Vector2(0.0f, 0.0f));
    CreateRagdollConstraint("r_index_2", "r_index_1", CONSTRAINT_HINGE, Vector3(0.0f, 0.0f, -1.0f),Vector3(0.0f, 0.0f, -1.0f), Vector2(90.0f, 0.0f), Vector2(0.0f, 0.0f));
    CreateRagdollConstraint("r_index_3", "r_index_2", CONSTRAINT_HINGE, Vector3(0.0f, 0.0f, -1.0f),Vector3(0.0f, 0.0f, -1.0f), Vector2(90.0f, 0.0f), Vector2(0.0f, 0.0f));

    CreateRagdollConstraint("r_thumb_1", "robotHand_root", CONSTRAINT_CONETWIST, Vector3(0.0f, 1.0f, 0.0f),Vector3(0.0f, 0.0f, 1.0f), Vector2(15.0f, 15.0f), Vector2(0.0f, 0.0f));
    CreateRagdollConstraint("r_thumb_2", "r_thumb_1", CONSTRAINT_HINGE, Vector3(0.0f, 0.0f, -1.0f),Vector3(0.0f, 0.0f, -1.0f), Vector2(90.0f, 0.0f), Vector2(0.0f, 0.0f));
    CreateRagdollConstraint("r_thumb_3", "r_thumb_2", CONSTRAINT_HINGE, Vector3(0.0f, 0.0f, -1.0f),Vector3(0.0f, 0.0f, -1.0f), Vector2(90.0f, 0.0f), Vector2(0.0f, 0.0f));
    
  }

  //ragdoll functions from the sample file
  void CreateRagdollBone(const String&in boneName, ShapeType type, const Vector3&in size, const Vector3&in position,
        const Quaternion&in rotation)
    {
        // Find the correct child scene node recursively
        Node@ boneNode = node.GetChild(boneName, true);
        if (boneNode is null)
        {
            log.Warning("Could not find bone " + boneName + " for creating ragdoll physics components");
            return;
        }

        RigidBody@ body = boneNode.CreateComponent("RigidBody");
        // Set mass to make movable
        body.mass = 1.0f;
        // Set damping parameters to smooth out the motion
        body.linearDamping = 0.05f;
        body.angularDamping = 0.85f;
        // Set rest thresholds to ensure the ragdoll rigid bodies come to rest to not consume CPU endlessly
        body.linearRestThreshold = 0.1f;//1.5f;
        body.angularRestThreshold = 0.1f;//2.5f;

        CollisionShape@ shape = boneNode.CreateComponent("CollisionShape");
        // We use either a box or a capsule shape for all of the bones
        if (type == SHAPE_BOX)
            shape.SetBox(size, position, rotation);
        else
            shape.SetCapsule(size.x, size.y, position, rotation);
    }

    void CreateRagdollConstraint(const String&in boneName, const String&in parentName, ConstraintType type,
        const Vector3&in axis, const Vector3&in parentAxis, const Vector2&in highLimit, const Vector2&in lowLimit,
        bool disableCollision = true)
    {
        Node@ boneNode = node.GetChild(boneName, true);
        Node@ parentNode = node.GetChild(parentName, true);
        if (boneNode is null)
        {
            log.Warning("Could not find bone " + boneName + " for creating ragdoll constraint");
            return;
        }
        if (parentNode is null)
        {
            log.Warning("Could not find bone " + parentName + " for creating ragdoll constraint");
            return;
        }

        Constraint@ constraint = boneNode.CreateComponent("Constraint");
        constraint.constraintType = type;
        // Most of the constraints in the ragdoll will work better when the connected bodies don't collide against each other
        constraint.disableCollision = disableCollision;
        // The connected body must be specified before setting the world position
        constraint.otherBody = parentNode.GetComponent("RigidBody");
        // Position the constraint at the child bone we are connecting
        constraint.worldPosition = boneNode.worldPosition;
        // Configure axes and limits
        constraint.axis = axis;
        constraint.otherAxis = parentAxis;
        constraint.highLimit = highLimit;
        constraint.lowLimit = lowLimit;
    }


}
