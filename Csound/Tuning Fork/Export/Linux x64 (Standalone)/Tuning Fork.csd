/**
 * Tuning Fork - Minimal Csound synth to test with Android
 * =======================================================
 *
 * This is a very basic synth to test usage of the Csound library from within a
 * custom built Android app. Nothing special. Just Bing.
 */
<Cabbage>
        form caption("Tuning Fork") size(380, 145), guiMode("queue"), pluginId("fork"), colour(200, 210, 220)
        button bounds(10, 10, 100, 30), channel("trigger"), latched(0), text("Bing!")
        keyboard bounds(0, 50, 380, 95)
    </Cabbage>
    <CsoundSynthesizer>
    <CsOptions>
        -n -d -+rtmidi=NULL -M0 --midi-key-cps=4 --midi-velocity-amp=5 --asciidisplay
    </CsOptions>
    
    <CsInstruments>
        ksmps  = 32
        nchnls = 2
        0dbfs  = 1
        
        alwayson "Read_Channels"
        
        ;====================================================================
        ; Respons to UI
        ;====================================================================
        instr Read_Channels
            k_Pressed init 0                ; Trigger only once while button is pressed
            k_Trigger chnget "trigger"
            
            if (k_Trigger > 0) then
                if k_Pressed = 0 then
                    event "i", "Tone_Generator", 0, 1, 440, 1
                    k_Pressed = 1
                endif
            else
                k_Pressed = 0
            endif
        endin

        ;====================================================================
        ; The most simple tuning fork you can build
        ;====================================================================
        instr Tone_Generator, 1
            k_Env = madsr(.05, 0.1, 1, 2) * .2
            a_Out = oscili(p5, p4) * k_Env
            outs(a_Out, a_Out)
        endin
    </CsInstruments>
</CsoundSynthesizer>
