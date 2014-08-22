class Projectile{
  Scene@ scene_;
  Node@ node_;
  RigidBody@ body_;

  Projectile(Scene@ scene, Vector3 pos, Vector3 dir, float speed = 4.5f){
    scene_ = scene;
    node_ = scene_.CreateChild("Projectile");
    node_.position = pos+(dir.Normalized()*1.0f);
    //_projectile_node.rotation = cameraNode.rotation;
    node_.SetScale(0.25f);
    StaticModel@ object_ = node_.CreateComponent("StaticModel");
    object_.model = cache.GetResource("Model", "Models/Box.mdl");
    object_.material = cache.GetResource("Material", "Materials/StoneEnvMapSmall.xml");
    object_.castShadows = true;

    // Create physics components, use a smaller mass also
    body_ = node_.CreateComponent("RigidBody");
    body_.mass = 0.25f;
    body_.friction = 0.75f;
    CollisionShape@ shape_ = node_.CreateComponent("CollisionShape");
    shape_.SetBox(Vector3(1.0f, 1.0f, 1.0f));



    // Set initial velocity for the RigidBody based on camera forward vector. Add also a slight up component
    // to overcome gravity better
    body_.linearVelocity = dir+Vector3(0.0f,1.0f,0.0f) * speed;

    //attach scriptObject
    attach_script();
  }

  void remove(){
    node_.RemoveAllComponents();
    node_.RemoveAllChildren();
    node_.Remove();
  }

  void attach_script(){
    Projectile_Script@ node_script_ = cast<Projectile_Script>(node_.CreateScriptObject(scriptFile, "Projectile_Script"));
    node_script_.set_parameters(this);
  }
  /*BoundingBox bbpoint(const Vector3 p,const Vector3 size = Vector3(0.1f,0.1f,0.1f)){
    Vector3 size_pos = size/2.0f;
    return BoundingBox(p - size_pos, p + size_pos);
  }*/

}

class Projectile_Script:ScriptObject{

  Projectile@ parent_;

  void Update(float timeStep){
    //DebugRenderer@ debug = node.scene.debugRenderer;
    //debug.AddBoundingBox( parent_.bbpoint(Vector3(1.0f,1.0f,1.0f),Vector3(1.0f,1.0f,1.0f)) ,Color(0.0f, 0.0f, 1.0f) );

    if(node.position.y <= -1)
      parent_.remove();
      //node.Remove();
    //}
    //node.position = node.position+Vector3(3.0f,3.0f,3.0f);//.position = Vector3(0.0f,0.0f,0.0f);
    //_parent._body.useGravity = false;
    //node.parent.position=node.parent.position+Vector3(2.0f,0.0f,0.0f);
  }
  void set_parameters(Projectile@ parent){
    parent_ = parent;
  }
}
