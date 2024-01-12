Envelope Generator
==================

This directory contains the \[envgen~\] abstraction, which is a linear envelope
generator with unlimited breakpoints. See `envgen~.pd` for details. Additionaly,
the \[envgen-gui\] abstraction provides a graphical user interface to program
the envelope generator.

Important Notes
---------------

1. The envelope generator itself is compatible with PD Vanilla, however the
   GUI isn't. PD-L2ORK and Purr Data fixed too many inconsistencies of the
   Tkl/Tk canvas drawing to remain compatible. What the UI is doing, simply
   is not possible with PD Vanilla.

2. The \[envgen-gui\] relys on \[envgen-gui-structs\] to be present in the
   same patch (the patch using the gui). It contains the PD structure definitions
   for the GUI's internal data structures. They have been splitted into their
   own abstraction so that they can be shared by all GUI instances.

3. When \[envgen-gui-structs\] is not present or not opened, PD may crash while
   trying to open \[envgen-gui\]. If you forgot to add the object to your patch,
   or you just want to edit `envgen-gui.pd`, open `envgen-gui-structs.pd` first,
   so that PD has the structure definitions (templates) in memory.
