#include "Scripts/enemies/Behavior.as";
#include "Scripts/math/Perlin.as"

class BehaviorNoise:Behavior{

	Perlin@ noise_;

	BehaviorNoise(Node@ slave, const int&in mirror = 0){
		super(slave,mirror);
		//slave_ = slave;
		//Pawn@ p = cast<Pawn>(slave_.scriptObject);//get the script that controls this enemy
		//speed_ = p.speed_;
		noise_= Perlin(); 
	}

	void update(float timeStep){
		//Print("in here instea");
		RigidBody@ body = slave_.GetComponent("RigidBody");
		Pawn@ pawn = cast<Pawn>(slave_.scriptObject);//get the script object, so I can call functions on it
		Node@ target_node = slave_.scene.GetChild("Character",true);//get the main character

		lastPosition = slave_.position;

		float nx = noise_.simplex2(slave_.position.x,slave_.position.z,100.0f,100.0f);
      	float nz = noise_.simplex2(slave_.position.x,slave_.position.z,100.0f,100.0f,10.0f,33.0f);
      	Vector3 d2 = Vector3(nx,nz,0.0f);
      	Vector3 d1 = slave_.position;
      	//float ds = d1.length;
      	Vector3 newd = d2-d1;
      	newd.Normalize();
      	newd = newd*speed_*timeStep;


		Vector3 updatePosition =  slave_.position+newd;//animCurve_.bezierP(pawn.timeIncrement_ * speed_);
		slave_.position = updatePosition ;

		Vector3 travelDirection = updatePosition-lastPosition;
		travelDirection.Normalize();
		Quaternion align = Quaternion();
		align.FromLookRotation(travelDirection,Vector3(0.0,1.0,0.0));
		slave_.rotation=align;
		pawn.fire(target_node.worldPosition,timeStep);
	}
}
