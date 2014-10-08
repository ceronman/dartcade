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

part of dartcade_test;

@InteractiveTest('KeyStateHandler', group: 'Input')
testKeyStateHandler(GameLoop game) {
  var label = new Label('Use Arrow Keys')
      ..position.x = game.width / 2
      ..position.y = game.height / 2
      ..align = 'center'
      ..addTo(game.scene);

  game.scene.onFrame.listen((dt) {
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
}

@InteractiveTest('onKeyDown and onKeyUp', group: 'Input')
testKeyEvents(GameLoop game) {
  var label = new Label('Press any key')
      ..position.x = game.width / 2
      ..position.y = game.width / 2
      ..align = 'center'
      ..addTo(game.scene);

  game.onKeyDown.listen((e) => label.text = 'Pressed ${e.keyCode}');
  game.onKeyUp.listen((e) => label.text = 'Press any key');
}
