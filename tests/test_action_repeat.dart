import '../lib/cocos.dart';

void main() {
  Director director = new Director('#gamebox');

  var layer = new Layer();
  var label = new Label('Repeat 4 (Move + Move)');

  layer.add(label);
  label.position.x = 0;
  label.position.y = director.canvas.height/2;

  var action = (new MoveBy(new vec2(50, 50), 1) +
                new MoveBy(new vec2(-50, -50), 1));

  label.runAction(new Repeat(action, 4));
  director.run(new Scene(layer));
}