const int SIDE_NEUTRAL = 0;
const int SIDE_PLAYER = 1;
const int SIDE_ENEMY = 2;

class Actor : ScriptObject{
  bool onGround_;
  bool isSliding_;
  float duration_;
  int health_;
  int maxHealth_;
  int side_;
  int lastDamageSide_;
  uint lastDamageCreatorID_;
  uint creatorID_;

  float speed_;
  float sensitivity_;

  Actor(){
    onGround_ = false;
    isSliding_ = false;
    duration_ = -1; // Infinite
    health_ = 0;
    maxHealth_ = 0;
    side_ = SIDE_NEUTRAL;
    lastDamageSide_ = SIDE_NEUTRAL;
    lastDamageCreatorID_ = 0;
    creatorID_ = 0;

    speed_ = 20.0f;
    sensitivity_ = 0.1f;
  }

  void FixedUpdate(float timeStep){
    // Disappear when duration expired
    if (duration_ >= 0){
      duration_ -= timeStep;
      if (duration_ <= 0)
          node.Remove();
    }
  }

  bool Damage(Actor@ origin, int amount){
    if ((origin.side_ == side_) || (health_ == 0))
        return false;

    lastDamageSide_ = origin.side_;
    lastDamageCreatorID_ = origin.creatorID_;
    health_ -= amount;
    if (health_ < 0)
        health_ = 0;
    return true;
  }

  bool Heal(int amount){
    // By default do not heal
    return false;
  }

  void PlaySound(const String&in soundName){
    // Create the sound channel
    SoundSource3D@ source = node.CreateComponent("SoundSource3D");
    Sound@ sound = cache.GetResource("Sound", soundName);

    source.SetDistanceAttenuation(2, 50, 1);
    source.Play(sound);
    source.autoRemove = true;
  }

  void HandleNodeCollision(StringHash eventType, VariantMap& eventData){
    Node@ otherNode = eventData["OtherNode"].GetPtr();
    RigidBody@ otherBody = eventData["OtherBody"].GetPtr();

    // If the other collision shape belongs to static geometry, perform world collision
    if (otherBody.collisionLayer == 2)
        WorldCollision(eventData);

    // If the other node is scripted, perform object-to-object collision
    Actor@ otherObject = cast<Actor>(otherNode.scriptObject);
    if (otherObject !is null)
      ObjectCollision(otherObject, eventData);
  }

  void WorldCollision(VariantMap& eventData){
    VectorBuffer contacts = eventData["Contacts"].GetBuffer();
    while (!contacts.eof){
      Vector3 contactPosition = contacts.ReadVector3();
      Vector3 contactNormal = contacts.ReadVector3();
      float contactDistance = contacts.ReadFloat();
      float contactImpulse = contacts.ReadFloat();

      // If contact is below node center and mostly vertical, assume it's ground contact
      if (contactPosition.y < node.position.y){
        float level = Abs(contactNormal.y);
        if (level > 0.75)
          onGround_ = true;
        else{
          // If contact is somewhere inbetween vertical/horizontal, is sliding a slope
          if (level > 0.1)
            isSliding_ = true;
        }
      }
    }

      // Ground contact has priority over sliding contact
    if (onGround_ == true)
      isSliding_ = false;
  }

  void ObjectCollision(Actor@ otherObject, VariantMap& eventData){}

  void ResetWorldCollision(){
    RigidBody@ body = node.GetComponent("RigidBody");
    if (body.active){
        onGround_ = false;
        isSliding_ = false;
    }else{
        // If body is not active, assume it rests on the ground
        onGround_ = true;
        isSliding_ = false;
    }
  }
  //------------------------
  //movements
  void move(Vector3 direction, float timeStep){
    node.Translate(direction*speed_*timeStep);
  }
  //------------------------
  //possible helper function
  Node@ Node() { return node; }//this guy lets me call get at this from other scripts

}
