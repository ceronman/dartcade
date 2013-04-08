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

abstract class GameNode {
  vec2 positionAnchor = new vec2(0.5, 0.5);
  vec2 rotationAnchor = new vec2(0.5, 0.5);
  vec2 scale = new vec2(1, 1);
  num rotation = 0;
  num opacity = 1.0;
  bool visible = true;
  List<GameNode> children = new List<GameNode>();
  List<Action> actions = new List<Action>();
  GameNode parent;

  num get width;
  num get height;

  vec2 _position = new vec2(0, 0);
  vec2 get position => _position;
  void set position(p) {
    if (p is List) {
      _position = new vec2(p[0], p[1]);
    } else {
      _position = p;
    }
  }

  transform(CanvasRenderingContext2D context) {
    context.globalAlpha = opacity;
    context.translate(position.x, position.y);

    if (scale.x != 1 || scale.y != 1) {
      context.scale(scale.x, scale.y);
    }

    if (rotation != 0) {
      var axis_x = (rotationAnchor.x - positionAnchor.x) * width;
      var axis_y = (rotationAnchor.y - positionAnchor.y) * height;
      context.translate(axis_x, axis_y);
      context.rotate(rotation * PI/180);
      context.translate(-axis_x, -axis_y);
    }

    context.translate(-positionAnchor.x * width, -positionAnchor.y * height);
  }

  drawWithTransform(context) {
//      context.save();
//      context.strokeStyle = "#FF0000";
//      context.beginPath();
//      context.rect(position.x, position.y, width, height);
//      context.stroke();
//      context.restore();

      context.save();
      transform(context);
      draw(context);
      context.restore();
  }

  drawWithChildren(context) {
    if (visible) {
      for (var child in children) {
        child.drawWithChildren(context);
      }
      drawWithTransform(context);
    }
  }

  draw(context) {
  }

  update(dt) {
    for (var child in children) {
      child.update(dt);
    }

    var doneActions = [];
    for (var action in actions) {
      if (!action.done) {
        action.step(dt);
      }
      else {
        doneActions.add(action);
      }
    }

    for (var action in doneActions) {
      action.stop();
      actions.removeRange(actions.indexOf(action), 1);
    }
  }

  add(node) {
    children.add(node);
    node.parent = this;
  }

  remove(GameNode node) {
    children.removeRange(children.indexOf(node), 1);
    node.parent = null;
  }

  runAction(Action action) {
    action.target = this;
    actions.add(action);
    action.start();
  }

  stopActions() {
    for (var action in new List.from(actions)) {
      action.stop();
      actions.removeRange(actions.indexOf(action), 1);
    }
  }
}