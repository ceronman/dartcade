#import('../lib/cocos.dart');

void main() {
  Director director = new Director("#gamebox");

  var layer = new Layer();
  var sprite = new Sprite(director.resource.image('images/tinto.png'));
  sprite.position.x = director.canvas.width / 2;
  sprite.position.y = director.canvas.height / 2;

  layer.add(sprite);
  director.run(new Scene(layer));
}