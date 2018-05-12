module dino.game;

import dino.player;
import dino.barrier;

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
  private Barrier[] barriers;
  private float seconds_to_next_barrier = 0;
  private StopWatch barrier_stopwatch;

  static immutable float width_to_height_ratio = 4;

  private void barrier_generation() {
    if(barrier_stopwatch.peek.asSeconds * player.speed / 300 > seconds_to_next_barrier) {
      barriers ~= new Barrier(random_width(), random_height(), 600);
      seconds_to_next_barrier = uniform01!float * 2 + 1;
      barrier_stopwatch.reset();
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

    barrier_stopwatch.start();
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

      barrier_generation();
      foreach(ref barrier; barriers) {
        barrier.move(player.displacement);
        window.draw(barrier);
      }

      window.display();
    }
  }
}
