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

abstract class Body {
  GameNode node;
}

class ArcadeBody extends Body {
  Collider _collider;

  Collider get collider => _collider;
  set collider(Collider value) {
    _collider = value;
    _collider.body = this;
  }

  Vector2 get position => node.position;
  Vector2 get size => node.size;
  Vector2 speed = new Vector2.zero();
  Vector2 acceleration = new Vector2.zero();
  Vector2 restitution = new Vector2.zero();

  ArcadeBody();

  void update(double dt) {
    position.x += speed.x * dt;
    position.y += speed.y * dt;
    speed.x += acceleration.x * dt;
    speed.y += acceleration.y * dt;

    if (collider != null) collider.syncFromBody();
  }

  void addTo(ArcadeWorld world) {
    world.addBody(this);
  }
}

class ArcadeWorld {
  List<ArcadeBody> bodies = new List<ArcadeBody>();
  Collider collider;
  List<CollisionCheck> collisions = new List<CollisionCheck>();

  ArcadeWorld(double x, double y, double width, double height) {
    collider = new AABB2Collider()
      ..boundingbox = new AABB2.xywh(x, y, width, height);
  }

  void addBody(ArcadeBody body) {
    bodies.add(body);
  }

  void update(double dt) {
    for (var body in bodies) {
      body.update(dt);
    }

    for (var collision in collisions) {
      collision.check();
    }
  }
}
