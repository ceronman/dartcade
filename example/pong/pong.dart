import 'package:dartcade/dartcade.dart';

main() {
  var game = new GameLoop('#gamebox', width: 800, height: 400);
  game.debug = new DebugDrawer('debuger');
  game.timeScale = 1.0;

  var loader = new AssetLoader();
  loader.add('paddle', new ImageAsset('paddle.png'));
  loader.add('ball', new ImageAsset('ball.png'));

  var world = new ArcadeWorld(0.0, 0.0, game.width, game.height);

  loader.load().last.then((p) {
    game.scene.onFrame.listen(world.update);

    var score1 = 0;
    var score2 = 0;

    var message = new Label('Press space to start')
      ..addTo(game.scene)
      ..align = 'center'
      ..position = new Vector2(400.0, 40.0);

    var counter1 = new Label(score1.toString())
      ..addTo(game.scene)
      ..align = 'center'
      ..position = new Vector2(20.0, 40.0);

    var counter2 = new Label(score1.toString())
      ..addTo(game.scene)
      ..align = 'center'
      ..position = new Vector2(780.0, 40.0);

    var controller1 = new ArcadeKeyboardController(game.keyboard)
      ..keyUp = Keys.A
      ..keyDown = Keys.Z
      ..speedUp = -400.0
      ..speedDown = 400.0;

    var body1 = new ArcadeBody()
      ..position = new Vector2(40.0, 400 / 2)
      ..restitution = new Vector2(0.0, 0.0)
      ..collider = new AABB2Collider()
      ..addTo(world);

    var paddle1 = new Sprite(loader['paddle'])
      ..addTo(game.scene)
      ..body = body1
      ..runAction(controller1);

    body1.syncToNode();
    body1.syncFromNode();

    var controller2 = new ArcadeKeyboardController(game.keyboard)
      ..keyUp = Keys.UP
      ..keyDown = Keys.DOWN
      ..speedUp = -400.0
      ..speedDown = 400.0;

    var body2 = new ArcadeBody()
      ..position = new Vector2(800.0 - 40, 400 / 2)
      ..restitution = new Vector2(0.0, 0.0)
      ..collider = new AABB2Collider()
      ..addTo(world);

    var paddle2 = new Sprite(loader['paddle'])
      ..addTo(game.scene)
      ..body = body2
      ..runAction(controller2);

    body2.syncToNode();
    body2.syncFromNode();

    var ballbody = new ArcadeBody()
      ..position = new Vector2(400.0, 200.0)
      ..speed = new Vector2(0.0, 0.0)
      ..restitution = new Vector2(1.0, 1.0)
      ..collider = new AABB2Collider()
      ..addTo(world);

    var ball = new Sprite(loader['ball'])
      ..addTo(game.scene)
      ..body = ballbody;

    ballbody.syncToNode();
    ballbody.syncFromNode();

    var bounce = (event) {
      ballbody.position.add(event.delta);
      if (event.delta.x != 0.0 && event.delta.x.sign != ballbody.speed.x.sign) {
        ballbody.speed.x *= -1.0;
      }
      if (event.delta.y != 0.0 && event.delta.y.sign != ballbody.speed.y.sign) {
        ballbody.speed.y *= -1.0;
      }
    };

    var wallsCollision = new StaticBodyOutOfBoundsCollisionCheck()
      ..collider1 = ballbody.collider
      ..collider2 = world.collider
      ..onCollision.listen((event) {
        bounce(event);
        var side = event.delta.x;
        if (side != 0.0) {
          if (side > 0) {
            score2++;
            counter2.text = score2.toString();
          } else {
            score1++;
            counter1.text = score1.toString();
          }
          message.runAction(new FadeIn(1));
          ballbody.position.setValues(400.0, 200.0);
          ballbody.speed.setValues(0.0, 0.0);
        }
      });
    world.collisions.add(wallsCollision);

    var paddleBallCollision = new StaticBodyVsGroupCollisionCheck()
      ..collider1 = ballbody.collider
      ..colliders = [body1.collider, body2.collider]
      ..onCollision.listen(bounce);
    world.collisions.add(paddleBallCollision);

    var paddleWallCollision = new GroupOutOfBoundsCollisionCheck()
      ..collider1 = world.collider
      ..colliders = [body1.collider, body2.collider]
      ..onCollision
          .listen((event) => event.collider1.body.position.add(event.delta));
    world.collisions.add(paddleWallCollision);

    game.keyboard.onKeyDown.where(((e) => e.keyCode == Keys.SPACE)).listen((e) {
      ballbody.speed.setValues(100.0, 200.0);
      message.runAction(new FadeOut(1));
    });
  });

  game.start();
}
