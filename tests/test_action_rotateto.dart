import '../lib/cocos.dart';

void main() {
  Director director = new Director('#gamebox');

  var layer = new Layer();
  var label1 = new Label('RotateToCW 45');

  label1.position.x = 100;
  label1.position.y = director.canvas.height/2;

  layer.add(label1);
  label1.runAction(new RotateToCW(45, 2));

  var label2 = new Label('RotateToACW 45');

  label2.position.x = director.canvas.width - 300;
  label2.position.y = director.canvas.height/2;

  layer.add(label2);
  label2.runAction(new RotateToACW(45, 2));

  director.run(new Scene(layer));
}