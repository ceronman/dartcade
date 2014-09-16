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

class PhysicsComponent {
  GameNode node;
  World world;

  Vector2 get position => node.position;
  Vector2 speed = new Vector2.zero();
  Vector2 acceleration = new Vector2.zero();
  Vector2 bounce =  new Vector2.zero();

  bool collideWorld = true;

  PhysicsComponent(this.world);

  void update(num dt) {
    // Don't use operators directly on the vector classes to avoid memory
    // allocation by creating new instances.
    node.position.x += speed.x * dt;
    node.position.y += speed.y * dt;
    speed.x += acceleration.x * dt;
    speed.y += acceleration.y * dt;

    if (collideWorld){
      _correctForWoldCollision();
    }
  }

  void _correctForWoldCollision() {
    if (position.x < world.left) {
      position.x = world.left;
      speed.x *= -bounce.x;
    }

    if (position.x > world.right) {
      position.x = world.right;
      speed.x *= -bounce.x;
    }

    if (position.y < world.top) {
      position.y = world.top;
      speed.y *= -bounce.y;
    }

    if (position.y > world.bottom) {
      position.y = world.bottom;
      speed.y *= -bounce.y;
    }
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
}
