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
class vec2 {
  num x;
  num y;

  vec2(this.x, this.y);

  toString() => "$x, $y";

  vec2 operator-(vec2 other) => new vec2(x - other.x, y - other.y);
  vec2 operator+(vec2 other) => new vec2(x + other.x, y + other.y);

  vec2 operator*(Dynamic other) {
    if (other is num) {
      return new vec2(x * other, y * other);
    }
    if (other is vec2) {
      return new vec2(x * other.x, y * other.y);
    }
  }
}