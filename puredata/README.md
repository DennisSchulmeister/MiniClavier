MiniClavier (Pure Data Implementation)
======================================

This is the Pure Data version of the MiniClavier synthesizer.

Compatibility
-------------

The synthesizer is implemented with PD-L2Ork, since this works the
most stable on my system. But it is also tested with PD Vanilla to
make sure it can easily be embedded with libpd into a host app later.
Except for the UI in `main.pd` this seems to work reasonably well.

Root Directory
--------------

The root directory consists of the following files:

 * `main.pd`: Main file with user interface
 * `_main.pd`: The actual synthesizer without the user interface

The first is meant to be used stand-alone with Pure Data. Simply open this
patch and connect a MIDI keyboard that sends on MIDI channel 1 to play the
synthesizer.

The latter implements the actual synthesizer. It is split from the user
interface to be embedded into host applications that provide their own
user interface. Communication between user interface and synthesizer is
happening via well-known send/receive objects, except for the MIDI messages,
which must be passed directly to libpd.

All other `*.pd` files here are internal abstractions of the synthesizer.
The smaller ones use only inlets and outlets to communicate with the outside
world. But the larger components rely on the aforementioned send/receive objects
to know what to do. All in all they form the "private" implementation of the
synthesizer.

Stand-alone Abstractions
------------------------

The sub-directories contain abstractions, that have been developed for this
synthesizer, but can actually be used in any PD project. All reasonable effort
has been done to make them as well-behaved and isolated as possible.

 * `utils`: Small utilities (each file is separate from the others). See
   [README there](./utils/README.md) for a description of each abstraction.

 * `chorus`: A simple stereo chorus/flanger effect

 * `envgen`: Envelope generator with unlimited breakpoints for attack and release

 * `voice_allocator`: What PD's `[poly]` should have been but never was. A proper
   voice allocator that is easy to use, easy to debug (look at the data sub-patch
   to see what's going on), and most importantly handles sustain and sustenuto pedals,
   and re-triggers already playing notes instead of doubling them.

Documentation for each abstraction is contained in the top-left corner of each
`*.pd` file.

More to come
------------

Have fun and feel free to use anything you find useful in your own projects. If you do,
send me a link to your patch and/or music. :-)
