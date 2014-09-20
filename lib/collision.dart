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

class Side {
  static const int TOP = 1;
  static const int BOTTOM = 2;
  static const int LEFT = 4;
  static const int RIGHT = 8;
  static const int ALL = 15;
}

class CollisionEvent {
  GameNode body1;
  int side1;
  GameNode body2;
  int side2;

  CollisionEvent(this.body1, this.side1, this.body2, this.side2);
}

abstract class Collision {
  StreamController<CollisionEvent> onCollisionController =
      new StreamController<CollisionEvent>();

  void check();
}

class OuterBoxCollision extends Collision {
  BoundingBox outer;
  BoundingBox inner;

  OuterBoxCollision(this.inner, this.outer);

  void check() {
    if (inner.left < outer.left) {
      onCollisionController.add(
          new CollisionEvent(inner, Side.LEFT, outer, Side.LEFT));
    }
    if (inner.right > outer.right) {
      onCollisionController.add(
          new CollisionEvent(inner, Side.RIGHT, outer, Side.RIGHT));
    }
    if (inner.bottom > outer.bottom) {
      onCollisionController.add(
          new CollisionEvent(inner, Side.BOTTOM, outer, Side.BOTTOM));
    }
    if (inner.top > outer.top) {
      onCollisionController.add(
          new CollisionEvent(inner, Side.TOP, outer, Side.TOP));
    }
  }
}

class CollisionHandlers {
  static void bounce(CollisionEvent event) {
    var body1 = event.body1.physics;
    var body2 = event.body2.physics;
    if (event.side2 == Side.TOP || event.side2 == Side.BOTTOM) {
      body1.speed.y = body1.speed.y * -body1.bounce.y;
    }
    if (event.side2 == Side.LEFT || event.side2 == Side.RIGHT) {
      body1.speed.x = body1.speed.x * -body1.bounce.y;
    }
  }
}
