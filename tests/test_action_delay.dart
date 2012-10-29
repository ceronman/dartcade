import '../lib/cocos.dart';

void main() {
  Director director = new Director('#gamebox');

  var layer = new Layer();
  var label = new Label('Move + Delay + Move');

  layer.add(label);
  label.position.x = 0;
  label.position.y = director.canvas.height;

  var actions = [new MoveTo(new vec2(0, director.canvas.height/2), 1),
                 new Delay(1),
                 new MoveTo(new vec2(0, director.canvas.height), 1)];

  label.runAction(new ActionSequence(actions));

  director.run(new Scene(layer));
}