import '../lib/cocos.dart';

void main() {
  Director director = new Director('#gamebox');

  var layer = new Layer();
  var label = new Label('MoveTo 200, 200');

  label.position.x = 100;
  label.position.y = 100;

  layer.add(label);
  label.runAction(new MoveTo(new vec2(200, 200), 2));

  director.run(new Scene(layer));
}