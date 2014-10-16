import 'package:dartcade/dartcade.dart';

main() {
  var game = new GameLoop('#gamebox', width: 800, height: 400);
  game.debug = new DebugDrawer();

  game.updateFrequency = 1;

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
        ..body.restitution = new Vector2(0.0, 0.0)
        ..runAction(controller1);

    var paddle2 = new Sprite(loader['paddle'])
        ..addTo(game.scene)
        ..runAction(new Place(new Vector2(800.0 - 40, 400 / 2)))
        ..body = new Body(world)
        ..body.restitution = new Vector2(0.0, 0.0)
        ..runAction(controller2);

    var ball = new Sprite(loader['ball'])
        ..addTo(game.scene)
        ..runAction(new Place(new Vector2(800 / 2, 400 / 2)))
        ..body = new Body(world)
        ..body.speed = new Vector2(-40.0, 0.0)
        ..body.restitution = new Vector2(1.0, 1.0);

    world.collide(ball).listen(CollisionResponse.bounce);
    // TODO: Implement collision groups here.
    world.collide(paddle1).listen(CollisionResponse.bounce);
    world.collide(paddle2).listen(CollisionResponse.bounce);

    world.collide(ball, paddle1).listen((e) => print("Collision"));
  });

  game.start();
}
