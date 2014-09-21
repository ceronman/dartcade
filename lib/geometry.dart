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

part of cocos;

abstract class Box {

  Vector2 get position;
  Vector2 get size;

  double get x => position.x;
  double get y => position.y;
  double get width => size.x;
  double get height => size.y;

  double get left => position.x;
  double get top => position.y;
  double get right => position.x + size.x;
  double get bottom => position.y + size.y;

  Vector2 get center => new Vector2(x + width/2, y + height/2);
}