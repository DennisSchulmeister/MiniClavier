MiniClavier Synthesizer
=======================

This is the MiniClavier software synthesizer, an additive, subtractive,
frequency modulation synthesizer loosely inspired by the original SynClavier
of the 1970s and 1980s. Therefor this is no recreation of the SynClavier FM
synthesis, but rather its own unique design borrowing some interesting ideas
from the original.

 * Additive synthesis for the carrier waveform
 * Additive synthesis for the modulator waveform
 * Waveform types: Sine, Saw, Square, Noise
 * Selectable waveforms for each harmonic
 * Analog filter for the harmonics, carrier, modulator and final output
 * Envelope generators for the harmonics, carrier, modulater final output
 * Two LFOs to modulate frequency, amplitude and filters
 * Four partials, just like the original SynClavier
 * Volume, expression, stereo panning (using equal power pan law)
 * Sustain pedal, sustenuto pedal, modulation wheel, pitch bend wheel
 * Built-in reverb, chorus/flanger

Differences from the SynClavier are (as far as I can tell, I never played one):

 * The SynClavier has 32 carrier harmonics, that can only be sine waves.
 * The SynClavier uses a single sine wave for the modulator.
 * The SynClavier has no programmable analog filters.
 * The SynClavier can string together "timbre frames" to resynthesize complex waveforms.
 * The SynClavier has no built-in effects, except for a simple chorus (voice doubler).
 * The SynClavier FM synthesis was mono in the early versions.

This project is mainly a playground for me to learn audio DSP programming and
especially to implement synthesizers that can actually be used in a modern
music production or live setup of a typical keyboard player.

Additionaly it is a research project to evaluate the modern Android ecosystem
(as of 2024) for real-time audio usage. Theoreticaly we can easily shrink the
the custom hardware of the SynClavier into a hand-held device, using a purely
software implementation of all the DSP. Apple devices are very good at this.
But how about the Android ecosystem? In theory the architectural problems have
finaly been solved since a few years (much too late, actually). But the Android
ecosystem is very fragmented, so that we cannot really know the current state
unless we try out concrete examples on concrete devices.

Since both Csound and Pure Data offer bindings for Android applications,
this project also compares how both of them can be used in a real-world
project with demanding real-time requirements.

Copyright
---------

© 2024 Dennis Schulmeister Zimolong (github@windows3.de)

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
