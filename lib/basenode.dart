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