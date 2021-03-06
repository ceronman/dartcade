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

  void add(GameNode node) {
    children.add(node);
    node.parent = this;
  }

  void addTo(GameNode node) {
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

  List<GameNode> children = new List<GameNode>();

  Body _body;
  Body get body => _body;
  set body(Body value) {
    _body = value..node = this;
  }

  StreamController<double> onFrameController =
      new StreamController<double>.broadcast(sync: true);
  Stream<num> get onFrame => onFrameController.stream;

  // TODO: Should this be part of box?

  Vector2 position = new Vector2.zero();
  Vector2 size = new Vector2.zero();
  Vector2 positionAnchor = new Vector2(0.5, 0.5);
  double rotation = 0.0;
  Vector2 rotationAnchor = new Vector2(0.5, 0.5);
  Vector2 scale = new Vector2(1.0, 1.0);
  double opacity = 1.0;
  bool visible = true;

  void transform(html.CanvasRenderingContext2D context) {
    context.globalAlpha = opacity;
    context.translate(position.x, position.y);

    if (scale.x != 1.0 || scale.y != 1.0) {
      context.scale(scale.x, scale.y);
    }

    if (rotation != 0) {
      var axis_x = (rotationAnchor.x - positionAnchor.x) * size.x;
      var axis_y = (rotationAnchor.y - positionAnchor.y) * size.y;
      context.translate(axis_x, axis_y);
      context.rotate(rotation * PI / 180);
      context.translate(-axis_x, -axis_y);
    }

    context.translate(-positionAnchor.x * size.x, -positionAnchor.y * size.y);
  }

  void drawWithTransform(html.CanvasRenderingContext2D context) {
    context.save();
    transform(context);
    draw(context);
    context.restore();
  }

  void drawWithChildren(html.CanvasRenderingContext2D context) {
    if (visible) {
      for (var child in children) {
        child.drawWithChildren(context);
      }
      drawWithTransform(context);
    }
  }

  void draw(html.CanvasRenderingContext2D context) {}

  void update(double dt) {
    for (var child in children) {
      child.update(dt);
    }

    for (var action in actions) {
      if (action.done) {
        action.stop();
      } else {
        action.step(dt);
      }
    }

    actions.removeWhere((action) => action.done);
    onFrameController.add(dt);
  }

  List<Action> actions = new List<Action>();

  void runAction(Action action) {
    action.target = this;
    actions.add(action);
    action.start();
  }

  void stopActions() {
    for (Action action in new List.from(actions)) {
      action.stop();
      actions.removeRange(actions.indexOf(action), 1);
    }
  }
}
