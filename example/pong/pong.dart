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
      ..speed = new Vector2(-300.0, 400.0)
      ..restitution = new Vector2(1.0, 1.0)
      ..addTo(world);

    var ball = new Sprite(loader['ball'])
      ..addTo(game.scene)
      ..runAction(new Place(new Vector2(800 / 2, 400 / 2)))
      ..body = ballbody;

    var wallsCollision = new StaticBodyOutOfBoundsCollisionCheck();
    ballbody.collider = new AABB2Collider();
    ballbody.collider.body = ballbody;
    world.collider = new AABB2Collider();
    world.collider.boundingbox = world.boundingbox;
    wallsCollision.collider1 = ballbody.collider;
    wallsCollision.collider2 = world.collider;
    wallsCollision.onCollision.listen((event) {
      if (event.delta.normalized().x != 0.0 && event.delta.normalized().y != 0.0) {
        print("walls ${event.delta}");
      }
      ballbody.position.add(event.delta);
      ballbody.speed.reflect(event.delta.normalized());
      ballbody.syncToNode();
    });
    world.collisions.add(wallsCollision);

    body1.collider = new AABB2Collider();
    body1.collider.body = body1;
    var paddle1Collision = new StaticBodyVsBodyCollisionCheck()
      ..collider1 = body1.collider
      ..collider2 = ballbody.collider;
    paddle1Collision.onCollision.listen((event) {
      ballbody.position.add(event.delta);
      ballbody.speed.reflect(event.delta.normalized());
      ballbody.syncToNode();
    });
    world.collisions.add(paddle1Collision);

    body2.collider = new AABB2Collider();
    body2.collider.body = body2;
    var paddle2Collision = new StaticBodyVsBodyCollisionCheck()
          ..collider1 = body2.collider
          ..collider2 = ballbody.collider;
    paddle2Collision.onCollision.listen((event) {
      ballbody.position.add(event.delta);
      ballbody.speed.reflect(event.delta.normalized());
      ballbody.syncToNode();
    });
    world.collisions.add(paddle2Collision);
  });

  game.start();
}
