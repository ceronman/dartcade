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

class Keys {
  static const int MAC_ENTER = 3;
  static const int BACKSPACE = 8;
  static const int TAB = 9;
  static const int ENTER = 13;
  static const int SHIFT = 16;
  static const int CTRL = 17;
  static const int ALT = 18;
  static const int PAUSE = 19;
  static const int CAPS_LOCK = 20;
  static const int ESC = 27;
  static const int SPACE = 32;
  static const int PAGE_UP = 33;
  static const int PAGE_DOWN = 34;
  static const int END = 35;
  static const int HOME = 36;
  static const int LEFT = 37;
  static const int UP = 38;
  static const int RIGHT = 39;
  static const int DOWN = 40;
  static const int INSERT = 45;
  static const int DELETE = 46;
  static const int NUM_0 = 48;
  static const int NUM_1 = 49;
  static const int NUM_2 = 50;
  static const int NUM_3 = 51;
  static const int NUM_4 = 52;
  static const int NUM_5 = 53;
  static const int NUM_6 = 54;
  static const int NUM_7 = 55;
  static const int NUM_8 = 56;
  static const int NUM_9 = 57;
  static const int A = 65;
  static const int B = 66;
  static const int C = 67;
  static const int D = 68;
  static const int E = 69;
  static const int F = 70;
  static const int G = 71;
  static const int H = 72;
  static const int I = 73;
  static const int J = 74;
  static const int K = 75;
  static const int L = 76;
  static const int M = 77;
  static const int N = 78;
  static const int O = 79;
  static const int P = 80;
  static const int Q = 81;
  static const int R = 82;
  static const int S = 83;
  static const int T = 84;
  static const int U = 85;
  static const int V = 86;
  static const int W = 87;
  static const int X = 88;
  static const int Y = 89;
  static const int Z = 90;
  static const int WIN = 91;
  static const int CONTEXT_MENU = 93;
  static const int NUMPAD_0 = 96;
  static const int NUMPAD_1 = 97;
  static const int NUMPAD_2 = 98;
  static const int NUMPAD_3 = 99;
  static const int NUMPAD_4 = 100;
  static const int NUMPAD_5 = 101;
  static const int NUMPAD_6 = 102;
  static const int NUMPAD_7 = 103;
  static const int NUMPAD_8 = 104;
  static const int NUMPAD_9 = 105;
  static const int NUMPAD_MULTIPLY = 106;
  static const int NUMPAD_PLUS = 107;
  static const int NUMPAD_MINUS = 109;
  static const int NUMPAD_DECIMAL = 110;
  static const int NUMPAD_DIVIDE = 111;
  static const int F1 = 112;
  static const int F2 = 113;
  static const int F3 = 114;
  static const int F4 = 115;
  static const int F5 = 116;
  static const int F6 = 117;
  static const int F7 = 118;
  static const int F8 = 119;
  static const int F9 = 120;
  static const int F10 = 121;
  static const int F11 = 122;
  static const int F12 = 123;
  static const int SEMICOLON = 186;
  static const int COLON = 186;
  static const int MINUS = 189;
  static const int EQUAL = 187;
  static const int COMMA = 188;
  static const int LESS = 188;
  static const int PERIOD = 190;
  static const int GREATER = 190;
  static const int SLASH = 191;
  static const int QUESTION = 191;
  static const int TILDE = 192;
  static const int BACKQUOTE = 192;
  static const int BRACKET_LEFT = 219;
  static const int BRACE_LEFT = 219;
  static const int BACKSLASH = 220;
  static const int PIPE = 220;
  static const int BRACKET_RIGHT = 221;
  static const int BRACE_RIGHT = 221;
  static const int APOSTROPHE = 222;
  static const int DOUBLEQUOTE = 222;
}

class KeyStateHandler {
  Map<num, bool> pressedKeys = new Map<num, bool>();
  Stream<KeyboardEvent> onKeyDown;
  Stream<KeyboardEvent> onKeyUp;

  KeyStateHandler(this.onKeyDown, this.onKeyUp) {
    onKeyDown.listen((KeyboardEvent event) {
      pressedKeys[event.keyCode] = true;
    });

    onKeyUp.listen((KeyboardEvent event) {
      pressedKeys[event.keyCode] = false;
    });
  }

  bool operator [](num key) {
    return pressedKeys.containsKey(key) && pressedKeys[key];
  }
}
