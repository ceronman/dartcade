part of cocos;

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

interface GameNode {
  vec2 get position;
       set position(vec2 value);
  vec2 get position_anchor;
       set position_anchor(vec2 value);
  vec2 get rotation_anchor;
       set rotation_anchor(vec2 value);
  vec2 get scale;
       set scale(vec2 value);
  num  get rotation;
       set rotation(num value);
  bool get visible;
       set visible(bool value);

  List<GameNode> get children;
  List<Action>   get actions;

  GameNode get parent;
           set parent(GameNode value);

  num get width;
  num get height;

  void transform(context);
  void drawWithTransform(context);
  void drawWithChildren(context);
  void draw(context);
  void update(dt);
  void add(node);
  void remove(GameNode node);
  void runAction(Action action);
}


abstract class AbstractNode implements GameNode{
  vec2 position_anchor;
  vec2 rotation_anchor;
  vec2 scale;
  num rotation;
  bool visible;
  List<GameNode> children;
  List<Action> actions;
  GameNode parent;

  abstract num get width;
  abstract num get height;

  vec2 _position;
  vec2 get position => _position;
  void set position(p) {
    if (p is List) {
      _position = new vec2(p[0], p[1]);
    } else {
      _position = p;
    }
  }

  AbstractNode() {
    position = new vec2(0, 0);
    position_anchor = new vec2(0.5, 0.5);
    scale = new vec2(1, 1);
    rotation = 0;
    rotation_anchor = new vec2(0.5, 0.5);
    visible = true;
    children = new List<GameNode>();
    actions = new List<Action>();
  }

  transform(CanvasRenderingContext2D context) {

    context.translate(position.x, position.y);

    if (scale.x != 1 || scale.y != 1) {
      context.scale(scale.x, scale.y);
    }

    if (rotation != 0) {
      var axis_x = (rotation_anchor.x - position_anchor.x) * width;
      var axis_y = (rotation_anchor.y - position_anchor.y) * height;
      context.translate(axis_x, axis_y);
      context.rotate(rotation * PI/180);
      context.translate(-axis_x, -axis_y);
    }

    context.translate(-position_anchor.x * width, -position_anchor.y * height);
  }

  drawWithTransform(context) {
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
}