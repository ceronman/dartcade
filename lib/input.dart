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
class Keys {
  static final int MAC_ENTER = 3;
  static final int BACKSPACE = 8;
  static final int TAB = 9;
  static final int ENTER = 13;
  static final int SHIFT = 16;
  static final int CTRL = 17;
  static final int ALT = 18;
  static final int PAUSE = 19;
  static final int CAPS_LOCK = 20;
  static final int ESC = 27;
  static final int SPACE = 32;
  static final int PAGE_UP = 33;
  static final int PAGE_DOWN = 34;
  static final int END = 35;
  static final int HOME = 36;
  static final int LEFT = 37;
  static final int UP = 38;
  static final int RIGHT = 39;
  static final int DOWN = 40;
  static final int INSERT = 45;
  static final int DELETE = 46;
  static final int NUM_0 = 48;
  static final int NUM_1 = 49;
  static final int NUM_2 = 50;
  static final int NUM_3 = 51;
  static final int NUM_4 = 52;
  static final int NUM_5 = 53;
  static final int NUM_6 = 54;
  static final int NUM_7 = 55;
  static final int NUM_8 = 56;
  static final int NUM_9 = 57;
  static final int A = 65;
  static final int B = 66;
  static final int C = 67;
  static final int D = 68;
  static final int E = 69;
  static final int F = 70;
  static final int G = 71;
  static final int H = 72;
  static final int I = 73;
  static final int J = 74;
  static final int K = 75;
  static final int L = 76;
  static final int M = 77;
  static final int N = 78;
  static final int O = 79;
  static final int P = 80;
  static final int Q = 81;
  static final int R = 82;
  static final int S = 83;
  static final int T = 84;
  static final int U = 85;
  static final int V = 86;
  static final int W = 87;
  static final int X = 88;
  static final int Y = 89;
  static final int Z = 90;
  static final int WIN = 91;
  static final int CONTEXT_MENU = 93;
  static final int NUMPAD_0 = 96;
  static final int NUMPAD_1 = 97;
  static final int NUMPAD_2 = 98;
  static final int NUMPAD_3 = 99;
  static final int NUMPAD_4 = 100;
  static final int NUMPAD_5 = 101;
  static final int NUMPAD_6 = 102;
  static final int NUMPAD_7 = 103;
  static final int NUMPAD_8 = 104;
  static final int NUMPAD_9 = 105;
  static final int NUMPAD_MULTIPLY = 106;
  static final int NUMPAD_PLUS = 107;
  static final int NUMPAD_MINUS = 109;
  static final int NUMPAD_DECIMAL = 110;
  static final int NUMPAD_DIVIDE = 111;
  static final int F1 = 112;
  static final int F2 = 113;
  static final int F3 = 114;
  static final int F4 = 115;
  static final int F5 = 116;
  static final int F6 = 117;
  static final int F7 = 118;
  static final int F8 = 119;
  static final int F9 = 120;
  static final int F10 = 121;
  static final int F11 = 122;
  static final int F12 = 123;
  static final int SEMICOLON = 186;
  static final int COLON = 186;
  static final int MINUS = 189;
  static final int EQUAL = 187;
  static final int COMMA = 188;
  static final int LESS = 188;
  static final int PERIOD = 190;
  static final int GREATER = 190;
  static final int SLASH = 191;
  static final int QUESTION = 191;
  static final int TILDE = 192;
  static final int BACKQUOTE = 192;
  static final int BRACKET_LEFT = 219;
  static final int BRACE_LEFT = 219;
  static final int BACKSLASH = 220;
  static final int PIPE = 220;
  static final int BRACKET_RIGHT = 221;
  static final int BRACE_RIGHT = 221;
  static final int APOSTROPHE = 222;
  static final int DOUBLEQUOTE = 222;
}

class KeyStateHandler {
  Map<num, bool> pressedKeys;

  KeyStateHandler() {
    pressedKeys = new Map<num, bool>();

    document.on.keyDown.add((KeyboardEvent event) {
      this.pressedKeys[event.keyCode] = true;
    });

    document.on.keyUp.add((KeyboardEvent event) {
      this.pressedKeys[event.keyCode] = false;
    });
  }

  bool operator [](num key) {
    if (this.pressedKeys.containsKey(key)) {
      return this.pressedKeys[key];
    }
    return false;
  }
}