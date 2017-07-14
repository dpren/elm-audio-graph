module Lib exposing (..)


type Waveform
    = Sawtooth
    | Square
    | Sine


type FilterMode
    = Lowpass
    | Highpass
    | Bandpass
    | Lowshelf
    | Highshelf
    | Peaking
    | Notch
    | Allpass


type alias AudioContextGraph =
    List ( AudioNode, List String )


type AudioNode
    = GainNode GainProps
    | OscillatorNode OscillatorProps
    | BiquadFilterNode BiquadFilterProps


type alias GainProps =
    { id : String
    , volume : Float
    }


type alias OscillatorProps =
    { id : String
    , waveform : Waveform
    , frequency : Float
    }


type alias BiquadFilterProps =
    { id : String
    , mode : FilterMode
    , frequency : Float
    , q : Float
    , detune : Float
    }


gainDefaults : GainProps
gainDefaults =
    { id = "def_gain"
    , volume = 1
    }


oscDefaults : OscillatorProps
oscDefaults =
    { id = "def_osc"
    , waveform = Sine
    , frequency = 400
    }


filterDefaults : BiquadFilterProps
filterDefaults =
    { id = "def_filter"
    , mode = Lowpass
    , frequency = 400
    , q = 1
    , detune = 0
    }


gain : GainProps -> AudioNode
gain = GainNode


osc : OscillatorProps -> AudioNode
osc = OscillatorNode


filter : BiquadFilterProps -> AudioNode
filter = BiquadFilterNode
