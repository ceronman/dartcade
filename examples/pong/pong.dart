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
        ..physics = new Body(world)
        ..runAction(controller1);

    var paddle2 = new Sprite(loader['paddle'])
        ..addTo(game.scene)
        ..runAction(new Place(new Vector2(800.0 - 40, 400 / 2)))
        ..physics = new Body(world)
        ..runAction(controller2);

    var ball = new Sprite(loader['ball'])
        ..addTo(game.scene)
        ..runAction(new Place(new Vector2(800 / 2, 400 / 2)))
        ..physics = new Body(world)
        ..physics.speed = new Vector2(-400.0, -400.0)
        ..physics.restitution = new Vector2(1.0, 1.0);

    world.collide(ball).listen((e) {
      var side = e.side1;
      var body = e.body1 as GameNode;
      if (side == Side.LEFT) {
        body.left = e.body2.left;
        body.physics.speed.x *= -body.physics.restitution.x;
      }
      else if (side == Side.RIGHT) {
        body.right = e.body2.right;
        body.physics.speed.x *= -body.physics.restitution.x;
      }
      else if (side == Side.TOP) {
        body.top = e.body2.top;
        body.physics.speed.y *= -body.physics.restitution.y;
      }
      else if (side == Side.BOTTOM) {
        body.bottom = e.body2.bottom;
        body.physics.speed.y *= -body.physics.restitution.y;
      }
    });
  });

  game.run();
}
