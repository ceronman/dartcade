
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