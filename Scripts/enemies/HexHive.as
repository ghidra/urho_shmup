#include "Scripts/enemies/Enemy.as"

class HexHive:Enemy{

	HexHive(){
		mesh_="hex_hive_shell_01";
		mesh_convex_="hex_hive_shell_shape_01";
	}

	void set_parameters(String etype,String ctype,String wtype,String btype, float fire_rate){//this all comes in from the enemy factory
	    //etype, ctype, wtype, btype, firerate (enemy type, class type, weapon type, behavior type, fire rate)
	    build_geo(mesh_,material_,3.0f);
	    node.position=Vector3(8.0,0.0,8.0);
	    //set_behavior(btype);

	    //WeaponBank@ wb = get_weaponbank();
	    //wb.set_weapon(0,"Weapon",fire_rate,1);

	    healthbar_ = node.CreateChild("healthbar");
	    ProgressBar@ bar = cast<ProgressBar>(healthbar_.CreateScriptObject(scriptFile, "ProgressBar"));
	    bar.set_parameters(maxHealth_*1.0,maxHealth_*1.0);
  	}

	  void build_geo(const String&in mesh = "Cone",const String&in mat = "Normal", const float&in scl = 1.0){
	    
	    Node@ chnode = node.CreateChild("Geometry");

	    //material to use
	    Material@ usemat = cache.GetResource("Material", "Materials/"+mat+".xml");
	    mesh_material_ = usemat.Clone();
	    Color col = Color(Random(1.0f),Random(1.0f),Random(1.0f),1.0f);
	    mesh_material_.shaderParameters["ObjectColor"]=Variant(col);//single quotes didnt work

	    //create the 6 shapes from the one mesh to make the hex
	    for (uint i=0; i<6; i++){
	    	Node@ hnode = chnode.CreateChild("hexpart");
	    	StaticModel@ hsm_ = hnode.CreateComponent("StaticModel");
	    	hsm_.model = cache.GetResource("Model", "Models/"+mesh+".mdl");

	    	Quaternion rot = Quaternion();
	    	rot.FromAngleAxis(i*60.0f,Vector3(0.0,1.0,0.0));
	    	hnode.rotation = rot;
	    
	    	hsm_.material = mesh_material_;
	    	hsm_.castShadows = true;
	    }

    

    //chsm_.material = cache.GetResource("Material", "Materials/"+mat+".xml");
    

    	chnode.Scale(scl);
	    
	    RigidBody@ chrb_ = node.CreateComponent("RigidBody");
	    chrb_.mass = 0.25f;
	    chrb_.friction = 0.75f;
	    chrb_.linearDamping = 0.6f;
	    chrb_.linearFactor = Vector3(1.0f,0.0f,1.0f);
	    chrb_.angularFactor = Vector3(0.0f,0.0f,0.0f);
	    chrb_.useGravity = false;
	    chrb_.collisionLayer=collision_layer_;
	    chrb_.collisionMask=collision_mask_;
	    CollisionShape@ chcs = node.CreateComponent("CollisionShape");
	    //chcs.SetBox(Vector3(1.0f, 1.0f, 1.0f));
	    chcs.SetConvexHull( cache.GetResource("Model", "Models/"+mesh_convex_+".mdl") );

  	}
}