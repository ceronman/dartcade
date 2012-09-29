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
  GameNode target;
  bool done = false;

  AbstractAction();

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
}

class MoveTo extends ChangeAttributeToAction {
  get _changingValue        => target.position;
  set _changingValue(value) => target.position = value;

  MoveTo(vec2 endPosition, num duration) : super(endPosition, duration);
}

class RotateBy extends ChangeAttributeByAction {
  get _changingValue        => target.rotation;
  set _changingValue(value) => target.rotation = value;

  RotateBy(num deltaRotation, num duration) : super(deltaRotation, duration);
}

class RotateToCW extends ChangeAttributeToAction {
  get _changingValue        => target.rotation;
  set _changingValue(value) => target.rotation = value;

  RotateToCW(num endRotation, num duration) :
     super(endRotation % 360, duration);
}

class RotateToACW extends ChangeAttributeToAction {
  get _changingValue        => target.rotation;
  set _changingValue(value) => target.rotation = value;

  RotateToACW(num endRotation, num duration) :
    super(endRotation % 360 - 360, duration);
}

class ScaleTo extends ChangeAttributeToAction {
  get _changingValue        => target.scale;
  set _changingValue(value) => target.scale = value;

  ScaleTo(vec2 endScale, num duration) : super(endScale, duration);
}

class ScaleBy extends ChangeAttributeByAction {
  get _changingValue        => target.scale;
  set _changingValue(value) => target.scale = value;

  ScaleBy(vec2 deltaScale, num duration) : super(deltaScale, duration);
}

class Blink extends IntervalAction {
  num _blinkInterval;
  num _blinks = 0;
  bool _initialVisibility;

  Blink(times, num duration) : super(duration) {
    _blinkInterval = 1 / times;
  }

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

class ActionSequence extends AbstractAction {
  List<Action> _actions;
  int _currentAction;

  // FIXME: add a type here. Maybe Enumerable?
  ActionSequence(actions) {
    // FIXME: Throw on empty actions
    _actions = new List<Action>.from(actions);
  }

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

class ActionSpawn extends AbstractAction {
  List<Action> _actions;

  bool get done => _actions.length == 0;

  // FIXME: add a type here. Maybe Enumerable?
  ActionSpawn(actions) {
    // FIXME: Throw on empty actions
    _actions = new List<Action>.from(actions);
  }

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
      print('Stopping $action');
      _actions.removeRange(_actions.indexOf(action), 1);
    }
  }
}