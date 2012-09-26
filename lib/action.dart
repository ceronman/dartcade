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
  GameNode get target                 => _target;
           set target(GameNode value) => _target = value;
  bool done;

  AbstractAction(): done=false;

  abstract void start();
  abstract void step(num dt);
  abstract void stop();
}

abstract class InstantAction extends AbstractAction {
  bool get done => true;

  void step(num dt) {}
  void stop() {}
}

class Place extends InstantAction {
  vec2 position;

  Place(this.position);

  start() => target.position = position;
}

class Hide extends InstantAction {

  start() => target.visible = false;
}

class Show extends InstantAction {

  start() => target.visible = true;
}

class ToggleVisibility extends InstantAction {

  start() => target.visible = !target.visible;
}

abstract class IntervalAction extends AbstractAction {
  num duration;
  num ellapsedTime = 0;

  bool get done => ellapsedTime >= duration;

  IntervalAction(num this.duration);

  step(dt) {
    ellapsedTime += dt;
    interval(ellapsedTime/duration); // FIXME: check duration == 0
  }

  abstract interval(num t);

  void stop(){}
}

abstract class ChangeAttributeToAction extends IntervalAction {
  var startValue;
  var deltaValue;
  var endValue;

  ChangeAttributeToAction(this.endValue, num duration) : super(duration);

  start() {
    startValue = _changingValue;
    deltaValue = calculateDeltaValue();
  }

  calculateDeltaValue() => endValue - startValue;
  interval(num t)       => _changingValue = startValue + deltaValue * t;

  abstract get _changingValue;
  abstract set _changingValue(value);
}

abstract class ChangeAttributeByAction extends IntervalAction {
  var startValue;
  var deltaValue;

  ChangeAttributeByAction(this.deltaValue, num duration) : super(duration);

  start()         => startValue = _changingValue;
  interval(num t) => _changingValue = startValue + deltaValue * t;

  abstract get _changingValue;
  abstract set _changingValue(value);
}

class MoveBy extends ChangeAttributeByAction {
  MoveBy(vec2 deltaPosition, num duration) : super(deltaPosition, duration);

  get _changingValue        => target.position;
  set _changingValue(value) => target.position = value;
}

class MoveTo extends ChangeAttributeToAction {
  MoveTo(vec2 endPosition, num duration) : super(endPosition, duration);

  get _changingValue        => target.position;
  set _changingValue(value) => target.position = value;
}

class RotateBy extends ChangeAttributeByAction {
  RotateBy(num deltaRotation, num duration) : super(deltaRotation, duration);

  get _changingValue        => target.rotation;
  set _changingValue(value) => target.rotation = value;
}

const int CLOCKWISE = 1;
const int ANTICLOCKWISE =-1;

class RotateTo extends ChangeAttributeToAction {
  int direction;

  RotateTo(num endRotation, num duration, {int direction}) :
      super(endRotation % 360, duration) {
    this.direction = direction != null ? direction : CLOCKWISE;
  }

  calculateDeltaValue() => (endValue - startValue) * direction;

  get _changingValue        => target.rotation;
  set _changingValue(value) => target.rotation = value;
}

class ScaleTo extends ChangeAttributeToAction {
  ScaleTo(vec2 endScale, num duration) : super(endScale, duration);

  get _changingValue        => target.scale;
  set _changingValue(value) => target.scale = value;
}

class ScaleBy extends ChangeAttributeByAction {
  ScaleBy(vec2 deltaScale, num duration) : super(deltaScale, duration);

  get _changingValue        => target.scale;
  set _changingValue(value) => target.scale = value;
}

class Blink extends IntervalAction {
  num blinkInterval;
  num blinks = 0;
  bool initialVisibility;

  Blink(times, num duration) : super(duration) {
    blinkInterval = 1 / times;
  }

  start() {
    initialVisibility = target.visible;
  }

  interval(num t) {
    if (t > (blinkInterval * blinks)) {
      target.visible = !target.visible;
      blinks++;
    }
  }

  stop() => target.visible = initialVisibility;
}
