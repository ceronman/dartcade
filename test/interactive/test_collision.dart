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

//TODO: collision hitbox doesn't seem to work properly.
@InteractiveTest('Collide world', group: 'Collision')
testOuterBoxCollision(GameLoop game) {

  // TODO: create a better interface for the asset loader
  var loader = new AssetLoader();
  loader.add('ship', new ImageAsset('images/ship1.png'));
  loader.load().last.then((p) {
    var world = new World(50.0, 50.0, game.width-100, game.height-100);
    var sprite = new Sprite(loader['ship'])
        ..addTo(game.scene)
        ..position.setValues(game.width / 2, game.height / 2)
        ..body = new Body(world)
        ..body.restitution.setValues(1.0, 1.0)
        ..body.speed.setValues(300.0, 50.0);

    // TODO: This should not be needed;
    game.scene.onFrame.listen(world.update);

    world.collide(sprite).listen((e) {
      var sprite = e.body1 as Body; // TODO: better not to have to use this.
      var world = e.body2 as World;

      sprite.node.debugBoxes.add({ 'box': new Aabb2.copy(sprite.hitbox), 'color': 'red' });

      double entryTime;
      if (e.normal2.x > 0.0) {
        entryTime = (world.left - sprite.left) / -sprite.speed.x;
      }
      else if (e.normal2.x < 0.0) {
        entryTime = (world.right - sprite.right) / -sprite.speed.x;
      }
      else if (e.normal2.y > 0.0) {
        entryTime = (world.top - sprite.top) / -sprite.speed.y;
      }
      else if (e.normal2.y < 0.0) {
        entryTime = (world.bottom - sprite.bottom) / -sprite.speed.y;
      }
      sprite.speed.reflect(e.normal2);
      sprite.position.add(sprite.speed.scaled(entryTime));
      sprite.sync();
      sprite.node.debugBoxes.add({ 'box': new Aabb2.copy(sprite.hitbox), 'color': 'green' });
    });
  });
}
