#import('dagali.dart');

void main() {
  Director director = new Director();

  var layer = new Layer();
  var label = new Label('Hello world', [100, 100]);

  layer.add(label);

  director.run(new Scene(layer));
}