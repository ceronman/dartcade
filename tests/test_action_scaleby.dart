import '../lib/cocos.dart';

void main() {
  Director director = new Director('#gamebox');

  var layer = new Layer();
  var label = new Label('ScaleBy 0, 2');

  label.position.x = director.canvas.width/2;
  label.position.y = director.canvas.height/2;

  layer.add(label);
  label.runAction(new ScaleBy(new vec2(0, 2), 2));

  director.run(new Scene(layer));
}