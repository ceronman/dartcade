// Copyright 2012 Manuel Cerón <ceronman@gmail.com>
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

part of cocostest;

void testActionPlace() {
  var layer = new Layer();
  var label = new Label('Place 200, 200');

  layer.add(label);
  label.runAction(new Place(new vec2(200, 200)));

  game.currentScene = new Scene(layer);
}

void testActionVisibility() {
  var layer = new Layer();

  var label1 = new Label('Show');
  label1.align = 'center';
  label1.visible = false;
  label1.position.x = game.width/4;
  label1.position.y = game.height/2;

  layer.add(label1);
  label1.runAction(new Delay(1) + new Show() +
                   new Delay(1) + new Show().reverse());

  var label2 = new Label('Hide');
  label2.position.x = game.width/2;
  label2.position.y = game.height/2;
  label2.align = 'center';

  layer.add(label2);
  label2.runAction(new Delay(1) + new Hide() +
                   new Delay(1) + new Hide().reverse());

  var label3 = new Label('ToggleVisibility');
  label3.position.x = 3 * game.width/4;
  label3.position.y = game.height/2;
  label3.align = 'center';

  layer.add(label3);
  label3.runAction(new Delay(1) + new ToggleVisibility() +
                   new Delay(1) + new ToggleVisibility());

  game.currentScene = new Scene(layer);
}

void testActionDelay() {
  var layer = new Layer();
  var label = new Label('Move + Delay + Move');

  layer.add(label);
  label.position.x = 0;
  label.position.y = game.height;

  var actions = [new MoveTo(new vec2(0, game.height/2), 1),
                 new Delay(1),
                 new MoveTo(new vec2(0, game.height), 1)];

  label.runAction(new ActionSequence(actions));

  game.currentScene = new Scene(layer);
}

void testActionSpeed() {
  var layer = new Layer();
  var label = new Label('RotateBy 360 2 seconds 2X speed');

  layer.add(label);
  label.position.x = game.width / 2 - label.width / 2;
  label.position.y = game.height/2;

  var action = new Speed(new RotateBy(360, 2), 2);
  label.runAction(action + action.reverse());

  game.currentScene = new Scene(layer);
}

void testActionAccelerate() {
  var layer = new Layer();
  var label = new Label('Move to top with 2X accel');

  layer.add(label);
  label.position.x = game.width / 2 - label.width / 2;
  label.position.y = game.height;

  var newPos = new vec2(0, 50-game.height);
  Accelerate action = new Accelerate(new MoveBy(newPos, 2), 2);
  label.runAction(action + action.reverse());

  game.currentScene = new Scene(layer);
}

void testActionAccelDeccel() {
  var layer = new Layer();
  var label = new Label('Move to top with 2X accel-deccel');

  layer.add(label);
  label.position.x = game.width / 2 - label.width / 2;
  label.position.y = game.height;

  var newPos = new vec2(0, 50-game.height);
  AccelDeccel action = new AccelDeccel(new MoveBy(newPos, 2), 2);
  label.runAction(action + action.reverse());

  game.currentScene = new Scene(layer);
}

void testActionBlink() {
  var layer = new Layer();
  var label = new Label('Blink for 2 seconds');

  label.align = 'center';
  label.position.x = game.width/2;
  label.position.y = game.height/2;

  layer.add(label);

  label.runAction(new Blink(10, 1) + new Blink(10, 1).reverse());

  game.currentScene = new Scene(layer);
}

void testActionMoveTo() {
  var layer = new Layer();
  var label = new Label('MoveTo 100, 100');

  label.position.x = game.width / 2 - label.width / 2;
  label.position.y = game.height / 2;

  layer.add(label);
  label.runAction(new MoveTo(new vec2(100, 100), 2));

  game.currentScene = new Scene(layer);
}

void testActionMoveBy() {
  var layer = new Layer();
  var label = new Label('MoveBy (100, 100)');

  layer.add(label);
  label.position.x = game.width / 2 - label.width / 2;
  label.position.y = game.height / 2;

  var action = new MoveBy(new vec2(100, 100), 1);

  label.runAction(action + action.reverse());

  game.currentScene = new Scene(layer);
}

void testActionRotateTo() {
  var layer = new Layer();
  var label1 = new Label('RotateTo 45');

  label1.position.x = 100;
  label1.position.y = game.height/2;

  layer.add(label1);
  label1.runAction(new RotateTo(45, 2));

  var label2 = new Label('RotateTo 45 reverse');

  label2.position.x = game.width - 300;
  label2.position.y = game.height/2;

  layer.add(label2);
  label2.runAction((new RotateTo(45, 2)).reverse());

  game.currentScene = new Scene(layer);
}

void testActionRotateBy() {
  var layer = new Layer();
  var label = new Label('RotateBy 90');

  layer.add(label);
  label.position.x = game.width/2;
  label.position.y = game.height/2;

  var action = new RotateBy(90, 1);
  label.runAction(action + action.reverse());

  game.currentScene = new Scene(layer);
}

void testActionScaleTo() {
  var layer = new Layer();
  var label = new Label('ScaleTo 2, 4');

  label.position.x = game.width/2;
  label.position.y = game.height/2;

  layer.add(label);
  label.runAction(new ScaleTo(new vec2(2, 4), 2));

  game.currentScene = new Scene(layer);
}

void testActionScaleBy() {
  var layer = new Layer();
  var label = new Label('ScaleBy 1, 2');

  label.align = 'center';
  label.position.x = game.width/2;
  label.position.y = game.height/2;

  layer.add(label);

  var action = new ScaleBy(new vec2(1, 2), 1);
  label.runAction(action + new Delay(0.5) + action.reverse());

  game.currentScene = new Scene(layer);
}

void testActionFade() {
  var layer = new Layer();

  var label1 = new Label('Fade Out');
  label1.align = 'center';
  label1.position.x = game.width/4;
  label1.position.y = game.height/2;

  layer.add(label1);
  label1.runAction(new FadeOut(1) + new FadeOut(1).reverse());

  var label2 = new Label('Fade In');
  label2.position.x = game.width/2;
  label2.position.y = game.height/2;
  label2.align = 'center';
  label2.opacity = 0.0;

  layer.add(label2);
  label2.runAction(new FadeIn(2) + new FadeIn(1).reverse());

  var label3 = new Label('Fade To 0.5');
  label3.position.x = 3 * game.width/4;
  label3.position.y = game.height/2;
  label3.align = 'center';
  label3.opacity = 0.0;

  layer.add(label3);
  label3.runAction(new FadeTo(0.5, 2));

  game.currentScene = new Scene(layer);
}

void testActionRepeat() {
  var layer = new Layer();
  var label = new Label('Repeat 3 (Move + Move)');

  layer.add(label);
  label.position.x = 0;
  label.position.y = game.height/2;

  var action = new Repeat(new MoveBy(new vec2(0, 50), 0.2) +
                          new MoveBy(new vec2(50, 0), 0.2), 3);

  label.runAction(action + action.reverse());

  game.currentScene = new Scene(layer);
}

void testActionSpawn() {
  var layer = new Layer();
  var label = new Label('Move | Rotate | Scale');

  layer.add(label);
  label.position.x = 0;
  label.position.y = game.height;

  var action = new ActionSpawn([new MoveBy(new vec2(200, -200), 2),
                                new RotateBy(360, 2),
                                new ScaleBy(new vec2(0.5, 0.5), 2)]);

  label.runAction(action + new Delay(0.5) + action.reverse());

  game.currentScene = new Scene(layer);
}

void testMultipleActions() {
  var layer = new Layer();
  var label = new Label('Move Rotate Scale');

  layer.add(label);
  label.position.x = 0;
  label.position.y = game.height;

  label.runAction(new MoveTo(new vec2(0, game.height/2), 2));
  label.runAction(new RotateBy(360, 2));
  label.runAction(new ScaleBy(new vec2(2, 2), 2));

  game.currentScene = new Scene(layer);
}

void testActionSequence() {
  var layer = new Layer();
  var label = new Label('Move + Rotate + Scale');

  layer.add(label);
  label.position.x = 0;
  label.position.y = game.height;

  var actions = new ActionSequence([new MoveBy(new vec2(0, -100), 1),
                                    new RotateBy(360, 1),
                                    new ScaleBy(new vec2(1.5, 1.5), 1)]);

  label.runAction(actions + actions.reverse());

  game.currentScene = new Scene(layer);
}

void testActionOperators() {
  var layer = new Layer();
  var label1 = new Label('Show + Move + Rotate + Scale');

  layer.add(label1);
  label1.position.x = 0;
  label1.position.y = 100;
  label1.visible = false;

  label1.runAction(new Show() +
                   new MoveTo(new vec2(200, 100), 2) +
                   new RotateBy(360, 2) +
                   new ScaleBy(new vec2(0.5, 0.5), 2));

  var label2 = new Label('Show | Move | Rotate | Scale');

  layer.add(label2);
  label2.position.x = 0;
  label2.position.y = 400;
  label2.visible = false;

  label2.runAction(new Show() |
                   new MoveTo(new vec2(200, 400), 2) |
                   new RotateBy(360, 2) |
                   new ScaleBy(new vec2(0.5, 0.5), 2));

  game.currentScene = new Scene(layer);
}
