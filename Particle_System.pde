


class Particle {
  Transform transform;
  Vector3 Velocity;
  Vector3 AngularVelocity;
  
  // LifeTime in seconds.
  float LifeTime;
  // Speed in units per seconds
  float Speed;
  
  Particle(){
    transform = new Transform();
    Velocity = new Vector3();
    AngularVelocity = new Vector3();
    Speed = 1;
  }
  
  void Update(){
    LifeTime += deltaTime;
    transform.Translate(Velocity.multiply(Speed * deltaTime));
    transform.Rotate(AngularVelocity.multiply(deltaTime));
  }  
}




class ParticleSystem extends Component {
  
  
  // Emission: settings for the start velocity and position.
  EmissionShape Emission;
  // emissionRate: how many particles gets emitted each second.
  float EmissionRate;
  // MaxLifeTime: particles max lifetime in seconds.
  float MaxLifeTime;
  // renderObj: the way all the particles gets renderd.
  RenderObject renderObj;
  // LocalSpace: does the particles simulate in local space or world space.
  boolean LocalSpace = false;
  // Scaler: scales the particles.
  float Scaler = 1;
  
  // StartTint: the start tint color of the RenderObject(Particle).  
  color StartTint = color(255, 255);
  // EndTint: the end tint color of the RenderObject(Particle).
  color EndTint = color(255, 255);
  
  
  
  ParticleSystem(EmissionShape emt, RenderObject renobj, Float rate, Float time){
    Emission = emt;
    renderObj = renobj;
    EmissionRate = rate;
    MaxLifeTime = time;
  }
  
  ArrayList<Particle> particles = new ArrayList<Particle>();
  float particlesQued;
  
  // Draw(): Draws the Particles in its current state, this does not Update the Physics.
  @Override
  void Render(){
  
    WorldGraphics.pushMatrix();
    if(LocalSpace){
      WorldGraphics.translate(transform.position.x, transform.position.y, transform.position.z);
      WorldGraphics.scale(transform.scale.x, transform.scale.y, transform.scale.z);
      Vector4 axisAngle = transform.rotation.GetAxisAngle();
      WorldGraphics.rotate(axisAngle.w, axisAngle.x, axisAngle.y, axisAngle.z);
    }    
    

    for(int i = 0; i < particles.size(); i++){
      Particle p = particles.get(i);
      float t = p.LifeTime / MaxLifeTime;
      renderObj.TintColor = lerpColor(StartTint, EndTint, t);
      renderObj.Render(p.transform.position, p.transform.scale.multiply(Scaler), p.transform.rotation);
    }
    
    WorldGraphics.popMatrix();
  }
  
  // Update(): Updates the Physics of each particle.
  @Override
  void Update() {
    // Update Particles. kill particle:
    for(int i = 0; i < particles.size(); i++){
      Particle p = particles.get(i);
      p.Update();
      if(p.LifeTime > MaxLifeTime){
        particles.remove(i);
      }
    }
    
    // create new particles:
    Burst(EmissionRate / frameRate); 
  }
  
  // Burst(): instantly spawns the number of particles specified. 
  void Burst(float burstNum){
    particlesQued += burstNum;
    for(int i = 0; i < floor(particlesQued); i++){
      NewParticle();
    }
    particlesQued -= floor(particlesQued);
  }
  
  // NewParticle(): spawns a new Particle in the system.
  void NewParticle(){   
    Particle p = Emission.NewParticle();
    if(!LocalSpace){
      p.transform.position.addVec(transform.position);     
    }    
    particles.add(p);
  }
  
}






// class EmissionShape: used by a ParticleSystem to know the start location and velocity of a particle.
abstract class EmissionShape{
  float StartMinVelocity = 0f;
  float StartMaxVelocity = 0f;  
  final Particle NewParticle(){
    Particle p = new Particle();    
    processParticle(p);    
    return p; 
  }
  abstract void processParticle(Particle p);
}
 
class PointEmission extends EmissionShape {  
  PointEmission(float min, float max){
    StartMinVelocity = min;
    StartMaxVelocity = max;
  }
  void processParticle(Particle p){
    p.Velocity.setRandomNormelizedDirection();
    p.Velocity = p.Velocity.multiply(random(StartMinVelocity, StartMaxVelocity));    
  }
}

class SphereEmission extends EmissionShape {  
  float radius;
  SphereEmission(float r){
    radius = r;
  }
  SphereEmission(float minvel, float maxvel, float r){
    StartMinVelocity = minvel;
    StartMaxVelocity = maxvel;
    radius = r;
  }
  void processParticle(Particle p){
    Vector3 dir = new Vector3();
    dir.setRandomNormelizedDirection();      
    p.transform.position.setValue(dir.multiply(random(0f, radius)));
    p.Velocity.setValue(dir.multiply(random(StartMinVelocity, StartMaxVelocity)));
  }
}

class ConeEmission extends EmissionShape{
  ConeEmission(){
  
  }
  void processParticle(Particle p){
    p.Velocity.setValue(1f,1f,1f);
    Vector2 t = new Vector2(p.Velocity.x, p.Velocity.y);
    t.Normelize();
    float theta = (t.Magnitude() / p.Velocity.z) * 45;
    
    //println(theta);
  }
}
