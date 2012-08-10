#import('dagali.dart');

void main() {
  Director director = new Director();

  var scene = new Scene();
  var layer = new Layer();
  var label = new Label('Hello world', [100, 100]);

  scene.add(layer);
  layer.add(label);

  director.run(scene);
}