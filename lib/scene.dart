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

  double get width => game.width;
  double get height => game.height;

  _active(event) => game.scene = this;

  Stream<KeyboardEvent> get onKeyDown => game.onKeyDown.where(_active);
  Stream<KeyboardEvent> get onKeyUp => game.onKeyDown.where(_active);
  Stream<MouseEvent> get onMouseDown => game.onMouseDown.where(_active);
  Stream<MouseEvent> get onMouseUp => game.onMouseUp.where(_active);
  Stream<MouseEvent> get onMouseMove => game.onMouseMove.where(_active);
  Stream<WheelEvent> get onMouseWheel => game.onMouseWheel.where(_active);

  Layer layer;

  Scene([Layer layer]) : super() {
    if (layer != null) {
      this.add(layer);
    }
    this.layer = layer;
  }
}
