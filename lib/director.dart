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

class Director {
  ResourceManager resource;
  KeyStateHandler keyboard;
  CanvasElement canvas;
  num fps;

  Scene _currentScene;
  Scene get currentScene => _currentScene;
  void set currentScene(Scene scene) {
    _currentScene = scene;
    _currentScene.width = canvas.width;
    _currentScene.height = canvas.height;
  }

  Director(selector, {int width, int height}) {
    width = width != null ? width : 640;
    height = height != null ? height : 480;
    resource = new ResourceManager();
    keyboard = new KeyStateHandler();

    var gamebox = query(selector);
    canvas = new CanvasElement(width:width, height:height);
    canvas.style.backgroundColor = 'black';
    gamebox.children.add(canvas);
  }

  void update(num dt) {
    currentScene.update(dt);
  }

  void _debugDraw(CanvasRenderingContext2D context) {
    context.save();
    context.translate(0.5, 0.5);
    var size = 20;
    var color = "#333333";
    var rows = canvas.height / size;
    var cols = canvas.width / size;
    context.strokeStyle = color;

    var i = 0;

    context.beginPath();
    for (var row=1; row<rows; row++) {
      i = row * size;
      context.moveTo(0, i);
      context.lineTo(canvas.width, i);
    }

    for (var col=1; col<cols; col++) {
      i = col * size;
      context.moveTo(i, 0);
      context.lineTo(i, canvas.height);
    }
    context.stroke();
    context.restore();
  }

  void draw(CanvasRenderingContext2D context) {
    context.clearRect(0, 0, canvas.width, canvas.height);
//    _debugDraw(context);
    currentScene.drawWithChildren(context);
  }

  void run([Scene scene]) {
    if (?scene) {
      currentScene = scene;
    }
    resource.onLoad.listen((e) {
      var initTime;
      var frameCount = 0;

      drawFrame(num currentTime) {
        if (initTime == null) {
          initTime = currentTime;
        }
        frameCount++;
        var dt = (currentTime - initTime) / 1000;
        initTime = currentTime;
        update(dt);
        draw(canvas.context2d);
        window.requestAnimationFrame(drawFrame);
      }

      window.requestAnimationFrame(drawFrame);
      
      new Timer.periodic(new Duration(seconds:1), (t) {
        fps = frameCount;
        frameCount = 0;
        print('fps: $fps');
      });
      
    });

    resource.loadAll();
//    document.onKeyDown.listen(keyPress);
//    document.onMouseDown.listen(mouseDown);
  }

  keyPress(KeyboardEvent event) => currentScene.keyPress(event);
  mouseDown(MouseEvent event) => currentScene.mouseDown(event);
}