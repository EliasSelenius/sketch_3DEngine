
class CommandExecutor {
  
  // Scripts: scripts loaded from a file
  Script[] Scripts;
  
  // Global: reference to an object in the application
  Object Global;
  
  HashMap<String, Object> vars = new HashMap<String, Object>();
  
  String[] ExecuteScript(String script) {
    for(Script s : Scripts){
      if(s.name.equals(script)){
        return s.Execute();
      }
    }
    return new String[] {script + " was not found in memory."};
  }
  
  String[] ExecuteLine(String line) {
    String[] args = line.split(" ");
    switch(args[0]){
      case "find":
        String[] path = args[1].split("\\.");
        Global = Reflect.GetObjectSuper(This, path[0]);
        for(int i = 1; i < path.length; i++){
          Global = Reflect.GetObjectSuper(Global, path[i]);
        }
        break;
      case "set":
        vars.put(args[1], Global);
        break;
      case "get":
        Global = vars.get(args[1]);
        break;
      case "print":
        println("print: " + ((Global == null)? "null" : Global.toString()));
        break;
      case "invoke":
        Global = InvokeCommand(Global, args[1], (ArrayList)ExcludeIndices(args, 0, 1));
        break;
      case "exec":
        ExecuteScript(args[1]);
        break;
      case "use":
        Global = InitObject(args[1], ExcludeIndices(args, 0, 1).toArray(new String[args.length - 2]));
    }
    return new String[] { line + " Not recognized, There is probably a syntax error..." };
  }
  
  Object InitObject(String obj, String... args) {
    // check for primitive value-type (String, float, bool)
    Float f = float(obj);
    if(!f.isNaN()) {
      return f;
    } else if(obj.equals("true")) {
      return true;
    } else if(obj.equals("false")) {
      return false;
    } else if(obj.equals("null")) {
      return null;
    }else if(obj.charAt(0) == '\"') {
      return obj.substring(1, obj.length() - 1);
    } else if(obj.equals("get")) {
      return vars.get(args[0]);
    }
    // if its not a primitive:
    if(args.length > 0) {
      Object[] arry = new Object[args.length];
      for(int i = 0; i < args.length; i++) {
        arry[i] = InitObject(args[i]);
      }
      return Reflect.InstantiateObject(Reflect.GetClass(obj), arry);
    } else {
      return Reflect.InstantiateObject(Reflect.GetClass(obj));
    }
  }
  
  Object InvokeCommand(Object o, String name, ArrayList<String> args) {
    if(args.size() > 0) {
      Object[] a = new Object[args.size()];
      boolean skipnext = false;
      for(int i = 0; i < a.length; i++) {
        a[i] = InitObject(args.get(i), args.get(i + 1));
      }
      return Reflect.InvokeMethod(o, name, a);
    } else {
      return Reflect.InvokeMethod(o, name);
    }
  }
    
  void LoadScript(){
    File dir = new File(sketchPath() + "\\data\\Scripts");
    File[] files = dir.listFiles();
    Scripts = new Script[files.length];
    for(int i = 0; i < Scripts.length; i++){
      //println(files[i].getName());
      Scripts[i] = new Script(files[i].getName(), loadStrings(files[i]));
    }
  }
  
  class Script {
    String name;
    String[] text;
    Script(String n, String... t){
      name = n; text = t;
    }
    String[] Execute(){
      String[] log = new String[text.length];
      for(int i = 0; i < text.length; i++){
        ExecuteLine(text[i]);
      }
      return log;
    }
  }
}
