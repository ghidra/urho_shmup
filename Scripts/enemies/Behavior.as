#include "Scripts/shmup/core/Pawn.as";
#include "Scripts/shmup/math/Bezier4.as";

class Behavior{
	Node@ slave_;
	Bezier4@ animCurve_ ;

	int mirror_;
	float speed_=0.005f;

	Behavior(Node@ slave, const int&in mirror = 0){
    slave_ = slave;
		/*Vector3 p0 = Vector3(-84.9794235229, 0.0, -240.153991699);
		Vector3 p1 = Vector3(-67.889213562, 0.0, -167.996002197);
		Vector3 p2 = Vector3(-16.3671989441, 0.0, -7.65077877045);
		Vector3 p3 = Vector3(-72.0755996704, 0.0, -12.5232925415);
		Vector3 p4 = Vector3(-141.126998901, 0.0, -12.5232868195);
		Vector3 p5 = Vector3(-154.447998047, 0.0, -75.8831787109);
		Vector3 p6 = Vector3(37.1620941162, 0.0, -51.8318023682);
		Vector3 p7 = Vector3(97.4971008301, 0.0, -39.6286087036);
		Vector3 p8 = Vector3(71.134223938, 0.0, 240.774993896);
		Vector3 p9 = Vector3(295.92199707, 0.0, -35.4511260986);*/

		Vector3 p0 = Vector3(-0.849794235229, 0.0, -2.40153991699);
		Vector3 p1 = Vector3(-0.67889213562, 0.0, -1.67996002197);
		Vector3 p2 = Vector3(-0.163671989441, 0.0, -0.0765077877045);
		Vector3 p3 = Vector3(-0.720755996704, 0.0, -0.125232925415);
		Vector3 p4 = Vector3(-1.41126998901, 0.0, -0.125232868195);
		Vector3 p5 = Vector3(-1.54447998047, 0.0, -0.758831787109);
		Vector3 p6 = Vector3(0.371620941162, 0.0, -0.518318023682);
		Vector3 p7 = Vector3(0.974971008301, 0.0, -0.396286087036);
		Vector3 p8 = Vector3(0.71134223938, 0.0, 2.40774993896);
		Vector3 p9 = Vector3(2.9592199707, 0.0, -0.354511260986);
		/*Vector3 p0 = Vector3(-5.0, 0.0, 5.0);
		Vector3 p1 = Vector3(5.0, 0.0, 5.0);
		Vector3 p2 = Vector3(5.0, 0.0, -5.0);
		Vector3 p3 = Vector3(-5.0, 0.0, -5.0);
		Vector3 p4 = Vector3(0.0, 0.0, 4.0);
		Vector3 p5 = Vector3(0.0, 0.0, 5.0);
		Vector3 p6 = Vector3(0.0, 0.0, 6.0);
		Vector3 p7 = Vector3(0.0, 0.0, 7.0);
		Vector3 p8 = Vector3(0.0, 0.0, 8.0);
		Vector3 p9 = Vector3(0.0, 0.0, 9.0);*/
		Array<Vector3> bp = {p0, p1, p2, p3, p4, p5, p6, p7, p8, p9};
		animCurve_ = Bezier4(bp);

	Pawn@ p = cast<Pawn>(slave_.scriptObject);//get the script that controls this enemy
	speed_ = p.speed_;//get the speed from it to appy here
	}

	void update(float timeStep){
		RigidBody@ body = slave_.GetComponent("RigidBody");
		Pawn@ pawn = cast<Pawn>(slave_.scriptObject);//get the script object, so I can call functions on it
		Node@ target_node = slave_.scene.GetChild("Character",true);//get the main character

		//body_.linearVelocity = body_.linearVelocity+Vector3(0.0f,0.0f,-0.1f);
		//body.linearVelocity = Vector3(0.0f,0.0f,-speed_);
		Vector3 updatePosition =  animCurve_.bezierP(pawn.timeIncrement_ * 0.5);
		slave_.position = updatePosition ;
		//+ Vector3(0.0f ,0.0f ,-20.0f + (pawn.timeIncrement_ * -speed_)
		pawn.fire(target_node.worldPosition,timeStep);
	}
}
