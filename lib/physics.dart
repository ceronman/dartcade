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

class CollisionHandlers {
  static void bounce(PhysicsComponent body1, int side1, PhysicsComponent body2,
      int side2) {
    if (!body1.isStatic) {
      if (side2 == Side.TOP || side2 == Side.BOTTOM) {
        body1.speed.y = body1.speed.y * -body1.bounce.y;
      }
      if (side2 == Side.LEFT || side2 == Side.RIGHT) {
        body1.speed.x = body1.speed.x * -body1.bounce.y;
      }
    }
  }
}

class PhysicsComponent {
  GameNode node;
  World world;

  Vector2 get position => node.position;
  Vector2 speed = new Vector2.zero();
  Vector2 acceleration = new Vector2.zero();
  Vector2 bounce = new Vector2.zero();
  bool isStatic = false;

  PhysicsComponent(this.world);

  void update(num dt) {
    // Don't use operators directly on the vector classes to avoid memory
    // allocation by creating new instances.
    node.position.x += speed.x * dt;
    node.position.y += speed.y * dt;
    speed.x += acceleration.x * dt;
    speed.y += acceleration.y * dt;
  }
}

class World {
  Vector2 position;
  Vector2 size;

  // TODO: Duplicated functionality with GameNode
  double get left => position.x;
  double get top => position.y;
  double get right => position.x + size.x;
  double get bottom => position.y + size.y;

  World(double x, double y, double width, double height) {
    position = new Vector2(x, y);
    size = new Vector2(width, height);
  }

  void update(num dt) {

  }
}
