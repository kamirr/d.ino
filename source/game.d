module dino.game;

import dino.player;
import dino.cactus;

import dsfml.graphics;
import dsfml.window;
import dsfml.system;

import std.random;
import std.datetime;
import std.datetime.stopwatch : StopWatch;

private Event[] events(RenderWindow window) {
  Event[] res;
  for(Event ev; window.pollEvent(ev);) {
    res ~= ev;
  }

  return res;
}

class Game {
  private RenderWindow window;
  private Player player;
  private Cactus[] cactuss;
  private float seconds_to_next_cactus = 0;
  private StopWatch cactus_stopwatch;

  static immutable float width_to_height_ratio = 4;

  private void cactus_generation() {
    if(cactus_stopwatch.peek.asSeconds * player.speed / 300 > seconds_to_next_cactus) {
      cactuss ~= new Cactus(random_width(), random_height(), 600);
      seconds_to_next_cactus = uniform01!float * 2 + 1;
      cactus_stopwatch.reset();
    }
  }

  private void on_key_pressed(Keyboard.Key code) {
    if(code == Keyboard.Key.Space || code == Keyboard.Key.Up) {
      player.jump();
    }
    if(code == Keyboard.Key.Down && player.vert_velocity > 0) {
      player.vert_velocity = 0;
    }
  }

  this(uint size) {
    window = new RenderWindow(VideoMode(cast(uint) width_to_height_ratio * size, size), "dino");
    player = new Player();
    player.window_height = size;

    cactus_stopwatch.start();
  }

  void run() {
    while(window.isOpen) {
      window.clear(Color(20, 20, 20));

      foreach(ev; window.events)
      switch(ev.type) {
        case Event.EventType.Closed:     window.close();              break;
        case Event.EventType.KeyPressed: on_key_pressed(ev.key.code); break;
        default: break;
      }

      player.update();
      window.draw(player);

      cactus_generation();
      foreach(ref cactus; cactuss) {
        cactus.move(player.displacement);
        window.draw(cactus);
      }

      window.display();
    }
  }
}
