module game;

import counter;
import player;
import cactus;
import ground;
import helpers;
import resourcemanager;

import dsfml.graphics;
import dsfml.window;
import dsfml.system;
import dsfml.audio;

import std.conv;
import std.random;
import std.algorithm;
import std.datetime;
import std.datetime.stopwatch : StopWatch;

static this() {
  assert(resource_manager.register!Texture("assets/gameover.png", "gameover"));
  assert(resource_manager.register!SoundBuffer("assets/sound_button.mp3", "button"));
  assert(resource_manager.register!SoundBuffer("assets/sound_hit.mp3", "hit"));
  assert(resource_manager.register!SoundBuffer("assets/sound_score100.mp3", "score"));
}

/++
 + Dino game,
 +
 + Creates a properly sized window and runs the whole simulation
 +/
class Game {
  private RenderWindow window;
  private Player player;
  private Ground ground;
  private Cactus[] cactuses;
  private float seconds_to_next_cactus = 3;
  private StopWatch cactus_stopwatch;
  private Counter counter;

  private Sound button_sound;
  private Sound hit_sound;
  private Sound score_sound;

  /++ Width/height ratio +/
  static immutable float width_to_height_ratio = 4;

  private void cactus_generation() {
    if(cactus_stopwatch.peek.asSeconds > seconds_to_next_cactus) {
      cactuses ~= random_cactus_at(600, window.getSize.y);
      seconds_to_next_cactus = uniform01!float * 1.5 + .5;
      cactus_stopwatch.reset();
    }
  }

  private void on_key_pressed(Keyboard.Key code) {
    if(code == Keyboard.Key.Space || code == Keyboard.Key.Up) {
      const jumped = player.jump();
      if(jumped && button_sound.status != Sound.Status.Playing) {
        button_sound.play();
      }
    }
    if(code == Keyboard.Key.Down && player.vert_velocity > 0) {
      player.vert_velocity = 0;
    }
  }

  private bool update_simulation() {
    bool close;

    cactus_generation();
    foreach(cactus; cactuses) {
      if(player.collider.intersects(cactus.collider)) {
        close = true;
        player.dead = true;
      }
    }

    player.update();
    foreach(cactus; cactuses) {
      cactus.move(player.displacement);
    }
    ground.move(player.displacement);
    // Remove cactuses that moved outside of the screen
    cactuses = remove!"a.horizontal_offset < -100"(cactuses);

    counter.num = player.displacement_tot.to!uint / 45;
    if(counter.num % 100 == 0 && counter.num != 0 && score_sound.status != Sound.Status.Playing) {
      score_sound.play();
    }

    return close;
  }

  private void draw_objects() {
    window.clear(Color(247, 247, 247));

    window.draw(ground);
    foreach(ref cactus; cactuses) {
      window.draw(cactus);
    }
    window.draw(player);
    window.draw(counter);
    window.display();
  }

  private void session() {
    bool close;
    while(!close) {
      foreach(ev; window.events)
      switch(ev.type) {
        case Event.EventType.Closed:     window.close(); close = true; break;
        case Event.EventType.KeyPressed: on_key_pressed(ev.key.code);  break;
        default: break;
      }

      close = update_simulation();
      draw_objects();
    }
  }

  private void endscreen() {
    const tex = window.screenshot;
    auto screenshot = new Sprite(tex);
    auto gameover_sprite = new Sprite(resource_manager.get!Texture("gameover"));
    gameover_sprite.position((window.middle - resource_manager.get!Texture("gameover").middle).changeType!float);

    bool open = true;
    bool key_released = true, key_pressed;

    import std.traits : EnumMembers;
    foreach(key; EnumMembers!(Keyboard.Key))
    if(Keyboard.isKeyPressed(key)) {
      key_released = false;
    }

    while(open) {
      foreach(ev; window.events) {
        switch(ev.type) {
          case Event.EventType.Closed:      window.close(); open = false; break;
          case Event.EventType.KeyReleased: key_released = true;          break;
          case Event.EventType.KeyPressed:  key_pressed = key_released;   break;
          default: break;
        }
      }
      if(key_pressed && key_released) {
        open = false;
      }

      window.draw(screenshot);
      window.draw(gameover_sprite);
      window.display();
    }
  }

  private void initialize(uint size) {
    player = new Player();
    player.window_height = size;

    cactus_stopwatch.start();

    ground = new Ground();

    button_sound = new Sound;
    button_sound.setBuffer(resource_manager.get!SoundBuffer("button"));

    hit_sound = new Sound;
    hit_sound.setBuffer(resource_manager.get!SoundBuffer("hit"));

    score_sound = new Sound;
    score_sound.setBuffer(resource_manager.get!SoundBuffer("score"));

    cactuses.length = 0;

    counter = new Counter;
  }

  /++ Creates a Dino game instance, size refers to height of the window +/
  this(uint size) {
    window = new RenderWindow(VideoMode(cast(uint) width_to_height_ratio * size, size), "dino");
    window.setVerticalSyncEnabled(true);

    initialize(size);
  }

  /++ Runs the game +/
  void run() {
    while(window.isOpen) {
      session();
      window.display();
      hit_sound.play();

      if(!window.isOpen) {
        break;
      }

      endscreen();
      button_sound.play();

      initialize(window.size.y);
    }
  }
}
