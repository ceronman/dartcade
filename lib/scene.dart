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

part of cocos;

class Scene extends GameNode {

  Game game;

  double get width => game.width;
  double get height => game.height;

  Scene();

  _active(event) => game.scene == this;

  // TODO: These don't seem to work properly.
  Stream<html.KeyboardEvent> get onKeyDown => game.onKeyDown.where(_active);
  Stream<html.KeyboardEvent> get onKeyUp => game.onKeyDown.where(_active);
  Stream<html.MouseEvent> get onMouseDown => game.onMouseDown.where(_active);
  Stream<html.MouseEvent> get onMouseUp => game.onMouseUp.where(_active);
  Stream<html.MouseEvent> get onMouseMove => game.onMouseMove.where(_active);
  Stream<html.WheelEvent> get onMouseWheel => game.onMouseWheel.where(_active);
}
