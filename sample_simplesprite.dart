#import('dagali.dart');

void main() {
  Director director = new Director();

  var layer = new Layer();
  var sprite = new Sprite(director.resource.image('images/tinto.png'), [100,100]);

  layer.add(sprite);

  director.run(new Scene(layer));
}