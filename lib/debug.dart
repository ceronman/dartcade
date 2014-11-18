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

// TODO: Write tests for the debuggers

abstract class DebugShape {
  int frames = 1;
  String strokeStyle = 'white';
  String fillStyle = null;
  void draw(html.CanvasRenderingContext2D context);
}

class DebugBox extends DebugShape {
  Aabb2 box;

  DebugBox(box) {
    this.box = new Aabb2.copy(box);
    this.box.min.x -= 0.5;
    this.box.min.y -= 0.5;
    this.box.max.x -= 0.5;
    this.box.max.y -= 0.5;
  }

  void draw(html.CanvasRenderingContext2D context) {
    context.beginPath();
    context.rect(
        box.min.x,
        box.min.y,
        box.max.x - box.min.x,
        box.max.y - box.min.y);
    context.fill();
    context.stroke();
    context.closePath();
  }
}

class DebugVector extends DebugShape {
  Vector2 start = new Vector2.zero();
  Vector2 vector = new Vector2.zero();

  DebugVector(this.vector, [this.start]);

  void draw(html.CanvasRenderingContext2D context) {
    fillStyle = strokeStyle;
    var target = start + vector;
    var arrow = vector.normalized();

    context
        ..beginPath()
        ..moveTo(start.x, start.y)
        ..lineTo(target.x, target.y)
        ..stroke()
        ..lineTo(
            target.x - arrow.x * 6 - arrow.y * 3,
            target.y - arrow.y * 6 + arrow.x * 3)
        ..lineTo(
            target.x - arrow.x * 6 + arrow.y * 3,
            target.y - arrow.y * 6 - arrow.x * 3)
        ..lineTo(target.x, target.y)
        ..fill()
        ..closePath();
  }
}

class DebugDrawer {
  List<DebugShape> shapes = [];
  static Map<String, DebugDrawer> _instances = {};
  factory DebugDrawer(String name) {
    if (!_instances.containsKey(name)) {
      _instances[name] = new DebugDrawer._internal();
    }
    return _instances[name];
  }
  DebugDrawer._internal();

  void update(dt) {
    shapes.removeWhere((box) => box.frames-- <= 0);
  }

  void draw(html.CanvasRenderingContext2D context) {
    for (var shape in shapes) {
      context.save();
      context.strokeStyle = shape.strokeStyle;
      context.fillStyle = shape.fillStyle;
      shape.draw(context);
      context.restore();
    }

  }

  void add(shape) => shapes.add(shape);

  void box(Aabb2 box, {fg: null, bg: null, frames: null}) {
    var debugBox = new DebugBox(box);
    if (fg != null) debugBox.strokeStyle = fg;
    if (bg != null) debugBox.fillStyle = bg;
    if (frames != null) debugBox.frames = frames;
    add(debugBox);
  }

  void vector(Vector2 vector, {start: null, fg: null, bg: null, frames:
      null}) {
    var debugVector = new DebugVector(vector, start);
    if (fg != null) debugVector.strokeStyle = fg;
    if (bg != null) debugVector.fillStyle = bg;
    if (frames != null) debugVector.frames = frames;
    add(debugVector);
  }
}
