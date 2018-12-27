

GameObject CreateShip(){
  ParticleSystem p = new ParticleSystem(new PointEmission(2, 7), new Sprite(assets.getTexture("front")), 30f, 10f);
  MeshRenderer mr = new MeshRenderer("spaceCraft");
  float m = mr.mesh.MaxLengthFromPivot();
  GameObject o = new GameObject(new SphereCollider(m), new Physics(1f), new SpaceShip(), p, mr);
  o.Name = "PlayerShip";
  o.transform.position.y = 200;

  return o;
}


class SpaceShip extends Component {
  float G(){return 0;}
  InpAxis h, v, r;
  Physics p;
  float camZoom = 20;
  float Force = 5;
  
  Transform cam;
  
  void Start(){
    h = input.GetAxis("Horizontal");
    v = input.GetAxis("Vertical");
    r = input.GetAxis("Roll");
    p = (Physics)GetComponent(Physics.class);
    
    //cam = gameObject.scene.FindObject("Camera").transform;
    input.mouseMode = MouseMode.Locked;
  }
  
  
  void Update(){
    p.addTorque(new Vector3(-input.mouseMove.y / 1500f, input.mouseMove.x / 1500f, -r.Value / 20f));    
    p.addForce(transform.Forward().multiply(v.Value * Force).plus(transform.Right().multiply(-h.Value * Force)));
    
    camZoom += input.mouseWheel;
    
    cam.position.setValue(transform.position.plus(transform.Forward().multiply(camZoom).plus(transform.Up().multiply(10f))));
    
    Quaternion q = new Quaternion();
    q.SetEuler(new Vector3(0f, PI, PI));
    
    cam.rotation.setValue(transform.rotation.multiply(q));
    
    if(input.GetKey('f').Pressed){
      p.Velocity.setValue(0f);
      p.AngularVelocity.setValue(0f);
    }
  }
}
