part of cocostest;


void testActionPlace(director) {
  var layer = new Layer();
  var label = new Label('Place 200, 200');

  layer.add(label);
  label.runAction(new Place(new vec2(200, 200)));

  director.currentScene = new Scene(layer);
}

void testActionDelay(director) {
  var layer = new Layer();
  var label = new Label('Move + Delay + Move');

  layer.add(label);
  label.position.x = 0;
  label.position.y = director.canvas.height;

  var actions = [new MoveTo(new vec2(0, director.canvas.height/2), 1),
                 new Delay(1),
                 new MoveTo(new vec2(0, director.canvas.height), 1)];

  label.runAction(new ActionSequence(actions));

  director.currentScene = new Scene(layer);
}

void testActionSpeed(director) {
  var layer = new Layer();
  var label = new Label('RotateBy 360 4 seconds 2X speed');

  layer.add(label);
  label.position.x = director.canvas.width / 2 - label.width / 2;
  label.position.y = director.canvas.height/2;

  label.runAction(new Speed(new RotateBy(360, 4), 2));

  director.currentScene = new Scene(layer);
}

void testActionAccelerate(director) {
  var layer = new Layer();
  var label = new Label('Move to top with 2X accell');

  layer.add(label);
  label.position.x = director.canvas.width / 2 - label.width / 2;
  label.position.y = director.canvas.height;

  var newPos = new vec2(director.canvas.width / 2 - label.width / 2, 50);

  label.runAction(new Accelerate(new MoveTo(newPos, 2), 2));

  director.currentScene = new Scene(layer);
}

void testActionBlink(director) {
  var layer = new Layer();
  var label = new Label('Blink for 5 seconds');

  label.align = 'center';
  label.position.x = director.canvas.width/2;
  label.position.y = director.canvas.height/2;

  layer.add(label);

  label.runAction(new Blink(50, 5));

  director.currentScene = new Scene(layer);
}

void testActionMoveTo(director) {
  var layer = new Layer();
  var label = new Label('MoveTo 200, 200');

  label.position.x = 100;
  label.position.y = 100;

  layer.add(label);
  label.runAction(new MoveTo(new vec2(200, 200), 2));

  director.currentScene = new Scene(layer);
}

void testActionMoveBy(director) {
  var layer = new Layer();
  var label = new Label('MoveBy -100, -100');

  layer.add(label);
  label.position.x = director.canvas.width/2;
  label.position.y = director.canvas.height/2;

  label.runAction(new MoveBy(new vec2(-100, -100), 2));

  director.currentScene = new Scene(layer);
}

void testActionRotateTo(director) {
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

  director.currentScene = new Scene(layer);
}

void testActionRotateBy(director) {
  var layer = new Layer();
  var label = new Label('RotateBy 90');

  layer.add(label);
  label.position.x = director.canvas.width/2;
  label.position.y = director.canvas.height/2;

  label.runAction(new RotateBy(90, 2));

  director.currentScene = new Scene(layer);
}

void testActionScaleTo(director) {
  var layer = new Layer();
  var label = new Label('ScaleTo 2, 4');

  label.position.x = director.canvas.width/2;
  label.position.y = director.canvas.height/2;

  layer.add(label);
  label.runAction(new ScaleTo(new vec2(2, 4), 2));

  director.currentScene = new Scene(layer);
}

void testActionScaleBy(director) {
  var layer = new Layer();
  var label = new Label('ScaleBy 0, 2');

  label.position.x = director.canvas.width/2;
  label.position.y = director.canvas.height/2;

  layer.add(label);
  label.runAction(new ScaleBy(new vec2(0, 2), 2));

  director.currentScene = new Scene(layer);
}

void testActionFade(director) {
  var layer = new Layer();

  var label1 = new Label('Fade Out');
  label1.align = 'center';
  label1.position.x = director.canvas.width/4;
  label1.position.y = director.canvas.height/2;

  layer.add(label1);
  label1.runAction(new FadeOut(2));

  var label2 = new Label('Fade In');
  label2.position.x = director.canvas.width/2;
  label2.position.y = director.canvas.height/2;
  label2.align = 'center';
  label2.opacity = 0.0;

  layer.add(label2);
  label2.runAction(new FadeIn(2));

  var label3 = new Label('Fade To 0.5');
  label3.position.x = 3 * director.canvas.width/4;
  label3.position.y = director.canvas.height/2;
  label3.align = 'center';
  label3.opacity = 0.0;

  layer.add(label3);
  label3.runAction(new FadeTo(0.5, 2));

  director.currentScene = new Scene(layer);
}

void testActionRepeat(director) {
  var layer = new Layer();
  var label = new Label('Repeat 4 (Move + Move)');

  layer.add(label);
  label.position.x = 0;
  label.position.y = director.canvas.height/2;

  var action = (new MoveBy(new vec2(50, 50), 1) +
                new MoveBy(new vec2(-50, -50), 1));

  label.runAction(new Repeat(action, 4));

  director.currentScene = new Scene(layer);
}

void testActionSpawn(director) {
  var layer = new Layer();
  var label = new Label('Show | Move | Rotate | Scale');

  layer.add(label);
  label.position.x = 0;
  label.position.y = director.canvas.height;
  label.visible = false;

  var actions = [new Show(),
                 new MoveTo(new vec2(0, director.canvas.height/2), 2),
                 new RotateBy(360, 2),
                 new ScaleBy(new vec2(0.5, 0.5), 2)];

  label.runAction(new ActionSpawn(actions));

  director.currentScene = new Scene(layer);
}

void testMultipleActions(director) {
  var layer = new Layer();
  var label = new Label('Move Rotate Scale');

  layer.add(label);
  label.position.x = 0;
  label.position.y = director.canvas.height;

  label.runAction(new MoveTo(new vec2(0, director.canvas.height/2), 2));
  label.runAction(new RotateBy(360, 2));
  label.runAction(new ScaleBy(new vec2(2, 2), 2));

  director.currentScene = new Scene(layer);
}

void testActionSequence(director) {
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

  director.currentScene = new Scene(layer);
}

void testActionOperators(director) {
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

  director.currentScene = new Scene(layer);
}