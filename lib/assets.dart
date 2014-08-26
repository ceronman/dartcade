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

abstract class Asset {
  String location;
  Object element;
  bool loaded = false;

  Asset(this.location);
  Stream<bool> load();
}

class ImageAsset extends Asset{
  ImageAsset(String location) : super(location);
  Stream<bool> load() {
    var image = new ImageElement();
    var transformer = new StreamTransformer.fromHandlers(handleData:(e, sink) {
      loaded = true;
      sink.add(true);
    });
    var result = image.onLoad.transform(transformer);
    image.src = location;
    element = image;
    return result;
  }
}

class AssetLoaderNg {
  Map<String, Asset> assets = {};

  void add(String name, Asset asset) {
    if (assets.containsKey(name)) {
      throw new ArgumentError("Asset $name already exists.");
    }
    assets[name] = asset;
  }

  Stream<num> load() {
    var progress = new StreamController();
    var toLoad = assets.values.where((a) => !a.loaded).toList();

    if (toLoad.length == 0) {
      progress.addError("Nothing to load");
      progress.close();
      return progress.stream.asBroadcastStream();
    }

    for (var asset in toLoad) {
      asset.load().listen((loaded) {
        var completed = toLoad.where((a) => a.loaded).length;
        var total = toLoad.length;
        progress.add(completed / total);
        if (completed == total) {
          progress.close();
        }
      }, onError: (error) => progress.addError(error));
    }
    return progress.stream.asBroadcastStream();
  }

  Object operator [](String name) => assets[name].element;
}

class AssetManager {
  Map<String, ImageElement> images = {};

  Stream<num> load(List<String> sources) {
    var progress = new StreamController();

    if (sources.length == 0) {
      progress.close();
      return progress.stream;
    }

    var loadedState = {};
    for (String source in sources) {
      loadedState[source] = false;
    }

    for (String source in sources) {
      images[source] = new ImageElement();
      images[source].onLoad.listen((e) {
        loadedState[source] = true;
        var completed = loadedState.values.where((loaded) => loaded).length;
        var total = loadedState.values.length;
        progress.add(completed / total);
        if (completed == total) {
          progress.close();
        }
      },
      onError: (error) {
        progress.addError(error);
      });
      images[source].src = source;
    }

    return progress.stream.asBroadcastStream();
  }
}

class LoadingScene extends Scene {
  LoadingScene(Stream<num> progress, Scene nextScene): super(null) {
    var layer = new Layer();
    var label = new Label('Loading...');
    label.align = 'center';
    label.position.x = game.width/2;
    label.position.y = game.height/2;
    this.layer = layer;
    this.add(layer);
    layer.add(label);

    progress.listen((p) {
      label.text = 'Loading ${(p * 100).toStringAsFixed(0)}%';
    }, onError: (error) {
      label.text = 'error $error';
    }, onDone: () {
      game.currentScene = nextScene;
    });

  }
}