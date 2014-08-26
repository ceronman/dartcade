import 'package:dartcocos/cocos.dart';

main() {
  game.init('#gamebox', width:800, height:400);

  var loader = new AssetLoaderNg();
  loader.add('paddle', new ImageAsset('paddle.png'));

  loader.load().last.then((p) {

    var speedX = 5;
    var speedY = 5;
    var layer = new Layer();
    var paddle = new Sprite(loader['paddle'])
                  ..addTo(layer)
                  ..runAction(new Place(new vec2(40, 100)));
    var scene = new Scene(layer);

    scene.onFrame.listen((dt) {
      if (game.keyboard.pressedKeys[Keys.UP]) {
        paddle.position.y -= speedY;
      }
      if (game.keyboard.pressedKeys[Keys.DOWN]) {
        paddle.position.y += speedY;
      }
    });

    game.run(scene);

  });
}
