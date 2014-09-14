import 'package:dartcocos/cocos.dart';

main() {
  game.init('#gamebox', width: 800, height: 400);

  var loader = new AssetLoaderNg();
  loader.add('paddle', new ImageAsset('paddle.png'));
  loader.add('ball', new ImageAsset('ball.png'));

  loader.load().last.then((p) {

    var layer = new Layer();
    var paddle1 = new Sprite(loader['paddle'])
        ..addTo(layer)
        ..runAction(new Place(new Vector2(40.0, 400 / 2)))
        ..physics = new PhysicsComponent();

    var paddle2 = new Sprite(loader['paddle'])
        ..addTo(layer)
        ..runAction(new Place(new Vector2(800.0 - 40, 400 / 2)))
        ..physics = new PhysicsComponent();

    var controller1 = new ArcadeKeyboardController(game.keyboard)
        ..keyUp = Keys.A
        ..keyDown = Keys.Z
        ..speedUp = -400.0
        ..speedDown = 400.0;
    paddle1.runAction(controller1);

    var controller2 = new ArcadeKeyboardController(game.keyboard)
        ..keyUp = Keys.UP
        ..keyDown = Keys.DOWN
        ..speedUp = -400.0
        ..speedDown = 400.0;
    paddle2.runAction(controller2);

    var ball = new Sprite(loader['ball'])
        ..addTo(layer)
        ..runAction(new Place(new Vector2(800 / 2, 400 / 2)))
        ..physics = new PhysicsComponent();
    ball.physics.speed = new Vector2(400.0, 400.0);

    var scene = new Scene(layer);

    scene.onFrame.listen((dt) {
      if (ball.position.x < 0.0) {
        ball.position.x = 0.0;
        ball.physics.speed.x *= -1;
      }

      if (ball.position.x > 800.0) {
        ball.position.x = 800.0;
        ball.physics.speed.x *= -1.0;
      }

      if (ball.position.y < 0.0) {
        ball.position.y = 0.0;
        ball.physics.speed.y *= -1;
      }

      if (ball.position.y > 400.0) {
        ball.position.y = 400.0;
        ball.physics.speed.y *= -1;
      }

    });

    game.run(scene);

  });
}
