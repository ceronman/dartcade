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

  int width;
  int height;

  Layer layer;

  Scene([Layer layer]): super() {
    if (layer != null) {
      this.add(layer);
    }

    this.layer = layer;

  }

  keyPress(KeyboardEvent event) => layer.keyPress(event);
  mouseDown(MouseEvent event) => layer.mouseDown(event);
}

class Layer extends GameNode {
  get width => parent.width;
  get height => parent.height;

  keyPress(KeyboardEvent event) {}
  mouseDown(MouseEvent event) {}
}