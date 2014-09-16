import 'package:dartcocos/cocos.dart';

main() {
  game.init('#gamebox', width: 800, height: 400);

  var loader = new AssetLoaderNg();
  loader.add('paddle', new ImageAsset('paddle.png'));
  loader.add('ball', new ImageAsset('ball.png'));

  var world = new World(0.0, 0.0, game.width, game.height);

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
        ..physics = new PhysicsComponent(world)
        ..runAction(controller1);

    var paddle2 = new Sprite(loader['paddle'])
        ..addTo(game.scene)
        ..runAction(new Place(new Vector2(800.0 - 40, 400 / 2)))
        ..physics = new PhysicsComponent(world)
        ..runAction(controller2);

    var ball = new Sprite(loader['ball'])
        ..addTo(game.scene)
        ..runAction(new Place(new Vector2(800 / 2, 400 / 2)))
        ..physics = new PhysicsComponent(world)
        ..physics.speed = new Vector2(400.0, 400.0)
        ..physics.bounce = new Vector2(1.0, 1.0);

    game.run();

  });
}
