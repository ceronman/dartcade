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

// TODO: Rename this to dartcade. This is not a cocos port anymore.
library cocos;

import 'dart:html' as html;
import 'dart:math';
import 'dart:async';
import 'package:vector_math/vector_math.dart';

export 'package:vector_math/vector_math.dart' show Vector2, Aabb2;

part 'action.dart';
part 'assets.dart';
part 'collision.dart';
part 'gameloop.dart';
part 'gamenode.dart';
part 'geometry.dart';
part 'input.dart';
part 'layer.dart';
part 'physics.dart';
part 'scene.dart';
part 'sprite.dart';
part 'text.dart';