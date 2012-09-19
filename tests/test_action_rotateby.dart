#import('../lib/cocos.dart');

void main() {
  Director director = new Director('#gamebox');

  var layer = new Layer();
  var label = new Label('RotateBy 90');

  layer.add(label);
  label.position.x = director.canvas.width/2;
  label.position.y = director.canvas.height/2;

  label.runAction(new RotateBy(90, 5));

  director.run(new Scene(layer));
}