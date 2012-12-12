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

class Resource {
  var element;
  String source;
  bool loaded;

  Resource(this.element, this.source, this.loaded) {
    this.element.on.load.add((e) => this.loaded = true);
  }

  void load() {
    this.element.src = this.source;
  }
}

class ResourceManagerEvents {
  EventListeners load;

  ResourceManagerEvents() {
    this.load = new EventListeners();
  }
}


class ResourceManager {
  ResourceManagerEvents on;
  List<Resource> resources;

  ResourceManager() {
    resources = new List<Resource>();
    on = new ResourceManagerEvents();
  }

  ImageElement image(String src) {
    var imageElement = new ImageElement();
    resources.add(new Resource(imageElement, src, false));
    imageElement.on.load.add(check);
    return imageElement;
  }

  void check(Event event) {
    if (resources.every((resource) => resource.loaded)) {
      on.load.dispatch(new Event('loaded'));
    }
  }

  void loadAll() {
    if (resources.length == 0) {
      on.load.dispatch(new Event('loaded'));
      return;
    }
    for (var resource in resources) {
      resource.load();
    }
  }
}