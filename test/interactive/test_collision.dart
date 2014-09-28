// Copyright 2014 Manuel Cerón <ceronman@gmail.com>
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

part of dartcocos_test;

@InteractiveTest('Collide world', group: 'Collision')
testOuterBoxCollision(Game game) {
  var loader = new AssetLoader();
  loader.add('ship', new ImageAsset('images/ship1.png'));
  loader.load().last.then((p) {
    var world = new World(0.0, 0.0, game.width, game.height);
    var sprite = new Sprite(loader['ship'])
      ..addTo(game.scene)
      ..position.setValues(game.width/2, game.height/2)
      ..body = new Body(world)
      ..body.restitution.setValues(1.0, 1.0)
      ..body.speed.setValues(200.0, 200.0);

    // TODO: This should not be needed;
    game.scene.onFrame.listen(world.update);

    world.collide(sprite).listen((e) {
       var sprite = e.body1;
       var world = e.body2;
       if (e.side1 == Side.LEFT) {
         sprite.left = world.hitbox.min.x;
         sprite.speed.x *= -sprite.restitution.x;
       }
       else if (e.side1 == Side.RIGHT) {
         sprite.right = world.hitbox.max.x;
         sprite.speed.x *= -sprite.restitution.x;
       }
       else if (e.side1 == Side.TOP) {
         sprite.top = world.hitbox.min.y;
         sprite.speed.y *= -sprite.restitution.y;
       }
       else if (e.side1 == Side.BOTTOM) {
         sprite.bottom = world.hitbox.max.y;
         sprite.speed.y *= -sprite.restitution.y;
       }
     });
  });
}
