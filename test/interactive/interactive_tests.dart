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
  static final groups = {};
  static final functions = {};
  final String group;
  final String name;
  const InteractiveTest(this.name, {this.group});

  function() => groups[group][name];
}

inspectTests() {
  var mirror = currentMirrorSystem();
  var library = mirror.findLibrary(new Symbol('dartcocos_test'));
  var locations = {};
  for (var declaration in library.declarations.values) {
    if (declaration is MethodMirror) {
      var testFunction = declaration as MethodMirror;
      var metadata = testFunction.metadata;
      try {
        var annotation = metadata.firstWhere((x) {
          return x.reflectee is InteractiveTest;
        });
        var testInfo = annotation.reflectee as InteractiveTest;
        locations[testInfo] = testFunction.location.line;
        InteractiveTest.groups.putIfAbsent(testInfo.group, () => []);
        InteractiveTest.groups[testInfo.group].add(testInfo);
        InteractiveTest.functions[testInfo] = testFunction;
        InteractiveTest.groups[testInfo.group].sort((a, b) {
          return locations[a].compareTo(locations[b]);
        });
      } on StateError catch (e) {
        continue;
      }
    }
  }
}

showIndex() {
  querySelector('#test-box').hidden = true;
  querySelector('#test-list').hidden = false;
  querySelector('#test-list').children.clear();
  querySelector('#test-title').text = '';
  for (var testGroup in InteractiveTest.groups.keys) {
    var tests = InteractiveTest.groups[testGroup];
    var header = new HeadingElement.h2();
    header.text = testGroup;
    querySelector('#test-list').children.add(header);
    var testsUL = new UListElement();
    for (var test in tests) {
      var item = new LIElement();
      var link = new AnchorElement(href: '#${testGroup}:${test.name}');
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
    testGroup = InteractiveTest.groups[groupName];
    testCase = testGroup.firstWhere((t) => t.name == testName);
  } on StateError catch (e) {
    window.alert("Test does not exist");
    return;
  }
  var groupIndex = InteractiveTest.groups.indexOf(testGroup);
  var testIndex = testGroup.tests.indexOf(testCase);
  var prevAnchor = querySelector('#prev-anchor') as AnchorElement;

  if (testIndex > 0) {
    var prevTest = testGroup.tests[testIndex - 1];
    prevAnchor.href = '#${testGroup.name}:${prevTest.name}';
    prevAnchor.hidden = false;
  } else if (groupIndex > 0) {
    var prevGroup = InteractiveTest.groups[groupIndex - 1];
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
  } else if (groupIndex < InteractiveTest.groups.length - 1) {
    var nextGroup = InteractiveTest.groups[groupIndex + 1];
    var nextTest = nextGroup.tests.first;
    nextAnchor.href = '#${nextGroup.name}:${nextTest.name}';
    nextAnchor.hidden = false;
  } else {
    nextAnchor.hidden = true;
  }

  querySelector('#test-title').text = '$groupName > $testName';
  game.scene = new Scene();
  testCase.testFunction();
}

var game;

main() {
  inspectTests();
//  game = new Game('#gamebox');
//  game.run();
//
//  hashChange(e) {
//    var hash = window.location.hash;
//    var testLink = hash.isEmpty ? '' : hash.substring(1);
//
//    if (testLink.isEmpty) {
//      showIndex();
//    }
//    else {
//      runTest(testLink);
//    }
//  };
//  window.onHashChange.listen(hashChange);
//  querySelector('#current-anchor').onClick.listen((e) {
//    hashChange(e);
//    e.preventDefault();
//  });

  showIndex();
}
