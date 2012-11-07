part of cocos;

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
class Sprite extends GameNode {
  ImageElement image;

  get width => image.width;
  get height => image.height;

  Sprite(ImageElement this.image, {pos}): super() {
    position = pos != null ? pos : position;
  }

  void draw(CanvasRenderingContext2D context) {
    context.drawImage(image, 0, 0);
  }
}