class EnemyFactory{

  Node@ spawn_enemy(const String&in ptype, const Vector3&in pos, const Quaternion&in ori = Quaternion()){

    XMLFile@ xml = cache.GetResource("XMLFile", "Scripts/shmup/nodes/" + ptype + ".xml");
    Node@ projectile_ = scene.InstantiateXML(xml, node.worldPosition, Quaternion());

    Projectile@ node_script_ = cast<Projectile>(projectile_.CreateScriptObject(scriptFile, "Projectile", LOCAL));
    node_script_.set_parms(dir,OBJECT_VELOCITY,hit);

    return projectile_;
  }
}
