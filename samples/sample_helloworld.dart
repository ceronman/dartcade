import '../lib/cocos.dart';

void main() {
  Director director = new Director('#gamebox');

  var layer = new Layer();
  var label = new Label('Hello world!');

  label.position.x = director.canvas.width/2;
  label.position.y = director.canvas.height/2;
  label.font = '25pt Arial';
  label.align = 'center';
  label.baseline = 'middle';

  layer.add(label);

  director.run(new Scene(layer));
}