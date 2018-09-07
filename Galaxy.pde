
class Galaxy extends Component {
  int Arms;
  float ArmLength;
  
  Galaxy(int a, float l){
    Arms = a;
    ArmLength = l;
  }
  
  void Start(){
    Sprite s = new Sprite(assets.getTexture("front"));    
    ParticleSystem p = new ParticleSystem(new GalaxyEmission(this), s, 12f, 20f);
    p.LocalSpace = true;
    p.EndTint = color(255, 0);
    gameObject.AddComponent(p);
  }
  
  // GetCoord: gets the local coordinate position from parameters: arm(0-Arms) and length(0-1). 
  Vector3 GetCoord(int arm, float Length){
    float dist = ArmLength * Length;
    float angle = ((TAU / Arms) * arm) + (dist / 3.2f);
    return new Vector3(sin(angle) * dist, 0, cos(angle) * dist);
  }
  
  
  GameObject CreateRandomSector(){
    ParticleSystem p = new ParticleSystem(new SphereEmission(100f), new Sprite(assets.getTexture("front")), 2f, 3f);
    p.LocalSpace = true;
    p.Scaler = 10;
    GameObject o = new GameObject(new SphereCollider(100), p);
    return o;
  }
}


class GalaxyEmission extends EmissionShape {
  Galaxy galaxy;
  GalaxyEmission(Galaxy g){
    galaxy = g;
  }
  void processParticle(Particle p){  
    p.transform.position.setValue(galaxy.GetCoord((int)random(galaxy.Arms), random(1)));
    p.transform.rotation.SetRandom();
  }
}


void CreateGalaxy(){
  Scene scene = new Scene();
  
  scene.Instantiate("Camera", new Camera());
    
  scene.Instantiate("Boat", new MeshRenderer("GalleonBoat"));
  
  scene.AddObject(CreateShip());

  scene.Instantiate("Galaxy", new Vector3(0), new Vector3(1000), new Quaternion(), new Galaxy(5, 10));
  
  defScene = scene;
}
