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
abstract class BaseNode {
  vec2 position_anchor;
  vec2 rotation_anchor;
  vec2 scale;
  num rotation;
  bool visible;
  List<BaseNode> children;
  BaseNode parent;

  abstract int get width();
  abstract int get height();

  vec2 _position;
  vec2 get position() => _position;
  void set position(p) {
    if (p is List) {
      _position = new vec2(p[0], p[1]);
    } else {
      _position = p;
    }
  }

  BaseNode() {
    position = new vec2(0, 0);
    position_anchor = new vec2(0.5, 0.5);
    scale = new vec2(1, 1);
    rotation = 0;
    rotation_anchor = new vec2(0.5, 0.5);
    visible = true;
    children = new List<BaseNode>();
  }

  void transform(CanvasRenderingContext2D context) {

    context.translate(position.x, position.y);

    if (scale.x != 1 || scale.y != 1) {
      context.scale(scale.x, scale.y);
    }

    if (rotation != 0) {
      var axis_x = (rotation_anchor.x - position_anchor.x) * width;
      var axis_y = (rotation_anchor.y - position_anchor.y) * height;
      context.translate(axis_x, axis_y);
      context.rotate(rotation * Math.PI/180);
      context.translate(-axis_x, -axis_y);
    }

    context.translate(-position_anchor.x * width, -position_anchor.y * height);
  }

  void drawWithTransform(context) {
      context.save();
      transform(context);
      draw(context);
      context.restore();
  }

  void drawWithChildren(context) {
    if (visible) {
      for (BaseNode child in children) {
        child.drawWithChildren(context);
      }
      drawWithTransform(context);
    }
  }

  void draw(context) {
  }

  void add(node) {
    children.add(node);
    node.parent = this;
  }

  void remove(BaseNode node) {
    children.removeRange(children.indexOf(node), 1);
    node.parent = null;
  }
}