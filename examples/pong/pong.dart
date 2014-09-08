import 'package:dartcocos/cocos.dart';

const PADDLE_SPEED = 5;
var ball_speed = new vec2(10, 10);

main() {
  game.init('#gamebox', width:800, height:400);

  var loader = new AssetLoaderNg();
  loader.add('paddle', new ImageAsset('paddle.png'));
  loader.add('ball', new ImageAsset('ball.png'));

  loader.load().last.then((p) {

    var layer = new Layer();
    var paddle1 = new Sprite(loader['paddle'])
                  ..addTo(layer)
                  ..runAction(new Place(new vec2(40, 400/2)));

    var paddle2 = new Sprite(loader['paddle'])
                      ..addTo(layer)
                      ..runAction(new Place(new vec2(800-40, 400/2)));

    var ball = new Sprite(loader['ball'])
                          ..addTo(layer)
                          ..runAction(new Place(new vec2(800/2, 400/2)));

    var scene = new Scene(layer);

    scene.onFrame.listen((dt) {
      if (game.keyboard[Keys.A]) {
        paddle1.y -= PADDLE_SPEED;
        if (paddle1.top < 0) {
          paddle1.top = 0;
        }
      }
      if (game.keyboard[Keys.Z]) {
        paddle1.position.y += PADDLE_SPEED;
        if (paddle1.bottom > 400) {
          paddle1.bottom = 400;
        }
      }
      if (game.keyboard[Keys.UP]) {
        paddle2.position.y -= PADDLE_SPEED;
        if (paddle2.top < 0) {
          paddle2.top = 0;
        }
      }
      if (game.keyboard[Keys.DOWN]) {
        paddle2.position.y += PADDLE_SPEED;
        if (paddle2.bottom > 400) {
          paddle2.bottom = 400;
        }
      }

      ball.position += ball_speed;

      if (ball.position.x < 0) {
        ball.position.x = 0;
        ball_speed.x *= -1;
      }

      if (ball.position.x > 800) {
        ball.position.x = 800;
        ball_speed.x *= -1;
      }

      if (ball.position.y < 0) {
        ball.position.y = 0;
        ball_speed.y *= -1;
      }

      if (ball.position.y > 400) {
        ball.position.y = 400;
        ball_speed.y *= -1;
      }

    });

    game.run(scene);

  });
}
