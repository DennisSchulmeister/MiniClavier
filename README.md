MiniClavier Synthesizer
=======================

![MiniClavier (PD), work in progress](puredata/screenshot.png?raw=true "MiniClavier (PD), work in progress")

![Band-limited Waveform Generator](puredata/wavetables/screenshot.png?raw=true "Band-limited Waveform Generator")

This is the MiniClavier software synthesizer, an additive, subtractive,
frequency modulation synthesizer loosely inspired by the original Synclavier
of the 1970s and 1980s. Therefore, this is no recreation of the Synclavier FM
synthesis, but rather its own unique design borrowing some interesting ideas
from the original.

 * Additive synthesis for the carrier waveform
 * Additive synthesis for the modulator waveform
 * Waveform types: Sine, Saw, Square, Triangle, Noise
 * Selectable waveforms for each harmonic
 * Analogue filter for the carrier and modulator
 * Envelope generators for the carrier and modulator
 * Two LFOs to modulate frequency, amplitude and filters
 * Four partials, just like the original Synclavier
 * Volume, expression, stereo panning (using equal power pan law)
 * Sustain pedal, sustenuto pedal, modulation wheel, pitch bend wheel
 * Built-in reverb, chorus/flanger

Differences from the Synclavier are (as far as I can tell, I never played one):

 * The Synclavier has 32 carrier harmonics, that can only be sine waves.
 * The Synclavier uses a single sine wave for the modulator.
 * The Synclavier has no programmable analogue filters.
 * The Synclavier can string together "timbre frames" to resynthesize complex waveforms.
 * The Synclavier has no built-in effects, except for a simple chorus (voice doubler).
 * The Synclavier FM synthesis was mono in the early versions.

Originally, I wanted to extend this much further, e.g. by allowing non-integer
harmonics or filtering single harmonics. But at least in Puredata this soon
proved to be more than Puredata can handle even on a not too old Intel(R)
Core(TM) i7-8550U. The plan **was**:

 * 32 voices of polyphony
 * 4 partials
 * 16 detunable carrier harmonics
 * 8 detunable modulator harmonics
 * all harmonics stereo-panable

That would have been 32 * 4 * (16 + 8) * 2 = 6144 individual oscilators. :-)
Since PD effectively runs on a single core, PD took three minutes just to load
the patch, with the CPU core permanently at 100% even thereafter. What a pitty.
Thus, at the end I settled with:

 * 16 voices of polyphony
 * 4 partials
 * 8 strictly integer carrier harmonics
 * 4 strictly integer modulator harmonics
 * all harmonics stereo-panable

Since the integer harmonics can be folded into a single wavetable, this reduces
the numbers to 16 * 4 * 2 * 2 = 256 individual oscillators. Now that should
be possible even for PD.

This project is mainly a playground for me to learn audio DSP programming and
especially to implement synthesizers that can actually be used in a modern
music production or live set up of a typical keyboard player.

Additionally it is a research project to evaluate the modern Android ecosystem
(as of 2024) for real-time audio usage. Theoretically we can easily shrink the
the custom hardware of the Synclavier into a hand-held device, using a purely
software implementation of all the DSP. Apple devices are very good at this.
But how about the Android ecosystem? In theory the architectural problems have
finally been solved since a few years (much too late, actually). But the Android
ecosystem is very fragmented, so that we cannot really know the current state
unless we try out concrete examples on concrete devices.

Since both Csound and Pure Data offer bindings for Android applications,
this project also compares how both of them can be used in a real-world
project with demanding real-time requirements.

Copyright
---------

© 2024 Dennis Schulmeister-Zimolong (github@windows3.de)

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
