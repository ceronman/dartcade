import 'package:dartcade/dartcade.dart';

main() {
  var game = new GameLoop('#gamebox', width: 800, height: 400);
  var loader = new AssetLoader();
  loader.add('paddle', new ImageAsset('paddle.png'));
  loader.add('ball', new ImageAsset('ball.png'));

  var world = new ArcadeWorld(0.0, 0.0, game.width, game.height);
  game.scene.onFrame.listen(world.update);

  loader.load().last.then((p) {

    var controller1 = new ArcadeKeyboardController(game.keyboard)
        ..keyUp = Keys.A
        ..keyDown = Keys.Z
        ..speedUp = -400.0
        ..speedDown = 400.0;

    var body1 = new ArcadeBody()
        ..restitution = new Vector2(0.0, 0.0)
        ..addTo(world);

    var paddle1 = new Sprite(loader['paddle'])
        ..addTo(game.scene)
        ..runAction(new Place(new Vector2(40.0, 400 / 2)))
        ..body = body1
        ..runAction(controller1);

    var controller2 = new ArcadeKeyboardController(game.keyboard)
        ..keyUp = Keys.UP
        ..keyDown = Keys.DOWN
        ..speedUp = -400.0
        ..speedDown = 400.0;

    var body2 = new ArcadeBody()
        ..restitution = new Vector2(0.0, 0.0)
        ..addTo(world);

    var paddle2 = new Sprite(loader['paddle'])
        ..addTo(game.scene)
        ..runAction(new Place(new Vector2(800.0 - 40, 400 / 2)))
        ..body = body2
        ..runAction(controller2);

    var ballbody = new ArcadeBody()
        ..speed = new Vector2(-40.0, 10.0)
        ..restitution = new Vector2(1.0, 1.0)
        ..addTo(world);

    var ball = new Sprite(loader['ball'])
        ..addTo(game.scene)
        ..runAction(new Place(new Vector2(800 / 2, 400 / 2)))
        ..body = ballbody;
  });

  game.start();
}
