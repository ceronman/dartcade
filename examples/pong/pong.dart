import 'package:dartcocos/cocos.dart';

main() {
  game.init('#gamebox', width:800, height:400);

  game.assets.load([
    'paddle.png'
  ]);

  game.run();
}
