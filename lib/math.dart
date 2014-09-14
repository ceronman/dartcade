// Copyright 2012 Manuel Cerón <ceronman@gmail.com>
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

class vec2 {
  num x;
  num y;

  vec2(this.x, this.y);
  vec2.copy(vec2 other) {
    x = other.x;
    y = other.y;
  }

  toString() => "$x, $y";

  vec2 operator -(vec2 other) => new vec2(x - other.x, y - other.y);
  vec2 operator +(vec2 other) => new vec2(x + other.x, y + other.y);

  vec2 operator *(other) {
    if (other is num) {
      return new vec2(x * other, y * other);
    }
    if (other is vec2) {
      return new vec2(x * other.x, y * other.y);
    }
    throw new ArgumentError('Invalid operand for vec2');
  }

  vec2 operator -() {
    return new vec2(-x, -y);
  }

  double get length {
    double sum = 0.0;
    sum += (x * x);
    sum += (y * y);
    return sqrt(sum);
  }

  double get length2 {
    double sum = 0.0;
    sum += (x * x);
    sum += (y * y);
    return sum;
  }

  vec2 normalize() {
    double l = length;
    if (l == 0.0) {
      return this;
    }
    x /= l;
    y /= l;
    return this;
  }
}

class Rectangle {
  num x1, y1, x2, y2;

  Rectangle(this.x1, this.y1, this.x2, this.y2);

  num get width => x2 - x1;
  num get height => y2 - y1;

  num get left => x1;
  num get top => y1;
  num get right => x1 + width;
  num get bottom => y1 + height;

  bool collide(Rectangle other) {
    return (other.left > left &&
        other.left < right &&
        other.top > top &&
        other.top < bottom);
  }
}
