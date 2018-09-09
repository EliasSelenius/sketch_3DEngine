

class Tree<T> {
  
  Node Root;
  
  abstract class Node {
    void Insert() {
      
    }
  }
  
  class LeafNode {
  
  }
  
  
}




interface IOcTreeIndex {
  Vector3 GetPosition();
}

OcTree<A> tree = new OcTree<A>(10);

class A implements IOcTreeIndex {
  Vector3 GetPosition(){return null;}
}

class OcTree<T extends IOcTreeIndex> {
  
  OcTreeNode BaseNode;
  
  int MaxDepth;
  
  int MaxCount;
  
  OcTree(float size) {
    BaseNode = new OcTreeNode(size);
  }
  
  void Insert(IOcTreeIndex e){
  
  }
}

class OcTreeNode {
  
  // cube: deffines the borders of this node:
  Cube cube;
  
  // Elements: only leaf nodes has elements, this is null for non-leaf nodes: 
  ArrayList<IOcTreeIndex> Elements = null;
  
  // Children: only non-leaf nodes has children, this is null for leaf nodes:
  OcTreeNode[] Children = null; 
  
  OcTreeNode(float size){
    cube = new Cube(size);
    Elements = new ArrayList<IOcTreeIndex>();
  }
  
  boolean IsLeaf() {
    return Children == null;
  }
  
  void InitChildren() {
    Children = new OcTreeNode[8];
    float s = cube.Size / 2f;
    for(int i = 0; i < Children.length; i++){
      Children[i] = new OcTreeNode(s);
    }
        
  }
  
  void SubDevide() {
  
  }
  
}
