

interface IShape {
  
  float Volume();
  float Area();
  float MaxLengthFromPivot();
  
}

class Sphere implements IShape {
  float Radius;
  Sphere(float r){
    Radius = r;
  } 
  float Volume() { return (4 / 3) * PI * pow(Radius, 3); }
  float Area() { return 4 * PI * sq(Radius); }
  float MaxLengthFromPivot() { return Radius; }
}

class Cube implements IShape {
  // Size: the cubes width, height or depth.
  float Size;
  Cube(float s){
    Size = s;
  }
  float Volume() { return pow(Size, 3); }
  float Area() { return 6 * (Size * Size); }
  float MaxLengthFromPivot() { return sqrt(sq(Size) * 3) / 2f; }
}

class Cuboid implements IShape {
  float Width, Height, Depth;
  Cuboid(float w, float h, float d){
    Width = w; Height = h; Depth = d;
  }
  float Volume() { return Width * Height * Depth; }
  float Area() { return (2 * (Width * Height)) + (2 * (Height * Depth)) + (2 * (Width * Depth)); }
  float MaxLengthFromPivot() { return sqrt(sq(Width) + sq(Height) + sq(Depth)) / 2f; }
}

class Cylinder implements IShape {
  float Radius, Height;
  Cylinder(float r, float h){
    Radius = r; Height = h;
  }
  float Volume() { return Height * (TAU * sq(Radius)); }
  float Area() { return (TAU * sq(Radius)) + (Height * (TAU * Radius)); }
  float MaxLengthFromPivot() { return sqrt(sq(Height / 2) + sq(Radius)); }
}

// TODO: the formulas in ConicalFrustum may be wrong 
class ConicalFrustum implements IShape {
  float LowerRadius, UpperRadius, Height;
  ConicalFrustum(float l, float u, float h){
    LowerRadius = l; UpperRadius = u; Height = h;
  }
  float Volume() { return ((PI * Height) / 3) * (sq(LowerRadius) + (LowerRadius * UpperRadius) + sq(UpperRadius)); }
  float Area() { System.err.println("Cone does not have a implementation of Area(), 0 is returnd"); return 0; }
  float MaxLengthFromPivot() { return sqrt(sq(Height / 2) + sq(max(LowerRadius, UpperRadius))); }
}




 
