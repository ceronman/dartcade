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

library dartcocos_test;

import 'dart:async';
import 'dart:html';
import 'package:dartcocos/cocos.dart';

part 'test_actions.dart';
part 'test_assets.dart';
part 'test_input.dart';

typedef void TestFunction();

class InteractiveTest {
  String name;
  TestFunction testFunction;
  InteractiveTest(this.name, this.testFunction);
}
test(String name, TestFunction testFunction) {
  return new InteractiveTest(name, testFunction);
}

class InteractiveTestGroup {
  String name;
  List<InteractiveTest> tests;
  InteractiveTestGroup(this.name, this.tests);
}
group(name, tests) {
  return new InteractiveTestGroup(name, tests);
}

final groups = [
  group('Action Tests', actionTests),   // from test_actions.dart
  group('Assets Tests', assetsTests),   // from test_assets.dart
  group('Input Tests', inputTests),     // from test_input.dart
];

showIndex() {
  querySelector('#test-box').hidden = true;
  querySelector('#test-list').hidden = false;
  querySelector('#test-list').children.clear();
  querySelector('#test-title').text = '';
  for (var testGroup in groups) {
    var header = new HeadingElement.h2();
    header.text = testGroup.name;
    querySelector('#test-list').children.add(header);
    var testsUL = new UListElement();
    for (var test in testGroup.tests) {
      var item = new LIElement();
      var link = new AnchorElement(href:'#${testGroup.name}:${test.name}');
      link.text = test.name;
      item.children.add(link);
      testsUL.children.add(item);
    }
    querySelector('#test-list').children.add(testsUL);
  }
}

runTest(String testLink) {
  querySelector('#test-list').hidden = true;
  querySelector('#test-box').hidden = false;

  var parts = testLink.split(':');

  var groupName = parts[0];
  var testName = parts[1];
  var testGroup;
  var testCase;
  try {
    testGroup = groups.firstWhere((g) => g.name == groupName);
    testCase = testGroup.tests.firstWhere((t) => t.name == testName);
  }
  on StateError catch(e) {
    window.alert("Test does not exist");
    return;
  }
  var groupIndex = groups.indexOf(testGroup);
  var testIndex = testGroup.tests.indexOf(testCase);
  var prevAnchor = querySelector('#prev-anchor') as AnchorElement;

  if (testIndex > 0) {
    var prevTest = testGroup.tests[testIndex -1];
    prevAnchor.href = '#${testGroup.name}:${prevTest.name}';
    prevAnchor.hidden = false;
  }
  else if (groupIndex > 0) {
    var prevGroup = groups[groupIndex-1];
    var prevTest = prevGroup.tests.last;
    prevAnchor.href = '#${prevGroup.name}:${prevTest.name}';
    prevAnchor.hidden = false;
  }
  else {
    prevAnchor.hidden = true;
  }

  var nextAnchor = querySelector('#next-anchor') as AnchorElement;
  if (testIndex < testGroup.tests.length - 1) {
    var nextTest = testGroup.tests[testIndex +1];
    nextAnchor.href = '#${testGroup.name}:${nextTest.name}';
    nextAnchor.hidden = false;
  } else if (groupIndex < groups.length - 1) {
    var nextGroup = groups[groupIndex + 1];
    var nextTest = nextGroup.tests.first;
    nextAnchor.href = '#${nextGroup.name}:${nextTest.name}';
    nextAnchor.hidden = false;
  }
  else {
    nextAnchor.hidden = true;
  }

  querySelector('#test-title').text = '$groupName > $testName';
  game.scene = new Scene();
  testCase.testFunction();
}

main() {
  game.init('#gamebox');
  game.run();

  hashChange(e) {
    var hash = window.location.hash;
    var testLink = hash.isEmpty ? '' : hash.substring(1);

    if (testLink.isEmpty) {
      showIndex();
    }
    else {
      runTest(testLink);
    }
  };
  window.onHashChange.listen(hashChange);
  querySelector('#current-anchor').onClick.listen((e) {
    hashChange(e);
    e.preventDefault();
  });

  showIndex();
}
