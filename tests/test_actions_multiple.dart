import '../lib/cocos.dart';

void main() {
  Director director = new Director('#gamebox');

  var layer = new Layer();
  var label = new Label('Move Rotate Scale');

  layer.add(label);
  label.position.x = 0;
  label.position.y = director.canvas.height;

  label.runAction(new MoveTo(new vec2(0, director.canvas.height/2), 2));
  label.runAction(new RotateBy(360, 2));
  label.runAction(new ScaleBy(new vec2(2, 2), 2));

  director.run(new Scene(layer));
}