#library('dagali');

#import('dart:html');

class Resource {
  var element;
  String source;
  bool loaded;
  
  Resource(this.element, this.source, this.loaded) {
    this.element.on.load.add((e) => this.loaded = true);
  }
  
  void load() {
    this.element.src = this.source;
  }
}


class EventListeners implements EventListenerList {
  var listeners;

  EventListeners() {
    this.listeners = [];
  }

  EventListeners add(EventListener handler, [bool useCapture]) {
    this.listeners.add(handler);
    return this;
  }
  
  EventListeners remove(EventListener handler, [bool useCapture]) {
    var index = listeners.indexOf(handler);
    listeners.removeRange(index, index);
    return this;
  }

  bool dispatch(Event event) {
    listeners.forEach((fn) {fn(event);});
    return true;
  }
}


class ResourceManagerEvents {
  EventListeners load;
  
  ResourceManagerEvents() {
    this.load = new EventListeners();
  }
}


class ResourceManager {
  ResourceManagerEvents on;
  List<Resource> resources;
  
  ResourceManager() {
    this.resources = new List<Resource>();
    this.on = new ResourceManagerEvents();
  }
  
  ImageElement image(String src) {
    var imageElement = new ImageElement();
    this.resources.add(new Resource(imageElement, src, false));
    imageElement.on.load.add(this.check);
    return imageElement;
  }
  
  void check(Event event) {
    if (this.resources.every((resource) => resource.loaded)) {
      this.on.load.dispatch(new Event('loaded'));
    }
  }
  
  void loadAll() {
    this.resources.forEach((resource) {
      resource.load();
    });
  }
}


class Keys {
  static final num MAC_ENTER = 3;
  static final num BACKSPACE = 8;
  static final num TAB = 9;
  static final num ENTER = 13;
  static final num SHIFT = 16;
  static final num CTRL = 17;
  static final num ALT = 18;
  static final num PAUSE = 19;
  static final num CAPS_LOCK = 20;
  static final num ESC = 27;
  static final num SPACE = 32;
  static final num PAGE_UP = 33;
  static final num PAGE_DOWN = 34;
  static final num END = 35;
  static final num HOME = 36;
  static final num LEFT = 37;
  static final num UP = 38;
  static final num RIGHT = 39;
  static final num DOWN = 40;
  static final num INSERT = 45;
  static final num DELETE = 46;
  static final num NUM_0 = 48;
  static final num NUM_1 = 49;
  static final num NUM_2 = 50;
  static final num NUM_3 = 51;
  static final num NUM_4 = 52;
  static final num NUM_5 = 53;
  static final num NUM_6 = 54;
  static final num NUM_7 = 55;
  static final num NUM_8 = 56;
  static final num NUM_9 = 57;
  static final num A = 65;
  static final num B = 66;
  static final num C = 67;
  static final num D = 68;
  static final num E = 69;
  static final num F = 70;
  static final num G = 71;
  static final num H = 72;
  static final num I = 73;
  static final num J = 74;
  static final num K = 75;
  static final num L = 76;
  static final num M = 77;
  static final num N = 78;
  static final num O = 79;
  static final num P = 80;
  static final num Q = 81;
  static final num R = 82;
  static final num S = 83;
  static final num T = 84;
  static final num U = 85;
  static final num V = 86;
  static final num W = 87;
  static final num X = 88;
  static final num Y = 89;
  static final num Z = 90;
  static final num WIN = 91;
  static final num CONTEXT_MENU = 93;
  static final num NUMPAD_0 = 96;
  static final num NUMPAD_1 = 97;
  static final num NUMPAD_2 = 98;
  static final num NUMPAD_3 = 99;
  static final num NUMPAD_4 = 100;
  static final num NUMPAD_5 = 101;
  static final num NUMPAD_6 = 102;
  static final num NUMPAD_7 = 103;
  static final num NUMPAD_8 = 104;
  static final num NUMPAD_9 = 105;
  static final num NUMPAD_MULTIPLY = 106;
  static final num NUMPAD_PLUS = 107;
  static final num NUMPAD_MINUS = 109;
  static final num NUMPAD_DECIMAL = 110;
  static final num NUMPAD_DIVIDE = 111;
  static final num F1 = 112;
  static final num F2 = 113;
  static final num F3 = 114;
  static final num F4 = 115;
  static final num F5 = 116;
  static final num F6 = 117;
  static final num F7 = 118;
  static final num F8 = 119;
  static final num F9 = 120;
  static final num F10 = 121;
  static final num F11 = 122;
  static final num F12 = 123;
  static final num SEMICOLON = 186;
  static final num COLON = 186;
  static final num MINUS = 189;
  static final num EQUAL = 187;
  static final num COMMA = 188;
  static final num LESS = 188;
  static final num PERIOD = 190;
  static final num GREATER = 190;
  static final num SLASH = 191;
  static final num QUESTION = 191;
  static final num TILDE = 192;
  static final num BACKQUOTE = 192;
  static final num BRACKET_LEFT = 219;
  static final num BRACE_LEFT = 219;
  static final num BACKSLASH = 220;
  static final num PIPE = 220;
  static final num BRACKET_RIGHT = 221;
  static final num BRACE_RIGHT = 221;
  static final num APOSTROPHE = 222;
  static final num DOUBLEQUOTE = 222;
}

class KeyStateHandler {
  Map<num, bool> pressedKeys;
  
  KeyStateHandler() {
    pressedKeys = new Map<num, bool>();
    
    document.on.keyDown.add((KeyboardEvent event) {
      this.pressedKeys[event.keyCode] = true;
    });
    
    document.on.keyUp.add((KeyboardEvent event) {
      this.pressedKeys[event.keyCode] = false;
    });
  }
  
  bool operator [](num key) {
    if (this.pressedKeys.containsKey(key)) {
      return this.pressedKeys[key];
    }
    return false;
  }
}

abstract class Game {
  ResourceManager resource;
  KeyStateHandler keyboard;
  CanvasElement canvas;
  
  Game() {
    resource = new ResourceManager();
    keyboard = new KeyStateHandler();
    
    var gamebox = query('#gamebox');
    canvas = new CanvasElement(640, 480);
    canvas.style.backgroundColor = 'black';
    gamebox.elements.add(canvas);
    
    init();
  }
  
  abstract void init();
  abstract void update(int dt);
  abstract void paint();
  
  void run() {
    resource.on.load.add((e) {
      var initTime = new Date.now().millisecondsSinceEpoch;
      drawFrame(int currentTime) {
        var dt = (currentTime - initTime) / 1000; 
        initTime = currentTime;
        update(dt);
        paint();
        window.requestAnimationFrame(drawFrame);
      }
      window.requestAnimationFrame(drawFrame);
    });
    
    resource.loadAll();
  }
}
