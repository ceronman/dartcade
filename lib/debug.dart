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

abstract class DebugShape {
  int drawCounter = 60;
  void draw(html.CanvasRenderingContext2D context);
}

class DebugBox extends DebugShape {
  Aabb2 box;
  String strokeStyle = 'rgba(255, 255, 255, 0.5)';
  String fillStyle = 'rgba(255, 255, 255, 0.5)';

  DebugBox(box, [strokeStyle, fillStyle]) {
    if (strokeStyle != null) this.strokeStyle = strokeStyle;
    if (fillStyle != null) this.fillStyle = fillStyle;
    this.box = new Aabb2.copy(box);
    this.box.min.x -= 0.5;
    this.box.min.y -= 0.5;
    this.box.max.x -= 0.5;
    this.box.max.y -= 0.5;
  }

  void draw(html.CanvasRenderingContext2D context) {
    context.save();
    context.beginPath();
    context.strokeStyle = strokeStyle;
    context.fillStyle = fillStyle;
    context.rect(
        box.min.x,
        box.min.y,
        box.max.x - box.min.x,
        box.max.y - box.min.y);
    context.fill();
    context.stroke();
    context.closePath();
    drawCounter--;
    context.restore();
  }
}

class DebugDrawer {
  List<DebugShape> shapes = new List<DebugShape>();

  static DebugDrawer _instance;
  factory DebugDrawer() {
    if (_instance == null) {
      _instance = new DebugDrawer._internal();
    }
    return _instance;
  }
  DebugDrawer._internal();

  void draw(html.CanvasRenderingContext2D context) {
    for (var box in shapes) {
      box.draw(context);
    }
    shapes.removeWhere((box) => box.drawCounter <= 0);
  }

  void add(shape) => shapes.add(shape);
}

void debug(DebugShape shape) {
  var debugger = new DebugDrawer();
  debugger.add(shape);
}
