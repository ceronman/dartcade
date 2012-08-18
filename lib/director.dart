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
class Director {
  ResourceManager resource;
  KeyStateHandler keyboard;
  CanvasElement canvas;

  Scene _currentScene;
  Scene get currentScene() => _currentScene;
  void set currentScene(Scene scene) {
    _currentScene = scene;
    _currentScene.width = canvas.width;
    _currentScene.height = canvas.height;
  }

  Director(selector, [int width, int height]) {
    width = width != null ? width : 640;
    height = height != null ? height : 480;
    resource = new ResourceManager();
    keyboard = new KeyStateHandler();

    var gamebox = query(selector);
    canvas = new CanvasElement(width, height);
    canvas.style.backgroundColor = 'black';
    gamebox.elements.add(canvas);
  }

  void update(num dt) {

  }

  void _debugDraw(CanvasRenderingContext2D context) {
    var size = 20;
    var color = "#333333";
    var rows = canvas.height / size;
    var cols = canvas.width / size;

    for (var row=0; row<rows; row++) {
      context.strokeStyle = color;
      context.moveTo(0, row * size + 0.5);
      context.lineTo(canvas.width, row * size + 0.5);
      context.stroke();
    }

    for (var col=0; col<cols; col++) {
      context.strokeStyle = color;
      context.moveTo(col * size + 0.5, 0);
      context.lineTo(col * size + 0.5, canvas.height);
      context.stroke();
    }
  }

  void draw(CanvasRenderingContext2D context) {
    context.clearRect(0, 0, canvas.width, canvas.height);
    _debugDraw(context);
    currentScene.drawWithChildren(context);
  }

  void run(Scene mainScene) {
    currentScene = mainScene;
    currentScene.width = canvas.width;
    currentScene.height = canvas.height;

    resource.on.load.add((e) {
      var initTime = new Date.now().millisecondsSinceEpoch;
      drawFrame(int currentTime) {
        var dt = (currentTime - initTime) / 1000;
        initTime = currentTime;
        update(dt);
        draw(canvas.context2d);
        window.requestAnimationFrame(drawFrame);
      }
      window.requestAnimationFrame(drawFrame);
    });

    resource.loadAll();
  }
}