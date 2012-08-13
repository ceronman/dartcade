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
    resources = new List<Resource>();
    on = new ResourceManagerEvents();
  }

  ImageElement image(String src) {
    var imageElement = new ImageElement();
    resources.add(new Resource(imageElement, src, false));
    imageElement.on.load.add(check);
    return imageElement;
  }

  void check(Event event) {
    if (resources.every((resource) => resource.loaded)) {
      on.load.dispatch(new Event('loaded'));
    }
  }

  void loadAll() {
    if (resources.length == 0) {
      on.load.dispatch(new Event('loaded'));
      return;
    }
    for (var resource in resources) {
      resource.load();
    }
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

class Director {
  ResourceManager resource;
  KeyStateHandler keyboard;
  CanvasElement canvas;
  Scene scene;

  Director() {
    resource = new ResourceManager();
    keyboard = new KeyStateHandler();

    var gamebox = query('#gamebox');
    canvas = new CanvasElement(640, 480);
    canvas.style.backgroundColor = 'black';
    gamebox.elements.add(canvas);
  }

  void update(num dt) {

  }

  void draw(context) {
    scene.drawWithChildren(context);
  }

  void run(Scene mainScene) {
    this.scene = mainScene;
    resource.on.load.add((e) {
      var initTime = new Date.now().millisecondsSinceEpoch;
      drawFrame(int currentTime) {
        var dt = (currentTime - initTime) / 1000;
        initTime = currentTime;
        update(dt);
        draw(canvas.context2d);
        window.requestAnimationFrame(drawFrame);
      }
      window.requestAnimationFrame(drawFrame);
    });

    resource.loadAll();
  }
}


class Vector {
  num x;
  num y;

  Vector(this.x, this.y);
}


abstract class BaseNode {
  Vector _position;
  Vector anchor;
  Vector scale;
  double rotation;
  bool visible;
  List<BaseNode> children;
  BaseNode parent;

  abstract get width();
  abstract set width(int w);

  abstract get height();
  abstract set height(int h);

  Vector get position() => _position;
  void set position(p) {
    if (p is List) {
      _position = new Vector(p[0], p[1]);
    } else {
      _position = p;
    }
  }

  BaseNode() {
    position = new Vector(0,0);
    anchor = new Vector(0, 0);
    scale = new Vector(1, 1);
    rotation = 0.0;
    visible = true;
    children = new List<BaseNode>();
  }

  void transform(CanvasRenderingContext2D context) {
    context.translate(position.x, position.y);
    if (scale.x != 1 || scale.y != 1) {
      context.scale(scale.x, scale.y);
    }
    if (rotation != 0) {
      context.rotate(rotation * Math.PI/180);
    }
  }

  void drawWithTransform(context) {
    if (visible) {
      context.save();
      transform(context);
      draw(context);
      context.restore();
    }
  }

  void drawWithChildren(context) {
    for (BaseNode child in children) {
      child.drawWithChildren(context);
    }
    drawWithTransform(context);
  }

  void draw(context) {
  }

  void add(node) {
    children.add(node);
    node.parent = this;
  }

  void remove(BaseNode node) {
    children.removeRange(children.indexOf(node), 1);
    node.parent = null;
  }
}

class Scene extends BaseNode {

  Scene([Layer layer]): super() {
    if (layer != null) {
      this.add(layer);
    }
  }
}

class Layer extends BaseNode {
}

class Label extends BaseNode {

  String font;
  var color;
  String align;
  String text;

  Label(this.text, [pos, this.font, this.color, this.align]) {
    position = pos != null ? pos : position;
    font = font != null ? font : '20pt Serif';
    color = color != null ? color : 'white';
    align = align != null ? align : 'start';
  }

  void draw(context) {
    context.font = font;
    context.fillStyle = color;
    context.textAlign = align;
    context.fillText(text, position.x, position.y);
  }
}

class Sprite extends BaseNode {
  ImageElement image;


  Sprite(ImageElement this.image, [pos]): super() {
    position = pos != null ? pos : position;
  }

  void draw(context) {
    context.drawImage(image, 0, 0);
  }
}