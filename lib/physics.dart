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
  void syncToNode();
  void syncFromNode();
}

class ArcadeBody extends Body {
  Collider collider;

  Vector2 size = new Vector2.zero();
  Vector2 position = new Vector2.zero();
  Vector2 speed = new Vector2.zero();
  Vector2 acceleration = new Vector2.zero();
  Vector2 restitution = new Vector2.zero();

  ArcadeBody();

  void update(double dt) {
    position.x += speed.x * dt;
    position.y += speed.y * dt;
    speed.x += acceleration.x * dt;
    speed.y += acceleration.y * dt;
  }

  void syncToNode() {
    node.position.setFrom(position);
  }

  void syncFromNode() {
    position.setFrom(node.position);

    // TODO: change GameNode to use size intead of width and height??
    size.setValues(node.width, node.height);
  }
}

class ArcadeWorld {
  List<ArcadeBody> bodies;
  Collider collider;

  ArcadeWorld(double x, double y, double width, double height);

  void addBody(ArcadeBody body) {
    bodies.add(body);
  }

  void update(double dt) {
    for (var body in bodies) {
      body.update(dt);
    }
  }
}
