
interface IOcTreeIndex {
  Vector3 GetPosition();
}

class OcTree<T extends IOcTreeIndex> {
  
  
  class Node{
    Node[] Children; 
  }
}