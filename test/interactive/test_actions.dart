// Copyright 2014 Manuel Cerón <ceronman@gmail.com>
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

part of dartcade_test;

// TODO: Check positions in tests.

@InteractiveTest('Place', group: 'Action')
testPlace(GameLoop game) {
  new Label('Place 200, 200')
    ..addTo(game.scene)
    ..runAction(new Place(new Vector2(200.0, 200.0)));
}

@InteractiveTest('Show, Hide, ToggleVisibility', group: 'Action')
testVisibility(GameLoop game) {
  new Label('Show')
    ..addTo(game.scene)
    ..align = 'center'
    ..visible = false
    ..position.x = game.width / 4
    ..position.y = game.height / 2
    ..runAction(new Delay(1) + new Show() + new Delay(1) + new Show().reversed);

  new Label('Hide')
    ..addTo(game.scene)
    ..position.x = game.width / 2
    ..position.y = game.height / 2
    ..align = 'center'
    ..runAction(new Delay(1) + new Hide() + new Delay(1) + new Hide().reversed);

  new Label('ToggleVisibility')
    ..addTo(game.scene)
    ..position.x = 3 * game.width / 4
    ..position.y = game.height / 2
    ..align = 'center'
    ..runAction(new Delay(1) +
        new ToggleVisibility() +
        new Delay(1) +
        new ToggleVisibility());
}

@InteractiveTest('Delay', group: 'Action')
testDelay(GameLoop game) {
  var actions = [
    new MoveTo(new Vector2(0.0, game.height / 2), 1),
    new Delay(1),
    new MoveTo(new Vector2(0.0, game.height), 1)
  ];

  new Label('Move + Delay + Move')
    ..addTo(game.scene)
    ..position.x = 0.0
    ..position.y = game.height
    ..runAction(new ActionSequence(actions));
}

@InteractiveTest('Speed', group: 'Action')
testSpeed(GameLoop game) {
  var action = new RotateBy(360, 2);

  new Label('RotateBy 360 2 seconds 2X speed')
    ..addTo(game.scene)
    ..align = 'center'
    ..position.x = game.width / 2
    ..position.y = game.height / 2
    ..runAction(action + new Speed(action, 2));
}

@InteractiveTest('Accelerate', group: 'Action')
testAccelerate(GameLoop game) {
  var newPos = new Vector2(0.0, game.height - 50);
  Accelerate action = new Accelerate(new MoveBy(newPos, 2), 2);
  new Label('Move to bottom with 2X accel')
    ..addTo(game.scene)
    ..align = 'center'
    ..position.x = game.width / 2
    ..position.y = 50.0
    ..runAction(action + action.reversed);
}

@InteractiveTest('AccelDeccel', group: 'Action')
testAccelDeccel(GameLoop game) {
  var newPos = new Vector2(0.0, game.height - 50);
  AccelDeccel action = new AccelDeccel(new MoveBy(newPos, 2), 2);

  new Label('Move to top with 2X accel-deccel')
    ..addTo(game.scene)
    ..align = 'center'
    ..position.x = game.width / 2
    ..position.y = 50.0
    ..runAction(action + action.reversed);
}

@InteractiveTest('Blink', group: 'Action')
testBlink(GameLoop game) {
  new Label('Blink for 2 seconds')
    ..addTo(game.scene)
    ..align = 'center'
    ..position.x = game.width / 2
    ..position.y = game.height / 2
    ..runAction(new Blink(10, 1) + new Blink(10, 1).reversed);
}

@InteractiveTest('MoveTo', group: 'Action')
testMoveTo(GameLoop game) {
  new Label('MoveTo 100, 100')
    ..addTo(game.scene)
    ..position.x = game.width / 2
    ..position.y = game.height / 2
    ..runAction(new MoveTo(new Vector2(100.0, 100.0), 2));
}

@InteractiveTest('MoveBy', group: 'Action')
testMoveBy(GameLoop game) {
  var action = new MoveBy(new Vector2(100.0, 100.0), 1);

  new Label('MoveBy 100, 100')
    ..addTo(game.scene)
    ..align = 'center'
    ..position.x = game.width / 2
    ..position.y = game.height / 2
    ..runAction(action + action.reversed);
}

@InteractiveTest('RotateTo', group: 'Action')
testRotateTo(GameLoop game) {
  new Label('RotateTo 45')
    ..addTo(game.scene)
    ..position.x = 100.0
    ..position.y = game.height / 2
    ..runAction(new RotateTo(45, 2));

  new Label('RotateTo 45 reverse')
    ..addTo(game.scene)
    ..position.x = game.width - 300
    ..position.y = game.height / 2
    ..runAction((new RotateTo(45, 2)).reversed);
}

@InteractiveTest('RotateBy', group: 'Action')
testRotateBy(GameLoop game) {
  var action = new RotateBy(90, 1);
  new Label('RotateBy 90')
    ..addTo(game.scene)
    ..position.x = game.width / 2
    ..position.y = game.height / 2
    ..runAction(action + action.reversed);
}

@InteractiveTest('ScaleTo', group: 'Action')
testScaleTo(GameLoop game) {
  var label = new Label('ScaleTo 2, 4')
    ..position.x = game.width / 2
    ..position.y = game.height / 2
    ..runAction(new ScaleTo(new Vector2(2.0, 4.0), 2));
  game.scene.add(label);
}

@InteractiveTest('ScaleBy', group: 'Action')
testScaleBy(GameLoop game) {
  var action = new ScaleBy(new Vector2(1.0, 2.0), 1);

  new Label('ScaleBy 1, 2')
    ..addTo(game.scene)
    ..align = 'center'
    ..position.x = game.width / 2
    ..position.y = game.height / 2
    ..runAction(action + new Delay(0.5) + action.reversed);
}

@InteractiveTest('FadeOut, FadeIn', group: 'Action')
testFade(GameLoop game) {
  new Label('Fade Out')
    ..addTo(game.scene)
    ..align = 'center'
    ..position.x = game.width / 4
    ..position.y = game.height / 2
    ..runAction(new FadeOut(1) + new FadeOut(1).reversed);

  new Label('Fade In')
    ..addTo(game.scene)
    ..position.x = game.width / 2
    ..position.y = game.height / 2
    ..align = 'center'
    ..opacity = 0.0
    ..runAction(new FadeIn(2) + new FadeIn(1).reversed);

  new Label('Fade To 0.5')
    ..addTo(game.scene)
    ..position.x = 3 * game.width / 4
    ..position.y = game.height / 2
    ..align = 'center'
    ..opacity = 0.0
    ..runAction(new FadeTo(0.5, 2));
}

@InteractiveTest('Repeat', group: 'Action')
testRepeat(GameLoop game) {
  var action = new Repeat(
      new MoveBy(new Vector2(0.0, -50.0), 0.2) +
          new MoveBy(new Vector2(50.0, 0.0), 0.2),
      3);

  new Label('Repeat 3 (Move + Move)')
    ..addTo(game.scene)
    ..position.x = 0.0
    ..position.y = game.height
    ..runAction(action + action.reversed);
}

@InteractiveTest('ActionSpawn', group: 'Action')
testSpawn(GameLoop game) {
  var action = new ActionSpawn([
    new MoveBy(new Vector2(200.0, -200.0), 2),
    new RotateBy(360, 2),
    new ScaleBy(new Vector2(0.5, 0.5), 2)
  ]);

  new Label('Move | Rotate | Scale')
    ..addTo(game.scene)
    ..position.x = 0.0
    ..position.y = game.height
    ..runAction(action + new Delay(0.5) + action.reversed);
}

@InteractiveTest('Multiple Action', group: 'Action')
testMultiple(GameLoop game) {
  new Label('Move Rotate Scale')
    ..addTo(game.scene)
    ..position.x = 0.0
    ..position.y = game.height
    ..runAction(new MoveTo(new Vector2(0.0, game.height / 2), 2))
    ..runAction(new RotateBy(360, 2))
    ..runAction(new ScaleBy(new Vector2(2.0, 2.0), 2));
}

@InteractiveTest('ActionSequece', group: 'Action')
testSequence(GameLoop game) {
  var actions = new ActionSequence([
    new MoveBy(new Vector2(0.0, -100.0), 1),
    new RotateBy(360, 1),
    new ScaleBy(new Vector2(1.5, 1.5), 1)
  ]);

  new Label('Move + Rotate + Scale')
    ..addTo(game.scene)
    ..position.x = 0.0
    ..position.y = game.height
    ..runAction(actions + actions.reversed);
}

@InteractiveTest('Operators', group: 'Action')
testOperators(GameLoop game) {
  new Label('Show + Move + Rotate + Scale')
    ..addTo(game.scene)
    ..position.x = 0.0
    ..position.y = 100.0
    ..visible = false
    ..runAction(new Show() +
        new MoveTo(new Vector2(200.0, 100.0), 2) +
        new RotateBy(360, 2) +
        new ScaleBy(new Vector2(0.5, 0.5), 2));

  new Label('Show | Move | Rotate | Scale')
    ..addTo(game.scene)
    ..position.x = 0.0
    ..position.y = 400.0
    ..visible = false
    ..runAction(new Show() |
        new MoveTo(new Vector2(200.0, 400.0), 2) |
        new RotateBy(360, 2) |
        new ScaleBy(new Vector2(0.5, 0.5), 2));
}

@InteractiveTest('Call function', group: 'Action')
testCallback(GameLoop game) {
  var action = new CallFunction((label) {
    label.text = "New text";
  });
  new Label('Old text')
    ..addTo(game.scene)
    ..align = 'center'
    ..position.x = game.width / 2
    ..position.y = game.height / 2
    ..runAction(new Delay(1) + action);
}

@InteractiveTest('Loop', group: 'Action')
testLoop(GameLoop game) {
  new Label('Endless Loop')
    ..addTo(game.scene)
    ..align = 'center'
    ..position.x = game.width / 2
    ..position.y = game.height / 2
    ..runAction(new Loop(new RotateBy(360, 2)));
}
