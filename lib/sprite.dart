
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