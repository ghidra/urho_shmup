class Projectile{
  //Scene@ _scene;
  Node@ _node;
  RigidBody@ _body;

  Projectile(Scene@ scene, Vector3 pos, Vector3 dir, float speed = 4.5f){
    //_scene = scene;
    _node = scene.CreateChild("Projectile");
    _node.position = pos+(dir.Normalized()*1.0f);
    //_projectile_node.rotation = cameraNode.rotation;
    _node.SetScale(0.25f);
    StaticModel@ _object = _node.CreateComponent("StaticModel");
    _object.model = cache.GetResource("Model", "Models/Box.mdl");
    _object.material = cache.GetResource("Material", "Materials/StoneEnvMapSmall.xml");
    _object.castShadows = true;

    // Create physics components, use a smaller mass also
    _body = _node.CreateComponent("RigidBody");
    _body.mass = 0.25f;
    _body.friction = 0.75f;
    CollisionShape@ _shape = _node.CreateComponent("CollisionShape");
    _shape.SetBox(Vector3(1.0f, 1.0f, 1.0f));



    // Set initial velocity for the RigidBody based on camera forward vector. Add also a slight up component
    // to overcome gravity better
    _body.linearVelocity = dir+Vector3(0.0f,1.0f,0.0f) * speed;
  }

}
