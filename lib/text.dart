class Label extends BaseNode {

  String font;
  var color;
  String align;
  String baseline;

  num width;
  num height;

  String _text;
  String get text() => _text;
         set text(String value) {
    var canvas = new CanvasElement(0, 0);
    var context = canvas.context2d;
    _setStyle(context);
    var dimensions = context.measureText(value);
    width = dimensions.width;

    // FIXME: Calculating height of text is very tricky.
    height = 0;

    _text = value;
  }

  Label(text, [position, font, color, align, baseline]):
      super() {
    position_anchor = new Vector(0, 0);
    this.position = position != null ? position : this.position;
    this.font = font != null ? font : '20pt Serif';
    this.color = color != null ? color : 'white';
    this.align = align != null ? align : 'start';
    this.baseline = baseline != null ? baseline : 'alphabetic';
    this.text = text;
  }

  void _setStyle(context) {
    context.font = font;
    context.fillStyle = color;
    context.textAlign = align;
    context.textBaseline = baseline;
  }

  void draw(context) {
    _setStyle(context);
    context.fillText(text, 0, 0);
  }
}