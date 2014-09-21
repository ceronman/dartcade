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

  double get x => min.x;
  double get y => min.y;
  double get width => max.x - min.x;
  double get height => max.y - min.y;

  double get left => min.x;
  double get top => min.y;
  double get right => max.x;
  double get bottom => max.y;

  Vector2 get center => min.clone().add(max).scale(0.5);
}