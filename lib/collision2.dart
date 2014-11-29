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

abstract class Aabb2Collidable {
  Aabb2 hitbox;
}

class Aabb2InAabb2 {
  Aabb2Collidable innerBody;
  Aabb2Collidable outerBody;

  Aabb2InAabb2(this.innerBody, this.outerBody);

  Vector2 check() {
    double deltaX;
    double deltaY;
    Aabb2 innerBox = innerBody.hitbox;
    Aabb2 outerBox = innerBody.hitbox;

    if (innerBox.min.x < outerBox.min.x) {
      deltaX = outerBox.min.x - innerBox.min.x;
    } else if (innerBox.max.x > outerBox.max.x) {
      deltaX = innerBox.max.x - outerBox.max.x;
    }

    if (innerBox.min.y < outerBox.min.y) {
      deltaY = outerBox.min.y - innerBox.min.y;
    } else if (innerBox.max.y > outerBox.max.y) {
      deltaX = innerBox.max.y - outerBox.max.y;
    }

    if (deltaX == 0.0 && deltaY == 0.0) {
      return null;
    }
    return new Vector2(deltaX, deltaY);
  }
}

class Aabb2VsAabb2 {
  Aabb2Collidable body1;
  Aabb2Collidable body2;

  Aabb2VsAabb2(this.body1, this.body2);

  Vector2 _center1 = new Vector2.zero();
  Vector2 _half1 = new Vector2.zero();
  Vector2 _center2 = new Vector2.zero();
  Vector2 _half2 = new Vector2.zero();

  Vector2 check() {
    body1.hitbox.copyCenterAndHalfExtents(_center1, _half1);
    body2.hitbox.copyCenterAndHalfExtents(_center2, _half2);

    double dx = _center1.x - _center2.x;
    double px = (_half1.x + _half2.x) - dx.abs();
    if (px < 0) return null;

    double dy = _center1.y - _center2.y;
    double py = (_half1.y + _half2.y) - dy.abs();
    if (py < 0) return null;

    if (px > py) {
      return new Vector2(px * dx.sign, 0.0);
    } else {
      return new Vector2(0.0, py * dy.sign);
    }
  }
}
