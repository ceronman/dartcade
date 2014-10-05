import 'package:dartcocos/cocos.dart';

// TODO: Find where are all those list allocations coming from.

main() {
  var game = new GameLoop('#gamebox', width: 800, height: 400);

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

    // TODO: Separate this into a reusable collider.
    world.collide(ball).listen((e) {
      var ball = e.body1;
      var world = e.body2;
      ball.speed.reflect(e.normal2); // TODO: proper respose by repositioning.
    });
  });

  game.start();
}
