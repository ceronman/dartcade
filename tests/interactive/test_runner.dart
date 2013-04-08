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

library cocostest;

import 'dart:mirrors';
import 'dart:html';
import '../../lib/cocos.dart';

part 'test_actions.dart';

main() {
  Director director = new Director('#gamebox');
  director.run(new Scene());

  hashChange(e) {
    var ms = currentMirrorSystem();
    var libraryMirror = ms.libraries['cocostest'];
    var functionNames = libraryMirror.functions.keys;
    var testFunctions = libraryMirror.functions.keys.where((testName) {
      return testName.startsWith('test');
    });
    testFunctions = new List.from(testFunctions);
    testFunctions.sort();

    var hash = window.location.hash;
    var testName = hash.isEmpty ? '' : hash.substring(1);

    if (testName.isEmpty) {
      query('#gamebox').hidden = true;
      queryAll('.test-naviation').forEach((e) => e.hidden = true);
      query('#test-list').hidden = false;
      var testsUL = new UListElement();
      for (var testName in testFunctions) {
        var item = new LIElement();
        var link = new AnchorElement(href:'#${testName}');
        link.text = testName;
        item.children.add(link);
        testsUL.children.add(item);
      }
      query('#test-list').children.clear();
      query('#test-list').children.add(testsUL);
      query('#test-title').text = 'Cocos Interactive Tests';
    }
    else {
      query('#gamebox').hidden = false;
      queryAll('.test-naviation').forEach((e) => e.hidden = false);
      query('#test-list').hidden = true;
      var testIndex = testFunctions.indexOf(testName);
      if (testIndex == -1) {
        window.alert("Test does not exist");
        return;
      }

      var prevAnchor = query('#prev-anchor') as AnchorElement;
      if (testIndex - 1 >= 0) {
        prevAnchor.hidden = false;
        prevAnchor.href = '#${testFunctions[testIndex -1]}';
      }
      else {
        prevAnchor.hidden = true;
      }

      var nextAnchor = query('#next-anchor') as AnchorElement;
      if (testIndex + 1 < testFunctions.length) {
        nextAnchor.hidden = false;
        nextAnchor.href = '#${testFunctions[testIndex + 1]}';
      }
      else {
        nextAnchor.hidden = true;
      }

      query('#test-title').text = testName;
      libraryMirror.invoke(testName, [reflect(director)]);
    }
  };

  window.onHashChange.listen(hashChange);
  query('#current-anchor').onClick.listen((e) {
    hashChange(e);
    e.preventDefault();
  });
  hashChange(null);
}