
class OcTreeRenderer extends Component {

  OcTree<Component> ocTree = new OcTree<Component>(10000);
  
  @Override
  void Start() {    

  }
  
  @Override
  void Update() {
    if(input.GetKey('r').Pressed) {
      transform.Translate(new Vector3(10,10,10));
      transform.Rotate(new Vector3(.1,.1,.1));
    } 
    /*
    if(input.GetKey('f').Released) {
      ArrayList nodes = ocTree.GetLeafNodes();
      int r = (int)random(nodes.size());
      Reflect.InvokeMethod(nodes.get(r), "SubDevide");
    }
    */
  }
  
  
  @Override
  void Render() {
    DisplayBuffer.pushMatrix();
    
    DisplayBuffer.translate(transform.position.x, transform.position.y, transform.position.z);    
    DisplayBuffer.scale(transform.scale.x, transform.scale.y, transform.scale.z);          
    Vector4 a = transform.rotation.GetAxisAngle();   
    DisplayBuffer.rotate(a.w, a.x, a.y, a.z);
    
    DisplayBuffer.noFill();
    DisplayBuffer.stroke(0, 255,255);
    
    //DisplayBuffer.box(ocTree.Root.cube.Size);
    

    for(OcTree.OcTreeNode node : ocTree.GetLeafNodes()) {
      DisplayBuffer.pushMatrix();
      DisplayBuffer.translate(node.position.x, node.position.y, node.position.z);
      DisplayBuffer.box(node.cube.Size);
      for(int i = 0; i < node.Elements.size(); i++) {
        Vector3 p = ((OcTree.OcTreeIndex)node.Elements.get(i)).pos.minus(node.position);
        DisplayBuffer.pushMatrix();
        DisplayBuffer.translate(p.x, p.y, p.z);
        DisplayBuffer.sphere(50);
        DisplayBuffer.popMatrix();
      }
      DisplayBuffer.popMatrix();
      println(node.Elements.size());
    }
    
    DisplayBuffer.popMatrix();
  }
}



enum OcTreeLocation {
  RightUpperFront, //111
  LeftUpperFront, // 011
  RightLowerFront, // 101
  LeftLowerFront, // 001
  RightUpperBack, // 110
  LeftUpperBack, // 010
  RightLowerBack, // 100
  LeftLowerBack; // 000
}




class OcTree<T> {
    
  OcTreeNode Root;
    
  int MaxDepth = 9999;
    
  int MaxCount = 1;
  
  OcTree(float size) {
    Root = new OcTreeNode(size, new Vector3(0));
  }
  
  void Insert(T e, Vector3 pos) {
    Root.Insert(e, pos);
  }
  
  ArrayList<OcTreeNode> GetLeafNodes() {
    ArrayList<OcTreeNode> list = new ArrayList<OcTreeNode>();
    Root.GetLeafNodes(list);
    return list;
  }
  
  T GetObject(Vector3 pos) {
    for(OcTreeNode node : GetLeafNodes()) {
      T o = node.GetObject(pos);
      if(o == null) {
        continue;
      } else {
        return o;
      }
    }
    return null;
  }
  
  void SubDevide() {
    for(OcTreeNode node : GetLeafNodes()) {
      node.SubDevide();
    }
  }
  
  class OcTreeIndex {
    T obj;
    Vector3 pos;
    OcTreeIndex(T o, Vector3 p){
      obj = o;
      pos = new Vector3(p);
    }
  }
  
  final Vector3[] OcTreeNodeLocations = {
    new Vector3(1,1,1),
    new Vector3(-1,1,1),
    new Vector3(1,-1,1),
    new Vector3(-1,-1,1),
    new Vector3(1,1,-1),
    new Vector3(-1,1,-1),
    new Vector3(1,-1,-1),
    new Vector3(-1,-1,-1)
  };
  
  class OcTreeNode {
    
    // cube: deffines the borders of this node:
    Cube cube;
    // position: this nodes position:
    Vector3 position;
    
    // Elements: only leaf nodes has elements, this is null for non-leaf nodes: 
    ArrayList<OcTreeIndex> Elements = null;
    
    // Children: only non-leaf nodes has children, this is null for leaf nodes:
    //HashMap<OcTreeLocation, OcTreeIndex> Children = null; 
    ArrayList<OcTreeNode> SubNodes = null;
    
    
    OcTreeNode(float size, Vector3 pos) {
      cube = new Cube(size);
      position = pos;
      Elements = new ArrayList<OcTreeIndex>();
    }
    
    void Insert(OcTreeIndex i) {
      Insert(i.obj, i.pos);
    }
    
    void Insert(T e, Vector3 pos) {
      if(IsLeaf()){
        if(Elements.size() == MaxCount){
          SubDevide();
          // TODO: is there a more satisfactory solution here?
          Insert(e, pos);
        } else {
          Elements.add(new OcTreeIndex(e, pos));
        }
      } else {
        
        Vector3 p = pos.minus(position);
        Vector3 dir = new Vector3(Math.Normelized(p.x), Math.Normelized(p.y), Math.Normelized(p.z));
        int index = -1;
        for(int i = 0; i < 8; i++) {
          if(dir.Equal(OcTreeNodeLocations[i])) {
            index = i;
            break;
          }
        }
        
        OcTreeNode node = SubNodes.get(index);
        node.Insert(e, pos);
      }
    }
    
    T GetObject(Vector3 pos) {
      if(Elements != null) {
        for(OcTreeIndex i : Elements) {
          if(i.pos.Equal(pos)) {
            return i.obj;
          }
        }
      }
      return null;
    }
    
    boolean IsLeaf() {
      return SubNodes == null;
    }
    
    void GetLeafNodes(ArrayList<OcTreeNode> list) {
      if(IsLeaf()) {
        list.add(this);
      } else {
        for(OcTreeNode node : SubNodes) {
          node.GetLeafNodes(list);
        }
      }
    }
    
    void SubDevide() {
      if(IsLeaf()) {
        SubNodes = new ArrayList<OcTreeNode>();
        float s = cube.Size / 2f;
        for(int i = 0; i < 8; i++){
          SubNodes.add(new OcTreeNode(s, position.plus(new Vector3(OcTreeNodeLocations[i].multiply(s / 2f)))));
        }
        for(int i = 0; i < Elements.size(); i++) {
          Insert(Elements.get(i));
        }
        Elements = null;
      } else {
        for(OcTreeNode node : SubNodes) {
          node.SubDevide();
        }
      }
    } 
  }
}
