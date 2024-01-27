Pure Data Utilities
===================

This directory contains various small abstractions, that have been developed
for the MiniClavier synthesizer, but a generic enough to be used in other
projects, too. Each `*.pd` file is independent of the others and simply be
copied into new projects.

 * `declick`: Avoids clicking by sudden jumps in control values. The control
   value will instead be ramped to its new value within 15 ms.

 * `foreach-split-list`: Takes an arbitrary lists and splits it into multiple
   lists of a fixed size. The split lists will be output in a loop one
   after another. This is e.g. used for the envelope generator to iterate
   over the breakpoints, which are defined as:

    - value
    - duration
    - value
    - duration
    - value
    - duration
    - ...

   `[foreach-split-list 2]` would in this case output three lists with value
    and duration, one after another. See the envelope generator for a working
    example.

 * `for-loop`: Small helper for an often needed things: Generating a sequence
   of ascending numbers. The arguments are the start and end numbers, which
   will be sent to the outlet one after another, once a bang is received.

 * `pan-mono` and `balance-stereo`: Stereo-paning of a mono/stereo signal as
   implemented in most commercial mixers. The algorithm is the same, but since
   for a stereo input, only the channel volumes will be adjusted, the stereo
   version is called "balance". Equal-power law is applied, using a square-root
   instead of the typical sine curve, as I think this a bit more musical.

 * `rms-peak`: Companion for PD's `[vu]` object. Takes an audio signal and
   calculates the current RMS and peak RMS for the VU meter. The peak RMS will
   remain constant for three seconds before slowly ramping down to -100db for
   five seconds, unless a higher value is measured.
