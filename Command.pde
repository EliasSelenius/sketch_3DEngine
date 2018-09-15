
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
    return new String[] {script + " is not a script"};
  }
  
  String[] ExecuteLine(String line){
    String[] args = line.split(" ");
    switch(args[0]){
      case "find":
        String[] path = args[1].split("\\.");
        Global = Reflect.GetObject(This, path[0]);
        for(int i = 1; i < path.length; i++){
          Global = Reflect.GetObject(Global, path[i]);
        }
        break;
      case "set":
        vars.put(args[1], Global);
        Global = null;
        break;
      case "get":
        Global = vars.get(args[1]);
        break;
      case "print":
        println("print: " + Global.toString());
        break;
      case "invoke":
        Reflect.InvokeMethod(Global, args[1]);
        break;
      default:
        return ExecuteScript(args[0]);
    }
    // This will never happen:
    return null;
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
