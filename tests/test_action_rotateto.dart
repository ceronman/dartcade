#import('../lib/cocos.dart');

void main() {
  Director director = new Director('#gamebox');

  var layer = new Layer();
  var label1 = new Label('RotateTo 45 CW');

  label1.position.x = 100;
  label1.position.y = director.canvas.height/2;

  layer.add(label1);
  label1.runAction(new RotateTo(45, 5));

  var label2 = new Label('RotateTo 45 ACW');

  label2.position.x = director.canvas.width - 300;
  label2.position.y = director.canvas.height/2;

  layer.add(label2);
  label2.runAction(new RotateTo(45, 5, direction: ANTICLOCKWISE));

  director.run(new Scene(layer));
}