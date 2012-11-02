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
    var testFunctions = libraryMirror.functions.keys.filter((testName) {
      return testName.startsWith('test');
    });
    testFunctions = new List.from(testFunctions);

    var hash = window.location.hash;
    var testName = hash.isEmpty ? '' : hash.substring(1);

    if (testName.isEmpty) {
      query('#gamebox').hidden = true;
      query('#test-naviation').hidden = true;
      query('#test-list').hidden = false;
      var testsUL = new UListElement();
      for (var testName in testFunctions) {
        var item = new LIElement();
        var link = new AnchorElement(href:'#${testName}');
        link.text = testName;
        item.elements.add(link);
        testsUL.elements.add(item);
      }
      query('#test-list').elements.clear();
      query('#test-list').elements.add(testsUL);
      query('#test-title').text = 'Cocos Interactive Tests';
    }
    else {
      query('#gamebox').hidden = false;
      query('#test-naviation').hidden = false;
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

  window.on.hashChange.add(hashChange);
  hashChange(null);
}