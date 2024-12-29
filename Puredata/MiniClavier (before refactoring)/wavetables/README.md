Band-limited Wavetable Calculator
=================================

![Screenshot](screenshot.png?raw=true "Screenshot of the wavetable generator")

This directory contains a small Puredata program to calculate band-limited
wavetables for different wavetables and octaves. The following waveforms
are currently supported:

 * Sawtooth
 * Square
 * Triangle

The resulting wave files are meant to be used with PD's [tabosc4~] object.
This uses a four-point polynomial interpolation. This requires the wavetables
to be a power of two in size plus three guard samples - one at the beginning
and two at the end. These minute details are of course automatically handled
by PD but must be taken into account when using the waveforms in other
environments.

The wavetables are generated with a simple fourier synthesis, where a harmonic
series is formed between the highest note of the target octave and the Nyquist
frequency (PD's sample rate divided by two).

The subdirectories contain pre-computed wavetables generated with the program.
The wavetables span one octave each, starting from MIDI note 0, minus the last
note that would start the next octave:

 * wavetable1: MIDI Note 0 - 11
 * wavetable2: MIDI Note 12 - 23
 * wavetable3: MIDI Note 24 - 35
 * and so on

If less wavetables shall be used, the number of octaves per wavetable can
be changed in the program. e.g. by setting this value to 2, only six wavetables
will be calculated with each wavetable spanning two octaves.

Using the input field and the bang buttons on the right, the wavetables can
be saved to WAVE files.
