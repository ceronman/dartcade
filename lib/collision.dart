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

abstract class Collidable {
  Aabb2 get hitbox;
}

class CollisionEvent {
  Collidable body1;
  Vector2 normal1;
  Collidable body2;
  Vector2 normal2;

  CollisionEvent(this.body1, this.normal1, this.body2, this.normal2);
}

abstract class Collision {
  // TODO: Check if this is synchronous.
  StreamController<CollisionEvent> onCollisionController =
      new StreamController<CollisionEvent>(sync: true);
  Stream<CollisionEvent> get onCollision =>
      onCollisionController.stream.asBroadcastStream();

  void check();
}

class OuterBoxCollision extends Collision {
  Collidable outer;
  Collidable inner;

  OuterBoxCollision(this.inner, this.outer);

  void check() {
    if (inner.hitbox.min.x < outer.hitbox.min.x) {
      onCollisionController.add(
          new CollisionEvent(
              inner,
              new Vector2(-1.0, 0.0),
              outer,
              new Vector2(1.0, 0.0)));
    }
    if (inner.hitbox.max.x > outer.hitbox.max.x) {
      onCollisionController.add(
          new CollisionEvent(
              inner,
              new Vector2(1.0, 0.0),
              outer,
              new Vector2(-1.0, 0.0)));
    }
    if (inner.hitbox.min.y < outer.hitbox.min.y) {
      onCollisionController.add(
          new CollisionEvent(
              inner,
              new Vector2(0.0, -1.0),
              outer,
              new Vector2(0.0, 1.0)));
    }
    if (inner.hitbox.max.y > outer.hitbox.max.y) {
      onCollisionController.add(
          new CollisionEvent(
              inner,
              new Vector2(0.0, 1.0),
              outer,
              new Vector2(0.0, -1.0)));
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

  SweptBoxCollision(this.body1, this.body2);

  void check() {
    _box1.copyFrom(body1.hitbox);
    _box2.copyFrom(body2.hitbox);

    _box1.min.sub(body1.speed);
    _box1.max.sub(body1.speed);

    if (body1.speed.x > 0) {
      _entryDistance.x = _box2.min.x - _box1.max.x;
      _exitDistance.x = _box2.max.x - _box1.min.x;
    } else {
      _entryDistance.x = _box1.min.x - _box2.max.x;
      _exitDistance.x = _box1.max.x - _box2.min.x;
    }

    if (body1.speed.y > 0) {
      _entryDistance.y = _box2.min.y - _box1.max.y;
      _exitDistance.y = _box2.max.y - _box1.min.y;
    } else {
      _entryDistance.y = _box1.min.y - _box2.max.y;
      _exitDistance.y = _box1.max.y - _box2.min.y;
    }

    if (body1.speed.x == 0.0) {
      _entryTime.x = double.INFINITY;
      _exitTime.x = double.INFINITY;
    } else {
      _entryTime.x = _entryDistance.x / body1.speed.x;
      _exitTime.x = _exitDistance.x / body1.speed.x;
    }

    if (body1.speed.y == 0.0) {
      _entryTime.y = double.INFINITY;
      _exitTime.y = double.INFINITY;
    } else {
      _entryTime.y = _entryDistance.y / body1.speed.y;
      _exitTime.y = _exitDistance.y / body1.speed.y;
    }

    double entryTime = max(_entryTime.x, _entryTime.y);
    double exitTime = min(_entryTime.x, _entryTime.y);

    if (entryTime > exitTime ||
        _entryTime.x < 0.0 && _entryTime.y < 0.0 ||
        _entryTime.x > 1.0 ||
        _entryTime.y > 1.0) {

      return null;
    } else {
      if (_entryTime.x > _entryTime.y) {
        if (_entryDistance.x < 0.0) {
//          side = Side.RIGHT;
        } else {
//          side = Side.LEFT;
        }
      } else {
        if (_entryDistance.y < 0.0) {
//          side = Side.BOTTOM;
        } else {
//          side = Side.TOP;
        }
      }
      onCollisionController.add(
          new CollisionEvent(
              body1, new Vector2.zero(), body2, new Vector2.zero()));
    }
  }
}
