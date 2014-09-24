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

  Vector2 get min;
  Vector2 get max;

  set min(Vector2 value);
  set max(Vector2 value);

  double get x => min.x;
  double get y => min.y;
  double get width => max.x - min.x;
  double get height => max.y - min.y;

  double get left => min.x;
  double get top => min.y;
  double get right => max.x;
  double get bottom => max.y;

  Vector2 get center => min.clone().add(max).scale(0.5);

  set x(double value) => min = new Vector2(value, min.y);
  set y(double value) => min = new Vector2(min.x, value);
  set left(num value) => min = new Vector2(value, min.y);
  set right(num value) => max = new Vector2(value, max.y);
  set top(num value) => min = new Vector2(min.x, value);
  set bottom(num value) => max = new Vector2(max.x, value);

  bool intersectsWith(Box other) {
    return min.x <= other.max.x &&
        min.y <= other.max.y &&
        max.x >= other.min.x &&
        max.y >= other.min.y;
  }

  bool containsPoint(Vector2 other) {
    return min.x < other.x &&
        min.y < other.y &&
        max.x > other.x &&
        max.y > other.y;
  }

  bool containsBox(Box other) {
    return min.x < other.min.x &&
        min.y < other.min.y &&
        max.y > other.max.y &&
        max.x > other.max.x;
  }
}
