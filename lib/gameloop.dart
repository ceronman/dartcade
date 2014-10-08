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

// TODO: Add game timers

class GameLoop {
  KeyStateHandler keyboard;

  // TODO: This should be abstracted
  html.CanvasElement canvas;

  Scene _scene;
  Scene get scene => _scene;
  set scene(Scene value) {
    _scene = value;
    _scene.game = this;
  }

  double get width => canvas.width.toDouble();
  double get height => canvas.height.toDouble();

  Stream<html.KeyboardEvent> get onKeyDown => html.document.onKeyDown;
  Stream<html.KeyboardEvent> get onKeyUp => html.document.onKeyUp;
  Stream<html.MouseEvent> get onMouseDown => canvas.onMouseDown;
  Stream<html.MouseEvent> get onMouseUp => canvas.onMouseUp;
  Stream<html.MouseEvent> get onMouseMove => canvas.onMouseMove;
  Stream<html.WheelEvent> get onMouseWheel => canvas.onMouseWheel;

  GameLoop(String selector, {int width, int height}) {
    width = width != null ? width : 640;
    height = height != null ? height : 480;
    keyboard = new KeyStateHandler(onKeyDown, onKeyUp);
    scene = new Scene();

    var gamebox = html.querySelector(selector);
    canvas = new html.CanvasElement(width: width, height: height);
    canvas.style.backgroundColor = 'black';
    gamebox.children.add(canvas);
  }

  num _updatePeriod = 1000/60;
  num get updateFrequency => 1000 / _updatePeriod;
  set updateFrequency(num value) => _updatePeriod = 1000 / value;
  num timeScale = 1.0;
  num _initTime = 0.0;
  num _accumulatedTime = 0.0;
  int _frameCount = 0;
  int fps;

  void _animationFrame(num currentTime) {
    _frameCount++;
    _accumulatedTime += (currentTime - _initTime) * timeScale;
    while (_accumulatedTime >= _updatePeriod) {
      _accumulatedTime -= _updatePeriod;
      scene.update(_updatePeriod/1000);
    }
    canvas.context2D.clearRect(0, 0, canvas.width, canvas.height);
    scene.drawWithChildren(canvas.context2D);

    _initTime = currentTime;
    html.window.requestAnimationFrame(_animationFrame);
  }

  void start() {
    html.window.requestAnimationFrame(_animationFrame);
    new Timer.periodic(new Duration(seconds: 1), (t) {
      fps = _frameCount;
      _frameCount = 0;
    });
  }
}