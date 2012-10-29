import '../lib/cocos.dart';

void main() {
  Director director = new Director('#gamebox');

  var layer = new Layer();
  var label1 = new Label('Move + Rotate + Scale');

  layer.add(label1);
  label1.position.x = 0;
  label1.position.y = 100;

  label1.runAction(new MoveTo(new vec2(200, 100), 2) +
                   new RotateBy(360, 2) +
                   new ScaleBy(new vec2(0.5, 0.5), 2));

  var label2 = new Label('Move | Rotate | Scale');

  layer.add(label2);
  label2.position.x = 0;
  label2.position.y = 400;

  label2.runAction(new MoveTo(new vec2(200, 400), 2) |
                   new RotateBy(360, 2) |
                   new ScaleBy(new vec2(0.5, 0.5), 2));

  director.run(new Scene(layer));
}