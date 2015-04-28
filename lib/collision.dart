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
  AABB2.xywh(double x, double y, double w, double h):
    center = new Vector2(x + w / 2.0, y + h / 2.0),
    half = new Vector2(w / 2.0, h / 2.0);

  String toString() => '$center,$half';
  Aabb2 toAabb2() => new Aabb2.minMax(center - half, center + half);
}

class CollisionEvent {
  Collider collider1;
  Collider collider2;
  Vector2 delta;

  CollisionEvent(this.collider1, this.collider2, this.delta);
}

abstract class Collider {
  ArcadeBody body;
  void syncFromBody();

  CollisionEvent collidesWith(Collider);
  CollisionEvent isOutOf(Collider);
}

class AABB2Collider extends Collider {
  AABB2 boundingbox = new AABB2();

  void syncFromBody() {
    boundingbox.center.setFrom(body.position);
    boundingbox.half.setValues(body.size.x / 2, body.size.y / 2);
  }

  CollisionEvent collidesWith(Collider other) {
    if (other is AABB2Collider) {
      AABB2 otherbox = other.boundingbox;
      var delta = _checkAabb2VsAabb2(boundingbox, otherbox);
      return delta == null ? null : new CollisionEvent(this, other, delta);
    }
    throw new ArgumentError("Unsupported collision with $other");
  }

  CollisionEvent isOutOf(Collider other) {
    if (other is AABB2Collider) {
      AABB2 otherbox = other.boundingbox;
      var delta = _checkAabb2OutOfAabb2(boundingbox, otherbox);
      return delta == null ? null : new CollisionEvent(this, other, delta);
    }
    throw new ArgumentError("Unsupported collision with $other");
  }

  Vector2 _checkAabb2OutOfAabb2(AABB2 innerBox, AABB2 outerBox) {
    double deltaX = 0.0;
    double deltaY = 0.0;

    if (innerBox.left < outerBox.left) {
      deltaX = outerBox.left - innerBox.left;
    } else if (innerBox.right > outerBox.right) {
      deltaX = outerBox.right - innerBox.right;
    }

    if (innerBox.top < outerBox.top) {
      deltaY = outerBox.top - innerBox.top;
    } else if (innerBox.bottom > outerBox.bottom) {
      deltaY = outerBox.bottom - innerBox.bottom;
    }

    if (deltaX == 0.0 && deltaY == 0.0) {
      return null;
    }
    return new Vector2(deltaX, deltaY);
  }

  Vector2 _checkAabb2VsAabb2(AABB2 box1, AABB2 box2) {
    double dx = box1.center.x - box2.center.x;
    double px = (box1.half.x + box2.half.x) - dx.abs();
    if (px < 0) return null;

    double dy = box1.center.y - box2.center.y;
    double py = (box1.half.y + box2.half.y) - dy.abs();
    if (py < 0) return null;

    if (px < py) {
      return new Vector2(px * dx.sign, 0.0);
    } else {
      return new Vector2(0.0, py * dy.sign);
    }
  }
}


abstract class CollisionCheck {

  StreamController<CollisionEvent> controller =
      new StreamController<CollisionEvent>.broadcast(sync: true);
  Stream<CollisionEvent> get onCollision => controller.stream;

  void check();
}

abstract class SingleCollisionCheck extends CollisionCheck {
  Collider collider1;
  Collider collider2;
  void check() {
    var event = _checkEvent();
    if (event != null) {
      controller.add(event);
    }
  }
  CollisionEvent _checkEvent();
}

class StaticBodyVsBodyCollisionCheck extends SingleCollisionCheck {
  CollisionEvent _checkEvent() => collider1.collidesWith(collider2);
}

class StaticBodyOutOfBoundsCollisionCheck extends SingleCollisionCheck {
  CollisionEvent _checkEvent() => collider1.isOutOf(collider2);
}

class StaticBodyVsGroupCollisionCheck extends CollisionCheck {
  Collider collider1;
  List<Collider> colliders;

  void check() {
    for (var other in colliders) {
      var event = collider1.collidesWith(other);
      if (event != null) controller.add(event);
    }
  }
}

class GroupOutOfBoundsCollisionCheck extends CollisionCheck {
  Collider collider1;
  List<Collider> colliders;

  void check() {
    for (var other in colliders) {
      var event = other.isOutOf(collider1);
      if (event != null) controller.add(event);
    }
  }
}
