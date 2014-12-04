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

part of dartcade;

abstract class Aabb2Collidable {
  Aabb2 hitbox;
}

Vector2 checkAabb2InAabb2(Aabb2 innerBox, Aabb2 outerBox) {
  double deltaX = 0.0;
  double deltaY = 0.0;

  if (innerBox.min.x < outerBox.min.x) {
    deltaX = outerBox.min.x - innerBox.min.x;
  } else if (innerBox.max.x > outerBox.max.x) {
    deltaX = innerBox.max.x - outerBox.max.x;
  }

  if (innerBox.min.y < outerBox.min.y) {
    deltaY = outerBox.min.y - innerBox.min.y;
  } else if (innerBox.max.y > outerBox.max.y) {
    deltaX = innerBox.max.y - outerBox.max.y;
  }

  if (deltaX == 0.0 && deltaY == 0.0) {
    return null;
  }
  return new Vector2(deltaX, deltaY);
}

Vector2 checkAabb2VsAabb2(Aabb2 box1, Aabb2 box2) {
  var center1 = new Vector2.zero();
  var center2 = new Vector2.zero();
  var half1 = new Vector2.zero();
  var half2 = new Vector2.zero();
  box1.copyCenterAndHalfExtents(center1, half1);
  box2.copyCenterAndHalfExtents(center2, half2);

  double dx = center1.x - center2.x;
  double px = (half1.x + half2.x) - dx.abs();
  if (px < 0) return null;

  double dy = center1.y - center2.y;
  double py = (half1.y + half2.y) - dy.abs();
  if (py < 0) return null;

  if (px > py) {
    return new Vector2(px * dx.sign, 0.0);
  } else {
    return new Vector2(0.0, py * dy.sign);
  }
}