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

part of dartcade_test;

@InteractiveTest('LoadingScene', group: 'Assets')
testLoading(GameLoop game) {
  var next = new Scene();
  new Label('New scene')
    ..position.x = 50.0
    ..position.y = 50.0
    ..addTo(next);

  fakeProgress() {
    var controller = new StreamController();
    num progress = 0;

    new Timer.periodic(new Duration(milliseconds: 100), (timer) {
      progress += 0.1;
      controller.add(progress);
      if (progress >= 1) {
        controller.close();
        timer.cancel();
      }
    });
    return controller.stream;
  }
  game.scene = new LoadingScene(fakeProgress(), next);
}

@InteractiveTest('LoadingScene with Error', group: 'Assets')
testLoadingWithError(GameLoop game) {
  var next = new Scene();
  new Label('New scene')
    ..position.x = 50.0
    ..position.y = 50.0
    ..addTo(next);

  fakeProgress() {
    var controller = new StreamController();
    controller.addError('This should be shown');
    return controller.stream;
  }

  game.scene = new LoadingScene(fakeProgress(), next);
}
