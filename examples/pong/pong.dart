import 'package:dartcocos/cocos.dart';

main() {
  var game = new Game('#gamebox', width: 800, height: 400);

  var loader = new AssetLoader();
  loader.add('paddle', new ImageAsset('paddle.png'));
  loader.add('ball', new ImageAsset('ball.png'));

  var world = new World(0.0, 0.0, game.width, game.height);
  game.scene.onFrame.listen(world.update);

  loader.load().last.then((p) {

    var controller1 = new ArcadeKeyboardController(game.keyboard)
        ..keyUp = Keys.A
        ..keyDown = Keys.Z
        ..speedUp = -400.0
        ..speedDown = 400.0;

    var controller2 = new ArcadeKeyboardController(game.keyboard)
        ..keyUp = Keys.UP
        ..keyDown = Keys.DOWN
        ..speedUp = -400.0
        ..speedDown = 400.0;

    var paddle1 = new Sprite(loader['paddle'])
        ..addTo(game.scene)
        ..runAction(new Place(new Vector2(40.0, 400 / 2)))
        ..body = new Body(world)
        ..runAction(controller1);

    var paddle2 = new Sprite(loader['paddle'])
        ..addTo(game.scene)
        ..runAction(new Place(new Vector2(800.0 - 40, 400 / 2)))
        ..body = new Body(world)
        ..runAction(controller2);

    var ball = new Sprite(loader['ball'])
        ..addTo(game.scene)
        ..runAction(new Place(new Vector2(800 / 2, 400 / 2)))
        ..body = new Body(world)
        ..body.speed = new Vector2(-400.0, -400.0)
        ..body.restitution = new Vector2(1.0, 1.0);

    world.collide(ball).listen((e) {
      var ball = e.body1;
      var world = e.body2;
      if (e.side1 == Side.LEFT) {
        ball.left = world.hitbox.min.x;
        ball.speed.x *= -ball.restitution.x;
      }
      else if (e.side1 == Side.RIGHT) {
        ball.right = world.hitbox.max.x;
        ball.speed.x *= -ball.restitution.x;
      }
      else if (e.side1 == Side.TOP) {
        ball.top = world.hitbox.min.y;
        ball.speed.y *= -ball.restitution.y;
      }
      else if (e.side1 == Side.BOTTOM) {
        ball.bottom = world.hitbox.max.y;
        ball.speed.y *= -ball.restitution.y;
      }
    });
  });

  game.run();
}
