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

var inputTests = [

  test('KeyStateHandler', () {
    var layer = new Layer();
    var label = new Label('Use Arrow Keys');
    label.position.x = game.width /2;
    label.position.y = game.height /2;
    label.align = 'center';
    layer.add(label);

    var scene = new Scene(layer);
    scene.onFrame.listen((dt){
      if (game.keyboard[Keys.LEFT]) {
        label.position.x -= 1;
      }
      if (game.keyboard[Keys.RIGHT]) {
        label.position.x += 1;
      }
      if (game.keyboard[Keys.UP]) {
        label.position.y -= 1;
      }
      if (game.keyboard[Keys.DOWN]) {
        label.position.y += 1;
      }
    });
    game.currentScene = scene;
  }),

  test('game onKeyDown and onKeyUp', () {
    var layer = new Layer();
    var label = new Label('Press any key');
    label.position.x = game.width /2;
    label.position.y = game.width /2;
    label.align = 'center';
    layer.add(label);

    game.onKeyDown.listen((e) => label.text = 'Pressed ${e.keyCode}');
    game.onKeyUp.listen((e) => label.text = 'Press any key');

    game.currentScene = new Scene(layer);;
  })

];


