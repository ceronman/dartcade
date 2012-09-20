#import('../lib/cocos.dart');

void main() {
  Director director = new Director('#gamebox');

  var layer = new Layer();
  var label = new Label('S: Show. H: Hide. T: Toggle');

  label.align = 'center';
  label.position.x = director.canvas.width/2;
  label.position.y = director.canvas.height/2;

  layer.add(label);

  label.runAction(new Blink(50, 5));

  director.run(new Scene(layer));
}