
class EventListeners implements EventListenerList {
  var listeners;

  EventListeners() {
    this.listeners = [];
  }

  EventListeners add(EventListener handler, [bool useCapture]) {
    this.listeners.add(handler);
    return this;
  }

  EventListeners remove(EventListener handler, [bool useCapture]) {
    var index = listeners.indexOf(handler);
    listeners.removeRange(index, index);
    return this;
  }

  bool dispatch(Event event) {
    listeners.forEach((fn) {fn(event);});
    return true;
  }
}