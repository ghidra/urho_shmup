#include "Scripts/enemies/Behavior.as";
#include "Scripts/math/Perlin.as"

class BehaviorNoise:Behavior{

	Perlin@ noise_;
	Vector2 offsetx_;// = Vector2(0.0f,0.0f);
	Vector2 offsety_;// = Vector2(10.0f,23.0f);

	BehaviorNoise(Node@ slave, const int&in mirror = 0){
		super(slave,mirror);
		//slave_ = slave;
		//Pawn@ p = cast<Pawn>(slave_.scriptObject);//get the script that controls this enemy
		//speed_ = p.speed_;
		offsetx_ = Vector2(Random(999),Random(999));
	    offsety_ = Vector2(Random(999),Random(999));

		noise_= Perlin(); 
	}

	void update(float timeStep){
		//Print("in here instea");
		inc_+=timeStep;

		RigidBody@ body = slave_.GetComponent("RigidBody");
		Pawn@ pawn = cast<Pawn>(slave_.scriptObject);//get the script object, so I can call functions on it
		Node@ target_node = slave_.scene.GetChild("Character",true);//get the main character

		lastPosition_ = slave_.position;

		float nx = noise_.simplex2(slave_.position.x,slave_.position.z,0.01f,0.01f,offsetx_.x+inc_,offsetx_.y+inc_);
      	float nz = noise_.simplex2(slave_.position.x,slave_.position.z,0.01f,0.01f,offsety_.x+inc_,offsety_.y+inc_);
      	
      	//Vector3 d2 = slave_.position+Vector3(nx,0.0f,nz);
      	//Vector3 d1 = slave_.position;
      	//Vector3 newd = d2-d1;

      	Vector3 nd = Vector3(nx,0.0f,nz);
      	nd.Normalize();
      	nd = nd.Lerp(travelDirection_,0.9);//smooth it way out based on the direction of travel
      	nd = nd*speed_*timeStep;//attach to it the speed we want to travel


		Vector3 updatePosition =  slave_.position+nd;//slave_.position+newd;//animCurve_.bezierP(pawn.timeIncrement_ * speed_);
		slave_.position = updatePosition ;

		orient();

		pawn.fire(target_node.worldPosition,timeStep);
	}
}
