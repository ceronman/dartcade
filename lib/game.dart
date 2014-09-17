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

class Game {
  AssetManager assets;
  KeyStateHandler keyboard;

  // TODO: This should be abstracted
  html.CanvasElement canvas;
  num fps;

  Scene scene;

  double get width => canvas.width.toDouble();
  double get height => canvas.height.toDouble();

  Stream<html.KeyboardEvent> get onKeyDown => html.document.onKeyDown;
  Stream<html.KeyboardEvent> get onKeyUp => html.document.onKeyUp;
  Stream<html.MouseEvent> get onMouseDown => canvas.onMouseDown;
  Stream<html.MouseEvent> get onMouseUp => canvas.onMouseUp;
  Stream<html.MouseEvent> get onMouseMove => canvas.onMouseMove;
  Stream<html.WheelEvent> get onMouseWheel => canvas.onMouseWheel;

  Game(String selector, {int width, int height}) {
    width = width != null ? width : 640;
    height = height != null ? height : 480;
    assets = new AssetManager();
    keyboard = new KeyStateHandler(onKeyDown, onKeyUp);
    scene = new Scene();
    scene.game = this;

    var gamebox = html.querySelector(selector);
    canvas = new html.CanvasElement(width: width, height: height);
    canvas.style.backgroundColor = 'black';
    gamebox.children.add(canvas);
  }

  void update(num dt) {
    scene.update(dt);
  }

  void draw(html.CanvasRenderingContext2D context) {
    context.clearRect(0, 0, canvas.width, canvas.height);
    scene.drawWithChildren(context);
  }

  void run() {
    var initTime = 0;
    var frameCount = 0;

    drawFrame(num currentTime) {
      if (initTime == null) {
        initTime = currentTime;
      }
      frameCount++;
      var dt = (currentTime - initTime) / 1000;
      initTime = currentTime;
      update(dt);
      draw(canvas.context2D);
      html.window.requestAnimationFrame(drawFrame);
    }
    html.window.requestAnimationFrame(drawFrame);

    new Timer.periodic(new Duration(seconds: 1), (t) {
      fps = frameCount;
      frameCount = 0;
    });
  }
}