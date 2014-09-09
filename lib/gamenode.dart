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

abstract class GameNode {

  GameNode _parent;
  GameNode get parent => _parent;
  void set parent(GameNode value) {
    if (_parent == value) {
      return;
    }
    if (_parent != null) {
      _parent.remove(this);
    }
    _parent = value;
  }
  void add(node) {
    children.add(node);
    node.parent = this;
  }

  void addTo(node) {
    node.add(this);
    this.parent = node;
  }

  void remove(GameNode node) {
    children.removeRange(children.indexOf(node), 1);
    node.parent = null;
  }

  void removeFromParent() {
    parent = null;
  }

  PhysicsComponent physics;

  vec2 position = new vec2(0, 0);
  vec2 positionAnchor = new vec2(0.5, 0.5);
  num get width;
  num get height;

  num get x => position.x;
  num get y => position.y;

  set x(num value) => position.x = value;
  set y(num value) => position.y = value;

  num get left => position.x - width * positionAnchor.x;
  num get top => position.y - height * positionAnchor.y;
  num get right => position.x + width * positionAnchor.x;
  num get bottom => position.y + height * positionAnchor.y;

  num rotation = 0;
  vec2 rotationAnchor = new vec2(0.5, 0.5);
  vec2 scale = new vec2(1, 1);
  num opacity = 1.0;
  bool visible = true;
  List<GameNode> children = new List<GameNode>();
  List<Action> actions = new List<Action>();


  StreamController<num> onFrameController = new StreamController<num>();
  Stream<num> get onFrame => onFrameController.stream.asBroadcastStream();


  set left(num value) => position.x = value + width * positionAnchor.x;
  set top(num value) => position.y = value + height * positionAnchor.y;
  set right(num value) => position.x = value - width * positionAnchor.x;
  set bottom(num value) => position.y = value - height * positionAnchor.y;

  void transform(CanvasRenderingContext2D context) {
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

  void drawWithTransform(context) {
      context.save();
      transform(context);
      draw(context);
      context.restore();
  }

  void drawWithChildren(context) {
    if (visible) {
      for (var child in children) {
        child.drawWithChildren(context);
      }
      drawWithTransform(context);
    }
  }

  void draw(context) {}

  void update(dt) {
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
    onFrameController.add(dt);
  }


  void runAction(Action action) {
    action.target = this;
    actions.add(action);
    action.start();
  }

  void stopActions() {
    for (var action in new List.from(actions)) {
      action.stop();
      actions.removeRange(actions.indexOf(action), 1);
    }
  }
}