#include "Scripts/shmup/core/Pawn.as";
#include "Scripts/shmup/math/Bezier4.as";

class Behavior{
	Node@ slave_;
	Bezier4@ animCurve_ ;

	int mirror_;//if we mirror this effect
	float speed_=5.0f;//incase we dont find one, we should

	Behavior(Node@ slave, const int&in mirror = 0){
		slave_ = slave;
		Vector3 a = Vector3(0.0,0.0,0.0);
		Vector3 b = Vector3(-10.0,0.0,10.0);
		Vector3 c = Vector3(10.0,0.0,20.0);
		Vector3 d = Vector3(0.0,0.0,30.0);
		//animCurve_ = Bezier4(Vector3(0.0,0.0,0.0),Vector3(1.0,0.0,0.0),Vector3(0.0,2.0,0.0),Vector3(0.0,0.0,3.0));
		animCurve_ = Bezier4(a,b,c,d);

	Pawn@ p = cast<Pawn>(slave_.scriptObject);//get the script that controls this enemy
	speed_ = p.speed_;//get the speed from it to appy here
	}

	void update(float timeStep){
		RigidBody@ body = slave_.GetComponent("RigidBody");
		Pawn@ pawn = cast<Pawn>(slave_.scriptObject);//get the script object, so I can call functions on it
		Node@ target_node = slave_.scene.GetChild("Character",true);//get the main character

		//body_.linearVelocity = body_.linearVelocity+Vector3(0.0f,0.0f,-0.1f);
		//body.linearVelocity = Vector3(0.0f,0.0f,-speed_);
		Vector3 updatePosition =  animCurve_.bezierP(pawn.timeIncrement_ * speed_);
		slave_.position = updatePosition;
		pawn.fire(target_node.worldPosition,timeStep);
	}
}


