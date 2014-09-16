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

    var label = new Label('Place 200, 200')
        ..addTo(game.scene)
        ..runAction(new Place(new Vector2(200.0, 200.0)));

  }), test('Show, Hide, ToggleVisibility', () {


    var label1 = new Label('Show')
        ..addTo(game.scene)
        ..align = 'center'
        ..visible = false
        ..position.x = game.width / 4
        ..position.y = game.height / 2
        ..runAction(
            new Delay(1) + new Show() + new Delay(1) + new Show().reversed);

    var label2 = new Label('Hide')
        ..addTo(game.scene)
        ..position.x = game.width / 2
        ..position.y = game.height / 2
        ..align = 'center'
        ..runAction(
            new Delay(1) + new Hide() + new Delay(1) + new Hide().reversed);

    var label3 = new Label('ToggleVisibility')
        ..addTo(game.scene)
        ..position.x = 3 * game.width / 4
        ..position.y = game.height / 2
        ..align = 'center'
        ..runAction(
            new Delay(1) + new ToggleVisibility() + new Delay(1) + new ToggleVisibility());


  }), test('Delay', () {
    var actions = [
        new MoveTo(new Vector2(0.0, game.height / 2), 1),
        new Delay(1),
        new MoveTo(new Vector2(0.0, game.height), 1)];

    var label = new Label('Move + Delay + Move')
        ..addTo(game.scene)
        ..position.x = 0.0
        ..position.y = game.height
        ..runAction(new ActionSequence(actions));


  }), test('Speed', () {
    var action = new RotateBy(360, 2);

    new Label('RotateBy 360 2 seconds 2X speed')
        ..addTo(game.scene)
        ..align = 'center'
        ..position.x = game.width / 2
        ..position.y = game.height / 2
        ..runAction(action + new Speed(action, 2));
  }), test('Accelerate', () {

    var newPos = new Vector2(0.0, game.height - 50);
    Accelerate action = new Accelerate(new MoveBy(newPos, 2), 2);
    var label = new Label('Move to bottom with 2X accel')
        ..addTo(game.scene)
        ..align = 'center'
        ..position.x = game.width / 2
        ..position.y = 50.0
        ..runAction(action + action.reversed);


  }), test('AccelDeccel', () {
    var newPos = new Vector2(0.0, game.height - 50);
    AccelDeccel action = new AccelDeccel(new MoveBy(newPos, 2), 2);

    var label = new Label('Move to top with 2X accel-deccel')
        ..addTo(game.scene)
        ..align = 'center'
        ..position.x = game.width / 2
        ..position.y = 50.0
        ..runAction(action + action.reversed);


  }), test('Blink', () {

    var label = new Label('Blink for 2 seconds')
        ..addTo(game.scene)
        ..align = 'center'
        ..position.x = game.width / 2
        ..position.y = game.height / 2
        ..runAction(new Blink(10, 1) + new Blink(10, 1).reversed);


  }), test('MoveTo', () {

    var label = new Label('MoveTo 100, 100')
        ..addTo(game.scene)
        ..position.x = game.width / 2
        ..position.y = game.height / 2
        ..runAction(new MoveTo(new Vector2(100.0, 100.0), 2));


  }), test('MoveBy', () {
    var action = new MoveBy(new Vector2(100.0, 100.0), 1);

    var label = new Label('MoveBy 100, 100')
        ..addTo(game.scene)
        ..align = 'center'
        ..position.x = game.width / 2
        ..position.y = game.height / 2
        ..runAction(action + action.reversed);


  }), test('RotateTo', () {

    var label1 = new Label('RotateTo 45')
        ..addTo(game.scene)
        ..position.x = 100.0
        ..position.y = game.height / 2
        ..runAction(new RotateTo(45, 2));

    var label2 = new Label('RotateTo 45 reverse')
        ..addTo(game.scene)
        ..position.x = game.width - 300
        ..position.y = game.height / 2
        ..runAction((new RotateTo(45, 2)).reversed);


  }), test('RotateBy', () {

    var action = new RotateBy(90, 1);
    var label = new Label('RotateBy 90')
        ..addTo(game.scene)
        ..position.x = game.width / 2
        ..position.y = game.height / 2
        ..runAction(action + action.reversed);


  }), test('ScaleTo', () {

    var label = new Label('ScaleTo 2, 4')
        ..position.x = game.width / 2
        ..position.y = game.height / 2
        ..runAction(new ScaleTo(new Vector2(2.0, 4.0), 2));
    game.scene.add(label);


  }), test('ScaleBy', () {
    var action = new ScaleBy(new Vector2(1.0, 2.0), 1);

    var label = new Label('ScaleBy 1, 2')
        ..addTo(game.scene)
        ..align = 'center'
        ..position.x = game.width / 2
        ..position.y = game.height / 2
        ..runAction(action + new Delay(0.5) + action.reversed);


  }), test('FadeOut, FadeIn', () {


    var label1 = new Label('Fade Out')
        ..addTo(game.scene)
        ..align = 'center'
        ..position.x = game.width / 4
        ..position.y = game.height / 2
        ..runAction(new FadeOut(1) + new FadeOut(1).reversed);

    var label2 = new Label('Fade In')
        ..addTo(game.scene)
        ..position.x = game.width / 2
        ..position.y = game.height / 2
        ..align = 'center'
        ..opacity = 0.0
        ..runAction(new FadeIn(2) + new FadeIn(1).reversed);

    var label3 = new Label('Fade To 0.5')
        ..addTo(game.scene)
        ..position.x = 3 * game.width / 4
        ..position.y = game.height / 2
        ..align = 'center'
        ..opacity = 0.0
        ..runAction(new FadeTo(0.5, 2));


  }), test('Repeat', () {
    var action =
        new Repeat(
            new MoveBy(new Vector2(0.0, -50.0), 0.2) +
                new MoveBy(new Vector2(50.0, 0.0), 0.2),
            3);

    var label = new Label('Repeat 3 (Move + Move)')
        ..addTo(game.scene)
        ..position.x = 0.0
        ..position.y = game.height
        ..runAction(action + action.reversed);


  }), test('ActionSpawn', () {
    var action =
        new ActionSpawn(
            [
                new MoveBy(new Vector2(200.0, -200.0), 2),
                new RotateBy(360, 2),
                new ScaleBy(new Vector2(0.5, 0.5), 2)]);

    var label = new Label('Move | Rotate | Scale')
        ..addTo(game.scene)
        ..position.x = 0.0
        ..position.y = game.height
        ..runAction(action + new Delay(0.5) + action.reversed);


  }), test('Multiple Action', () {

    var label = new Label('Move Rotate Scale')
        ..addTo(game.scene)
        ..position.x = 0.0
        ..position.y = game.height
        ..runAction(new MoveTo(new Vector2(0.0, game.height / 2), 2))
        ..runAction(new RotateBy(360, 2))
        ..runAction(new ScaleBy(new Vector2(2.0, 2.0), 2));


  }), test('ActionSequece', () {
    var actions =
        new ActionSequence(
            [
                new MoveBy(new Vector2(0.0, -100.0), 1),
                new RotateBy(360, 1),
                new ScaleBy(new Vector2(1.5, 1.5), 1)]);

    var label = new Label('Move + Rotate + Scale')
        ..addTo(game.scene)
        ..position.x = 0.0
        ..position.y = game.height
        ..runAction(actions + actions.reversed);


  }), test('Operators', () {

    var label1 = new Label('Show + Move + Rotate + Scale')
        ..addTo(game.scene)
        ..position.x = 0.0
        ..position.y = 100.0
        ..visible = false
        ..runAction(
            new Show() +
                new MoveTo(new Vector2(200.0, 100.0), 2) +
                new RotateBy(360, 2) +
                new ScaleBy(new Vector2(0.5, 0.5), 2));

    var label2 = new Label('Show | Move | Rotate | Scale')
        ..addTo(game.scene)
        ..position.x = 0.0
        ..position.y = 400.0
        ..visible = false
        ..runAction(
            new Show() |
                new MoveTo(new Vector2(200.0, 400.0), 2) |
                new RotateBy(360, 2) |
                new ScaleBy(new Vector2(0.5, 0.5), 2));


  }), test('Call function', () {
    var action = new CallFunction((label) {
      label.text = "New text";
    });

    var label = new Label('Old text')
        ..addTo(game.scene)
        ..align = 'center'
        ..position.x = game.width / 2
        ..position.y = game.height / 2
        ..runAction(new Delay(1) + action);
  }), test('Loop', () {

    var label = new Label('Endless Loop')
        ..addTo(game.scene)
        ..align = 'center'
        ..position.x = game.width / 2
        ..position.y = game.height / 2
        ..runAction(new Loop(new RotateBy(360, 2)));
  }),];
