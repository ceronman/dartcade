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

class CollisionResponse {

  // TODO: Think about bouncing two objects
  static void bounce(CollisionEvent e) {
    var body = e.body1 as Body; // TODO: better not to have to use this.
    body.position.add(body.speed.scaled(-e.entryTime));
    body.speed.reflect(e.normal2).multiply(body.restitution);
    body.position.add(body.speed.scaled(e.entryTime));
    body.sync();
  }
}

// TODO: Add a debug draw for hit boxes.
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

  Body(this.world);

  void update(double dt) {
    position.x += speed.x * dt;
    position.y += speed.y * dt;

    // TODO: Updating speed right after updating position messes up with
    // collisions
    speed.x += acceleration.x * dt;
    speed.y += acceleration.y * dt;
    sync();
  }

  // TODO: is this the best way to do it (collision handlers)
  void sync() {
    _updateHitBox();
    node.position.setFrom(position);
  }

  void _updateHitBox() {
    hitbox.min.setValues(
        position.x - node.width * node.positionAnchor.x,
        position.y - node.height * node.positionAnchor.y);
    hitbox.max.setValues(hitbox.min.x + node.width, hitbox.min.y + node.height);
  }
}

class World implements Collidable {
  Aabb2 hitbox = new Aabb2();

  // TODO: Try moving these to Aabb2
  double get left => hitbox.min.x;
  double get right => hitbox.max.x;
  double get top => hitbox.min.y;
  double get bottom => hitbox.max.y;

  List<Collision> _collisions = new List<Collision>();

  World(double x, double y, double width, double height) {
    hitbox.min.setValues(x, y);
    hitbox.max.setValues(x + width, y + height);
  }

  Stream<CollisionEvent> collide(GameNode node1, [GameNode node2]) {
    Collision collision;
    if (node2 == null) {
      collision = new BodyVsWorldBoxCollision(node1.body, this);
    } else {
      collision = new SweptBoxCollision(node1.body, node2.body);
    }
    _collisions.add(collision);
    return collision.onCollision;
  }

  void update(double dt) {
    for (var collision in _collisions) {
      collision.check();
    }
  }
}
