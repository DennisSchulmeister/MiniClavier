/**
 * Facelift FM4 - 4 Operator FM Synthesizer
 * ========================================
 *
 * Dec 28 2024: Dennis Schulmeister-Zimolong
 * This is the synthesizer with which Android will be tested.
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
        nslider  $WIDGET, $NSLIDER,  bounds( 60,  35,  75, 25), channel("OP1_Frequency_LFO"),   text("LFO"),           range(0, 1, 0, 1, 0.01)
        checkbox $WIDGET, $CHECKBOX, bounds( 10,  85, 120, 20), channel("OP1_FM_Enable"),       text("Modulate OP2")
        checkbox $WIDGET, $CHECKBOX, bounds( 10, 115, 120, 20), channel("OP1_Out_Enable"),      text("Direct Output")
        
        rslider  $WIDGET, $RSLIDER,  bounds(145,  30,  75, 75), channel("OP1_FM_Level"),        text("Modulate OP2"),  range(0, 1, 0.5, 1, 0.01)
        rslider  $WIDGET, $RSLIDER,  bounds(220,  30,  75, 75), channel("OP1_Out_Level"),       text("Direct Output"), range(0, 1, 0,   1, 0.01)
        rslider  $WIDGET, $RSLIDER,  bounds(295,  30,  75, 75), channel("OP1_Feedback_Level"),  text("Feedback"),      range(0, 1, 0,   1, 0.01)
        
        nslider  $WIDGET, $NSLIDER,  bounds(145, 110,  75, 25), channel("OP1_FM_LFO"),          text("LFO"),           range(0, 1, 0, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(220, 110,  75, 25), channel("OP1_Out_LFO"),         text("LFO"),           range(0, 1, 0, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(295, 110,  75, 25), channel("OP1_Feedback_LFO"),    text("LFO"),           range(0, 1, 0, 1, 0.01)
        
        nslider  $WIDGET, $NSLIDER,  bounds(380,  40,  75, 30), channel("OP1_Attack_Level"),    text("Attack"),        range(0, 1, 1.0, 1, 0.01), active(0)
        nslider  $WIDGET, $NSLIDER,  bounds(460,  40,  75, 30), channel("OP1_Decay_Level"),     text("Decay"),         range(0, 1, 1.0, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(540,  40,  75, 30), channel("OP1_Sustain_Level"),   text("Sustain"),       range(0, 1, 1.0, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(620,  40,  75, 30), channel("OP1_Release_Level"),   text("Release"),       range(0, 1, 0.0, 1, 0.01), active(0)
        
        nslider  $WIDGET, $NSLIDER,  bounds(380,  80,  75, 30), channel("OP1_Attack_Time"),     text("Seconds"),       range(0, 100, 0.1, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(460,  80,  75, 30), channel("OP1_Decay_Time"),      text("Seconds"),       range(0, 100, 0.0, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(540,  80,  75, 30), channel("OP1_Sustain_Time"),    text("Seconds"),       range(0, 100, 0.0, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(620,  80,  75, 30), channel("OP1_Release_Time"),    text("Seconds"),       range(0, 100, 0.2, 1, 0.01)
    }
    
    ; Operator 2
    groupbox $GROUPBOX, bounds(10, 165, 690, 145), text("Operator 2") {
        nslider  $WIDGET, $NSLIDER,  bounds(  5,  30,  75, 35), channel("OP2_Frequency_Level"), text("Frequency"),     range(0, 100, 1, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds( 60,  35,  75, 25), channel("OP2_Frequency_LFO"),   text("LFO"),           range(0, 1, 0, 1, 0.01)
        checkbox $WIDGET, $CHECKBOX, bounds( 10,  85, 120, 20), channel("OP2_FM_Enable"),       text("Modulate OP3")
        checkbox $WIDGET, $CHECKBOX, bounds( 10, 115, 120, 20), channel("OP2_Out_Enable"),      text("Direct Output")
        
        rslider  $WIDGET, $RSLIDER,  bounds(145,  30,  75, 75), channel("OP2_FM_Level"),        text("Modulate OP3"),  range(0, 1, 0.5, 1, 0.01)
        rslider  $WIDGET, $RSLIDER,  bounds(220,  30,  75, 75), channel("OP2_Out_Level"),       text("Direct Output"), range(0, 1, 0,   1, 0.01)
        rslider  $WIDGET, $RSLIDER,  bounds(295,  30,  75, 75), channel("OP2_Feedback_Level"),  text("Feedback"),      range(0, 1, 0,   1, 0.01)
        
        nslider  $WIDGET, $NSLIDER,  bounds(145, 110,  75, 25), channel("OP2_FM_LFO"),          text("LFO"),           range(0, 1, 0, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(220, 110,  75, 25), channel("OP2_Out_LFO"),         text("LFO"),           range(0, 1, 0, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(295, 110,  75, 25), channel("OP2_Feedback_LFO"),    text("LFO"),           range(0, 1, 0, 1, 0.01)
        
        nslider  $WIDGET, $NSLIDER,  bounds(380,  40,  75, 30), channel("OP2_Attack_Level"),    text("Attack"),        range(0, 1, 1.0, 1, 0.01), active(0)
        nslider  $WIDGET, $NSLIDER,  bounds(460,  40,  75, 30), channel("OP2_Decay_Level"),     text("Decay"),         range(0, 1, 1.0, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(540,  40,  75, 30), channel("OP2_Sustain_Level"),   text("Sustain"),       range(0, 1, 1.0, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(620,  40,  75, 30), channel("OP2_Release_Level"),   text("Release"),       range(0, 1, 0.0, 1, 0.01), active(0)
        
        nslider  $WIDGET, $NSLIDER,  bounds(380,  80,  75, 30), channel("OP2_Attack_Time"),     text("Seconds"),       range(0, 100, 0.1, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(460,  80,  75, 30), channel("OP2_Decay_Time"),      text("Seconds"),       range(0, 100, 0.0, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(540,  80,  75, 30), channel("OP2_Sustain_Time"),    text("Seconds"),       range(0, 100, 0.0, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(620,  80,  75, 30), channel("OP2_Release_Time"),    text("Seconds"),       range(0, 100, 0.2, 1, 0.01)
    }
    
    ; Operator 3
    groupbox $GROUPBOX, bounds(10, 320, 690, 145), text("Operator 3") {
        nslider  $WIDGET, $NSLIDER,  bounds(  5,  30,  75, 35), channel("OP3_Frequency_Level"), text("Frequency"),     range(0, 100, 1, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds( 60,  35,  75, 25), channel("OP3_Frequency_LFO"),   text("LFO"),           range(0, 1, 0, 1, 0.01)
        checkbox $WIDGET, $CHECKBOX, bounds( 10,  85, 120, 20), channel("OP3_FM_Enable"),       text("Modulate OP4"),  value(1)
        checkbox $WIDGET, $CHECKBOX, bounds( 10, 115, 120, 20), channel("OP3_Out_Enable"),      text("Direct Output")
        
        rslider  $WIDGET, $RSLIDER,  bounds(145,  30,  75, 75), channel("OP3_FM_Level"),        text("Modulate OP4"),  range(0, 1, 0.5, 1, 0.01)
        rslider  $WIDGET, $RSLIDER,  bounds(220,  30,  75, 75), channel("OP3_Out_Level"),       text("Direct Output"), range(0, 1, 0,   1, 0.01)
        rslider  $WIDGET, $RSLIDER,  bounds(295,  30,  75, 75), channel("OP3_Feedback_Level"),  text("Feedback"),      range(0, 1, 0,   1, 0.01)
        
        nslider  $WIDGET, $NSLIDER,  bounds(145, 110,  75, 25), channel("OP3_FM_LFO"),          text("LFO"),           range(0, 1, 0, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(220, 110,  75, 25), channel("OP3_Out_LFO"),         text("LFO"),           range(0, 1, 0, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(295, 110,  75, 25), channel("OP3_Feedback_LFO"),    text("LFO"),           range(0, 1, 0, 1, 0.01)
        
        nslider  $WIDGET, $NSLIDER,  bounds(380,  40,  75, 30), channel("OP3_Attack_Level"),    text("Attack"),        range(0, 1, 1.0, 1, 0.01), active(0)
        nslider  $WIDGET, $NSLIDER,  bounds(460,  40,  75, 30), channel("OP3_Decay_Level"),     text("Decay"),         range(0, 1, 1.0, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(540,  40,  75, 30), channel("OP3_Sustain_Level"),   text("Sustain"),       range(0, 1, 1.0, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(620,  40,  75, 30), channel("OP3_Release_Level"),   text("Release"),       range(0, 1, 1.0, 1, 0.01), active(0)
        
        nslider  $WIDGET, $NSLIDER,  bounds(380,  80,  75, 30), channel("OP3_Attack_Time"),     text("Seconds"),       range(0, 100, 0.1, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(460,  80,  75, 30), channel("OP3_Decay_Time"),      text("Seconds"),       range(0, 100, 0.0, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(540,  80,  75, 30), channel("OP3_Sustain_Time"),    text("Seconds"),       range(0, 100, 0.0, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(620,  80,  75, 30), channel("OP3_Release_Time"),    text("Seconds"),       range(0, 100, 0.2, 1, 0.01)
    }
    
    ; Operator 4
    groupbox $GROUPBOX, bounds(10, 475, 690, 145), text("Operator 4") {
        nslider  $WIDGET, $NSLIDER,  bounds(  5,  30,  75, 35), channel("OP4_Frequency_Level"), text("Frequency"),     range(0, 100, 1, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds( 60,  35,  75, 25), channel("OP4_Frequency_LFO"),   text("LFO"),           range(0, 1, 0, 1, 0.01)
        checkbox $WIDGET, $CHECKBOX, bounds( 10, 115, 120, 20), channel("OP4_Out_Enable"),      text("Direct Output"), value(1)
        
        rslider  $WIDGET, $RSLIDER,  bounds(220,  30,  75, 75), channel("OP4_Out_Level"),       text("Direct Output"), range(0, 1, 1, 1, 0.01)
        rslider  $WIDGET, $RSLIDER,  bounds(295,  30,  75, 75), channel("OP4_Feedback_Level"),  text("Feedback"),      range(0, 1, 0, 1, 0.01)
        
        nslider  $WIDGET, $NSLIDER,  bounds(220, 110,  75, 25), channel("OP4_Out_LFO"),         text("LFO"),           range(0, 1, 0, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(295, 110,  75, 25), channel("OP4_Feedback_LFO"),    text("LFO"),           range(0, 1, 0, 1, 0.01)
        
        nslider  $WIDGET, $NSLIDER,  bounds(380,  40,  75, 30), channel("OP4_Attack_Level"),    text("Attack"),        range(0, 1, 1.0, 1, 0.01), active(0)
        nslider  $WIDGET, $NSLIDER,  bounds(460,  40,  75, 30), channel("OP4_Decay_Level"),     text("Decay"),         range(0, 1, 0.8, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(540,  40,  75, 30), channel("OP4_Sustain_Level"),   text("Sustain"),       range(0, 1, 0.5, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(620,  40,  75, 30), channel("OP4_Release_Level"),   text("Release"),       range(0, 1, 0.0, 1, 0.01), active(0)
        
        nslider  $WIDGET, $NSLIDER,  bounds(380,  80,  75, 30), channel("OP4_Attack_Time"),     text("Seconds"),       range(0, 100, 0.1, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(460,  80,  75, 30), channel("OP4_Decay_Time"),      text("Seconds"),       range(0, 100, 0.5, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(540,  80,  75, 30), channel("OP4_Sustain_Time"),    text("Seconds"),       range(0, 100, 0.3, 1, 0.01)
        nslider  $WIDGET, $NSLIDER,  bounds(620,  80,  75, 30), channel("OP4_Release_Time"),    text("Seconds"),       range(0, 100, 0.2, 1, 0.01)
    }
    

    ; LFO
    groupbox $GROUPBOX, bounds(710, 10, 225, 145), text("LFO") {
        nslider  $WIDGET, $NSLIDER,  bounds(10, 40,  75, 35), channel("LFO_Frequency"), text("Frequency"), range(0, 50, 2.5, 1, .01), valuePostfix(" Hz")
        checkbox $WIDGET, $CHECKBOX, bounds(10, 95, 140, 20), channel("LFO_Mod_Wheel"), text("Modulation Wheel"), value(0)
    }
    
    ; Chorus
    groupbox $GROUPBOX, bounds(710, 165, 225, 145), text("Chorus") {
        rslider $WIDGET, $RSLIDER, bounds( 10, 40, 75, 75), channel("Chorus_DryWet"),    text("Dry/Wet"),   range(0, 1, .3, 1, .01)
        
        nslider $WIDGET, $NSLIDER, bounds( 80, 40, 75, 30), channel("Chorus_Frequency"), text("Frequency [Hz]"), range(0, 25,   1.5, 1, 0.01)
        nslider $WIDGET, $NSLIDER, bounds(150, 40, 75, 30), channel("Chorus_Delay"),     text("Delay [ms]"),     range(0, 100, 30.0, 1, 0.1)
        nslider $WIDGET, $NSLIDER, bounds( 80, 80, 75, 30), channel("Chorus_Width"),     text("Width [ms]"),     range(0, 100,  1.8, 1, 0.1)
        nslider $WIDGET, $NSLIDER, bounds(150, 80, 75, 30), channel("Chorus_Feedback"),  text("Feedback"),  range(0, 1,    0,   1, 0.01)
    }
    
    ; Reverb
    groupbox $GROUPBOX, bounds(710, 320, 225, 145), text("Reverb") {
        rslider $WIDGET, $RSLIDER, bounds( 10, 40, 75, 75), channel("Reverb_DryWet"), text("Dry/Wet"), range(0,     1,   .3,  1, .01)
        rslider $WIDGET, $RSLIDER, bounds( 75, 40, 75, 75), channel("Reverb_Size"),   text("Size"),    range(0,     1,   .6,  1, .01)
        rslider $WIDGET, $RSLIDER, bounds(140, 40, 75, 75), channel("Reverb_CutOff"), text("Cut-Off"), range(0, 20000, 7000, .5, 100), valuePostfix(" Hz")
    }
    
    ; Output
    groupbox $GROUPBOX, bounds(710, 475, 225, 145), text("Output") {
        rslider $WIDGET, $RSLIDER, bounds(10,  30, 75, 75), channel("Output_Volume_Level"),   text("Volume"),   range(-24, 12, -6, 1, .1), valuePostfix(" dB")
        rslider $WIDGET, $RSLIDER, bounds(75,  30, 75, 75), channel("Output_Panorama_Level"), text("Panorama"), range(-1,   1,  0, 1, .01)
        
        nslider $WIDGET, $NSLIDER, bounds(10, 110, 75, 25), channel("Output_Level_LFO"),      text("LFO"),      range(0, 1, 0, 1, 0.01)
        nslider $WIDGET, $NSLIDER, bounds(75, 110, 75, 25), channel("Output_Panorama_LFO"),   text("LFO"),      range(0, 1, 0, 1, 0.01)
    }

    ;; VU Meters
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
        -n -d -+rtmidi=NULL -M0 --midi-key=4 --midi-velocity-amp=5
    </CsOptions>

    <CsInstruments>
        ; Initialize the global variables. 
        ksmps  = 32
        nchnls = 2
        0dbfs  = 1
                
        ; Connect instruments
        gk_LFO = 0
        
        connect "ToneGen", "Out_L",  "Reverb", "In_L"
        connect "ToneGen", "Out_R",  "Reverb", "In_R"
        
        connect "Reverb",  "Out_L",  "Output", "In_L"
        connect "Reverb",  "Out_R",  "Output", "In_R"
        
        alwayson "ReadChannels"
        alwayson "LFO"
        alwayson "Reverb"
        alwayson "Output"
        
        ;====================================================================
        ; FM Operator
        ;====================================================================
        opcode Operator, a, kk
            k_Frequency,
            k_Amplitude xin
            
            ; TODO
            a_Out = 0
             
            xout(a_Out)
        endop
                
        ;====================================================================
        ; Read channels into global variables (as this should be cheaper
        ; than repeatedly calling chnget for each played note)
        ;====================================================================
        instr ReadChannels
            i_Declick_ms            = 0.15
            
            ; TODO
            
            ;gk_Osc1_Type            =           chnget:k("Osc1_Type")
            ;gk_Osc1_Width           = lag(      chnget:k("Osc1_Width"),                                       i_Declick_ms)
            ;gk_Osc1_Transpose       = lag(      chnget:k("Osc1_Transpose"),                                   i_Declick_ms)
            ;gk_Osc1_Panorama        = lag(      chnget:k("Osc1_Panorama"),                                    i_Declick_ms)
            ;gk_Osc1_Volume          = lag(ampdb(chnget:k("Osc1_Volume")       * chnget:k("Osc1_Volume_X")),   i_Declick_ms)
            ;gk_Osc1_Detune          = lag(      chnget:k("Osc1_Detune")       * chnget:k("Osc1_Detune_X"),    i_Declick_ms)
            ;gk_Osc1_Attack          = lag(      chnget:k("Osc1_Attack")       * chnget:k("Osc1_Attack_X"),    i_Declick_ms)
            ;gk_Osc1_Decay           = lag(      chnget:k("Osc1_Decay")        * chnget:k("Osc1_Decay_X"),     i_Declick_ms)
            ;gk_Osc1_Sustain         = lag(      chnget:k("Osc1_Sustain")      * chnget:k("Osc1_Sustain_X"),   i_Declick_ms)
            ;gk_Osc1_Release         = lag(      chnget:k("Osc1_Release")      * chnget:k("Osc1_Release_X"),   i_Declick_ms)
            ;gk_Osc1_Filter_F        = lag(      chnget:k("Osc1_Filter_F")     * chnget:k("Osc1_Filter_F_X"),  i_Declick_ms)
            ;gk_Osc1_Filter_R        = lag(      chnget:k("Osc1_Filter_R")     * chnget:k("Osc1_Filter_R_X"),  i_Declick_ms)
            ;gk_Osc1_Filter_Order    =           chnget:k("Osc1_Filter_Order")
            ;gk_Osc1_Filter_Envelope = lag(      chnget:k("Osc1_Filter_Envelope"),                             i_Declick_ms)
            
            gk_LFO_Type             = lag(      chnget:k("LFO_Type"),                                         i_Declick_ms)
            gk_LFO_Frequency        = lag(      chnget:k("LFO_Frequency"),                                    i_Declick_ms)
            ;gk_LFO_Osc_Width        = lag(      chnget:k("LFO_Osc_Width"),                                    i_Declick_ms)
            ;gk_LFO_Osc_Volume       = lag(      chnget:k("LFO_Osc_Volume")    * chnget:k("LFO_Osc_Volume_X"), i_Declick_ms)
            ;gk_LFO_Osc_Panorama     = lag(      chnget:k("LFO_Osc_Panorama"),                                 i_Declick_ms)
            ;gk_LFO_Osc_Detune       = lag(      chnget:k("LFO_Osc_Detune")    * chnget:k("LFO_Osc_Detune_X"), i_Declick_ms)
            ;gk_LFO_Osc_Filter       = lag(      chnget:k("LFO_Osc_Filter")    * chnget:k("LFO_Osc_Filter_X"), i_Declick_ms)
            
            gk_Reverb_DryWet        = lag(      chnget:k("Reverb_DryWet"),                                    i_Declick_ms)
            gk_Reverb_Size          = lag(      chnget:k("Reverb_Size"),                                      i_Declick_ms)
            gk_Reverb_CutOff        = lag(      chnget:k("Reverb_CutOff"),                                    i_Declick_ms)
             
            gk_Global_Volume        = lag(ampdb(chnget:k("Global_Volume")),                                   i_Declick_ms)
        endin

        ;====================================================================
        ; Tone generator triggered by MIDI input
        ;
        ; Parameters:
        ;   p4 = MIDI note number
        ;   p5 = Amplitude
        ;
        ; Outputs:
        ;   Out_L = Left audio output
        ;   Out_R = Right audio output
        ;====================================================================
        instr ToneGen, 1
            ; TODO
            a_Out_L = 0
            a_Out_R = 0
            
            outleta("Out_L", a_Out_L)
            outleta("Out_R", a_Out_R)
        endin
        
        ;====================================================================
        ; Low Frequency Oscilator
        ;
        ; Generates an oscilating signal between [-1 … 1] and stores it in
        ; the global variable gk_LFO.
        ;====================================================================
        instr LFO            
            a_LFO_Sine     = lfo(1, gk_LFO_Frequency, 0)
            a_LFO_Triangle = lfo(1, gk_LFO_Frequency, 1)
            a_LFO_Square   = lfo(1, gk_LFO_Frequency, 2)
            a_LFO_Saw_Up   = lfo(1, gk_LFO_Frequency, 4)
            a_LFO_Saw_Down = lfo(1, gk_LFO_Frequency, 5)
            
            if gk_LFO_Type == 1 then        ; Sine
                a_Out = (a_LFO_Sine + 1) * .5
            elseif gk_LFO_Type == 2 then    ; Triangle
                a_Out = (a_LFO_Triangle + 1) * .5
            elseif gk_LFO_Type == 3 then    ; Square
                a_Out = (a_LFO_Square + 1) * .5
            elseif gk_LFO_Type == 4 then    ; Saw Up
                a_Out = a_LFO_Saw_Up
            elseif gk_LFO_Type == 5 then    ; Saw Down
                a_Out = a_LFO_Saw_Down
            endif
            
            gk_LFO = (k(a_Out) * 2) - 1
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

            k_Reverb_Amp = sqrt(gk_Reverb_DryWet)            ; Approximate equal-power
            k_In_Amp     = 1 - k_Reverb_Amp

            a_Out_L = (a_In_L * k_In_Amp) + (a_Reverb_L * k_Reverb_Amp)
            a_Out_R = (a_In_R * k_In_Amp) + (a_Reverb_R * k_Reverb_Amp)
            
            outleta("Out_L", a_Out_L)
            outleta("Out_R", a_Out_R)
        endin
        
        ;====================================================================
        ; Output stage
        ;
        ; Inputs:
        ;   In_L = Left audio input
        ;   In_R = Right audio input
        ;====================================================================
        instr Output
            ; Apply volume and output sound
            a_Out_L     = dcblock(inleta("In_L") * gk_Global_Volume)
            a_Out_R     = dcblock(inleta("In_R") * gk_Global_Volume)
            
            outs(a_Out_L, a_Out_R)
            
            ; Update VU meters with the current RMS
            k_RMS_L = rms(a_Out_L, 20)
            k_RMS_R = rms(a_Out_R, 20)
            
            cabbageSetValue "VU_L", portk(k_RMS_L * 10, .25), metro(10)
            cabbageSetValue "VU_R", portk(k_RMS_R * 10, .25), metro(10)
        endin
    </CsInstruments>
</CsoundSynthesizer>
