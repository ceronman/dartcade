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

class Body implements Collidable {
  GameNode node;
  World world;

  Aabb2 hitbox = new Aabb2();

  Vector2 position = new Vector2.zero();
  Vector2 speed = new Vector2.zero();
  Vector2 acceleration = new Vector2.zero();
  Vector2 restitution = new Vector2.zero();

  double get left => hitbox.min.x;
  double get right => hitbox.max.x;
  double get top => hitbox.min.y;
  double get bottom => hitbox.max.y;

  set left(double value) {
    position.x = value;
    _updateHitBox();
  }
  set right(double value) {
    position.x = value - (hitbox.max.x - hitbox.min.x);
    _updateHitBox();
  }
  set top(double value) {
    position.y = value;
    _updateHitBox();
  }
  set bottom(double value) {
    position.y = value - (hitbox.max.y - hitbox.min.y);
    _updateHitBox();
  }

  Body(this.world);

  void update(double dt) {
    position.x += speed.x * dt;
    position.y += speed.y * dt;
    speed.x += acceleration.x * dt;
    speed.y += acceleration.y * dt;
    _updateHitBox();
    node.position.setFrom(position);
  }

  void _updateHitBox() {
    hitbox.min.setValues(position.x, position.y);
    hitbox.max.setValues(position.x + node.width, position.y + node.height);
  }
}

class World implements Collidable {
  Aabb2 hitbox = new Aabb2();

  List<Collision> _collisions = new List<Collision>();

  World(double x, double y, double width, double height) {
    hitbox.min.setValues(x, y);
    hitbox.max.setValues(x + width, y + height);
  }

  Stream<CollisionEvent> collide(GameNode node1, [GameNode node2]) {
    if (node2 == null) {
      var collision = new OuterBoxCollision(node1.body, this);
      _collisions.add(collision);
      return collision.onCollision;
    }
    return null;
  }

  void update(double dt) {
    for (var collision in _collisions) {
      collision.check();
    }
  }
}
