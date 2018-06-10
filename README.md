# iss-pistreamer

Stream largely based on [this blog post][blog].

A little Ansible role and playbook that:

*   Installs [omxplayer](https://github.com/popcornmix/omxplayer), a nice little
    command-line video player for the RPi,
*   Installs [livestreamer](http://docs.livestreamer.io/), a utility to pipe
    video streams from places like UStream and YouTube Live to a video player
    (in this case, omx),
*   Registers a startup task to play the ISS High-Def earth-viewing feed from
    YouTube.

## Usage

### If you have a Raspberry Pi and just want it working...

This is the current "simple" installation method :smile:. You'll need a little
bit of technical know-how; in the future I might host an image you can just
copy to an SD card.

If you're comfortable with Ansible and remote provisioning, by all means do
that :smile:.

1.  Follow the [instructions to install Raspbian Desktop][raspbian-desktop],
2.  Boot up your Raspberry Pi with a network connection, note it's IP on your
    network (likely a 192.x.x.x address),
3.  Using [an SSH client][ssh] or by connecting a keyboard and monitor, and
    opening the Terminal app, run the following commands:
    a.  `sudo apt install ansible git`
    b.  `git clone https://github.com/rmasters/iss-pistreamer`
    c.  `cd iss-pistreamer`
    d.  `ansible-playbook -i local, --connection=localhost site.yml`

## As a role

To install the dependencies required, simply include the role, perhaps using
ansible-galaxy to fetch it:

```
ansible-galaxy install git+https://github.com/rmasters/iss-pistreamer.git

# Or in your requirements.yml

- src: https://github.com/rmasters/iss-pistreamer.git
  scm: git
```

Including the role will only install the software required, to register the
startup tasks, you'll need to include those tasks:

```
- include_role:
    role: iss-pistreamer
    tasks_from: startup
```

See [site.yml](./site.yml) for more details.

## Options

|       Option key     |      Description      |                 Default value                 |
| -------------------- | --------------------- | --------------------------------------------- |
| `iss_stream_url`     | Stream URL to use     | `{{ iss_ustream_url }}`                       |
| `iss_omx_resolution` | Resolution of display | Null, expects array, e.g. `[1920,1080]`       |
| -------------------- | --------------------- | --------------------------------------------- |
| `iss_ustream_url`    | Default UStream URL   | http://ustream.tv/channel/iss-hdev-payload    |
| `iss_youtube_url`    | Default YouTube URL   | https://www.youtube.com/watch?v=yjkGMeSia1s   |
| `iss_bin_install`    | Default bin location  | /usr/local/bin/iss                            |

[blog]: https://blog.miguelgrinberg.com/post/watch-live-video-of-earth-on-your-raspberry-pi
[raspb-desktop]: https://www.raspberrypi.org/downloads/raspbian/
[ssh]: https://www.raspberrypi.org/documentation/remote-access/ssh/
