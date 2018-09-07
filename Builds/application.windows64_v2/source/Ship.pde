

GameObject CreateShip(){
  ParticleSystem p = new ParticleSystem(new PointEmission(2, 7), new Sprite(assets.getTexture("front")), 30f, 10f);
  MeshRenderer mr = new MeshRenderer("GalleonBoat");
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
  
  void Start(){
    h = input.getAxis("Horizontal");
    v = input.getAxis("Vertical");
    r = input.getAxis("Roll");
    p = (Physics)GetComponent(Physics.class);
    
    input.mouseMode = MouseMode.Locked;
  }
  
  
  void Update(){
    //p.addTorque(new Vector3(-input.mouseMove.y / 1500f, input.mouseMove.x / 1500f, -r.Value / 20f));    
    //p.addForce(transform.Forward().multiply(v.Value * Force).plus(transform.Right().multiply(-h.Value * Force)));
    
    camZoom += input.mouseWheel;
    
    //gameObject.scene.camera.transform.position = transform.position.plus(transform.Forward().multiply(camZoom).plus(transform.Up().multiply(10)));
    
    Quaternion q = new Quaternion();
    q.SetEuler(new Vector3(0, PI, PI));
    //gameObject.scene.camera.transform.rotation = transform.rotation.multiply(q);
    
    if(input.getKey('f').Pressed){
      p.Velocity.setValue(0);
      p.AngularVelocity.setValue(0);
    }
  }
}