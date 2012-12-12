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

import '../lib/cocos.dart';

void main() {
  Director director = new Director('#gamebox');

  var layer = new Layer();
  var label = new Label('Hello world!');

  label.position.x = director.canvas.width/2;
  label.position.y = director.canvas.height/2;
  label.font = '25pt Arial';
  label.align = 'center';
  label.baseline = 'middle';

  layer.add(label);

  director.run(new Scene(layer));
}