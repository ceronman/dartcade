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
  static final int MAC_ENTER = 3;
  static final int BACKSPACE = 8;
  static final int TAB = 9;
  static final int ENTER = 13;
  static final int SHIFT = 16;
  static final int CTRL = 17;
  static final int ALT = 18;
  static final int PAUSE = 19;
  static final int CAPS_LOCK = 20;
  static final int ESC = 27;
  static final int SPACE = 32;
  static final int PAGE_UP = 33;
  static final int PAGE_DOWN = 34;
  static final int END = 35;
  static final int HOME = 36;
  static final int LEFT = 37;
  static final int UP = 38;
  static final int RIGHT = 39;
  static final int DOWN = 40;
  static final int INSERT = 45;
  static final int DELETE = 46;
  static final int NUM_0 = 48;
  static final int NUM_1 = 49;
  static final int NUM_2 = 50;
  static final int NUM_3 = 51;
  static final int NUM_4 = 52;
  static final int NUM_5 = 53;
  static final int NUM_6 = 54;
  static final int NUM_7 = 55;
  static final int NUM_8 = 56;
  static final int NUM_9 = 57;
  static final int A = 65;
  static final int B = 66;
  static final int C = 67;
  static final int D = 68;
  static final int E = 69;
  static final int F = 70;
  static final int G = 71;
  static final int H = 72;
  static final int I = 73;
  static final int J = 74;
  static final int K = 75;
  static final int L = 76;
  static final int M = 77;
  static final int N = 78;
  static final int O = 79;
  static final int P = 80;
  static final int Q = 81;
  static final int R = 82;
  static final int S = 83;
  static final int T = 84;
  static final int U = 85;
  static final int V = 86;
  static final int W = 87;
  static final int X = 88;
  static final int Y = 89;
  static final int Z = 90;
  static final int WIN = 91;
  static final int CONTEXT_MENU = 93;
  static final int NUMPAD_0 = 96;
  static final int NUMPAD_1 = 97;
  static final int NUMPAD_2 = 98;
  static final int NUMPAD_3 = 99;
  static final int NUMPAD_4 = 100;
  static final int NUMPAD_5 = 101;
  static final int NUMPAD_6 = 102;
  static final int NUMPAD_7 = 103;
  static final int NUMPAD_8 = 104;
  static final int NUMPAD_9 = 105;
  static final int NUMPAD_MULTIPLY = 106;
  static final int NUMPAD_PLUS = 107;
  static final int NUMPAD_MINUS = 109;
  static final int NUMPAD_DECIMAL = 110;
  static final int NUMPAD_DIVIDE = 111;
  static final int F1 = 112;
  static final int F2 = 113;
  static final int F3 = 114;
  static final int F4 = 115;
  static final int F5 = 116;
  static final int F6 = 117;
  static final int F7 = 118;
  static final int F8 = 119;
  static final int F9 = 120;
  static final int F10 = 121;
  static final int F11 = 122;
  static final int F12 = 123;
  static final int SEMICOLON = 186;
  static final int COLON = 186;
  static final int MINUS = 189;
  static final int EQUAL = 187;
  static final int COMMA = 188;
  static final int LESS = 188;
  static final int PERIOD = 190;
  static final int GREATER = 190;
  static final int SLASH = 191;
  static final int QUESTION = 191;
  static final int TILDE = 192;
  static final int BACKQUOTE = 192;
  static final int BRACKET_LEFT = 219;
  static final int BRACE_LEFT = 219;
  static final int BACKSLASH = 220;
  static final int PIPE = 220;
  static final int BRACKET_RIGHT = 221;
  static final int BRACE_RIGHT = 221;
  static final int APOSTROPHE = 222;
  static final int DOUBLEQUOTE = 222;
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

  Scene _currentScene;
  Scene get currentScene() => _currentScene;
  void set currentScene(Scene scene) {
    _currentScene = scene;
    _currentScene.width = canvas.width;
    _currentScene.height = canvas.height;
  }

  Director(selector, [int width, int height]) {
    width = width != null ? width : 640;
    height = height != null ? height : 480;
    resource = new ResourceManager();
    keyboard = new KeyStateHandler();

    var gamebox = query(selector);
    canvas = new CanvasElement(width, height);
    canvas.style.backgroundColor = 'black';
    gamebox.elements.add(canvas);
  }

  void update(num dt) {

  }

  void _debugDraw(CanvasRenderingContext2D context) {
    var size = 20;
    var color = "#333333";
    var rows = canvas.height / size;
    var cols = canvas.width / size;

    for (var row=0; row<rows; row++) {
      context.strokeStyle = color;
      context.moveTo(0, row * size + 0.5);
      context.lineTo(canvas.width, row * size + 0.5);
      context.stroke();
    }

    for (var col=0; col<cols; col++) {
      context.strokeStyle = color;
      context.moveTo(col * size + 0.5, 0);
      context.lineTo(col * size + 0.5, canvas.height);
      context.stroke();
    }
  }

  void draw(CanvasRenderingContext2D context) {
    context.clearRect(0, 0, canvas.width, canvas.height);
    _debugDraw(context);
    currentScene.drawWithChildren(context);
  }

  void run(Scene mainScene) {
    currentScene = mainScene;
    currentScene.width = canvas.width;
    currentScene.height = canvas.height;

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
  Vector position_anchor;
  Vector rotation_anchor;
  Vector scale;
  num rotation;
  bool visible;
  List<BaseNode> children;
  BaseNode parent;

  abstract int get width();
  abstract int get height();

  Vector _position;
  Vector get position() => _position;
  void set position(p) {
    if (p is List) {
      _position = new Vector(p[0], p[1]);
    } else {
      _position = p;
    }
  }

  BaseNode() {
    position = new Vector(0, 0);
    position_anchor = new Vector(0.5, 0.5);
    scale = new Vector(1, 1);
    rotation = 0;
    rotation_anchor = new Vector(0.5, 0.5);
    visible = true;
    children = new List<BaseNode>();
  }

  void transform(CanvasRenderingContext2D context) {

    context.translate(position.x, position.y);

    if (scale.x != 1 || scale.y != 1) {
      context.scale(scale.x, scale.y);
    }

    if (rotation != 0) {
      var axis_x = (rotation_anchor.x - position_anchor.x) * width;
      var axis_y = (rotation_anchor.y - position_anchor.y) * height;
      context.translate(axis_x, axis_y);
      context.rotate(rotation * Math.PI/180);
      context.translate(-axis_x, -axis_y);
    }

    context.translate(-position_anchor.x * width, -position_anchor.y * height);
  }

  void drawWithTransform(context) {
      context.save();
      transform(context);
      draw(context);
      context.restore();
  }

  void drawWithChildren(context) {
    if (visible) {
      for (BaseNode child in children) {
        child.drawWithChildren(context);
      }
      drawWithTransform(context);
    }
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

  int width;
  int height;

  Scene([Layer layer]): super() {
    if (layer != null) {
      this.add(layer);
    }
  }
}

class Layer extends BaseNode {
  get width() => parent.width;
  get height() => parent.height;
}

class Label extends BaseNode {

  String font;
  var color;
  String align;
  String baseline;

  num width;
  num height;

  String _text;
  String get text() => _text;
  void set text(newText) {
    var canvas = new CanvasElement(0, 0);
    var context = canvas.context2d;
    _setStyle(context);
    var dimensions = context.measureText(newText);
    width = dimensions.width;

    // FIXME: Calculating height of text is very tricky.
    height = 0;

    _text = newText;
  }

  Label(text, [position, font, color, align, baseline]):
      super() {
    position_anchor = new Vector(0, 0);
    this.position = position != null ? position : this.position;
    this.font = font != null ? font : '20pt Serif';
    this.color = color != null ? color : 'white';
    this.align = align != null ? align : 'start';
    this.baseline = baseline != null ? baseline : 'alphabetic';
    this.text = text;
  }

  void _setStyle(context) {
    context.font = font;
    context.fillStyle = color;
    context.textAlign = align;
    context.textBaseline = baseline;
  }

  void draw(context) {
    _setStyle(context);
    context.fillText(text, 0, 0);
  }
}

class Sprite extends BaseNode {
  ImageElement image;

  get width() => image.width;
  get height() => image.height;

  Sprite(ImageElement this.image, [pos]): super() {
    position = pos != null ? pos : position;
  }

  void draw(CanvasRenderingContext2D context) {
    context.drawImage(image, 0, 0);
  }
}