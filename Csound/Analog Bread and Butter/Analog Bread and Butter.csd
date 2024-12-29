/**
 * Simple 2-Oscilator Synthesizer
 * ==============================
 *
 * Dec 23-28 2024: Dennis Schulmeister-Zimolong
 * First test to learn building software synthesizers with Cabbage + Csound.
 * Based on prior experiments from the past two years. :-)
 *
 * Csound Caveat
 * -------------
 *
 * https://github.com/csound/csound/issues/1557 - Some opcodes do not run at k-rate with functional syntax
 * chnget() doesn't run at k-rate, but chnget does. So does chnget:k().
 * And I wondered why playing notes would not pick up new values from the UI. :-)
 */
<Cabbage>
    ; HERE BE DRAGONS: Don't edit with the graphical GUI editor in Cabbage! It will garble the code (at least in version 2.8.162)
    form caption("Analog Bread & Butter") size(985, 570), guiMode("queue"), pluginId("ABnB"), colour(170, 0, 0)
    #define GROUPBOX colour(10, 10, 10), fontColour("white"), alpha(0.9)
    
    ; Oscilator 1
    groupbox bounds(10, 10, 900, 145), text("Oscilator 1"), $GROUPBOX {
        combobox bounds(10,   30, 75, 25), channel("Osc1_Type"),            items("---", "Sin", "Saw", "Square", "Triangle", "Ramp", "PWM"), value(3)
        nslider  bounds(10,   60, 75, 25), channel("Osc1_Width"),           text("Width"),     range(.01, .99,  .5, 1, .01), colour("(0,0,0,0)")
        nslider  bounds(10,  110, 75, 25), channel("Osc1_Transpose"),       text("Transpose"), range(-100, 100,  0, 1,   1), colour("(0,0,0,0)")
        
        rslider  bounds(105, 30, 75, 75),  channel("Osc1_Volume"),          range(-24, 12,    0, 1, .1),  valueTextBox(1), text("Volume"),   valuePostfix(" dB")
        rslider  bounds(170, 30, 75, 75),  channel("Osc1_Panorama"),        range(-1,   1, -.25, 1, .01), valueTextBox(1), text("Panorama")
        rslider  bounds(235, 30, 75, 75),  channel("Osc1_Detune"),          range(-1,   1,   0,  1, .01), valueTextBox(1), text("Detune")
        rslider  bounds(330, 30, 75, 75),  channel("Osc1_Attack"),          range( 0,   1,  .1,  1, .01), valueTextBox(1), text("Attack"),   valuePostfix(" sec")
        rslider  bounds(395, 30, 75, 75),  channel("Osc1_Decay"),           range( 0,   1,  .5,  1, .01), valueTextBox(1), text("Decay"),    valuePostfix(" sec")
        rslider  bounds(460, 30, 75, 75),  channel("Osc1_Sustain"),         range( 0,   1,  .5,  1, .01), valueTextBox(1), text("Sustain")
        rslider  bounds(525, 30, 75, 75),  channel("Osc1_Release"),         range( 0,   1,  .2,  1, .01), valueTextBox(1), text("Release"),  valuePostfix(" sec")
        rslider  bounds(620, 30, 75, 75),  channel("Osc1_Filter_F"),        range( 0,   1, .18, .5, .01), valueTextBox(1), text("Cut-Off")
        rslider  bounds(685, 30, 75, 75),  channel("Osc1_Filter_R"),        range( 0,   1,   0,  1, .01), valueTextBox(1), text("Resonance")
        
        nslider  bounds(105, 110, 75, 25), channel("Osc1_Volume_X"),        text("×"), value(1), colour("(0,0,0,0)")
        nslider  bounds(235, 110, 75, 25), channel("Osc1_Detune_X"),        text("×"), value(1), colour("(0,0,0,0)")
        nslider  bounds(330, 110, 75, 25), channel("Osc1_Attack_X"),        text("×"), value(1), colour("(0,0,0,0)")
        nslider  bounds(395, 110, 75, 25), channel("Osc1_Decay_X"),         text("×"), value(1), colour("(0,0,0,0)")
        nslider  bounds(460, 110, 75, 25), channel("Osc1_Sustain_X"),       text("×"), value(1), colour("(0,0,0,0)")
        nslider  bounds(525, 110, 75, 25), channel("Osc1_Release_X"),       text("×"), value(1), colour("(0,0,0,0)")
        nslider  bounds(620, 110, 75, 25), channel("Osc1_Filter_F_X"),      text("×"), value(1), colour("(0,0,0,0)")
        nslider  bounds(685, 110, 75, 25), channel("Osc1_Filter_R_X"),      text("×"), value(1), colour("(0,0,0,0)")
        
        combobox bounds(790,  30, 75, 25), channel("Osc1_Filter_Order"),    items("-6 dB", "-12 dB", "-18 dB", "-24 dB", "-30 dB", "-36 dB", "-42 dB", "-48 dB"), value(4)
        nslider  bounds(790,  60, 75, 25), channel("Osc1_Filter_Envelope"), text("Filter Envelope"), range(0, 1, 0, 1, .1), colour("(0,0,0,0)")
    }
    
    ; Oscilator 2
    groupbox bounds(10, 165, 900, 145), text("Oscilator 2"), $GROUPBOX {
        combobox bounds(10,   30, 75, 25), channel("Osc2_Type"),            items("---", "Sin", "Saw", "Square", "Triangle", "Ramp", "PWM"), value(2)
        nslider  bounds(10,   60, 75, 25), channel("Osc2_Width"),           text("Width"),     range( .01, .99, .5, 1, .01), colour("(0,0,0,0)")
        nslider  bounds(10,  110, 75, 25), channel("Osc2_Transpose"),       text("Transpose"), range(-100, 100,  0, 1,   1), colour("(0,0,0,0)")

        rslider  bounds(105, 30, 75, 75),  channel("Osc2_Volume"),          range(-24, 12,    0, 1, .1),  valueTextBox(1), text("Volume"),  valuePostfix(" dB")
        rslider  bounds(170, 30, 75, 75),  channel("Osc2_Panorama"),        range(-1,   1,  .25, 1, .01), valueTextBox(1), text("Panorama")
        rslider  bounds(235, 30, 75, 75),  channel("Osc2_Detune"),          range(-1,   1,  .1,  1, .01), valueTextBox(1), text("Detune")
        rslider  bounds(330, 30, 75, 75),  channel("Osc2_Attack"),          range( 0,   1,  .1,  1, .01), valueTextBox(1), text("Attack"),  valuePostfix(" sec")
        rslider  bounds(395, 30, 75, 75),  channel("Osc2_Decay"),           range( 0,   1,  .5,  1, .01), valueTextBox(1), text("Decay"),   valuePostfix(" sec")
        rslider  bounds(460, 30, 75, 75),  channel("Osc2_Sustain"),         range( 0,   1,  .5,  1, .01), valueTextBox(1), text("Sustain")
        rslider  bounds(525, 30, 75, 75),  channel("Osc2_Release"),         range( 0,   1,  .2,  1, .01), valueTextBox(1), text("Release"), valuePostfix(" sec")
        rslider  bounds(620, 30, 75, 75),  channel("Osc2_Filter_F"),        range( 0,   1, .28, .5, .01), valueTextBox(1), text("Cut-Off")
        rslider  bounds(685, 30, 75, 75),  channel("Osc2_Filter_R"),        range( 0,   1,   0,  1, .01), valueTextBox(1), text("Resonance")
        
        nslider  bounds(105, 110, 75, 25), channel("Osc2_Volume_X"),        text("×"), value(1), colour("(0,0,0,0)")
        nslider  bounds(235, 110, 75, 25), channel("Osc2_Detune_X"),        text("×"), value(1), colour("(0,0,0,0)")
        nslider  bounds(330, 110, 75, 25), channel("Osc2_Attack_X"),        text("×"), value(1), colour("(0,0,0,0)")
        nslider  bounds(395, 110, 75, 25), channel("Osc2_Decay_X"),         text("×"), value(1), colour("(0,0,0,0)")
        nslider  bounds(460, 110, 75, 25), channel("Osc2_Sustain_X"),       text("×"), value(1), colour("(0,0,0,0)")
        nslider  bounds(525, 110, 75, 25), channel("Osc2_Release_X"),       text("×"), value(1), colour("(0,0,0,0)")
        nslider  bounds(630, 110, 75, 25), channel("Osc2_Filter_F_X"),      text("×"), value(1), colour("(0,0,0,0)")
        nslider  bounds(685, 110, 75, 25), channel("Osc2_Filter_R_X"),      text("×"), value(1), colour("(0,0,0,0)")
        
        combobox bounds(790,  30, 75, 25), channel("Osc2_Filter_Order"),    items("-6 dB", "-12 dB", "-18 dB", "-24 dB", "-30 dB", "-36 dB", "-42 dB", "-48 dB"), value(4)
        nslider  bounds(790,  60, 75, 25), channel("Osc2_Filter_Envelope"), text("Filter Envelope"), range(0, 1, 0, 1, .1), colour("(0,0,0,0)")
    }
    
    ; Voice Mode
    groupbox bounds(10, 320, 195, 145), text("Voice Mode"), $GROUPBOX {
        combobox bounds(10, 30,  75, 25), channel("Mode_Type"),       items("Single", "Double", "Tripple"), value(1)
        nslider  bounds(20, 60,  75, 30), channel("Mode_1st_Detune"),   text("1st Detune"),   range(-100, 100,   .1, 1, .01), colour("(0,0,0,0)")
        nslider  bounds(85, 60,  75, 30), channel("Mode_1st_Panorama"), text("1st Panorama"), range(-1,   1,     .5, 1, .01), colour("(0,0,0,0)")
        nslider  bounds(20, 100, 75, 30), channel("Mode_2nd_Detune"),   text("2nd Detune"),   range(-100, 100, -0.1, 1, .01), colour("(0,0,0,0)")
        nslider  bounds(85, 100, 75, 30), channel("Mode_2nd_Panorama"), text("2nd Panorama"), range(-1,   1,   -0.5, 1, .01), colour("(0,0,0,0)")
    }
    
    ; LFO
    groupbox bounds(215, 320, 460, 145), text("LFO"), $GROUPBOX {
        combobox bounds(10,  30, 85, 25), channel("LFO_Type"), items("Sin", "Tri", "Square", "Saw Up", "Saw Down"), value(1)
        nslider  bounds(10,  60, 75, 25), channel("LFO_Frequency"), range(0, 50, 2.5, 1, .01), text("Frequency"), valuePostfix(" Hz"), colour("(0,0,0,0)")
        
        rslider  bounds(105, 30, 75, 75),  channel("LFO_Osc_Width"),    range(0, 1, 0, 1, .01), valueTextBox(1), text("Width")
        rslider  bounds(170, 30, 75, 75),  channel("LFO_Osc_Volume"),   range(0, 1, 0, 1, .01), valueTextBox(1), text("Volume")
        rslider  bounds(235, 30, 75, 75),  channel("LFO_Osc_Panorama"), range(0, 1, 0, 1, .01), valueTextBox(1), text("Panorama")
        rslider  bounds(300, 30, 75, 75),  channel("LFO_Osc_Detune"),   range(0, 1, 0, 1, .01), valueTextBox(1), text("Frequency")
        rslider  bounds(365, 30, 75, 75),  channel("LFO_Osc_Filter"),   range(0, 1, 0, 1, .01), valueTextBox(1), text("Filter")
        
        nslider  bounds(170, 110, 75, 25), channel("LFO_Osc_Volume_X"), text("×"), value(1),   colour("(0,0,0,0)")
        nslider  bounds(300, 110, 75, 25), channel("LFO_Osc_Detune_X"), text("×"), value(.01), colour("(0,0,0,0)")
        nslider  bounds(365, 110, 75, 25), channel("LFO_Osc_Filter_X"), text("×"), value(1),   colour("(0,0,0,0)")
    }
    
    ; Reverb
    groupbox bounds(685, 320, 225, 145), text("Reverb"), $GROUPBOX {
        rslider bounds(10,  30, 75, 75), channel("Reverb_DryWet"), range(0,     1,   .3,  1, .01), valueTextBox(1), text("Dry/Wet")
        rslider bounds(75,  30, 75, 75), channel("Reverb_Size"),   range(0,     1,   .6,  1, .01), valueTextBox(1), text("Size")
        rslider bounds(140, 30, 75, 75), channel("Reverb_CutOff"), range(0, 20000, 7000, .5, 100), valueTextBox(1), text("Cut-Off"), valuePostfix(" Hz")
    }

    ; VU Meters and global volume
    vmeter bounds(935, 10, 10, 415) channel("VU_L") value(0) outlineColour(0, 0, 0), overlayColour(0, 0, 0) meterColour:0(255, 0, 0) meterColour:1(255, 255, 0) meterColour:2(0, 255, 0) outlineThickness(1) 
    vmeter bounds(950, 10, 10, 415) channel("VU_R") value(0) outlineColour(0, 0, 0), overlayColour(0, 0, 0) meterColour:0(255, 0, 0) meterColour:1(255, 255, 0) meterColour:2(0, 255, 0) outlineThickness(1) 
    
    nslider bounds(915, 435, 60, 25), channel("Global_Volume"), text("Volume"), range(-24, 12, -6, 1, .1), valueTextBox(1), text("Volume"), valuePostfix(" dB"), colour("(0,0,0,0)")
    
    ; Virtual Keyboard
    keyboard bounds(0, 475, 985, 95), value(23)
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
        ; Variable order low-pass filter
        ;====================================================================
        opcode LowPassFilter, a, akkk
            a_In,
            k_Frequency,
            k_Resonance,
            k_Order xin
            
            a6, a12, a18, a24 mvclpf4 a_In, k_Frequency, k_Resonance
            
            if k_Order == 1 then        ; -6 dB
                a_Out = a6
            elseif k_Order == 2 then    ; -12 dB
                a_Out = a12
            elseif k_Order == 3 then    ; -18 dB
                a_Out = a18
            elseif k_Order == 4 then    ; -24 dB
                a_Out = a24
            endif
            
            if k_Order >= 5 then
                a6, a12, a18, a24 mvclpf4 a24, k_Frequency, k_Resonance
            endif
            
            if k_Order == 5 then        ; -30 dB
                a_Out = a6
            elseif k_Order == 6 then    ; -36 dB
                a_Out = a12
            elseif k_Order == 7 then    ; -42 dB
                a_Out = a18
            elseif k_Order == 8 then    ; -48 dB
                a_Out = a24
            endif
            
            xout(a_Out)
        endop
        
        ;====================================================================
        ; Custom oscilator with panning and envelope
        ;====================================================================
        opcode Oscilator, aa, kkkkkiiiikkkkkkkkkk
            k_Frequency,
            k_Amplitude,
            k_Panorama,
            i_Type,
            k_Width,
            i_Attack,
            i_Decay,
            i_Sustain,
            i_Release,
            k_Filter_F,
            k_Filter_R,
            k_Filter_Order,
            k_Filter_Envelope,
            k_LFO,
            k_LFO_Width,
            k_LFO_Volume,
            k_LFO_Panorama,
            k_LFO_Detune,
            k_LFO_Filter xin
            
            k_Amplitude = max(k_Amplitude + (k_Amplitude * k_LFO * k_LFO_Volume), 0)        ; Amplitude LFO
            k_Frequency = max(k_Frequency + (k_Frequency * k_LFO * k_LFO_Detune), 0)        ; Frequency LFO
            
            if i_Type == 1 then            ; ---
            elseif i_Type == 2 then        ; Sin
                a_Out = oscili(k_Amplitude, k_Frequency)
            else
                if i_Type == 3 then        ; Saw
                    i_Type = 0
                elseif i_Type == 4 then    ; Squr
                    i_Type = 10
                elseif i_Type == 5 then    ; Tri
                    i_Type = 12
                elseif i_Type == 6 then    ; Ramp
                    i_Type = 4    
                elseif i_Type == 7 then    ; PWM
                    i_Type = 2
                endif
                
                k_Width = k_Width + (k_Width * k_LFO * k_LFO_Width)                         ; Width LFO
                k_Width = min(max(k_Width, 0.01), 0.99)
                
                a_Out = vco2(k_Amplitude, k_Frequency, i_Type, k_Width)
            endif

            k_Envelope = madsr(i_Attack, i_Decay, i_Sustain, i_Release)
            
            k_Filter_F = max(k_Filter_F + (k_Filter_F * k_LFO * k_LFO_Filter), 0)           ; Filter LFO
            k_Filter_F = k_Frequency * sqrt(k_Filter_F) * 10
            
            k_Filter_E = k_Filter_F * k_Envelope * k_Filter_Envelope                        ; Filter Envelope
            k_Filter_F = (k_Filter_F * (1 - k_Filter_Envelope)) + k_Filter_E
            
            a_Out      = LowPassFilter(a_Out, k_Filter_F, k_Filter_R, k_Filter_Order)       ; Filter
            a_Out      = a_Out * k_Envelope                                                 ; Amplitude ADSR
            
            k_Panorama = (k_Panorama / 2) + .5
            k_Panorama = k_Panorama + (k_Panorama * k_LFO * k_LFO_Panorama)                 ; Panorama LFO
            k_Panorama = max(min(k_Panorama, 1), 0)
            a_Out_L, a_Out_R pan2 a_Out, k_Panorama, 1                                      ; Mode 0 = Equal Power, 1 = Square-Root, 2 = Linear, 3 = Alternative Equal Power
                        
            xout(a_Out_L, a_Out_R)
        endop
                
        ;====================================================================
        ; Read channels into global variables (as this should be cheaper
        ; than repeatedly calling chnget for each played note)
        ;====================================================================
        instr ReadChannels
            i_Declick_ms            = 0.15
            
            gk_Osc1_Type            =           chnget:k("Osc1_Type")
            gk_Osc1_Width           = lag(      chnget:k("Osc1_Width"),                                       i_Declick_ms)
            gk_Osc1_Transpose       = lag(      chnget:k("Osc1_Transpose"),                                   i_Declick_ms)
            gk_Osc1_Panorama        = lag(      chnget:k("Osc1_Panorama"),                                    i_Declick_ms)
            gk_Osc1_Volume          = lag(ampdb(chnget:k("Osc1_Volume")       * chnget:k("Osc1_Volume_X")),   i_Declick_ms)
            gk_Osc1_Detune          = lag(      chnget:k("Osc1_Detune")       * chnget:k("Osc1_Detune_X"),    i_Declick_ms)
            gk_Osc1_Attack          = lag(      chnget:k("Osc1_Attack")       * chnget:k("Osc1_Attack_X"),    i_Declick_ms)
            gk_Osc1_Decay           = lag(      chnget:k("Osc1_Decay")        * chnget:k("Osc1_Decay_X"),     i_Declick_ms)
            gk_Osc1_Sustain         = lag(      chnget:k("Osc1_Sustain")      * chnget:k("Osc1_Sustain_X"),   i_Declick_ms)
            gk_Osc1_Release         = lag(      chnget:k("Osc1_Release")      * chnget:k("Osc1_Release_X"),   i_Declick_ms)
            gk_Osc1_Filter_F        = lag(      chnget:k("Osc1_Filter_F")     * chnget:k("Osc1_Filter_F_X"),  i_Declick_ms)
            gk_Osc1_Filter_R        = lag(      chnget:k("Osc1_Filter_R")     * chnget:k("Osc1_Filter_R_X"),  i_Declick_ms)
            gk_Osc1_Filter_Order    =           chnget:k("Osc1_Filter_Order")
            gk_Osc1_Filter_Envelope = lag(      chnget:k("Osc1_Filter_Envelope"),                             i_Declick_ms)
            
            gk_Osc2_Type            =           chnget:k("Osc2_Type")
            gk_Osc2_Width           = lag(      chnget:k("Osc2_Width"),                                       i_Declick_ms)
            gk_Osc2_Transpose       = lag(      chnget:k("Osc2_Transpose"),                                   i_Declick_ms)
            gk_Osc2_Panorama        = lag(      chnget:k("Osc2_Panorama"),                                    i_Declick_ms)
            gk_Osc2_Volume          = lag(ampdb(chnget:k("Osc2_Volume")       * chnget:k("Osc2_Volume_X")),   i_Declick_ms)
            gk_Osc2_Detune          = lag(      chnget:k("Osc2_Detune")       * chnget:k("Osc2_Detune_X"),    i_Declick_ms)
            gk_Osc2_Attack          = lag(      chnget:k("Osc2_Attack")       * chnget:k("Osc2_Attack_X"),    i_Declick_ms)
            gk_Osc2_Decay           = lag(      chnget:k("Osc2_Decay")        * chnget:k("Osc2_Decay_X"),     i_Declick_ms)
            gk_Osc2_Sustain         = lag(      chnget:k("Osc2_Sustain")      * chnget:k("Osc2_Sustain_X"),   i_Declick_ms)
            gk_Osc2_Release         = lag(      chnget:k("Osc2_Release")      * chnget:k("Osc2_Release_X"),   i_Declick_ms)
            gk_Osc2_Filter_F        = lag(      chnget:k("Osc2_Filter_F")     * chnget:k("Osc2_Filter_F_X"),  i_Declick_ms)
            gk_Osc2_Filter_R        = lag(      chnget:k("Osc2_Filter_R")     * chnget:k("Osc2_Filter_R_X"),  i_Declick_ms)
            gk_Osc2_Filter_Order    =           chnget:k("Osc2_Filter_Order")
            gk_Osc2_Filter_Envelope = lag(      chnget:k("Osc2_Filter_Envelope"),                             i_Declick_ms)
            
            gk_Mode_Type            =           chnget:k("Mode_Type")
            gk_Mode_1st_Detune      = lag(      chnget:k("Mode_1st_Detune"),                                  i_Declick_ms)
            gk_Mode_1st_Panorama    = lag(      chnget:k("Mode_1st_Panorama"),                                i_Declick_ms)
            gk_Mode_2nd_Detune      = lag(      chnget:k("Mode_2nd_Detune"),                                  i_Declick_ms)
            gk_Mode_2nd_Panorama    = lag(      chnget:k("Mode_2nd_Panorama"),                                i_Declick_ms)
            
            gk_LFO_Type             = lag(      chnget:k("LFO_Type"),                                         i_Declick_ms)
            gk_LFO_Frequency        = lag(      chnget:k("LFO_Frequency"),                                    i_Declick_ms)
            gk_LFO_Osc_Width        = lag(      chnget:k("LFO_Osc_Width"),                                    i_Declick_ms)
            gk_LFO_Osc_Volume       = lag(      chnget:k("LFO_Osc_Volume")    * chnget:k("LFO_Osc_Volume_X"), i_Declick_ms)
            gk_LFO_Osc_Panorama     = lag(      chnget:k("LFO_Osc_Panorama"),                                 i_Declick_ms)
            gk_LFO_Osc_Detune       = lag(      chnget:k("LFO_Osc_Detune")    * chnget:k("LFO_Osc_Detune_X"), i_Declick_ms)
            gk_LFO_Osc_Filter       = lag(      chnget:k("LFO_Osc_Filter")    * chnget:k("LFO_Osc_Filter_X"), i_Declick_ms)
            
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
            k_Osc1_Frequency = cpsmidinn(p4 + gk_Osc1_Detune + gk_Osc1_Transpose)
            k_Osc1_Volume    = gk_Osc1_Volume * p5
            k_Osc1_Panorama  = gk_Osc1_Panorama
            k_Osc2_Frequency = cpsmidinn(p4 + gk_Osc2_Detune + gk_Osc2_Transpose)
            k_Osc2_Volume    = gk_Osc2_Volume * p5
            k_Osc2_Panorama  = gk_Osc2_Panorama
            
            ; Base oscilators
            a_Osc1_L, a_Osc1_R    Oscilator    k_Osc1_Frequency, k_Osc1_Volume, k_Osc1_Panorama, i(gk_Osc1_Type), gk_Osc1_Width, \
                                               i(gk_Osc1_Attack), i(gk_Osc1_Decay), i(gk_Osc1_Sustain), i(gk_Osc1_Release), \
                                               gk_Osc1_Filter_F, gk_Osc1_Filter_R, gk_Osc1_Filter_Order, gk_Osc1_Filter_Envelope, \
                                               gk_LFO, gk_LFO_Osc_Width, gk_LFO_Osc_Volume, gk_LFO_Osc_Panorama, gk_LFO_Osc_Detune, gk_LFO_Osc_Filter
                                               
            a_Osc2_L, a_Osc2_R    Oscilator    k_Osc2_Frequency, k_Osc2_Volume, k_Osc2_Panorama, i(gk_Osc2_Type), gk_Osc2_Width, \
                                               i(gk_Osc2_Attack), i(gk_Osc2_Decay), i(gk_Osc2_Sustain), i(gk_Osc2_Release), \
                                               gk_Osc2_Filter_F, gk_Osc2_Filter_R, gk_Osc2_Filter_Order, gk_Osc2_Filter_Envelope, \
                                               gk_LFO, gk_LFO_Osc_Width, gk_LFO_Osc_Volume, gk_LFO_Osc_Panorama, gk_LFO_Osc_Detune, gk_LFO_Osc_Filter

            a_Out_L     = a_Osc1_L + a_Osc2_L
            a_Out_R     = a_Osc1_R + a_Osc2_R
            k_Out_Scale = 1 / 2
            
            if gk_Mode_Type >= 2 then   ; Double Mode
                k_Out_Scale = 1 / 2.5   ; Normaly 1/4, but we make up a little bit for the comb-filtering
                
                k_Osc1_Frequency = cpsmidinn(p4 + gk_Osc1_Detune + gk_Osc1_Transpose + gk_Mode_1st_Detune)
                k_Osc2_Frequency = cpsmidinn(p4 + gk_Osc2_Detune + gk_Osc2_Transpose + gk_Mode_1st_Detune)
                k_Osc1_Panorama  = gk_Osc1_Panorama + gk_Mode_1st_Panorama
                k_Osc2_Panorama  = gk_Osc2_Panorama + gk_Mode_1st_Panorama
                
                a_Osc1_L, a_Osc1_R    Oscilator    k_Osc1_Frequency, k_Osc1_Volume, k_Osc1_Panorama, i(gk_Osc1_Type), gk_Osc1_Width, \
                                                   i(gk_Osc1_Attack), i(gk_Osc1_Decay), i(gk_Osc1_Sustain), i(gk_Osc1_Release), \
                                                   gk_Osc1_Filter_F, gk_Osc1_Filter_R, gk_Osc1_Filter_Order, gk_Osc1_Filter_Envelope, \
                                                   gk_LFO, gk_LFO_Osc_Width, gk_LFO_Osc_Volume, gk_LFO_Osc_Panorama, gk_LFO_Osc_Detune, gk_LFO_Osc_Filter
                                               
                a_Osc2_L, a_Osc2_R    Oscilator    k_Osc2_Frequency, k_Osc2_Volume, k_Osc2_Panorama, i(gk_Osc2_Type), gk_Osc2_Width, \
                                                   i(gk_Osc2_Attack), i(gk_Osc2_Decay), i(gk_Osc2_Sustain), i(gk_Osc2_Release), \
                                                   gk_Osc2_Filter_F, gk_Osc2_Filter_R, gk_Osc2_Filter_Order, gk_Osc2_Filter_Envelope, \
                                                   gk_LFO, gk_LFO_Osc_Width, gk_LFO_Osc_Volume, gk_LFO_Osc_Panorama, gk_LFO_Osc_Detune, gk_LFO_Osc_Filter
            
                a_Out_L = a_Out_L + a_Osc1_L + a_Osc2_L
                a_Out_R = a_Out_R + a_Osc1_R + a_Osc2_R
            endif
            
            if gk_Mode_Type >= 3 then   ; Trippple Mode
                k_Out_Scale = 1 / 3     ; Normaly 1/6, but we make up a little bit for the comb-filtering
                
                k_Osc1_Frequency = cpsmidinn(p4 + gk_Osc1_Detune + gk_Osc1_Transpose + gk_Mode_2nd_Detune)
                k_Osc2_Frequency = cpsmidinn(p4 + gk_Osc2_Detune + gk_Osc2_Transpose + gk_Mode_2nd_Detune)
                k_Osc1_Panorama  = gk_Osc1_Panorama + gk_Mode_2nd_Panorama
                k_Osc2_Panorama  = gk_Osc2_Panorama + gk_Mode_2nd_Panorama
                
                a_Osc1_L, a_Osc1_R    Oscilator    k_Osc1_Frequency, k_Osc1_Volume, k_Osc1_Panorama, i(gk_Osc1_Type), gk_Osc1_Width, \
                                                   i(gk_Osc1_Attack), i(gk_Osc1_Decay), i(gk_Osc1_Sustain), i(gk_Osc1_Release), \
                                                   gk_Osc1_Filter_F, gk_Osc1_Filter_R, gk_Osc1_Filter_Order, gk_Osc1_Filter_Envelope, \
                                                   gk_LFO, gk_LFO_Osc_Width, gk_LFO_Osc_Volume, gk_LFO_Osc_Panorama, gk_LFO_Osc_Detune, gk_LFO_Osc_Filter
                                               
                a_Osc2_L, a_Osc2_R    Oscilator    k_Osc2_Frequency, k_Osc2_Volume, k_Osc2_Panorama, i(gk_Osc2_Type), gk_Osc2_Width, \
                                                   i(gk_Osc2_Attack), i(gk_Osc2_Decay), i(gk_Osc2_Sustain), i(gk_Osc2_Release), \
                                                   gk_Osc2_Filter_F, gk_Osc2_Filter_R, gk_Osc2_Filter_Order, gk_Osc2_Filter_Envelope, \
                                                   gk_LFO, gk_LFO_Osc_Width, gk_LFO_Osc_Volume, gk_LFO_Osc_Panorama, gk_LFO_Osc_Detune, gk_LFO_Osc_Filter
            
                a_Out_L = a_Out_L + a_Osc1_L + a_Osc2_L
                a_Out_R = a_Out_R + a_Osc1_R + a_Osc2_R
            endif
            
            ; Csound Bug? If the math is done inside outleta(), the right channel will be silent?
            a_Out_L = a_Out_L * k_Out_Scale
            a_Out_R = a_Out_R * k_Out_Scale
            
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
