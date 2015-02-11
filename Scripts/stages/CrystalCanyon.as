class CrystalCanyon:ScriptObject{

  Node@ node_a;
  Node@ node_b;
  Node@ node_c;
  Node@ node_d;
  Node@ node_e;

  float speed_ = 5.0f;

  CrystalCanyon(){}

  void Start(){
    node_a = node.CreateChild("canyon_a");
    node_b = node.CreateChild("canyon_b");
    node_c = node.CreateChild("canyon_c");
    node_d = node.CreateChild("canyon_d");
    node_e = node.CreateChild("canyon_e");

    StaticModel@ sm_a = node_a.CreateComponent("StaticModel");
    sm_a.model = cache.GetResource("Model", "Models/canyon_scaled10.mdl");
    StaticModel@ sm_b = node_b.CreateComponent("StaticModel");
    sm_b.model = cache.GetResource("Model", "Models/canyon_scaled10.mdl");
    StaticModel@ sm_c = node_c.CreateComponent("StaticModel");
    sm_c.model = cache.GetResource("Model", "Models/canyon_scaled10.mdl");
    StaticModel@ sm_d = node_d.CreateComponent("StaticModel");
    sm_d.model = cache.GetResource("Model", "Models/canyon_scaled10.mdl");
    StaticModel@ sm_e = node_e.CreateComponent("StaticModel");
    sm_e.model = cache.GetResource("Model", "Models/canyon_scaled10.mdl");

    Material@ usemat = cache.GetResource("Material", "Materials/Pixel.xml");
    usemat.shaderParameters["ObjectBlend"]=Variant(1.0f);//single quotes didnt work
    Color col = Color(Random(1.0f),Random(1.0f),Random(1.0f),1.0f);
    usemat.shaderParameters["ObjectColor"]=Variant(col);

    sm_a.material = usemat;
    sm_a.castShadows = true;
    sm_b.material = usemat;
    sm_b.castShadows = true;
    sm_c.material = usemat;
    sm_c.castShadows = true;
    sm_d.material = usemat;
    sm_d.castShadows = true;
    sm_e.material = usemat;
    sm_e.castShadows = true;

    node_b.position=Vector3(0.0f,0.0f,10.0f);
    node_c.position=Vector3(0.0f,0.0f,-10.0f);
    node_d.position=Vector3(0.0f,0.0f,20.0f);
    node_e.position=Vector3(0.0f,0.0f,-20.0f);


    node.Scale(6.0f);
    node.position=Vector3(0.0f,-100.0f,10.0f);
  }

  void FixedUpdate(float timeStep){
    //node.position = node.position+Vector3(0.0f,0.0f,0.75f*timeStep);
    Vector3 tran = Vector3(0.0,0.0,-1.0)*speed_*timeStep;

    if(node_a.position.z<=-30.0)node_a.position = Vector3(0.0,0.0,20.0);
    if(node_b.position.z<=-30.0)node_b.position = Vector3(0.0,0.0,20.0);
    if(node_c.position.z<=-30.0)node_c.position = Vector3(0.0,0.0,20.0);
    if(node_d.position.z<=-30.0)node_d.position = Vector3(0.0,0.0,20.0);
    if(node_e.position.z<=-30.0)node_e.position = Vector3(0.0,0.0,20.0);

    node_a.position=node_a.position+tran;
    node_b.position=node_b.position+tran;
    node_c.position=node_c.position+tran;
    node_d.position=node_d.position+tran;
    node_e.position=node_e.position+tran;
  }

}
