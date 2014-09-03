class Explosion{

  Node@ node_;

	Explosion(Scene@ scene, Vector3 pos, Vector3 dir, float speed = 0.0f){
    node_ = scene.CreateChild("Explosion");
    node_.position = pos;

    StaticModel@ object_ = node_.CreateComponent("StaticModel");
    object_.model = cache.GetResource("Model", "Models/Sphere.mdl");
    object_.material = cache.GetResource("Material", "Materials/StoneEnvMapSmall.xml");
  }

}
