// Copyright 2014 Manuel Cerón <ceronman@gmail.com>
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

part of dartcocos_test;

// TODO: Check positions in tests.

var actionTests = [test('Place', () {
    var layer = new Layer();
    var label = new Label('Place 200, 200')
        ..addTo(layer)
        ..runAction(new Place(new vec2(200, 200)));
    game.currentScene = new Scene(layer);
  }), test('Show, Hide, ToggleVisibility', () {
    var layer = new Layer();

    var label1 = new Label('Show')
        ..addTo(layer)
        ..align = 'center'
        ..visible = false
        ..position.x = game.width / 4
        ..position.y = game.height / 2
        ..runAction(
            new Delay(1) + new Show() + new Delay(1) + new Show().reversed);

    var label2 = new Label('Hide')
        ..addTo(layer)
        ..position.x = game.width / 2
        ..position.y = game.height / 2
        ..align = 'center'
        ..runAction(
            new Delay(1) + new Hide() + new Delay(1) + new Hide().reversed);

    var label3 = new Label('ToggleVisibility')
        ..addTo(layer)
        ..position.x = 3 * game.width / 4
        ..position.y = game.height / 2
        ..align = 'center'
        ..runAction(
            new Delay(1) + new ToggleVisibility() + new Delay(1) + new ToggleVisibility());

    game.currentScene = new Scene(layer);
  }), test('Delay', () {
    var actions = [
        new MoveTo(new vec2(0, game.height / 2), 1),
        new Delay(1),
        new MoveTo(new vec2(0, game.height), 1)];
    var layer = new Layer();
    var label = new Label('Move + Delay + Move')
        ..addTo(layer)
        ..position.x = 0
        ..position.y = game.height
        ..runAction(new ActionSequence(actions));

    game.currentScene = new Scene(layer);
  }), test('Speed', () {
    var action = new RotateBy(360, 2);
    // TODO: MAYBE Use this notation or the one in other tests?
    game.currentScene = new Scene()..add(
        new Layer()..add(new Label('RotateBy 360 2 seconds 2X speed')
                ..align = 'center'
                ..position.x = game.width / 2
                ..position.y = game.height / 2
                ..runAction(action + new Speed(action, 2))));
  }), test('Accelerate', () {
    var layer = new Layer();
    var newPos = new vec2(0, game.height - 50);
    Accelerate action = new Accelerate(new MoveBy(newPos, 2), 2);
    var label = new Label('Move to bottom with 2X accel')
        ..addTo(layer)
        ..align = 'center'
        ..position.x = game.width / 2
        ..position.y = 50
        ..runAction(action + action.reversed);

    game.currentScene = new Scene(layer);
  }), test('AccelDeccel', () {
    var newPos = new vec2(0, game.height - 50);
    AccelDeccel action = new AccelDeccel(new MoveBy(newPos, 2), 2);
    var layer = new Layer();
    var label = new Label('Move to top with 2X accel-deccel')
        ..addTo(layer)
        ..align = 'center'
        ..position.x = game.width / 2
        ..position.y = 50
        ..runAction(action + action.reversed);

    game.currentScene = new Scene(layer);
  }), test('Blink', () {
    var layer = new Layer();
    var label = new Label('Blink for 2 seconds')
        ..addTo(layer)
        ..align = 'center'
        ..position.x = game.width / 2
        ..position.y = game.height / 2
        ..runAction(new Blink(10, 1) + new Blink(10, 1).reversed);

    game.currentScene = new Scene(layer);
  }), test('MoveTo', () {
    var layer = new Layer();
    var label = new Label('MoveTo 100, 100')
        ..addTo(layer)
        ..position.x = game.width / 2
        ..position.y = game.height / 2
        ..runAction(new MoveTo(new vec2(100, 100), 2));

    game.currentScene = new Scene(layer);
  }), test('MoveBy', () {
    var action = new MoveBy(new vec2(100, 100), 1);
    var layer = new Layer();
    var label = new Label('MoveBy 100, 100')
        ..addTo(layer)
        ..align = 'center'
        ..position.x = game.width / 2
        ..position.y = game.height / 2
        ..runAction(action + action.reversed);

    game.currentScene = new Scene(layer);
  }), test('RotateTo', () {
    var layer = new Layer();
    var label1 = new Label('RotateTo 45')
        ..addTo(layer)
        ..position.x = 100
        ..position.y = game.height / 2
        ..runAction(new RotateTo(45, 2));

    var label2 = new Label('RotateTo 45 reverse')
        ..addTo(layer)
        ..position.x = game.width - 300
        ..position.y = game.height / 2
        ..runAction((new RotateTo(45, 2)).reversed);

    game.currentScene = new Scene(layer);
  }), test('RotateBy', () {
    var layer = new Layer();
    var action = new RotateBy(90, 1);
    var label = new Label('RotateBy 90')
        ..addTo(layer)
        ..position.x = game.width / 2
        ..position.y = game.height / 2
        ..runAction(action + action.reversed);

    game.currentScene = new Scene(layer);
  }), test('ScaleTo', () {
    var layer = new Layer();
    var label = new Label('ScaleTo 2, 4')
        ..position.x = game.width / 2
        ..position.y = game.height / 2
        ..runAction(new ScaleTo(new vec2(2, 4), 2));
    layer.add(label);

    game.currentScene = new Scene(layer);
  }), test('ScaleBy', () {
    var action = new ScaleBy(new vec2(1, 2), 1);
    var layer = new Layer();
    var label = new Label('ScaleBy 1, 2')
        ..addTo(layer)
        ..align = 'center'
        ..position.x = game.width / 2
        ..position.y = game.height / 2
        ..runAction(action + new Delay(0.5) + action.reversed);

    game.currentScene = new Scene(layer);
  }), test('FadeOut, FadeIn', () {
    var layer = new Layer();

    var label1 = new Label('Fade Out')
        ..addTo(layer)
        ..align = 'center'
        ..position.x = game.width / 4
        ..position.y = game.height / 2
        ..runAction(new FadeOut(1) + new FadeOut(1).reversed);

    var label2 = new Label('Fade In')
        ..addTo(layer)
        ..position.x = game.width / 2
        ..position.y = game.height / 2
        ..align = 'center'
        ..opacity = 0.0
        ..runAction(new FadeIn(2) + new FadeIn(1).reversed);

    var label3 = new Label('Fade To 0.5')
        ..addTo(layer)
        ..position.x = 3 * game.width / 4
        ..position.y = game.height / 2
        ..align = 'center'
        ..opacity = 0.0
        ..runAction(new FadeTo(0.5, 2));

    game.currentScene = new Scene(layer);
  }), test('Repeat', () {
    var action =
        new Repeat(
            new MoveBy(new vec2(0, -50), 0.2) + new MoveBy(new vec2(50, 0), 0.2),
            3);
    var layer = new Layer();
    var label = new Label('Repeat 3 (Move + Move)')
        ..addTo(layer)
        ..position.x = 0
        ..position.y = game.height
        ..runAction(action + action.reversed);

    game.currentScene = new Scene(layer);
  }), test('ActionSpawn', () {
    var action =
        new ActionSpawn(
            [
                new MoveBy(new vec2(200, -200), 2),
                new RotateBy(360, 2),
                new ScaleBy(new vec2(0.5, 0.5), 2)]);
    var layer = new Layer();
    var label = new Label('Move | Rotate | Scale')
        ..addTo(layer)
        ..position.x = 0
        ..position.y = game.height
        ..runAction(action + new Delay(0.5) + action.reversed);

    game.currentScene = new Scene(layer);
  }), test('Multiple Action', () {
    var layer = new Layer();
    var label = new Label('Move Rotate Scale')
        ..addTo(layer)
        ..position.x = 0
        ..position.y = game.height
        ..runAction(new MoveTo(new vec2(0, game.height / 2), 2))
        ..runAction(new RotateBy(360, 2))
        ..runAction(new ScaleBy(new vec2(2, 2), 2));

    game.currentScene = new Scene(layer);
  }), test('ActionSequece', () {
    var actions =
        new ActionSequence(
            [
                new MoveBy(new vec2(0, -100), 1),
                new RotateBy(360, 1),
                new ScaleBy(new vec2(1.5, 1.5), 1)]);
    var layer = new Layer();
    var label = new Label('Move + Rotate + Scale')
        ..addTo(layer)
        ..position.x = 0
        ..position.y = game.height
        ..runAction(actions + actions.reversed);

    game.currentScene = new Scene(layer);
  }), test('Operators', () {
    var layer = new Layer();
    var label1 = new Label('Show + Move + Rotate + Scale')
        ..addTo(layer)
        ..position.x = 0
        ..position.y = 100
        ..visible = false
        ..runAction(
            new Show() +
                new MoveTo(new vec2(200, 100), 2) +
                new RotateBy(360, 2) +
                new ScaleBy(new vec2(0.5, 0.5), 2));

    var label2 = new Label('Show | Move | Rotate | Scale')
        ..addTo(layer)
        ..position.x = 0
        ..position.y = 400
        ..visible = false
        ..runAction(
            new Show() |
                new MoveTo(new vec2(200, 400), 2) |
                new RotateBy(360, 2) |
                new ScaleBy(new vec2(0.5, 0.5), 2));

    game.currentScene = new Scene(layer);
  }), test('Call function', () {
    var action = new CallFunction((label) {
      label.text = "New text";
    });
    var layer = new Layer();
    var label = new Label('Old text')
        ..addTo(layer)
        ..align = 'center'
        ..position.x = game.width / 2
        ..position.y = game.height / 2
        ..runAction(new Delay(1) + action);

    game.currentScene = new Scene(layer);
  }), test('Loop', () {
    var layer = new Layer();
    var label = new Label('Endless Loop')
        ..addTo(layer)
        ..align = 'center'
        ..position.x = game.width / 2
        ..position.y = game.height / 2
        ..runAction(new Loop(new RotateBy(360, 2)));

    game.currentScene = new Scene(layer);
  }),];
