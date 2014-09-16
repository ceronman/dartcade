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

class Game {
  AssetManager assets;
  KeyStateHandler keyboard;
  CanvasElement canvas;
  num fps;

  Scene scene = new Scene();

  double get width => canvas.width.toDouble();
  double get height => canvas.height.toDouble();

  Stream<KeyboardEvent> get onKeyDown => document.onKeyDown;
  Stream<KeyboardEvent> get onKeyUp => document.onKeyUp;
  Stream<MouseEvent> get onMouseDown => canvas.onMouseDown;
  Stream<MouseEvent> get onMouseUp => canvas.onMouseUp;
  Stream<MouseEvent> get onMouseMove => canvas.onMouseMove;
  Stream<WheelEvent> get onMouseWheel => canvas.onMouseWheel;

  void init(String selector, {int width, int height}) {
    width = width != null ? width : 640;
    height = height != null ? height : 480;
    assets = new AssetManager();
    keyboard = new KeyStateHandler(onKeyDown, onKeyUp);

    var gamebox = querySelector(selector);
    canvas = new CanvasElement(width: width, height: height);
    canvas.style.backgroundColor = 'black';
    gamebox.children.add(canvas);
  }

  void update(num dt) {
    scene.update(dt);
  }

  void draw(CanvasRenderingContext2D context) {
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
      window.requestAnimationFrame(drawFrame);
    }
    window.requestAnimationFrame(drawFrame);

    new Timer.periodic(new Duration(seconds: 1), (t) {
      fps = frameCount;
      frameCount = 0;
    });
  }
}

final Game game = new Game();
