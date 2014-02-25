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

class Label extends GameNode {

  String font;
  var color;
  String align;
  String baseline;

  num width;
  num height;

  String _text;
  String get text => _text;
         set text(String value) {
    var canvas = new CanvasElement(width:0, height:0);
    var context = canvas.context2D;
    _setStyle(context);
    var dimensions = context.measureText(value);
    width = dimensions.width;

    // FIXME: Calculating height of text is very tricky.
    height = 0;

    _text = value;
  }

  Label(text, {position, font, color, align, baseline}):
      super() {
    positionAnchor = new vec2(0, 0);
    this.position = position != null ? position : this.position;
    this.font = font != null ? font : '20pt Serif';
    this.color = color != null ? color : 'white';
    this.align = align != null ? align : 'start';
    this.baseline = baseline != null ? baseline : 'alphabetic';
    this.text = text;
  }

  void _setStyle(context) {
    context.font = font;
    context.fillStyle = color;
    context.textAlign = align;
    context.textBaseline = baseline;
  }

  void draw(context) {
    _setStyle(context);
    context.fillText(text, 0, 0);
  }
}