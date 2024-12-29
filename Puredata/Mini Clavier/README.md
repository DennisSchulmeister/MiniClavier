MiniClavier (Pure Data Implementation)
======================================

This is the Pure Data version of the MiniClavier synthesizer.

![Screenshot](screenshot.png?raw=true "Screenshot of the unfinished version")

The screenshot shows a work-in-progress version which doesn't include all
planned features, yet.

1. [Compatibility](#compatibility)
1. [Root Directory](#root-directory)
1. [Presets](#presets)
1. [Stand-Alone Abstractions](#stand-alone-abstractions)
1. [Band-Limited Wavetables](#band-limited-wavetables)
1. [More to come](#more-to-come)

Compatibility
-------------

The synthesizer is implemented with PD-L2Ork, since this works the
most stable on my system. But it is also tested with PD Vanilla to
make sure it can easily be embedded with libpd into a host app later.
Except for the UI in `main.pd` this seems to work reasonably well.

Root Directory
--------------

The root directory consists of the following files:

 * `main.pd`:  All-in-one synthesizer with UI and preset management (wraps `main1.pd`)
 * `main1.pd`: The synthesizer with preset managenet but no UI (wraps `main2.pd`)
 * `main2.pd`: Just the synthesizer engine without presets and UI (e.g. for embedding)

The first is meant to be used stand-alone with Pure Data. Simply open this
patch and connect a MIDI keyboard that sends on MIDI channel 1 to play the
synthesizer. If the UI is too heavy on the CPU, you can try `main1.pd` instead
and load one of the available presets.

`main2.pd` implements the actual synthesizer. It is split from the user
interface to be embedded into host applications that provide their own
user interface. Communication between user interface and synthesizer is
happening via well-known send/receive objects, except for the MIDI messages,
which must be passed directly to libpd.

All other `*.pd` files here are internal abstractions of the synthesizer.
The smaller ones use only inlets and outlets to communicate with the outside
world. But the larger components rely on the aforementioned send/receive objects
to know what to do. All in all they form the "private" implementation of the
synthesizer.

Presets
-------

The `presets` directory contains a few preset files that can be loaded into
the synthesizer via the corresponding buttons (bangs).

Stand-Alone Abstractions
------------------------

The sub-directories contain abstractions, that have been developed for this
synthesizer, but can actually be used in any PD project. All reasonable effort
has been done to make them as well-behaved and isolated as possible.

 * `utils`: Small utilities (each file is separate from the others). See
   [README there](./utils/README.md) for a description of each abstraction.

 * `chorus`: A simple stereo chorus/flanger effect

 * `envgen`: Envelope generator with unlimited breakpoints for attack and release

 * `preset`: Simple mechanism to save and load the synthesizer parameters from
   preset files. Can also be used to save parameters in memory when the same
   user interface widgets are used to control different parts of the synthesizer,
   (e.g. the same controls are used to program partials 1, 2, 3, 4 and we need
   a mechanism to switch the currently edited partial).

 * `voice_allocator`: What PD's `[poly]` should have been but never was. A proper
   voice allocator that is easy to use, easy to debug (look at the data sub-patch
   to see what's going on), and most importantly handles sustain and sustenuto pedals,
   and re-triggers already playing notes instead of doubling them.

Documentation for each abstraction is contained in the top-left corner of each
`*.pd` file.

Band-Limited Wavetables
-----------------------

The directory `wavetables` contains wave files with the internal wavetables
used by the synthesizer. They are calculated using the PD program in the
same directory.

![Wavetable Generator Screenshot](wavetables/screenshot.png?raw=true "Screenshot of the wavetable generator")

There are many ways to avoid aliasing in digital synthesizers, with a popular
algorithm being the relatively light-weight PolyPLEP. Unfortunately PD doesn't
include band-limited oscillators and evaluating expressions at audio rate seems
to costly for this synthesizer, that is already stretching the limits of what
performance PD can deliver (running on a single core etc.).

Therefore, we use the same trick as was used on the Korg DW-8000 in the mid-80s.
We pre-calculate band-limited waveforms with Fourier synthesis, calculating
one wavetable per octave, limiting the top harmonic to the Nyquist frequency.
This should eliminate aliasing completely with a trade-off in memory and sonic
quality. The sonic quality trade-off is that the wavetables are only calculated
per octave and not per semi-tone, therefore not utilising the full harmonic
spectrum that would be possible for each note. In practice the difference should
be almost unnoticeable, though.

More to come
------------

Have fun and feel free to use anything you find useful in your own projects. If you do,
send me a link to your patch and/or music. :-)
