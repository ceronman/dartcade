#import('../lib/cocos.dart');

void main() {
  Director director = new Director('#gamebox');

  var layer = new Layer();
  var label = new Label('MoveBy -100, -100');

  layer.add(label);
  label.position.x = director.canvas.width/2;
  label.position.y = director.canvas.height/2;

  label.runAction(new MoveBy(new vec2(-100, -100), 2));

  director.run(new Scene(layer));
}