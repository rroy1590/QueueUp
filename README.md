#QueueUp

a tinder ui + soundcloud experiment

uses [SoundCloudAPI](https://raw.github.com/soundcloud/CocoaSoundCloudAPI/)

## Overview
I wanted to create a way to queue up music that I normally listen to on soundcloud without necessarily having to make a playlist.

Basically this app has a UI that allows users to queue a number of available streamable songs to play. 

## Setup

This project is configured to run on ios7/64 bit. It should run out of the box. 

### In terminal

1. Go to a working directory.

2. Clone:
```
git clone git@github.com:rroy1590/QueueUp.git
cd QueueUp
git submodule init
git submodule update
open .
```

### In XCode

1. Make sure all projects are set to not only build active architecture, and that arm64 is enabled as a valid architecture for all project targets on iOS. (should not be necessary by default, this is incase you run into issues)

![Screenshot](http://i.imgur.com/VLsaqm1.png)