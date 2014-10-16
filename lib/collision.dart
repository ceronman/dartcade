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

abstract class Collidable {
  Aabb2 get hitbox;
}

class Side {
  static Vector2 get left => new Vector2(-1.0, 0.0);
  static Vector2 get right => new Vector2(1.0, 0.0);
  static Vector2 get up => new Vector2(0.0, -1.0);
  static Vector2 get down => new Vector2(0.0, 1.0);
}

class CollisionEvent {
  Collidable body1;
  Vector2 normal1;
  Collidable body2;
  Vector2 normal2;
  double entryTime;

  CollisionEvent(this.body1, this.normal1, this.body2, this.normal2,
      this.entryTime);
}

abstract class Collision {
  StreamController<CollisionEvent> onCollisionController =
      new StreamController<CollisionEvent>.broadcast(sync: true);
  Stream<CollisionEvent> get onCollision => onCollisionController.stream;

  void check();
}

// TODO: Fix the double collision problem when the correction of a collision
//       Generates another collisoin
class BodyVsWorldBoxCollision extends Collision {
  World world;
  Body body;

  BodyVsWorldBoxCollision(this.body, this.world);

  void check() {
    // TODO: Is it right to use infinity when the object is not moving?
    if (body.hitbox.min.x < world.hitbox.min.x) {
      double entryTime = body.speed.x != 0 ?
          (body.left - world.left) / body.speed.x :
          double.INFINITY;
      onCollisionController.add(
          new CollisionEvent(body, Side.left, world, Side.right, entryTime));

    }
    if (body.hitbox.max.x > world.hitbox.max.x) {
      double entryTime = body.speed.x != 0 ?
          (body.right - world.right) / body.speed.x :
          double.INFINITY;
      onCollisionController.add(
          new CollisionEvent(body, Side.right, world, Side.left, entryTime));
    }
    if (body.hitbox.min.y < world.hitbox.min.y) {
      double entryTime = body.speed.y != 0 ?
          (body.top - world.top) / body.speed.y :
          double.INFINITY;
      onCollisionController.add(
          new CollisionEvent(body, Side.up, world, Side.down, entryTime));
    }
    if (body.hitbox.max.y > world.hitbox.max.y) {
      double entryTime = body.speed.y != 0 ?
          (body.bottom - world.bottom) / body.speed.y :
          double.INFINITY;
      onCollisionController.add(
          new CollisionEvent(body, Side.down, world, Side.up, entryTime));
    }
  }
}

class SweptBoxCollision extends Collision {
  Body body1;
  Body body2;

  Aabb2 _box1 = new Aabb2();
  Aabb2 _box2 = new Aabb2();
  Vector2 _entryDistance = new Vector2.zero();
  Vector2 _exitDistance = new Vector2.zero();
  Vector2 _entryTime = new Vector2.zero();
  Vector2 _exitTime = new Vector2.zero();
  Vector2 _relativeSpeed = new Vector2.zero();

  SweptBoxCollision(this.body1, this.body2) {
    body1.node.debugBoxes.add({ "box": _box1, "color": "red" });
  }

  void check() {
    _relativeSpeed = (body1.position - body1.previousPosition) - (body2.position - body2.previousPosition);
    _box1.copyFrom(body1.hitbox);
    _box2.copyFrom(body2.hitbox);

    _box1.min.sub(_relativeSpeed);
    _box1.max.sub(_relativeSpeed);

    if (_relativeSpeed.x > 0.0) {
      _entryDistance.x = _box2.min.x - _box1.max.x;
      _exitDistance.x = _box2.max.x - _box1.min.x;
    } else {
      _entryDistance.x = _box2.max.x - _box1.min.x;
      _exitDistance.x = _box2.min.x - _box2.max.x;
    }

    if (_relativeSpeed.y > 0.0) {
      _entryDistance.y = _box2.min.y - _box1.max.y;
      _exitDistance.y = _box2.max.y - _box1.min.y;
    } else {
      _entryDistance.y = _box2.max.y - _box1.min.y;
      _exitDistance.y = _box2.min.y - _box2.max.y;
    }

    if (_relativeSpeed.x == 0.0) {
      _entryTime.x = -double.INFINITY;
      _exitTime.x = double.INFINITY;
    } else {
      _entryTime.x = _entryDistance.x / _relativeSpeed.x;
      _exitTime.x = _exitDistance.x / _relativeSpeed.x;
    }

    if (_relativeSpeed.y == 0.0) {
      _entryTime.y = -double.INFINITY;
      _exitTime.y = double.INFINITY;
    } else {
      _entryTime.y = _entryDistance.y / _relativeSpeed.y;
      _exitTime.y = _exitDistance.y / _relativeSpeed.y;
    }

    if (_entryTime.y > 1.0) _entryTime.y = -double.INFINITY; // From previous bug above.
    if (_entryTime.x > 1.0) _entryTime.x = -double.INFINITY; // From previous bug above.

    double entryTime = max(_entryTime.x, _entryTime.y);
    double exitTime = min(_exitTime.x, _exitTime.y);

    print("$_relativeSpeed $_entryDistance   $_entryTime   $_exitTime $entryTime, $exitTime");
    if (entryTime > exitTime) return null; // This check was correct.
    if (_entryTime.x < 0.0 && _entryTime.y < 0.0) return null;
    if (_entryTime.x < 0.0 ) {
      // Check that the bounding box started overlapped or not.
      if (_box1.max.x < _box2.min.x || _box1.min.x > _box2.max.x) return null;
    }
    if (_entryTime.y < 0.0) {
      // Check that the bounding box started overlapped or not.
      if (_box1.max.y < _box2.min.y || _box1.min.y > _box2.max.y) return null;
    }

    Vector2 side1;
    Vector2 side2;

    if (_entryTime.x > _entryTime.y) {
      if (_entryDistance.x < 0.0) {
        side1 = Side.right;
        side2 = Side.left;
      } else {
        side1 = Side.left;
        side2 = Side.right;
      }
    } else {
      if (_entryDistance.y < 0.0) {
        side1 = Side.down;
        side2 = Side.up;
      } else {
        side1 = Side.up;
        side2 = Side.down;
      }
    }
    onCollisionController.add(
        new CollisionEvent(body1, side1, body2, side2, entryTime));
  }
}
