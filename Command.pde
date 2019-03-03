
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
        Global = Reflect.GetObjectSuper(App, path[0]);
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
    
  void LoadScript() {
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


class RilPack {
	RilScript[] Scripts;

	void LoadFromConfig(XML xml) {

	}
}

class RilScript { 
	
	String Name;
	
	RilFunction[] Functions;

	Log log = new Console(); // new Console is temp until we get inGame console

	Object baseObject;

	RilScript(String path, Object base) {
		baseObject = base;
		File f = new File(path);
		Name = f.getName();
		LoadFromFile(f);
	}

	void LoadFromFile(File f) {
		Parse(ConcatStringArray(loadStrings(f)));
	}

	void Parse(String source) {
		String[][] match = null;
		match = matchAll(source, "func (\\w+) \\{((.|\\n)+?)\\}");
		Functions = new RilFunction[match.length];
		for (int i = 0; i < match.length; i++) {
			Functions[i] = new RilFunction(match[i][1], match[i][2], this);
		}
	}

	Object ExecuteFunc(String name) { 
		for(RilFunction f : Functions) { 
			if(f.Name.equals(name)) {
				return f.Execute();
			}
		}
		return null; // todo: throw error
	}	
}

class RilFunction {
	String Name;
	String[] body;
	String currentExpression;

	RilScript script = null;
	Log log = null;

	Object baseObject;
	Object currentObject;
	HashMap<String, Object> locals = new HashMap<String, Object>();
	Object returnValue;

	int execIndex = 0;

	void Parse(String source) {
		String[][] match = matchAll(source, "(\\b|\").+?;"); // <-- GetRilExpressions regex
		if(match == null) {
			return;
		}
		body = new String[match.length];
		for(int i = 0; i < match.length; i++) {
			body[i] = match[i][0].substring(0, match[i][0].length() - 1); // substring() to remove the semi at the end
		}
	}

	// used when the RilFunction doesnt belong to a RilScript
	RilFunction(String name, String source, Log l, Object base) {
		Name = name;
		log = l;
		baseObject = (base == null)? App : base;
		Parse(source);
	}

	RilFunction(String name, String source, RilScript s) {
		Name = name;
		script = s;
		log = script.log;
		baseObject = script.baseObject;
		Parse(source);
	}

	void Reset() {
		currentObject = null;
		locals = new HashMap<String, Object>();
		returnValue = null;
		currentExpression = null;
	}

	Object Execute() {

		Reset();
		
		for(execIndex = 0; execIndex < body.length; execIndex++) {
			currentExpression = body[execIndex];
			EvaluateExpression(currentExpression);
		}

		return returnValue;
	}

	void Interrupt() {
		execIndex = body.length;
	}

	void Return(Object o) {
		returnValue = o;
		Interrupt();
	}

	void EvaluateExpression(String string) {	
		ArrayList<String> parsed = SepperateString(string);
		String type = parsed.get(0);

		if(type.equals("print")) {
			log.Write(currentObject);
			return;
		}


		else if(type.equals("set")) {
			locals.put(parsed.get(1), currentObject);
			return;
		}


		else if(type.equals("return")) {
			Return(StringToObject(parsed.get(1)));
			return;
		}


		currentObject = StringToObject(parsed);
	}

	

	Object FindJavaObject(String path) {
		Object o;
		String[] split = path.split("\\.");
		if(split[0].equals("*")) {
			o = currentObject;
		} else if (split[0].equals("this")) {
			return baseObject;
		} else {
			o = Reflect.GetObjectSuper(baseObject, split[0]);
		}
		for(int i = 1; i < split.length; i++){
			o = Reflect.GetObjectSuper(o, split[i]);
		}
		return o;
	}

	Object StringToObject(String string) {
		return StringToObject(SepperateString(string));
	}


	Object StringToObject(ArrayList<String> parsed) {
		String type = parsed.get(0);


		// int
		try {
			return Integer.parseInt(type);
		} catch (NumberFormatException e) {  } // not an integer, continue...



		// float
		Float f = float(type);
		if(!f.isNaN()) {
			return f;
		}


		// null
		else if(type.equals("null")) {
			return null;
		}


		// bool
		else if(type.equals("true")) {
			return true;
		} else if (type.equals("false")) {
			return false;
		}


		// String
		else if(type.charAt(0) == '\"') {
			return type.substring(1, type.length());
		}


		// todo: throw error when the method isnt found
		else if(type.equals("invoke")) {
			if(currentObject == null) { ThrowError("Cannot invoke on null value"); return null; }
			Object[] args = new Object[parsed.size() - 2];
			for(int i = 2; i < parsed.size(); i++) { 
				args[i - 2] = StringToObject(parsed.get(i));
			}
			return Reflect.InvokeMethodSuper(currentObject, parsed.get(1), args);
		}


		else if(type.equals("get")) {
			return locals.get(parsed.get(1));
		}


		else if(type.equals("find")) {
			return FindJavaObject(parsed.get(1));
		}


		else if(type.equals("typeof")) {
			return Reflect.GetType(StringToObject(parsed.get(1)));
		}


		else if(type.equals("call")) {
			return script.ExecuteFunc(parsed.get(1));
		}


		// class type
		Class c = Reflect.GetClass(type);
		if(c != null) { // its a class
			ArrayList<Object> args = new ArrayList<Object>();
			for(int i = 1; i < parsed.size(); i++) {
				args.add(StringToObject(parsed.get(i)));
			}
			return Reflect.InstantiateObject(c, args.toArray(new Object[args.size()]));
		}



		println("THERE WAS AN ERROR IN: StringToObject");
		// use ThrowError() method...
		return null;	
	}


	void ThrowError(String msg) {
		log.Write("There was an error in func " + Name);
		log.Write("at " + currentExpression);
		log.Write(msg + ". At expression index: " + execIndex);
		if(script != null) {
			log.Write("in " + script.Name + "\n");
		}
		
	}

}



class RilComponent extends Component {
	
	RilScript script;

	RilComponent(String path) {
		script = new RilScript(path, this); 
	}
	
	@Override 
	void Start() {
		script.ExecuteFunc("Start");
	}

	@Override
	void Update() {
		script.ExecuteFunc("Update");
	}

	@Override
	void Render() {
		script.ExecuteFunc("Render");
	}

	@Override
	void End() {
		script.ExecuteFunc("End");
	}
}


void TestStringToObject() {

	RilScript s = new RilScript(assets.DataPath + "\\Scripts\\newandbetterTest.ril", App);
	//s.ExecuteFunc("main");

	RilScript myRilS = new RilScript(assets.DataPath + "\\Scripts\\myRilScript.ril", App);
	myRilS.ExecuteFunc("main");

	
	println(SepperateString("return (invoke GetComponent (typeof (Physics 1f)))"));
}


String InnerSubString(String string) {
	int start = 0;
	for(int i = 0; i < string.length(); i++) {
		char c = string.charAt(i);
		if(c == '(') {
			start = i;
		} else if(c == ')') {
			return string.substring(start + 1, i);
		}
	}
	return string;
}



ArrayList<String> SepperateString(String string) {
	ArrayList<String> res = new ArrayList<String>();
	for(int i = 0; i < string.length(); i++) {
		char c = string.charAt(i);
		if (c == '(') {
			int newindex = indexOfEndParentes(string, i);
			res.add(string.substring(i + 1, newindex));
			i = newindex + 1;
		} else if (c == '"') {
			int newindex = indexOfNextChar(string, i, '\"');
			res.add(string.substring(i, newindex));
			i = newindex;
		} else if (c != ' ' || c != '\n') {
			int newindex = nextIndexThatIsWhitespace(string, i);
			res.add(string.substring(i, newindex));
			i = newindex;
		}
	}
	return res;
}

int indexOfNextChar(String string, int startPoint, char c) {
	for(int i = startPoint + 1; i < string.length(); i++) {
		if(string.charAt(i) == c) {
			return i;
		}
	}
	return string.length();
}

int indexOfEndParentes(String string, int startPoint) {
	int startIndex = startPoint;
	int index = startIndex;
	int count = 1;

	while(count != 0) {
		index++;
		char c = string.charAt(index);

		if(c == '(') {
			count++;
		} else if(c == ')') {
			count--;
		}
	}

	return index;
}

int nextIndexThatIsWhitespace(String string, int startPoint) {
	for(int i = startPoint + 1; i < string.length(); i++) {
		char c = string.charAt(i);
		if(c == ' ' || c == '\n') {
			return i;
		}
	}
	return string.length();
}


String[] GetSubstrings(String string) {
	ArrayList<String> res = new ArrayList<String>();

	int start = 0;
	int end = 0;

	// Transform (Vector3 10) (Vector3 1) (Quaternion)

	for(int i = 0; i < string.length(); i++) {
		char c = string.charAt(i);
		if (c == ' ') {
			end = i;
			res.add(string.substring(start, end));
			start = end;
		} else if(i == string.length() - 1) {
			res.add(string.substring(start, string.length()));
		} else if(c == '(') {
			String sub = string.substring(i, string.length());
			int count = 1;
			int whileIndex = 0;
			while (count != 0) {
				whileIndex++;
				char ch = sub.charAt(whileIndex);
				if (ch == '(') {
					count++;
				} else if(ch == ')'){
					count--;
				}
			}
			i += whileIndex;
		}
	}

	return res.toArray(new String[0]);
}



String FirstSubstring(String string) {
	int startIndex = string.indexOf('(');
	int index = startIndex;
	int count = 1;

	while(count != 0) {
		index++;
		char c = string.charAt(index);

		if(c == '(') {
			count++;
		} else if(c == ')') {
			count--;
		}
	}

	return string.substring(startIndex + 1, index);
}

