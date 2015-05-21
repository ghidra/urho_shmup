#include "Scripts/enemies/Enemy.as"

class HexSpawn:Enemy{

	HexSpawn(){
		mesh_="hex_hive_ship_01";
		mesh_convex_="hex_hive_ship_shape_01";
		speed_=10.0f;
	}

	void set_parameters(String wtype,String btype, float fire_rate, Vector3 pos=Vector3(), Quaternion rot=Quaternion(), float scl=1.0){//this all comes in from the enemy factory
	    //etype, ctype, wtype, btype, firerate (enemy type, class type, weapon type, behavior type, fire rate)
	    build_geo(mesh_,material_,3.0f);
	    mesh_material_.shaderParameters["ObjectBlend"]=Variant(1.0f);
	    //node.position=Vector3(8.0,0.0,8.0);
	    node.position=pos;
	    node.rotation=rot;
	    //get some random numbers foe noise offset
	    set_behavior(btype);

	    //WeaponBank@ wb = get_weaponbank();
	    //wb.set_weapon(0,"Weapon",fire_rate,1);

	    healthbar_ = node.CreateChild("healthbar");
	    ProgressBar@ bar = cast<ProgressBar>(healthbar_.CreateScriptObject(scriptFile, "ProgressBar"));
	    bar.set_parameters(maxHealth_*1.0,maxHealth_*1.0);
  	}

}