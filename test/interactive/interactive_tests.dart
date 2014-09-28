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

library dartcocos_test;

import 'dart:async';
import 'dart:html';
import 'dart:mirrors';
import 'package:dartcocos/cocos.dart';

part 'test_actions.dart';
part 'test_assets.dart';
part 'test_input.dart';

class InteractiveTest {
  final String group;
  final String name;
  const InteractiveTest(this.name, {this.group});
}

typedef TestFunction(Game game);

class TestCase {
  String name;
  TestFunction function;
  TestCase(this.name, this.function);
}

class TestGroup {
  String name;
  List<TestCase> tests;
  TestGroup(this.name, this.tests);
}

inspectTests() {
  var locations = {};
  var testsByGroup = {};
  var library = currentMirrorSystem().findLibrary(new Symbol('dartcocos_test'));
  for (var declaration in library.declarations.values) {
    if (declaration is MethodMirror) {
      var testFunction = declaration as MethodMirror;
      var metadata = testFunction.metadata;
      var annotations = metadata.where((a) => a.reflectee is InteractiveTest);
      if (annotations.isNotEmpty) {
        var annotation = annotations.first;
        var testInfo = annotation.reflectee as InteractiveTest;
        var testCase = new TestCase(testInfo.name, (Game game) {
          library.invoke(testFunction.simpleName, [game]);
        });
        locations[testCase] = testFunction.location.line;
        testsByGroup.putIfAbsent(testInfo.group, () => []);
        testsByGroup[testInfo.group].add(testCase);
      }
    }
  }
  return testsByGroup.keys.map((name) {
    var group = new TestGroup(name, testsByGroup[name]);
    group.tests.sort((a, b) => locations[a].compareTo(locations[b]));
    return group;
  }).toList();
}

showIndex(groups) {
  querySelector('#test-box').hidden = true;
  querySelector('#test-list').hidden = false;
  querySelector('#test-list').children.clear();
  querySelector('#test-title').text = '';
  for (var group in groups) {
    var header = new HeadingElement.h2()
      ..text = group.name;
    querySelector('#test-list').children.add(header);
    var testsUL = new UListElement();
    for (var test in group.tests) {
      var item = new LIElement();
      var link = new AnchorElement(href: '#${group.name}:${test.name}');
      link.text = test.name;
      item.children.add(link);
      testsUL.children.add(item);
    }
    querySelector('#test-list').children.add(testsUL);
  }
}

runTest(game, groups, testLink) {
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
  } on StateError catch (e) {
    window.alert("ERROR: Test does not exist");
    return;
  }
  var groupIndex = groups.indexOf(testGroup);
  var testIndex = testGroup.tests.indexOf(testCase);
  var prevAnchor = querySelector('#prev-anchor') as AnchorElement;

  if (testIndex > 0) {
    var prevTest = testGroup.tests[testIndex - 1];
    prevAnchor.href = '#${testGroup.name}:${prevTest.name}';
    prevAnchor.hidden = false;
  } else if (groupIndex > 0) {
    var prevGroup = groups[groupIndex - 1];
    var prevTest = prevGroup.tests.last;
    prevAnchor.href = '#${prevGroup.name}:${prevTest.name}';
    prevAnchor.hidden = false;
  } else {
    prevAnchor.hidden = true;
  }

  var nextAnchor = querySelector('#next-anchor') as AnchorElement;
  if (testIndex < testGroup.tests.length - 1) {
    var nextTest = testGroup.tests[testIndex + 1];
    nextAnchor.href = '#${testGroup.name}:${nextTest.name}';
    nextAnchor.hidden = false;
  } else if (groupIndex < groups.length - 1) {
    var nextGroup = groups[groupIndex + 1];
    var nextTest = nextGroup.tests.first;
    nextAnchor.href = '#${nextGroup.name}:${nextTest.name}';
    nextAnchor.hidden = false;
  } else {
    nextAnchor.hidden = true;
  }

  querySelector('#test-title').text = '$groupName > $testName';
  game.scene = new Scene();
  testCase.function(game);
}

main() {
  var groups = inspectTests();

  var game = new Game('#gamebox');
  game.run();

  hashChange(e) {
    var hash = window.location.hash;
    var testLink = hash.isEmpty ? '' : hash.substring(1);

    if (testLink.isEmpty) {
      showIndex(groups);
    }
    else {
      runTest(game, groups, testLink);
    }
  };
  window.onHashChange.listen(hashChange);
  querySelector('#current-anchor').onClick.listen((e) {
    hashChange(e);
    e.preventDefault();
  });

  showIndex(groups);
}
