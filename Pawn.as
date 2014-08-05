class Pawn{
    Node@ _node;
    Scene@ _scene;
    //Controller@ _controller;
    Pawn(Scene@ scene,String node_name ){
      _scene = scene;

      _node = _scene.CreateChild(node_name);

      StaticModel@ coneObject = _node.CreateComponent("StaticModel");
      coneObject.model = cache.GetResource("Model", "Models/Cone.mdl");
      coneObject.material = cache.GetResource("Material", "Materials/StoneTiled.xml");
    }

    //setters
    void set_position(Vector3 pos){
      _node.position = pos;
    }
}
