#import('../lib/cocos.dart');

void main() {
  Director director = new Director('#gamebox');

  var layer = new Layer();
  var label = new Label('Place 200, 200');

  layer.add(label);
  print('Old position: ${label.position}');
  label.runAction(new Place(new vec2(200, 200)));
  print('New position: ${label.position}');

  director.run(new Scene(layer));
}