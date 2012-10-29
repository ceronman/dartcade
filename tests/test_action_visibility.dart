// FIXME: don't use dart:html here!!!
import 'dart:html';
import '../lib/cocos.dart';

void main() {
  Director director = new Director('#gamebox');

  var layer = new Layer();
  var label = new Label('S: Show. H: Hide. T: Toggle');

  label.align = 'center';
  label.position.x = director.canvas.width/2;
  label.position.y = director.canvas.height/2;

  layer.add(label);

  // FIXME: don't use document events use director events!!!
  document.on.keyDown.add((KeyboardEvent event) {
    if (event.keyCode == Keys.H) {
      label.runAction(new Hide());
    }

    if (event.keyCode == Keys.S) {
      label.runAction(new Show());
    }

    if (event.keyCode == Keys.T) {
      label.runAction(new ToggleVisibility());
    }

  });

  director.run(new Scene(layer));
}