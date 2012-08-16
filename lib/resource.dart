
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