module resourcemanager;

import dsfml.graphics : Texture;
import dsfml.audio    : SoundBuffer;

private class ResourceManager {
  Texture[string] textures;
  SoundBuffer[string] buffers;

  bool register(T)(const string path, const string name) if(is(T == Texture)) {
    auto newtex = new Texture;
    if(newtex.loadFromFile(path)) {
      textures[name] = newtex;
      return true;
    }

    return false;
  }
  bool register(T)(const string path, const string name) if(is(T == SoundBuffer)) {
    auto newbuf = new SoundBuffer;
    if(newbuf.loadFromFile(path)) {
      buffers[name] = newbuf;
      return true;
    }

    return false;
  }

  Texture get(T)(const string name) if(is(T == Texture)) {
    return textures[name];
  }
  SoundBuffer get(T)(const string name) if(is(T == SoundBuffer)) {
    return buffers[name];
  }
}

/// Manages sound buffers and textures
static ResourceManager resource_manager;

static this() {
  resource_manager = new ResourceManager;
}
