
interface IOcTreeIndex {
  Vector3 GetPosition();
}

class OcTree<T extends IOcTreeIndex> {
  
  Node BaseNode;
  
  int MaxDepth;
  
  int MaxCount;
  
  OcTree(float size) {
    BaseNode = new Node(size);
  }
  
  void Insert(IOcTreeIndex e){
  
  }
  
 
  
  class Node {
    
    // cube: deffines the borders of this node:
    Cube cube;
    
    // Indices: only leaf nodes has elements, this is null for non-leaf nodes: 
    ArrayList<IOcTreeIndex> Elements = null;
    
    // Children: only non-leaf nodes has children, this is null for leaf nodes:
    Node[] Children = null; 
    
    Node(float size){
      cube = new Cube(size);
    }
    
    boolean IsLeaf() {
      return Children == null;
    }
    
    void InitChildren() {
      Children = new Node[8];
      
      
    }
    
    void SubDevide() {
    
    }
    
  }
}
