# iss-pistreamer

[![rmasters.iss-pistreamer](https://img.shields.io/ansible/role/26241.svg)](https://galaxy.ansible.com/rmasters/iss-pistreamer/)

I wanted an always-on window from the ISS in my living room, so I made this.
Tooling largely based on [Miguel's blog post][blog], jazzed up a little with
Ansible and a systemd service.

An Ansible role and playbook that:

*   Installs [omxplayer](https://github.com/popcornmix/omxplayer), a nice little
    command-line video player for the RPi,
*   Installs [livestreamer](http://docs.livestreamer.io/), a utility to pipe
    video streams from places like UStream and YouTube Live to a video player
    (in this case, omx),
*   Registers a startup task to play the ISS High-Def earth-viewing feed from
    YouTube.

## Usage

### If you have a Raspberry Pi and just want it working...

This is the current "simple" installation method :smile: - installing Ansible
on the Raspberry Pi, and applying [this playbook][pb] locally. If you're
comfortable with Ansible and remote provisioning, by all means do that instead. 

1.  Follow the [instructions to install Raspbian Desktop][raspbian-desktop],
    a.  After you've copied to your SD card - create an empty file called `ssh`
        at the root-directory level of the card (i.e. next to config.txt). This
        enables SSH automatically on boot.
2.  Boot up your Raspberry Pi with a network connection, note it's IP on your
    network (likely a 192.x.x.x address),
3.  Using [an SSH client][ssh] or by connecting a keyboard and monitor, and
    opening the Terminal app, run the following commands:
    1.  `sudo apt install ansible git`
    2.  `git clone https://github.com/rmasters/iss-pistreamer`
    3.  `cd iss-pistreamer/installer/`
    4.  `make dependencies local`
4.  The attached display should show the current webcam view shortly after the
    playbook finishes. If not, try rebooting, and if still not, report an issue.

### As a role

To install the dependencies required, simply include the role, perhaps using
ansible-galaxy to fetch it:

```
ansible-galaxy install rmasters.iss-pistreamer

# Or in your requirements.yml

- src: rmasters.iss-pistreamer
```

Including the role will only install the software required, to register the
startup tasks, you'll need to include those tasks:

```
- include_role:
    role: rmasters.iss-pistreamer
    tasks_from: startup
```

See [site.yml](./installer/site.yml) for more details.

### Role variables

Configuration options - see [defaults/main.yml](./defaults/main.yml) for the
canonical values.

|       Option key     |      Description      |                 Default value                 |
| -------------------- | --------------------- | --------------------------------------------- |
| `iss_stream_url`     | Stream URL to use     | `{{ iss_ustream_url }}`                       |
| `iss_video_format`   | Stream format to use  | `best` - [see the livestreamer docs][lscli]   |
| `iss_omx_resolution` | Resolution of display | Null, expects array, e.g. `[1920,1080]`       |

Less-often changed options here:

|       Option key     |      Description      |                 Default value                 |
| -------------------- | --------------------- | --------------------------------------------- |
| `iss_ustream_url`    | Default UStream URL   | http://ustream.tv/channel/iss-hdev-payload    |
| `iss_youtube_url`    | Default YouTube URL   | https://www.youtube.com/watch?v=yjkGMeSia1s   |
| `iss_bin_install`    | Default bin location  | /usr/local/bin/iss                            |

## Troubleshooting

### I only see a blank screen

Try SSHing in and running the `iss` command - this should tell you if there's an
error with the stream. There may be a warning if using UStream about an
unparseable feed - this is apparently fine.

Try to look for a slightly non-dark section of your screen (easier to spot with
a 4:3 display). There is always the possiblity that the ISS is simply somewhere
_where it is night_. Check [the ESA's ISS tracker][esa] to be sure.

### The feed keeps stopping and starting

UStream doesn't seem to be particularly stable. The `iss` script restarts
itself automatically if the feed is lost.

### I see a sunrise image with some text

The ISS lost connection to one of the satellites (happens a lot) - the
[HDEV homepage][hdev] has some notes.

[blog]: https://blog.miguelgrinberg.com/post/watch-live-video-of-earth-on-your-raspberry-pi
[raspbian-desktop]: https://www.raspberrypi.org/downloads/raspbian/
[ssh]: https://www.raspberrypi.org/documentation/remote-access/ssh/
[esa]: http://www.esa.int/Our_Activities/Human_Spaceflight/International_Space_Station/Where_is_the_International_Space_Station
[hdev]: https://eol.jsc.nasa.gov/ESRS/HDEV/
[pb]: ./installer/
[lscli]: http://docs.livestreamer.io/cli.html#command-line-usage
