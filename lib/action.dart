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

// TODO: create functions for each concrete action

abstract class Action {
  GameNode target;
  bool get done => false;

  Action();
  Action clone();
  Action reverse() {
    throw "Reverse not available";
  }
  Action operator |(Action action) => new ActionSpawn([this, action]);
  Action operator +(Action action) => new ActionSequence([this, action]);
  
  void start();
  void step(num dt);
  void stop();

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
  
  void start() {
    target.position = position; 
  }
}


typedef CallFunctionCallback(GameNode node);

class CallFunction extends InstantAction {
  CallFunctionCallback method;
  vec2 position;

  CallFunction(this.method);
  CallFunction clone() => new CallFunction(method);
  
  void start() { 
    method(target); 
  }
}

class Hide extends InstantAction {
  Hide clone() => new Hide();
  Show reverse() => new Show();
  
  void start() {
    target.visible = false;
  }
}

class Show extends InstantAction {
  Show clone() => new Show();
  Hide reverse() => new Hide();
  
  void start() {
    target.visible = true;
  }
}

class ToggleVisibility extends InstantAction {
  ToggleVisibility clone() => new ToggleVisibility();
  ToggleVisibility reverse() => new ToggleVisibility();
  
  void start() {
    target.visible = !target.visible; 
  }
}

abstract class IntervalAction extends Action {
  num _duration;
  num ellapsedTime = 0;
  
  num get duration => _duration;
  set duration(num value) {
    // TODO: test this
    if (value <= 0) {
      throw "Invalid duration for interval";
    }
    _duration = value;      
  }
  
  bool get done => ellapsedTime >= duration;

  IntervalAction(num duration) {
    this.duration = duration;
  }

  void step(dt) {
    ellapsedTime = min(ellapsedTime + dt, duration);
    _interval(ellapsedTime/duration);
  }

  void _interval(num t);
}

abstract class ChangeAttributeToAction extends IntervalAction {
  var startValue;
  var deltaValue;
  var endValue;

  get _changingValue;
  set _changingValue(value);

  ChangeAttributeToAction(this.endValue, num duration) : super(duration);

  void start() {
    startValue = _changingValue;
    deltaValue = endValue - startValue;
  }

  void stop() {}

  _interval(num t) => _changingValue = startValue + deltaValue * t;
}

abstract class ChangeAttributeByAction extends IntervalAction {
  var startValue;
  var deltaValue;

  get _changingValue;
  set _changingValue(value);

  ChangeAttributeByAction(this.deltaValue, num duration) : super(duration);

  void start() {
    startValue = _changingValue;
  }
  void stop()  {
    _changingValue = startValue + deltaValue;
  }

  _interval(num t) => _changingValue = startValue + deltaValue * t;
}

class MoveBy extends ChangeAttributeByAction {
  get _changingValue        => target.position;
  set _changingValue(value) => target.position = value;

  MoveBy(vec2 deltaPosition, num duration) : super(deltaPosition, duration);
  MoveBy clone() => new MoveBy(deltaValue, duration);
  MoveBy reverse() => new MoveBy(-deltaValue, duration);
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
  RotateBy reverse() => new RotateBy(-deltaValue, duration);
}

class RotateTo extends ChangeAttributeToAction {
  get _changingValue        => target.rotation;
  set _changingValue(value) => target.rotation = value;

  RotateTo(num endRotation, num duration) : super(endRotation, duration) {
    if (endRotation.abs() > 360) {
      endValue = endRotation % 360;
    }
  }
  RotateTo clone() => new RotateTo(endValue, duration);
  RotateTo reverse() => new RotateTo(endValue - 360, duration);
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
  ScaleBy reverse() {
    num x = deltaValue.x == 0 ? 0 : 1 / deltaValue.x;
    num y = deltaValue.y == 0 ? 0 : 1 / deltaValue.y;
    return new ScaleBy(new vec2(x, y), duration);
  }

  void start() {
    super.start();
    deltaValue = startValue * deltaValue - startValue;
  }
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
  FadeIn reverse() => new FadeIn(duration);
}

class FadeIn extends FadeTo {
  FadeIn(num duration) : super(1.0, duration);
  FadeIn clone() => new FadeIn(duration);
  FadeOut reverse() => new FadeOut(duration);
}

class Blink extends IntervalAction {
  num _blinkInterval;
  num _blinks = 0;
  bool _initialVisibility;

  Blink(times, num duration) : super(duration) {
    _blinkInterval = 1 / times;
  }
  Blink clone() => new Blink(1 / _blinkInterval, duration);
  Blink reverse() => clone();

  void start() {
    _initialVisibility = target.visible;
  }

  void stop() {
    target.visible = _initialVisibility;
  }

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

  void start() {}
  void stop() {}
  _interval(num t) {}
}

class RandomDelay extends Delay {
  num min;
  num max;

  RandomDelay(num min, num max):
    super(min + new Random().nextDouble() * (max-min)) {

    this.min = min;
    this.max = max;
  }

  RandomDelay clone() => new RandomDelay(min, max);
}

class Speed extends IntervalAction {
  IntervalAction action;

  Speed(IntervalAction action, num speedFactor) : super(action.duration) {
    if (speedFactor <= 0) {
      throw "Invalid speed factor";
    }
    duration = action.duration / speedFactor;
    this.action = action;
  }
  Speed clone() => new Speed(action.clone(), action.duration/duration);
  Speed reverse() => new Speed(action.reverse(), action.duration/duration);

  void start() {
    action.target = this.target;
    action.start();
  }

  void stop() => action.stop();
  void _interval(num t) {
    action._interval(t);
  }
}

class Accelerate extends IntervalAction {
  IntervalAction action;
  num _rate;
  
  num get rate => _rate;
  set rate(num value) {
    if (value <= 0) {
      throw "Invalid acceleration rate";
    }
  }

  Accelerate(IntervalAction action, num rate) : super(action.duration) {
    this.rate = rate;
    this.action = action;
  }
  Accelerate clone() => new Accelerate(action.clone(), rate);
  Accelerate reverse() => new Accelerate(action.reverse(), 1/rate);

  void start() {
    action.target = this.target;
    action.start();
  }
  
  void stop() => action.stop();

  void _interval(num t) {
    action._interval(pow(t, rate));
  }
}

class AccelDeccel extends Accelerate {
  AccelDeccel(IntervalAction action, rate): super(action, rate);
  AccelDeccel clone() => new AccelDeccel(action.clone(), rate);
  AccelDeccel reverse() => new AccelDeccel(action.reverse(), rate);

  void _interval(num t) {
    if (t != 1.0) {
      var ft = (t - 0.5) * 12;
      t = 1.0 / ( 1.0 + exp(-ft) );
    }
    action._interval(t);
  }
}

class ActionSequence extends Action {
  List<Action> _actions;
  int _currentAction;
  bool done = false;

  // TODO: add a type here. Maybe Enumerable?
  ActionSequence(actions) {
    // TODO: Throw on empty actions
    _actions = new List.from(actions.map((action) => action.clone()));
  }
  ActionSequence clone() => new ActionSequence(_actions);
  ActionSequence reverse() {
    return new ActionSequence(_actions.reversed.map((a) => a.reverse()));
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

  void _nextAction() {
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

  // TODO: add a type here. Maybe Enumerable?
  ActionSpawn(actions) {
    // TODO: Throw on empty actions
    _actions = new List<Action>();
    for (var action in actions) {
      _actions.add(action.clone());
    }
  }
  ActionSpawn clone() => new ActionSpawn(_actions);
  ActionSpawn reverse() {
    return new ActionSpawn(_actions.reversed.map((a) => a.reverse()));
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

  void _removeActions(actions) {
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
  Repeat reverse() => new Repeat(action.reverse(), times);

  void start() {
    return _nextAction();
  }

  void step(num dt) {
    _currentAction.step(dt);
    if (_currentAction.done) {
      _nextAction();
    }
  }

  void stop() {}

  void _nextAction() {
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

class Loop extends Action {
  Action action;
  bool done = false;
  Action activeAction = null;

  Loop(Action this.action);
  Loop clone() => new Loop(action);
  Loop reverse() => new Loop(action.reverse());

  void start() => _nextAction();

  void step(num dt) {
    activeAction.step(dt);
    if (activeAction.done) {
      _nextAction();
    }
  }

  void stop() {}

  void _nextAction() {
    if (activeAction != null) {
      activeAction.stop();
    }
    activeAction = action.clone();

    activeAction.target = target;
    activeAction.start();

    // this is useful for instant actions
    if (activeAction.done) {
      _nextAction();
    }
  }
}
