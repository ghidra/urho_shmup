#include "Scripts/outlyer/Projectile.as"
#include "Scripts/outlyer/Explosion.as"

class ProjectileExploder:Projectile{
  Vector3 hit_;
  ProjectileExploder(Scene@ scene, Vector3 pos, Vector3 dir, Vector3 hit, float speed = 4.5f){
    super(scene,pos,dir,speed);
    hit_ = hit;
    //_scene = scene;
  }

  void remove(){
    node_.RemoveAllComponents();
    node_.RemoveAllChildren();
    node_.Remove();
  }

  void attach_script(){
    ProjectileExploder_Script@ node_script_ = cast<ProjectileExploder_Script>(node_.CreateScriptObject(scriptFile, "ProjectileExploder_Script"));
    node_script_.set_parameters(this);
  }

  /*BoundingBox bbpoint(const Vector3 p,const Vector3 size = Vector3(0.1f,0.1f,0.1f)){
    Vector3 size_pos = size/2.0f;
    return BoundingBox(p - size_pos, p + size_pos);
  }*/

}

class ProjectileExploder_Script:ScriptObject{

  ProjectileExploder@ parent_;

  void Update(float timeStep){
    //DebugRenderer@ debug = node.scene.debugRenderer;
    //debug.AddBoundingBox( parent_.bbpoint(Vector3(1.0f,1.0f,1.0f),Vector3(1.0f,1.0f,1.0f)) ,Color(0.0f, 0.0f, 1.0f) );

    if(node.position.y <= -3)
      parent_.remove();
      //node.Remove();
    //}
    //node.position = node.position+Vector3(3.0f,3.0f,3.0f);//.position = Vector3(0.0f,0.0f,0.0f);
    //_parent._body.useGravity = false;
    //node.parent.position=node.parent.position+Vector3(2.0f,0.0f,0.0f);
    Vector3 distance = node.position-parent_.hit_;
    if(distance.length<0.2f){
      parent_.remove();
    }
  }
  void set_parameters(ProjectileExploder@ parent){
    parent_ = parent;
  }
}
