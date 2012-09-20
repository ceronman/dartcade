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
  GameNode get target;
           set target(GameNode);

  bool get done;

  void start();
  void step(num dt);
  void stop();
}

abstract class AbstractAction implements Action {
  GameNode _target;
  GameNode get target => _target;
           set target(GameNode value) => _target = value;
  bool done;

  AbstractAction(): done=false;

  abstract void start();
  abstract void step(num dt);
  abstract void stop();
}

abstract class InstantAction extends AbstractAction {
  bool get done => true;
  abstract void start();

  void step(num dt) {}
  void stop() {}
}

class Place extends InstantAction {
  vec2 position;

  Place(this.position);

  start() => target.position = position;
}

abstract class IntervalAction extends AbstractAction {
  num duration;
  num ellapsedTime = 0;

  bool get done => ellapsedTime >= duration;

  IntervalAction(this.duration);

  abstract start();

  step(dt) {
    ellapsedTime += dt;
    interval(ellapsedTime/duration); // FIXME: check duration == 0
  }

  abstract interval(num t);

  void stop() {}
}

class MoveBy extends IntervalAction {
  vec2 deltaPosition;
  vec2 startPosition;

  MoveBy(this.deltaPosition, duration) : super(duration);

  start() {
    startPosition = target.position;
  }

  interval(num t) {
    target.position = startPosition + deltaPosition * t;
  }
}

class MoveTo extends IntervalAction {

  vec2 endPosition;
  vec2 deltaPosition;
  vec2 startPosition;

  MoveTo(this.endPosition, duration) : super(duration);

  start() {
    startPosition = target.position;
    deltaPosition = endPosition - startPosition;
  }

  interval(num t) {
    target.position = startPosition + deltaPosition * t;
  }
}

class RotateBy extends IntervalAction {
  num startRotation;
  num deltaRotation;

  RotateBy(this.deltaRotation, duration) : super(duration);

  start() {
    startRotation = target.rotation;
  }

  interval(num t) {
    target.rotation = startRotation + deltaRotation * t;
  }
}

const int CLOCKWISE = 1;
const int ANTICLOCKWISE = 2;

class RotateTo extends IntervalAction {
  num startRotation;
  num endRotation;
  num deltaRotation;
  int direction;

  RotateTo(endRotation, duration, {int direction}) : super(duration) {
    this.direction = direction != null ? direction : CLOCKWISE;
    this.endRotation = endRotation % 360;
  }

  start() {
    startRotation = target.rotation;
    if (direction == CLOCKWISE) {
      deltaRotation = endRotation - startRotation;
    }
    else {
      deltaRotation = startRotation - endRotation;
    }
  }

  interval(num t) {
    target.rotation = startRotation + deltaRotation * t;
  }
}

class ScaleTo extends IntervalAction {
  vec2 startScale;
  vec2 endScale;
  vec2 deltaScale;

  ScaleTo(this.endScale, duration) : super(duration);

  start() {
    startScale= target.scale;
    deltaScale = endScale - startScale;
  }

  interval(num t) {
    target.scale = startScale + deltaScale * t;
  }
}

class ScaleBy extends IntervalAction {
  vec2 startScale;
  vec2 deltaScale;

  ScaleBy(this.deltaScale, duration) : super(duration);

  start() {
    startScale= target.scale;
  }

  interval(num t) {
    target.scale = startScale + deltaScale * t;
  }
}
