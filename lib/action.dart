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
interface Action {
  GameNode get target();
           set target(GameNode);

  bool get done();

  void start();
  void step(num dt);
  void stop();
}

abstract class AbstractAction implements Action {
  GameNode _target;
  GameNode get target()                => _target;
           set target(GameNode value)  => _target = value;
  bool done;

  AbstractAction(): done=false;

  abstract void start();
  abstract void step(num dt);
  abstract void stop();
}

abstract class InstantAction extends AbstractAction {
  bool get done() => true;
  abstract void start();

  void step(num dt) {}
  void stop() {}
}

class Place extends InstantAction {
  vec2 position;

  Place(this.position);

  start() => target.position = position;
}

class MoveTo extends AbstractAction {
  vec2 endPosition;
  num duration;
  num ellapsedTime;

  vec2 deltaPosition;
  vec2 startPosition;

  bool get done() => ellapsedTime >= duration;

  MoveTo(this.endPosition, this.duration): ellapsedTime = 0;

  start() {
    startPosition = target.position;
    deltaPosition = endPosition - startPosition;
  }

  step(dt) {
    ellapsedTime += dt;
    interval(ellapsedTime/duration);
  }

  interval(num t) {
    target.position = startPosition + deltaPosition * t;
  }

  void stop() {}
}
