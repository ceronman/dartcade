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

class AABB2 {
  Vector2 center = new Vector2.zero();
  Vector2 half = new Vector2.zero();

  double get left => center.x - half.x;
  double get right => center.x + half.x;
  double get top => center.y - half.y;
  double get bottom => center.y + half.y;

  Vector2 get topLeft => new Vector2(top, left);
  Vector2 get topRight => new Vector2(top, right);
  Vector2 get bottomLeft => new Vector2(bottom, left);
  Vector2 get bottomRight => new Vector2(bottom, right);
  Vector2 get min => topLeft;
  Vector2 get max => bottomRight;

  AABB2();
  AABB2.centerHalf(Vector2 this.center, Vector2 this.half);
}

abstract class BoxCollider {
  AABB2 bounds;
  Body body;

  void update() {
    bounds.center.setFrom(body.position);
  }
}

class CollisionChecker<T> {
  Set<T> bodies;

  void checkBodyVsBody(T body1, T body2) {

  }

  void checkBodyInBody(T body1, T body2) {

  }

  void checkBodyVsGroup(T body1, List<T> group) {

  }

  void checkGroupVsGroup(List<T> group1, List<T> group2) {

  }
}

class CollisionBroadphaseSelector {

}

Vector2 checkAabb2InAabb2(AABB2 innerBox, AABB2 outerBox) {
  double deltaX = 0.0;
  double deltaY = 0.0;

  if (innerBox.left < outerBox.left) {
    deltaX = outerBox.left - innerBox.left;
  } else if (innerBox.right > outerBox.right) {
    deltaX = innerBox.right - outerBox.right;
  }

  if (innerBox.top < outerBox.top) {
    deltaY = outerBox.top - innerBox.top;
  } else if (innerBox.bottom > outerBox.bottom) {
    deltaX = innerBox.bottom - outerBox.bottom;
  }

  if (deltaX == 0.0 && deltaY == 0.0) {
    return null;
  }
  return new Vector2(deltaX, deltaY);
}

Vector2 checkAabb2VsAabb2(AABB2 box1, AABB2 box2) {
  double dx = box1.center.x - box2.center.x;
  double px = (box1.half.x + box2.half.x) - dx.abs();
  if (px < 0) return null;

  double dy = box1.center.y - box2.center.y;
  double py = (box1.half.y + box2.half.y) - dy.abs();
  if (py < 0) return null;

  if (px > py) {
    return new Vector2(px * dx.sign, 0.0);
  } else {
    return new Vector2(0.0, py * dy.sign);
  }
}
