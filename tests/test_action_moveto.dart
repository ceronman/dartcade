#import('../lib/cocos.dart');

void main() {
  Director director = new Director('#gamebox');

  var layer = new Layer();
  var label = new Label('Place!');

  layer.add(label);
  label.runAction(new MoveTo(new vec2(200, 200), 5));

  director.run(new Scene(layer));
}