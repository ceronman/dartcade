#import('../lib/cocos.dart');

void main() {
  Director director = new Director('#gamebox');

  var layer = new Layer();
  var label = new Label('Move + Rotate + Scale + Place');

  layer.add(label);
  label.position.x = 0;
  label.position.y = director.canvas.height;

  var actions = [new MoveTo(new vec2(0, director.canvas.height/2), 2),
                 new RotateBy(360, 2),
                 new ScaleBy(new vec2(0.5, 0.5), 2),
                 new Place(new vec2(0, director.canvas.height))];

  label.runAction(new ActionSequence(actions));

  director.run(new Scene(layer));
}