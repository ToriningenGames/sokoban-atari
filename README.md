# Sokoban

This is a sokoban game, playable on the Atari 2600.

## Building

### Prereqs
- WLA-6502
- WLALINK
- make
- C90+ compiler

Have all tools on your path and run make in the root directory. A raw `.rom` file will be present in `./bin` <br/>
Building is tested using a bash shell on linux, but should be portable to other systems.

## How to Play

Sokoban is a puzzle game, with a worker on a grid. The worker is to push certain boxes (brown) onto target spaces (gold). The worker can only push boxes, not pull them. The worker cannot push other boxes (light blue), climb on boxes, or push multiple boxes at once.

## Controls

This game is played with the **joystick** attachment in slot 1. The joystick directions control the worker.<br/>The reset switch resets the current level.

## Program details

Two tools are provided: pack and unpack. pack takes a standard sokoban level description with a play area no greater than 8x8 from standard input, and outputs a 17 byte compact level to standard output. unpack does the reverse: it reads a packed level from standard input and outputs a sokoban level description to standard output. <br/>
These tools are used to take the levels in `levels` and fit them on the 4096-byte cart that is an Atari game.

## Credits

Levels generated using eightonthebottom's Python Level Generator, available at https://bitbucket.org/eightonthebottom/puzzle-generation/src/master/
