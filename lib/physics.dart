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

class PhysicsComponent {
  GameNode node;

  Vector2 get position => node.position;
  Vector2 speed = new Vector2.zero();
  Vector2 acceleration = new Vector2.zero();

  PhysicsComponent();

  void update(num dt) {
    node.position += speed * dt;
    speed += acceleration * dt;
  }
}
