/**
 * Facelift FM4 - 4 Operator FM Synthesizer
 * ========================================
 *
 * Dec 28-31 2024: Dennis Schulmeister-Zimolong
 * This is the synthesizer with which Android will be tested.
 *
 * Csound Caveats
 * --------------
 *
 * https://github.com/csound/csound/issues/1557 - Some opcodes do not run at k-rate with functional syntax
 * chnget() doesn't run at k-rate, but chnget does. So does chnget:k().
 * And I wondered why playing notes would not pick up new values from the UI. :-)
 *
 * Csound handles the sustain pedal but not the sustenuto pedal. If this is wanted, one needs to manually
 * trigger the tone generator instrument from MIDI messages.
 *
 * Some MIDI opcodes like aftouch only handle the "current channel", whatever that is. In that case it
 * is better to manually interpret the MIDI messages.
 *
 * When lag() is used to interpolate values (to avoid clicks), an On/Off value might never reach zero,
 * after it is switched off. So check for "value < 0.01", instead, to detect when it is turned off.
 *
 * Many opcodes don't perform range checking. So always make sure to never exceed their expected number
 * ranges. Otherwise Csound might crash and not generate any audio unless restarted. The Xadrs opcodes
 * are especially picky and sometimes crash even with valid (very small) numbers. 
 */
<Cabbage>
    ; HERE BE DRAGONS: Don't edit with the graphical GUI editor in Cabbage! It will garble the code (at least in version 2.8.162)
    ;
    ; DX7-Style colors:
    ;   Dark Brown: 70,   46, 26
    ;   Brown-ish:  100,  82, 76
    ;   Green-ish:  0,   150, 115
    ;   Blue-ish:   117, 130, 168
    ;   White-ish:  205, 201, 192
    ;   Red-ish:    228, 108, 109
    form caption("Schoko FM4") size(980, 725), guiMode("queue"), pluginId("SFM4"), colour(70, 46, 26)
    
    #define GROUPBOX   colour(10, 10, 10), fontColour("205, 201, 192"), alpha(0.9)
    #define WIDGET     textColour(140,  122, 116), trackerColour(0, 150, 115)
    #define CHECKBOX   colour:0(27, 50, 78), colour:1(117, 130, 168)
    #define NSLIDER    colour(0,0,0,0)
    #define RSLIDER    valueTextBox(1)

    ; Operator 1
    groupbox $GROUPBOX, bounds(10, 10, 690, 145), text("Operator 1") {
        nslider  $WIDGET, $NSLIDER,  bounds(  5,  30,  75, 35), channel("OP1_Frequency_Level"), text("Frequency"),     range(0, 100, 1, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds( 60,  35,  75, 25), channel("OP1_Frequency_LFO"),   text("LFO"),           range(0, 100, 0, 1, 0.01)
        checkbox $WIDGET, $CHECKBOX, bounds( 10,  85, 120, 20), channel("OP1_FM_Enable"),       text("Modulate OP2")
        checkbox $WIDGET, $CHECKBOX, bounds( 10, 115, 120, 20), channel("OP1_Output_Enable"),   text("Direct Output")
        
        rslider  $WIDGET, $RSLIDER,  bounds(145,  30,  75, 75), channel("OP1_Feedback_Level"),  text("Feedback"),      range(0, 1, 0.0, 1, 0.01)
        rslider  $WIDGET, $RSLIDER,  bounds(220,  30,  75, 75), channel("OP1_FM_Level"),        text("Modulate OP2"),  range(0, 1, 0.5, 1, 0.01)
        rslider  $WIDGET, $RSLIDER,  bounds(295,  30,  75, 75), channel("OP1_Output_Level"),    text("Direct Output"), range(0, 1, 0.5, 1, 0.01)
        
        nslider  $WIDGET, $NSLIDER,  bounds(145, 110,  75, 25), channel("OP1_Feedback_LFO"),    text("LFO"),           range(0, 1, 0, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(220, 110,  75, 25), channel("OP1_FM_LFO"),          text("LFO"),           range(0, 1, 0, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(295, 110,  75, 25), channel("OP1_Output_LFO"),      text("LFO"),           range(0, 1, 0, 1, 0.01)
        
        nslider  $WIDGET, $NSLIDER,  bounds(380,  40,  75, 30), channel("OP1_Initial_Level"),   text("Initial"),       range(0, 1, 0.0, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(440,  40,  75, 30), channel("OP1_Attack_Level"),    text("Attack"),        range(0, 1, 1.0, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(500,  40,  75, 30), channel("OP1_Decay_Level"),     text("Decay"),         range(0, 1, 1.0, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(560,  40,  75, 30), channel("OP1_Sustain_Level"),   text("Sustain"),       range(0, 1, 1.0, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(620,  40,  75, 30), channel("OP1_Release_Level"),   text("Release"),       range(0, 1, 0.0, 1, 0.01), active(0)
        
        nslider  $WIDGET, $NSLIDER,  bounds(440,  80,  75, 30), channel("OP1_Attack_Time"),     text("Seconds"),       range(0, 100, 0.1, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(500,  80,  75, 30), channel("OP1_Decay_Time"),      text("Seconds"),       range(0, 100, 0.0, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(560,  80,  75, 30), channel("OP1_Sustain_Time"),    text("Seconds"),       range(0, 100, 0.0, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(620,  80,  75, 30), channel("OP1_Release_Time"),    text("Seconds"),       range(0, 100, 0.2, 1, 0.01)
    }
    
    ; Operator 2
    groupbox $GROUPBOX, bounds(10, 165, 690, 145), text("Operator 2") {
        nslider  $WIDGET, $NSLIDER,  bounds(  5,  30,  75, 35), channel("OP2_Frequency_Level"), text("Frequency"),     range(0, 100, 1, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds( 60,  35,  75, 25), channel("OP2_Frequency_LFO"),   text("LFO"),           range(0, 100, 0, 1, 0.01)
        checkbox $WIDGET, $CHECKBOX, bounds( 10,  85, 120, 20), channel("OP2_FM_Enable"),       text("Modulate OP3")
        checkbox $WIDGET, $CHECKBOX, bounds( 10, 115, 120, 20), channel("OP2_Output_Enable"),   text("Direct Output")
        
        rslider  $WIDGET, $RSLIDER,  bounds(145,  30,  75, 75), channel("OP2_Feedback_Level"),  text("Feedback"),      range(0, 1, 0.0, 1, 0.01)
        rslider  $WIDGET, $RSLIDER,  bounds(220,  30,  75, 75), channel("OP2_FM_Level"),        text("Modulate OP3"),  range(0, 1, 0.5, 1, 0.01)
        rslider  $WIDGET, $RSLIDER,  bounds(295,  30,  75, 75), channel("OP2_Output_Level"),    text("Direct Output"), range(0, 1, 0.5, 1, 0.01)
        
        nslider  $WIDGET, $NSLIDER,  bounds(145, 110,  75, 25), channel("OP2_Feedback_LFO"),    text("LFO"),           range(0, 1, 0, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(220, 110,  75, 25), channel("OP2_FM_LFO"),          text("LFO"),           range(0, 1, 0, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(295, 110,  75, 25), channel("OP2_Output_LFO"),      text("LFO"),           range(0, 1, 0, 1, 0.01)

        nslider  $WIDGET, $NSLIDER,  bounds(380,  40,  75, 30), channel("OP2_Initial_Level"),   text("Initial"),       range(0, 1, 0.0, 1, 0.01)        
        nslider  $WIDGET, $NSLIDER,  bounds(440,  40,  75, 30), channel("OP2_Attack_Level"),    text("Attack"),        range(0, 1, 1.0, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(500,  40,  75, 30), channel("OP2_Decay_Level"),     text("Decay"),         range(0, 1, 1.0, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(560,  40,  75, 30), channel("OP2_Sustain_Level"),   text("Sustain"),       range(0, 1, 1.0, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(620,  40,  75, 30), channel("OP2_Release_Level"),   text("Release"),       range(0, 1, 0.0, 1, 0.01), active(0)
        
        nslider  $WIDGET, $NSLIDER,  bounds(440,  80,  75, 30), channel("OP2_Attack_Time"),     text("Seconds"),       range(0, 100, 0.1, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(500,  80,  75, 30), channel("OP2_Decay_Time"),      text("Seconds"),       range(0, 100, 0.0, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(560,  80,  75, 30), channel("OP2_Sustain_Time"),    text("Seconds"),       range(0, 100, 0.0, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(620,  80,  75, 30), channel("OP2_Release_Time"),    text("Seconds"),       range(0, 100, 0.2, 1, 0.01)
    }
    
    ; Operator 3
    groupbox $GROUPBOX, bounds(10, 320, 690, 145), text("Operator 3") {
        nslider  $WIDGET, $NSLIDER,  bounds(  5,  30,  75, 35), channel("OP3_Frequency_Level"), text("Frequency"),     range(0, 100, 1, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds( 60,  35,  75, 25), channel("OP3_Frequency_LFO"),   text("LFO"),           range(0, 100, 0, 1, 0.01)
        checkbox $WIDGET, $CHECKBOX, bounds( 10,  85, 120, 20), channel("OP3_FM_Enable"),       text("Modulate OP4"),  value(1)
        checkbox $WIDGET, $CHECKBOX, bounds( 10, 115, 120, 20), channel("OP3_Output_Enable"),   text("Direct Output")
        
        rslider  $WIDGET, $RSLIDER,  bounds(145,  30,  75, 75), channel("OP3_Feedback_Level"),  text("Feedback"),      range(0, 1, 0.0, 1, 0.01)
        rslider  $WIDGET, $RSLIDER,  bounds(220,  30,  75, 75), channel("OP3_FM_Level"),        text("Modulate OP4"),  range(0, 1, 0.5, 1, 0.01)
        rslider  $WIDGET, $RSLIDER,  bounds(295,  30,  75, 75), channel("OP3_Output_Level"),    text("Direct Output"), range(0, 1, 0.5, 1, 0.01)
        
        nslider  $WIDGET, $NSLIDER,  bounds(145, 110,  75, 25), channel("OP3_Feedback_LFO"),    text("LFO"),           range(0, 1, 0, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(220, 110,  75, 25), channel("OP3_FM_LFO"),          text("LFO"),           range(0, 1, 0, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(295, 110,  75, 25), channel("OP3_Output_LFO"),      text("LFO"),           range(0, 1, 0, 1, 0.01)
        
        nslider  $WIDGET, $NSLIDER,  bounds(380,  40,  75, 30), channel("OP3_Initial_Level"),   text("Initial"),       range(0, 1, 0.0, 1, 0.01)        
        nslider  $WIDGET, $NSLIDER,  bounds(440,  40,  75, 30), channel("OP3_Attack_Level"),    text("Attack"),        range(0, 1, 1.0, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(500,  40,  75, 30), channel("OP3_Decay_Level"),     text("Decay"),         range(0, 1, 1.0, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(560,  40,  75, 30), channel("OP3_Sustain_Level"),   text("Sustain"),       range(0, 1, 1.0, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(620,  40,  75, 30), channel("OP3_Release_Level"),   text("Release"),       range(0, 1, 0.0, 1, 0.01), active(0)
        
        nslider  $WIDGET, $NSLIDER,  bounds(440,  80,  75, 30), channel("OP3_Attack_Time"),     text("Seconds"),       range(0, 100, 0.1, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(500,  80,  75, 30), channel("OP3_Decay_Time"),      text("Seconds"),       range(0, 100, 0.0, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(560,  80,  75, 30), channel("OP3_Sustain_Time"),    text("Seconds"),       range(0, 100, 0.0, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(620,  80,  75, 30), channel("OP3_Release_Time"),    text("Seconds"),       range(0, 100, 0.2, 1, 0.01)
    }
    
    ; Operator 4
    groupbox $GROUPBOX, bounds(10, 475, 690, 145), text("Operator 4") {
        nslider  $WIDGET, $NSLIDER,  bounds(  5,  30,  75, 35), channel("OP4_Frequency_Level"), text("Frequency"),     range(0, 100, 1, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds( 60,  35,  75, 25), channel("OP4_Frequency_LFO"),   text("LFO"),           range(0, 100, 0, 1, 0.01)
        checkbox $WIDGET, $CHECKBOX, bounds( 10, 115, 120, 20), channel("OP4_Output_Enable"),   text("Direct Output"), value(1)
        
        rslider  $WIDGET, $RSLIDER,  bounds(145,  30,  75, 75), channel("OP4_Feedback_Level"),  text("Feedback"),      range(0, 1, 0, 1, 0.01)
        rslider  $WIDGET, $RSLIDER,  bounds(295,  30,  75, 75), channel("OP4_Output_Level"),    text("Direct Output"), range(0, 1, 1, 1, 0.01)
        
        nslider  $WIDGET, $NSLIDER,  bounds(145, 110,  75, 25), channel("OP4_Feedback_LFO"),    text("LFO"),           range(0, 1, 0, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(295, 110,  75, 25), channel("OP4_Output_LFO"),      text("LFO"),           range(0, 1, 0, 1, 0.01)
        
        nslider  $WIDGET, $NSLIDER,  bounds(380,  40,  75, 30), channel("OP4_Initial_Level"),   text("Initial"),       range(0, 1, 0.0, 1, 0.01)        
        nslider  $WIDGET, $NSLIDER,  bounds(440,  40,  75, 30), channel("OP4_Attack_Level"),    text("Attack"),        range(0, 1, 1.0, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(500,  40,  75, 30), channel("OP4_Decay_Level"),     text("Decay"),         range(0, 1, 0.8, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(560,  40,  75, 30), channel("OP4_Sustain_Level"),   text("Sustain"),       range(0, 1, 0.5, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(620,  40,  75, 30), channel("OP4_Release_Level"),   text("Release"),       range(0, 1, 0.0, 1, 0.01), active(0)
        
        nslider  $WIDGET, $NSLIDER,  bounds(440,  80,  75, 30), channel("OP4_Attack_Time"),     text("Seconds"),       range(0, 100, 0.1, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(500,  80,  75, 30), channel("OP4_Decay_Time"),      text("Seconds"),       range(0, 100, 0.5, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(560,  80,  75, 30), channel("OP4_Sustain_Time"),    text("Seconds"),       range(0, 100, 0.3, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(620,  80,  75, 30), channel("OP4_Release_Time"),    text("Seconds"),       range(0, 100, 0.2, 1, 0.01)
    }
    

    ; LFO & Pitch Bend
    groupbox $GROUPBOX, bounds(710, 10, 225, 145), text("LFO & Pitch Bend") {
        nslider  $WIDGET, $NSLIDER,  bounds(10,  30,  75, 35), channel("LFO_Frequency"),    text("Frequency"),           range(0, 50, 2.5, 1, .01), valuePostfix(" Hz")
        nslider  $WIDGET, $NSLIDER,  bounds(110, 30, 100, 35), channel("Pitch_Bend_Range"), text("Pitch Bend Range"),    range(0, 48, 2,   1, 1)
        checkbox $WIDGET, $CHECKBOX, bounds(10,  85, 150, 20), channel("LFO_Mod_Wheel"),    text("Modulation Wheel"),    value(0)
        checkbox $WIDGET, $CHECKBOX, bounds(10, 115, 150, 20), channel("LFO_After_Touch"),  text("Channel After Touch"), value(0)
    }
    
    ; Output
    groupbox $GROUPBOX, bounds(710, 165, 225, 145), text("Output") {
        rslider $WIDGET, $RSLIDER, bounds(10,  30, 75, 75), channel("Output_Volume_Level"),   text("Volume"),   range(-24, 12, -6, 1, .1), valuePostfix(" dB")
        rslider $WIDGET, $RSLIDER, bounds(75,  30, 75, 75), channel("Output_Panorama_Level"), text("Panorama"), range(-1,   1,  0, 1, .01)
        
        nslider $WIDGET, $NSLIDER, bounds(10, 110, 75, 25), channel("Output_Volume_LFO"),     text("LFO"),      range(0, 1, 0, 1, 0.01)
        nslider $WIDGET, $NSLIDER, bounds(75, 110, 75, 25), channel("Output_Panorama_LFO"),   text("LFO"),      range(0, 1, 0, 1, 0.01)
    }

    ; Chorus
    groupbox $GROUPBOX, bounds(710, 320, 225, 145), text("Chorus") {
        rslider $WIDGET, $RSLIDER, bounds( 10, 40, 75, 75), channel("Chorus_DryWet"),    text("Dry/Wet"),   range(0, 1, .3, 1, .01)
        
        nslider $WIDGET, $NSLIDER, bounds( 80, 40, 75, 30), channel("Chorus_Frequency"), text("Frequency [Hz]"), range(0, 25,    1.5, 1, 0.01)
        nslider $WIDGET, $NSLIDER, bounds(150, 40, 75, 30), channel("Chorus_Delay"),     text("Delay [ms]"),     range(0, 50,   30.0, 1, 0.1)
        nslider $WIDGET, $NSLIDER, bounds( 80, 80, 75, 30), channel("Chorus_Width"),     text("Width [ms]"),     range(1, 20,    1.8, 1, 0.1)
        nslider $WIDGET, $NSLIDER, bounds(150, 80, 75, 30), channel("Chorus_Feedback"),  text("Feedback"),       range(0,  0.99, 0,   1, 0.01)
    }
    
    ; Reverb
    groupbox $GROUPBOX, bounds(710, 475, 225, 145), text("Reverb") {
        rslider $WIDGET, $RSLIDER, bounds( 10, 40, 75, 75), channel("Reverb_DryWet"), text("Dry/Wet"), range(0,     1,  .15,  1, .01)
        rslider $WIDGET, $RSLIDER, bounds( 75, 40, 75, 75), channel("Reverb_Size"),   text("Size"),    range(0,     1,  .40,  1, .01)
        rslider $WIDGET, $RSLIDER, bounds(140, 40, 75, 75), channel("Reverb_CutOff"), text("Cut-Off"), range(0, 20000, 7000, .5, 100), valuePostfix(" Hz")
    }
    
    ; VU Meters
    vmeter $WIDGET, bounds(945, 10, 10, 610) channel("VU_L") value(0) outlineColour(0, 0, 0), overlayColour(0, 0, 0) meterColour:0(255, 0, 0) meterColour:1(255, 255, 0) meterColour:2(0, 255, 0) outlineThickness(1) 
    vmeter $WIDGET, bounds(960, 10, 10, 610) channel("VU_R") value(0) outlineColour(0, 0, 0), overlayColour(0, 0, 0) meterColour:0(255, 0, 0) meterColour:1(255, 255, 0) meterColour:2(0, 255, 0) outlineThickness(1) 
       
    ; Virtual Keyboard
    keyboard $WIDGET, bounds(0, 630, 980, 95), value(23)
</Cabbage>

<CsoundSynthesizer>
    <CsOptions>
        ; -M0                       Listen for MIDI input and send it to instrument 1
        ; --midi-key-cps=4          Set p4 to the frequency from the MIDI input
        ; --midi-key=4              Set p4 to the note number from the MIDI input
        ; --midi-velocity-amp=5     Set p5 to the amplitude from the MIDI input
        ; --asciidisplay            Suppress graphics, use ASCII displays instead => Cabbage!
        ; --postscriptdisplay       Suppress graphics, use PostScript displays instead
        -n -d -+rtmidi=NULL -M0 --midi-key=4 --midi-velocity-amp=5 --asciidisplay
    </CsOptions>

    <CsInstruments>
        ; Global variables
        ksmps  = 32
        nchnls = 2
        0dbfs  = 1

        gk_LFO1 = 0.5
        gk_LFO2 = 0.0

        ; MIDI Controlers mapped to [0 … 1], except pitch bend [-1 … 1]
        gi_MIDI_Channel = 1
        massign gi_MIDI_Channel, "Tone_Generator"
        
        gk_MIDI_Mod_Wheel   = 0.0
        gk_MIDI_After_Touch = 0.0
        gk_MIDI_Pitch_Bend  = 0.0
        gk_MIDI_Volume      = 1.0
        gk_MIDI_Expression  = 1.0
        
        ; Connect instruments
        connect "Tone_Generator", "Out",    "Output", "In"
        
        connect "Output",  "Out_L",  "Chorus", "In_L"
        connect "Output",  "Out_R",  "Chorus", "In_R"
        
        connect "Chorus",  "Out_L",  "Reverb", "In_L"
        connect "Chorus",  "Out_R",  "Reverb", "In_R"
        
        connect "Reverb",  "Out_L",  "To_Speakers", "In_L"
        connect "Reverb",  "Out_R",  "To_Speakers", "In_R"
        
        alwayson "Read_Channels"
        alwayson "Read_MIDI_Controlers"
        alwayson "LFO"
        alwayson "Output"
        alwayson "Chorus"
        alwayson "Reverb"
        alwayson "To_Speakers"
                       
        ;====================================================================
        ; Read channels into global variables (as this should be cheaper
        ; than repeatedly calling chnget for each played note)
        ;====================================================================
        instr Read_Channels
            i_Declick_ms             = 0.15
        
            gk_OP1_Frequency_Level   = lag(chnget:k("OP1_Frequency_Level"),   i_Declick_ms)
            gk_OP1_Frequency_LFO     = lag(chnget:k("OP1_Frequency_LFO"),     i_Declick_ms)
            gk_OP1_FM_Enable         = lag(chnget:k("OP1_FM_Enable"),         i_Declick_ms)
            gk_OP1_FM_Level          = lag(chnget:k("OP1_FM_Level"),          i_Declick_ms)
            gk_OP1_FM_LFO            = lag(chnget:k("OP1_FM_LFO"),            i_Declick_ms)
            gk_OP1_Output_Enable     = lag(chnget:k("OP1_Output_Enable"),     i_Declick_ms)
            gk_OP1_Output_Level      = lag(chnget:k("OP1_Output_Level"),      i_Declick_ms)
            gk_OP1_Output_LFO        = lag(chnget:k("OP1_Output_LFO"),        i_Declick_ms)
            gk_OP1_Feedback_Level    = lag(chnget:k("OP1_Feedback_Level"),    i_Declick_ms)
            gk_OP1_Feedback_LFO      = lag(chnget:k("OP1_Feedback_LFO"),      i_Declick_ms)
            gk_OP1_Initial_Level     = lag(chnget:k("OP1_Initial_Level"),     i_Declick_ms)
            gk_OP1_Attack_Level      = lag(chnget:k("OP1_Attack_Level"),      i_Declick_ms)
            gk_OP1_Attack_Time       = lag(chnget:k("OP1_Attack_Time"),       i_Declick_ms)
            gk_OP1_Decay_Level       = lag(chnget:k("OP1_Decay_Level"),       i_Declick_ms)
            gk_OP1_Decay_Time        = lag(chnget:k("OP1_Decay_Time"),        i_Declick_ms)
            gk_OP1_Sustain_Level     = lag(chnget:k("OP1_Sustain_Level"),     i_Declick_ms)
            gk_OP1_Sustain_Time      = lag(chnget:k("OP1_Sustain_Time"),      i_Declick_ms)
            gk_OP1_Release_Level     = lag(chnget:k("OP1_Release_Level"),     i_Declick_ms)
            gk_OP1_Release_Time      = lag(chnget:k("OP1_Release_Time"),      i_Declick_ms)
            
            gk_OP2_Frequency_Level   = lag(chnget:k("OP2_Frequency_Level"),   i_Declick_ms)
            gk_OP2_Frequency_LFO     = lag(chnget:k("OP2_Frequency_LFO"),     i_Declick_ms)
            gk_OP2_FM_Enable         = lag(chnget:k("OP2_FM_Enable"),         i_Declick_ms)
            gk_OP2_FM_Level          = lag(chnget:k("OP2_FM_Level"),          i_Declick_ms)
            gk_OP2_FM_LFO            = lag(chnget:k("OP2_FM_LFO"),            i_Declick_ms)
            gk_OP2_Output_Enable     = lag(chnget:k("OP2_Output_Enable"),     i_Declick_ms)
            gk_OP2_Output_Level      = lag(chnget:k("OP2_Output_Level"),      i_Declick_ms)
            gk_OP2_Output_LFO        = lag(chnget:k("OP2_Output_LFO"),        i_Declick_ms)
            gk_OP2_Feedback_Level    = lag(chnget:k("OP2_Feedback_Level"),    i_Declick_ms)
            gk_OP2_Feedback_LFO      = lag(chnget:k("OP2_Feedback_LFO"),      i_Declick_ms)
            gk_OP2_Initial_Level     = lag(chnget:k("OP2_Initial_Level"),     i_Declick_ms)
            gk_OP2_Attack_Level      = lag(chnget:k("OP2_Attack_Level"),      i_Declick_ms)
            gk_OP2_Attack_Time       = lag(chnget:k("OP2_Attack_Time"),       i_Declick_ms)
            gk_OP2_Decay_Level       = lag(chnget:k("OP2_Decay_Level"),       i_Declick_ms)
            gk_OP2_Decay_Time        = lag(chnget:k("OP2_Decay_Time"),        i_Declick_ms)
            gk_OP2_Sustain_Level     = lag(chnget:k("OP2_Sustain_Level"),     i_Declick_ms)
            gk_OP2_Sustain_Time      = lag(chnget:k("OP2_Sustain_Time"),      i_Declick_ms)
            gk_OP2_Release_Level     = lag(chnget:k("OP2_Release_Level"),     i_Declick_ms)
            gk_OP2_Release_Time      = lag(chnget:k("OP2_Release_Time"),      i_Declick_ms)
            
            gk_OP3_Frequency_Level   = lag(chnget:k("OP3_Frequency_Level"),   i_Declick_ms)
            gk_OP3_Frequency_LFO     = lag(chnget:k("OP3_Frequency_LFO"),     i_Declick_ms)
            gk_OP3_FM_Enable         = lag(chnget:k("OP3_FM_Enable"),         i_Declick_ms)
            gk_OP3_FM_Level          = lag(chnget:k("OP3_FM_Level"),          i_Declick_ms)
            gk_OP3_FM_LFO            = lag(chnget:k("OP3_FM_LFO"),            i_Declick_ms)
            gk_OP3_Output_Enable     = lag(chnget:k("OP3_Output_Enable"),     i_Declick_ms)
            gk_OP3_Output_Level      = lag(chnget:k("OP3_Output_Level"),      i_Declick_ms)
            gk_OP3_Output_LFO        = lag(chnget:k("OP3_Output_LFO"),        i_Declick_ms)
            gk_OP3_Feedback_Level    = lag(chnget:k("OP3_Feedback_Level"),    i_Declick_ms)
            gk_OP3_Feedback_LFO      = lag(chnget:k("OP3_Feedback_LFO"),      i_Declick_ms)
            gk_OP3_Initial_Level     = lag(chnget:k("OP3_Initial_Level"),     i_Declick_ms)
            gk_OP3_Attack_Level      = lag(chnget:k("OP3_Attack_Level"),      i_Declick_ms)
            gk_OP3_Attack_Time       = lag(chnget:k("OP3_Attack_Time"),       i_Declick_ms)
            gk_OP3_Decay_Level       = lag(chnget:k("OP3_Decay_Level"),       i_Declick_ms)
            gk_OP3_Decay_Time        = lag(chnget:k("OP3_Decay_Time"),        i_Declick_ms)
            gk_OP3_Sustain_Level     = lag(chnget:k("OP3_Sustain_Level"),     i_Declick_ms)
            gk_OP3_Sustain_Time      = lag(chnget:k("OP3_Sustain_Time"),      i_Declick_ms)
            gk_OP3_Release_Level     = lag(chnget:k("OP3_Release_Level"),     i_Declick_ms)
            gk_OP3_Release_Time      = lag(chnget:k("OP3_Release_Time"),      i_Declick_ms)
            
            gk_OP4_Frequency_Level   = lag(chnget:k("OP4_Frequency_Level"),   i_Declick_ms)
            gk_OP4_Frequency_LFO     = lag(chnget:k("OP4_Frequency_LFO"),     i_Declick_ms)
            gk_OP4_Output_Enable     = lag(chnget:k("OP4_Output_Enable"),     i_Declick_ms)
            gk_OP4_Output_Level      = lag(chnget:k("OP4_Output_Level"),      i_Declick_ms)
            gk_OP4_Output_LFO        = lag(chnget:k("OP4_Output_LFO"),        i_Declick_ms)
            gk_OP4_Feedback_Level    = lag(chnget:k("OP4_Feedback_Level"),    i_Declick_ms)
            gk_OP4_Feedback_LFO      = lag(chnget:k("OP4_Feedback_LFO"),      i_Declick_ms)
            gk_OP4_Initial_Level     = lag(chnget:k("OP4_Initial_Level"),     i_Declick_ms)
            gk_OP4_Attack_Level      = lag(chnget:k("OP4_Attack_Level"),      i_Declick_ms)
            gk_OP4_Attack_Time       = lag(chnget:k("OP4_Attack_Time"),       i_Declick_ms)
            gk_OP4_Decay_Level       = lag(chnget:k("OP4_Decay_Level"),       i_Declick_ms)
            gk_OP4_Decay_Time        = lag(chnget:k("OP4_Decay_Time"),        i_Declick_ms)
            gk_OP4_Sustain_Level     = lag(chnget:k("OP4_Sustain_Level"),     i_Declick_ms)
            gk_OP4_Sustain_Time      = lag(chnget:k("OP4_Sustain_Time"),      i_Declick_ms)
            gk_OP4_Release_Level     = lag(chnget:k("OP4_Release_Level"),     i_Declick_ms)
            gk_OP4_Release_Time      = lag(chnget:k("OP4_Release_Time"),      i_Declick_ms)
            
            gk_LFO_Frequency         = lag(chnget:k("LFO_Frequency"),         i_Declick_ms)
            gk_LFO_Mod_Wheel         = lag(chnget:k("LFO_Mod_Wheel"),         i_Declick_ms)
            gk_LFO_After_Touch       = lag(chnget:k("LFO_After_Touch"),       i_Declick_ms)
            gk_Pitch_Bend_Range      = lag(chnget:k("Pitch_Bend_Range"),      i_Declick_ms)
            
            gk_Output_Volume_Level   = lag(chnget:k("Output_Volume_Level"),   i_Declick_ms)
            gk_Output_Volume_LFO     = lag(chnget:k("Output_Volume_LFO"),     i_Declick_ms)
            gk_Output_Panorama_Level = lag(chnget:k("Output_Panorama_Level"), i_Declick_ms)
            gk_Output_Panorama_LFO   = lag(chnget:k("Output_Panorama_LFO"),   i_Declick_ms)
            
            gk_Chorus_DryWet         = lag(chnget:k("Chorus_DryWet"),         i_Declick_ms)
            gk_Chorus_Frequency      = lag(chnget:k("Chorus_Frequency"),      i_Declick_ms)
            gk_Chorus_Delay          = lag(chnget:k("Chorus_Delay"),          i_Declick_ms)
            gk_Chorus_Width          = lag(chnget:k("Chorus_Width"),          i_Declick_ms)
            gk_Chorus_Feedback       = lag(chnget:k("Chorus_Feedback"),       i_Declick_ms)
            
            gk_Reverb_DryWet         = lag(chnget:k("Reverb_DryWet"),         i_Declick_ms)
            gk_Reverb_Size           = lag(chnget:k("Reverb_Size"),           i_Declick_ms)
            gk_Reverb_CutOff         = lag(chnget:k("Reverb_CutOff"),         i_Declick_ms)
        endin
        
        ;====================================================================
        ; Read MIDI controllers, that are not automatically handled by Csound
        ; like mod wheel, after touch, pitch bend, …
        ;====================================================================
        instr Read_MIDI_Controlers
            k_MIDI_Status, k_MIDI_Channel, k_MIDI_Data1, k_MIDI_Data2 midiin
            
            if k_MIDI_Channel == gi_MIDI_Channel then
                if (k_MIDI_Status == 176) then      ; Control Change
                    ; Mod Wheel (CC 1 + 33)
                    initc14 gi_MIDI_Channel, 1, 33, 0.0
                    gk_MIDI_Mod_Wheel = ctrl14:k(gi_MIDI_Channel, 1, 33, 0.0, 1.0)
                    
                    ; Volume (CC 7 + 39)
                    initc14 gi_MIDI_Channel, 7, 39, 1.0
                    gk_MIDI_Volume = ctrl14:k(gi_MIDI_Channel, 7, 39, 0.0, 1.0)
                    
                    ; Expression (CC 11 + 43)
                    initc14 gi_MIDI_Channel, 11, 43, 1.0
                    gk_MIDI_Expression = ctrl14:k(gi_MIDI_Channel, 11, 43, 0.0, 1.0)
                elseif (k_MIDI_Status == 208) then  ; After Touch
                    gk_After_Touch = k_MIDI_Data1 / 127
                elseif (k_MIDI_Status == 224) then  ; Pitch Bend
                    k_Pitch_Bend = (k_MIDI_Data2 << 7) | k_MIDI_Data1
                    gk_MIDI_Pitch_Bend = (k_Pitch_Bend - 8192) / 8192
                endif
            endif
        endin

        ;====================================================================
        ; Low Frequency Oscilator
        ;
        ; Generates an oscilating signal between and stores it in the global
        ; variables gk_LFO1 and gk_LFO2.
        ;
        ;   gk_LFO1 = [ 0 … 1] 
        ;   gk_LFO2 = [-1 … 1]
        ;====================================================================
        instr LFO            
            ; Generate base waveform with range [-1 … 1]
            a_LFO   = lfo(1, gk_LFO_Frequency, 0)                        
            gk_LFO2 = k(a_LFO)
            
            ; MIDI Support: If at least one of the MIDI checkboxes is activated, the LFO values are
            ; multiplited with the sum of the selected controller values mapped to 0…1 and limited to 1.            
            if gk_LFO_Mod_Wheel > 0.01 || gk_LFO_After_Touch > 0.01 then                                
                k_Factor = min((gk_MIDI_Mod_Wheel * gk_LFO_Mod_Wheel) + (gk_MIDI_After_Touch * gk_LFO_After_Touch), 1)
                gk_LFO2  = gk_LFO2 * k_Factor
            endif
            
            ; Scale waveform to range [0 … 1]
            gk_LFO1 = (gk_LFO2 / 2) + .5 
        endin
        
        ;====================================================================
        ; FM Operator (phase modulation actually)
        ;
        ; The Csound book; pp. 197-207, 249-253, 261-279
        ; Csound - A Sound and Music Computing System; pp. 234-238
        ;====================================================================
        opcode FMOperator, a, akkiiiiiiiii
            a_Modulator,
            k_Frequency,
            k_Feedback,
            i_Initial_Level,
            i_Attack_Level,
            i_Attack_Time,
            i_Decay_Level,
            i_Decay_Time,
            i_Sustain_Level,
            i_Sustain_Time,
            i_Release_Level,
            i_Release_Time xin
            
            setksmps(1)                                                             ; Needed for accurate feedback
            a_Out   = init:a(0)                                                     ; Initialize variable at i-time and retain value afterwards
            a_Phase = phasor:a(k_Frequency) + a_Modulator + (a_Out * k_Feedback)
            a_Out   = tablei:a(a_Phase, -1, 1, .5, 1)                               ; andx, ifn, ixmode, ixoff, iwrap            
            
            a_Envelope cossegr i_Initial_Level,                 \
                               i_Attack_Time,  i_Attack_Level,  \
                               i_Decay_Time,   i_Decay_Level,   \
                               i_Sustain_Time, i_Sustain_Level, \
                               i_Release_Time, i_Release_Level
            
            xout(a_Out * a_Envelope)
            
        endop
        
        ;====================================================================
        ; Tone generator triggered by MIDI input
        ;
        ; Parameters:
        ;   p4 = MIDI note number
        ;   p5 = Amplitude
        ;
        ; Outputs:
        ;   Out = Audio output
        ;====================================================================
        instr Tone_Generator, 1
            ; Calculate values before LFO
            k_Pitch_Bend     = gk_MIDI_Pitch_Bend * gk_Pitch_Bend_Range
            k_Base_Frequency = cpsmidinn(p4 + k_Pitch_Bend)
            
            k_OP1_Frequency    = gk_OP1_Frequency_Level
            k_OP1_Feedback     = gk_OP1_Feedback_Level
            k_OP1_FM_Level     = gk_OP1_FM_Enable     * gk_OP1_FM_Level
            k_OP1_Output_Level = gk_OP1_Output_Enable * gk_OP1_Output_Level
            
            k_OP2_Frequency    = gk_OP2_Frequency_Level
            k_OP2_Feedback     = gk_OP2_Feedback_Level
            k_OP2_FM_Level     = gk_OP2_FM_Enable     * gk_OP2_FM_Level
            k_OP2_Output_Level = gk_OP2_Output_Enable * gk_OP2_Output_Level
            
            k_OP3_Frequency    = gk_OP3_Frequency_Level
            k_OP3_Feedback     = gk_OP3_Feedback_Level
            k_OP3_FM_Level     = gk_OP3_FM_Enable     * gk_OP3_FM_Level
            k_OP3_Output_Level = gk_OP3_Output_Enable * gk_OP3_Output_Level
            
            k_OP4_Frequency    = gk_OP4_Frequency_Level
            k_OP4_Feedback     = gk_OP4_Feedback_Level
            k_OP4_Output_Level = gk_OP4_Output_Enable * gk_OP4_Output_Level
            
            ; Apply LFO
            k_OP1_Frequency    =     max(k_OP1_Frequency    + (gk_LFO2 * gk_OP1_Frequency_LFO), 0)
            k_OP1_Feedback     = min(max(k_OP1_Feedback     + (gk_LFO2 * gk_OP1_Feedback_LFO ), 0), 1)
            k_OP1_FM_Level     = min(max(k_OP1_FM_Level     + (gk_LFO2 * gk_OP1_FM_LFO       ), 0), 1)
            k_OP1_Output_Level = min(max(k_OP1_Output_Level + (gk_LFO2 * gk_OP1_Output_LFO   ), 0), 1)
            
            k_OP2_Frequency    =     max(k_OP2_Frequency    + (gk_LFO2 * gk_OP2_Frequency_LFO), 0)
            k_OP2_Feedback     = min(max(k_OP2_Feedback     + (gk_LFO2 * gk_OP2_Feedback_LFO ), 0), 1)
            k_OP2_FM_Level     = min(max(k_OP2_FM_Level     + (gk_LFO2 * gk_OP2_FM_LFO       ), 0), 1)
            k_OP2_Output_Level = min(max(k_OP2_Output_Level + (gk_LFO2 * gk_OP2_Output_LFO   ), 0), 1)
            
            k_OP3_Frequency    =     max(k_OP3_Frequency    + (gk_LFO2 * gk_OP3_Frequency_LFO), 0)
            k_OP3_Feedback     = min(max(k_OP3_Feedback     + (gk_LFO2 * gk_OP3_Feedback_LFO ), 0), 1)
            k_OP3_FM_Level     = min(max(k_OP3_FM_Level     + (gk_LFO2 * gk_OP3_FM_LFO       ), 0), 1)
            k_OP3_Output_Level = min(max(k_OP3_Output_Level + (gk_LFO2 * gk_OP3_Output_LFO   ), 0), 1)
            
            k_OP4_Frequency    =     max(k_OP4_Frequency    + (gk_LFO2 * gk_OP4_Frequency_LFO), 0)
            k_OP4_Feedback     = min(max(k_OP4_Feedback     + (gk_LFO2 * gk_OP4_Feedback_LFO ), 0), 1)
            k_OP4_Output_Level = min(max(k_OP4_Output_Level + (gk_LFO2 * gk_OP4_Output_LFO   ), 0), 1)
                       
            ; Generate sound
            a_OP1 FMOperator  a(0),                                          \
                              k_OP1_Frequency * k_Base_Frequency,            \
                              k_OP1_Feedback,                                \
                           i(gk_OP1_Initial_Level),                          \
                           i(gk_OP1_Attack_Level),   i(gk_OP1_Attack_Time),  \
                           i(gk_OP1_Decay_Level),    i(gk_OP1_Decay_Time),   \
                           i(gk_OP1_Sustain_Level),  i(gk_OP1_Sustain_Time), \
                           i(gk_OP1_Release_Level),  i(gk_OP1_Release_Time)

            a_OP2 FMOperator  a_OP1 * k_OP1_FM_Level,                        \
                              k_OP2_Frequency * k_Base_Frequency,            \
                              k_OP2_Feedback,                                \
                           i(gk_OP2_Initial_Level),                          \
                           i(gk_OP2_Attack_Level),   i(gk_OP2_Attack_Time),  \
                           i(gk_OP2_Decay_Level),    i(gk_OP2_Decay_Time),   \
                           i(gk_OP2_Sustain_Level),  i(gk_OP2_Sustain_Time), \
                           i(gk_OP2_Release_Level),  i(gk_OP2_Release_Time)
            
            a_OP3 FMOperator  a_OP2 * k_OP2_FM_Level,                        \
                              k_OP3_Frequency * k_Base_Frequency,            \
                              k_OP3_Feedback,                                \
                           i(gk_OP3_Initial_Level),                          \
                           i(gk_OP3_Attack_Level),   i(gk_OP3_Attack_Time),  \
                           i(gk_OP3_Decay_Level),    i(gk_OP3_Decay_Time),   \
                           i(gk_OP3_Sustain_Level),  i(gk_OP3_Sustain_Time), \
                           i(gk_OP3_Release_Level),  i(gk_OP3_Release_Time)
                           
            a_OP4 FMOperator  a_OP3 * k_OP3_FM_Level,                        \
                              k_OP4_Frequency * k_Base_Frequency,            \
                              k_OP4_Feedback,                                \
                           i(gk_OP4_Initial_Level),                          \
                           i(gk_OP4_Attack_Level),   i(gk_OP4_Attack_Time),  \
                           i(gk_OP4_Decay_Level),    i(gk_OP4_Decay_Time),   \
                           i(gk_OP4_Sustain_Level),  i(gk_OP4_Sustain_Time), \
                           i(gk_OP4_Release_Level),  i(gk_OP4_Release_Time)

            a_Out = (a_OP1 * .25 * k_OP1_Output_Level) \
                  + (a_OP2 * .25 * k_OP2_Output_Level) \
                  + (a_OP3 * .25 * k_OP3_Output_Level) \
                  + (a_OP4 * .25 * k_OP4_Output_Level)
                  
            outleta("Out", a_Out * .7)
            
            ; Keep running during the release phase
            xtratim(max(i(gk_OP1_Release_Time), i(gk_OP2_Release_Time), i(gk_OP3_Release_Time), i(gk_OP4_Release_Time)) + 0.25)
        endin
                
        ;====================================================================
        ; Output stage to apply volume and panorama
        ;
        ; Inputs:
        ;   In = Audio input
        ;
        ; Outputs:
        ;   Out_L = Left audio output
        ;   Out_R = Right audio output
        ;====================================================================
        instr Output
            a_In = inleta("In")
            
            k_Volume   = ampdb(gk_Output_Volume_Level)
            k_Volume   = k_Volume - (k_Volume * gk_LFO1 * gk_Output_Volume_LFO)                 ; Volume LFO

            k_Panorama = gk_Output_Panorama_Level + (gk_LFO2 * gk_Output_Panorama_LFO)          ; Panorama LFO
            k_Panorama = (k_Panorama * .5) + .5
            k_Panorama = max(min(k_Panorama, 1), 0)
            
            a_Out_L, a_Out_R pan2 a_In * k_Volume, k_Panorama, 0

            outleta("Out_L", a_Out_L)
            outleta("Out_R", a_Out_R)
        endin
        
        ;====================================================================
        ; Chorus/Flanger voice
        ;
        ; The Csound book; pp. 458-461, 586-589
        ; Csound - A Sound and Music Computing System; pp. 271-274
        ;
        ; Typical values for chorus:
        ;   - Delay:       20…30 ms
        ;   - Frequency:   < 30 Hz
        ;   - Sweep Width: ~ 5 ms
        ;   - Feedback:    None
        ;
        ; Typical values for flanger:
        ;   - Delay:       < 10 ms
        ;   - Frequency:   ~ 10 Hz
        ;   - Sweep Width: ~ 1 ms
        ;   - Feedback:    Yes
        ;====================================================================
        opcode ChorusVoice, a, akkkki
            a_In,
            k_Frequency,
            k_Delay,
            k_Width,
            k_Feedback,
            i_Phase_Offset xin

            k_Frequency  = k_Frequency + birnd:i(.05)   ; Slightly randomize frequency
            k_Delay      = k_Delay * .001               ; Miliseconds to seconds
            k_Width      = max(k_Width, 1) * .001
            
            a_Modulation = oscili(k_Width * .5, k_Frequency, -1, i_Phase_Offset) + k_Width
            a_Dummy      = delayr:a(.1)
            a_Chorus     = deltapi:a(k_Delay + a_Modulation)
            delayw(a_In + (a_Chorus * k_Feedback))
            
            xout(a_Chorus)
        endop
        
        ;====================================================================
        ; Global chorus/flanger effect
        ;
        ; Inputs:
        ;   In_L = Left audio input
        ;   In_R = Right audio input
        ;
        ; Outputs:
        ;   Out_L = Left audio output
        ;   Out_R = Right audio output
        ;====================================================================
        instr Chorus
            a_In_L = inleta("In_L")
            a_In_R = inleta("In_R")
            
            a_Chorus_L1 = ChorusVoice(a_In_L, gk_Chorus_Frequency, gk_Chorus_Delay, gk_Chorus_Width, gk_Chorus_Feedback, 0.00)
            a_Chorus_L2 = ChorusVoice(a_In_L, gk_Chorus_Frequency, gk_Chorus_Delay, gk_Chorus_Width, gk_Chorus_Feedback, 0.25)
            a_Chorus_L  = (a_Chorus_L1 + a_Chorus_L2) * .5
            
            a_Chorus_R1 = ChorusVoice(a_In_R, gk_Chorus_Frequency, gk_Chorus_Delay, gk_Chorus_Width, gk_Chorus_Feedback, 0.01)
            a_Chorus_R2 = ChorusVoice(a_In_R, gk_Chorus_Frequency, gk_Chorus_Delay, gk_Chorus_Width, gk_Chorus_Feedback, 0.35)
            a_Chorus_R  = (a_Chorus_R1 + a_Chorus_R2) * .5
            
            k_Wet_Amp = sqrt(gk_Chorus_DryWet)            ; Approximate equal-power
            k_Dry_Amp = 1 - k_Wet_Amp
            a_Out_L   = (a_In_L * k_Dry_Amp) + (a_Chorus_L * k_Wet_Amp)
            a_Out_R   = (a_In_R * k_Dry_Amp) + (a_Chorus_R * k_Wet_Amp)
            
            outleta("Out_L", a_Out_L)
            outleta("Out_R", a_Out_R)
        endin
        
        ;====================================================================
        ; Global reverb effect
        ;
        ; Inputs:
        ;   In_L = Left audio input
        ;   In_R = Right audio input
        ;
        ; Outputs:
        ;   Out_L = Left audio output
        ;   Out_R = Right audio output
        ;====================================================================
        instr Reverb
            a_In_L = inleta("In_L")
            a_In_R = inleta("In_R")
            
            a_Reverb_L, a_Reverb_R reverbsc a_In_L, a_In_R, pow(gk_Reverb_Size, 1/3), gk_Reverb_CutOff

            k_Wet_Amp = sqrt(gk_Reverb_DryWet)            ; Approximate equal-power
            k_Dry_Amp = 1 - k_Wet_Amp
            a_Out_L   = (a_In_L * k_Dry_Amp) + (a_Reverb_L * k_Wet_Amp)
            a_Out_R   = (a_In_R * k_Dry_Amp) + (a_Reverb_R * k_Wet_Amp)
            
            outleta("Out_L", a_Out_L)
            outleta("Out_R", a_Out_R)
        endin
                
        ;====================================================================
        ; Send audio output to speakrs and VU meters
        ;
        ; Inputs:
        ;   In_L = Left audio input
        ;   In_R = Right audio input
        ;====================================================================
        instr To_Speakers
            a_Out_L = dcblock(inleta("In_L"))
            a_Out_R = dcblock(inleta("In_R"))
            
            outs(a_Out_L, a_Out_R)
            
            k_RMS_L = rms(a_Out_L, 20)
            k_RMS_R = rms(a_Out_R, 20)
            
            cabbageSetValue "VU_L", portk(k_RMS_L * 10, .25), metro(10)
            cabbageSetValue "VU_R", portk(k_RMS_R * 10, .25), metro(10)
        endin
    </CsInstruments>
</CsoundSynthesizer>