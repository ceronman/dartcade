#import('dagali.dart');

class HelloWorldGame extends Game {
  var image;
  var x=100;
  var y=100;
  
  init() {
    image = resource.image('images/tinto.png');      
  }
  
  update(dt) {
    if (keyboard[Keys.LEFT]) {
      x -= 60 * dt;
    }
    if (keyboard[Keys.RIGHT]) {
      x += 60 * dt;
    }
    if (keyboard[Keys.DOWN]) {
      y += 60 * dt;
    }
    if (keyboard[Keys.UP]) {
      y -= 60 * dt;
    }
  }
  
  paint() {
    canvas.context2d.clearRect(0, 0, 640, 480);
    canvas.context2d.drawImage(image, x.round(), y.round());
    
    canvas.context2d.font = '14pt Serif italic';
    canvas.context2d.fillStyle = 'white';
    canvas.context2d.textAlign = 'start';
    canvas.context2d.fillText('Hello world', 100, 100);
  }
}

void main() {
  var game = new HelloWorldGame();
  game.run();
}