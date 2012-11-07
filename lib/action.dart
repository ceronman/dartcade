part of cocos;

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

abstract class Action {
  GameNode target;
  bool get done => false;

  Action();

  abstract Action clone();
  abstract void start();
  abstract void step(num dt);
  abstract void stop();

  Action operator +(Action action) {
    return new ActionSequence([this, action]);
  }

  Action operator |(Action action) {
    return new ActionSpawn([this, action]);
  }
}

abstract class InstantAction extends Action {
  bool get done => true;

  void step(num dt) {}
  void stop() {}
}

class Place extends InstantAction {
  vec2 position;

  Place(this.position);

  Place clone() => new Place(position);
  start() => target.position = position;
}

class Hide extends InstantAction {

  Hide clone() => new Hide();
  start() => target.visible = false;
}

class Show extends InstantAction {

  Show clone() => new Show();
  start() => target.visible = true;
}

class ToggleVisibility extends InstantAction {

  ToggleVisibility clone() => new ToggleVisibility();
  start() => target.visible = !target.visible;
}

abstract class IntervalAction extends Action {
  num duration;
  num ellapsedTime = 0;

  bool get done => ellapsedTime >= duration;

  IntervalAction(num this.duration);

  step(dt) {
    ellapsedTime = min(ellapsedTime + dt, duration);
    _interval(ellapsedTime/duration); // FIXME: check duration == 0
  }

  abstract _interval(num t);
}

abstract class ChangeAttributeToAction extends IntervalAction {
  var startValue;
  var deltaValue;
  var endValue;

  abstract get _changingValue;
  abstract set _changingValue(value);

  ChangeAttributeToAction(this.endValue, num duration) : super(duration);

  start() {
    startValue = _changingValue;
    deltaValue = endValue - startValue;
  }

  stop() {}

  _interval(num t)       => _changingValue = startValue + deltaValue * t;
}

abstract class ChangeAttributeByAction extends IntervalAction {
  var startValue;
  var deltaValue;

  abstract get _changingValue;
  abstract set _changingValue(value);

  ChangeAttributeByAction(this.deltaValue, num duration) : super(duration);

  start() => startValue = _changingValue;
  stop()  => _changingValue = startValue + deltaValue;

  _interval(num t) => _changingValue = startValue + deltaValue * t;
}

class MoveBy extends ChangeAttributeByAction {
  get _changingValue        => target.position;
  set _changingValue(value) => target.position = value;

  MoveBy(vec2 deltaPosition, num duration) : super(deltaPosition, duration);
  MoveBy clone() => new MoveBy(deltaValue, duration);
}

class MoveTo extends ChangeAttributeToAction {
  get _changingValue        => target.position;
  set _changingValue(value) => target.position = value;

  MoveTo(vec2 endPosition, num duration) : super(endPosition, duration);
  MoveTo clone() => new MoveTo(endValue, duration);
}

class RotateBy extends ChangeAttributeByAction {
  get _changingValue        => target.rotation;
  set _changingValue(value) => target.rotation = value;

  RotateBy(num deltaRotation, num duration) : super(deltaRotation, duration);
  RotateBy clone() => new RotateBy(deltaValue, duration);
}

class RotateToCW extends ChangeAttributeToAction {
  get _changingValue        => target.rotation;
  set _changingValue(value) => target.rotation = value;

  RotateToCW(num endRotation, num duration) :
     super(endRotation % 360, duration);
  RotateToCW clone() => new RotateToCW(endValue, duration);
}

class RotateToACW extends ChangeAttributeToAction {
  get _changingValue        => target.rotation;
  set _changingValue(value) => target.rotation = value;

  RotateToACW(num endRotation, num duration) :
    super(endRotation % 360 - 360, duration);
  RotateToACW clone() => new RotateToACW(endValue, duration);
}

class ScaleTo extends ChangeAttributeToAction {
  get _changingValue        => target.scale;
  set _changingValue(value) => target.scale = value;

  ScaleTo(vec2 endScale, num duration) : super(endScale, duration);
  ScaleTo clone() => new ScaleTo(endValue, duration);
}

class ScaleBy extends ChangeAttributeByAction {
  get _changingValue        => target.scale;
  set _changingValue(value) => target.scale = value;

  ScaleBy(vec2 deltaScale, num duration) : super(deltaScale, duration);
  ScaleBy clone() => new ScaleBy(deltaValue, duration);
}

class FadeTo extends ChangeAttributeToAction {
  get _changingValue        => target.opacity;
  set _changingValue(value) => target.opacity = value;

  FadeTo(num endOpacity, num duration) : super(endOpacity, duration);
  FadeTo clone() => new FadeTo(endValue, duration);
}

class FadeOut extends FadeTo {
  FadeOut(num duration) : super(0.0, duration);
  FadeOut clone() => new FadeOut(duration);
}

class FadeIn extends FadeTo {
  FadeIn(num duration) : super(1.0, duration);
  FadeIn clone() => new FadeIn(duration);
}

class Blink extends IntervalAction {
  num _blinkInterval;
  num _blinks = 0;
  bool _initialVisibility;

  Blink(times, num duration) : super(duration) {
    _blinkInterval = 1 / times;
  }
  Blink clone() => new Blink(1 / _blinkInterval, duration);

  start() {
    _initialVisibility = target.visible;
  }

  stop() => target.visible = _initialVisibility;

  _interval(num t) {
    if (t > (_blinkInterval * _blinks)) {
      target.visible = !target.visible;
      _blinks++;
    }
  }
}

class Delay extends IntervalAction {

  Delay(num duration): super(duration);
  Delay clone() => new Delay(duration);

  start() {}
  stop() {}
  _interval(num t) {}
}

class Speed extends IntervalAction {
  IntervalAction action;

  Speed(IntervalAction action, num speedFactor) : super(0) { // <-- FIXME
    // TODO: check speedFactor == 0;
    this.duration = action.duration / speedFactor;
    this.action = action;
  }
  Speed clone() {
    return new Speed(action.clone(), action.duration/duration);
  }

  void start() {
    action.target = this.target;
    action.start();
  }

  void stop() {
    action.stop();
  }

  void _interval(num t) {
    action._interval(t);
  }
}

class Accelerate extends IntervalAction {
  IntervalAction action;
  num rate;

  Accelerate(IntervalAction action, num this.rate) : super(action.duration) {
    this.action = action;
  }
  Accelerate clone() {
    return new Accelerate(action.clone(), rate);
  }

  void start() {
    action.target = this.target;
    action.start();
  }

  void stop() {
    action.stop();
  }

  void _interval(num t) {
    action._interval(pow(t, rate));
  }
}

class ActionSequence extends Action {
  List<Action> _actions;
  int _currentAction;
  bool done = false;

  // FIXME: add a type here. Maybe Enumerable?
  ActionSequence(actions) {
    // FIXME: Throw on empty actions
    _actions = new List<Action>();
    for (var action in actions) {
      _actions.add(action.clone());
    }
  }
  ActionSequence clone() => new ActionSequence(_actions);

  void start() {
    _nextAction();
  }

  void step(num dt) {
    _actions[_currentAction].step(dt);
    if (_actions[_currentAction].done) {
      _nextAction();
    }
  }

  void stop() {}

  _nextAction() {
    if (_currentAction == null) {
      _currentAction = 0;
    }
    else {
      _actions[_currentAction].stop();
      _currentAction++;
    }
    if (_currentAction < _actions.length) {
      _actions[_currentAction].target = target;
      _actions[_currentAction].start();

      // this is useful for instant actions
      if (_actions[_currentAction].done) {
        _nextAction();
      }
    }
    else {
      done = true;
    }
  }
}

class ActionSpawn extends Action {
  List<Action> _actions;

  bool get done => _actions.length == 0;

  // FIXME: add a type here. Maybe Enumerable?
  ActionSpawn(actions) {
    // FIXME: Throw on empty actions
    _actions = new List<Action>();
    for (var action in actions) {
      _actions.add(action.clone());
    }
  }
  ActionSpawn clone() => new ActionSpawn(_actions);

  void start() {
    var doneActions = [];
    for (var action in _actions) {
      action.target = target;
      action.start();
      // For instant actions.
      if (action.done) {
        doneActions.add(action);
      }
    }
    _removeActions(doneActions);
  }

  void step(num dt) {
    var doneActions = [];
    for (var action in _actions) {
      if (!action.done) {
        action.step(dt);
      }
      else {
        doneActions.add(action);
      }
    }
    _removeActions(doneActions);
  }

  void stop() {}

  _removeActions(actions) {
    for (var action in actions) {
      action.stop();
      _actions.removeRange(_actions.indexOf(action), 1);
    }
  }
}

class Repeat extends Action {
  Action action;
  num times;
  bool done = false;
  Action _currentAction = null;
  num _repetitions = 0;

  Repeat(Action this.action, num this.times);
  Repeat clone() => new Repeat(action, times);

  void start() {
    _nextAction();
  }

  void step(num dt) {
    _currentAction.step(dt);
    if (_currentAction.done) {
      _nextAction();
    }
  }

  void stop() {}

  _nextAction() {
    if (_currentAction != null) {
      _currentAction.stop();
    }
    _currentAction = action.clone();
    _repetitions++;

    if (_repetitions <= times) {
      _currentAction.target = target;
      _currentAction.start();

      // this is useful for instant actions
      if (_currentAction.done) {
        _nextAction();
      }
    }
    else {
      done = true;
    }
  }
}
