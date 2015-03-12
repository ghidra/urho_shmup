#include "Scripts/enemies/Behavior.as"
#include "Scripts/enemies/BehaviorNoise.as"

class BehaviorManager{
	Behavior@ behavior_;
	BehaviorManager(Node@ n,String btype="Behavior"){
		if(btype=="Behavior") behavior_ = Behavior(n);
		if(btype=="BehaviorNoise") behavior_ = BehaviorNoise(n);
	}
}