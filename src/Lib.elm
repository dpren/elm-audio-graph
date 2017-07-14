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


type DistanceModel
    = Linear
    | Inverse
    | Exponential


type PanningModel
    = Equalpower
    | HRTF


type alias AudioContextGraph =
    List ( AudioNode, List String )


type AudioNode
    = GainNode GainProps
    | OscillatorNode OscillatorProps
    | BiquadFilterNode BiquadFilterProps
    | PannerNode PannerProps


type alias GainProps =
    { id : String
    , volume : Float
    }


type alias OscillatorProps =
    { id : String
    , waveform : Waveform
    , frequency : Float
    , detune : Float
    }


type alias BiquadFilterProps =
    { id : String
    , mode : FilterMode
    , frequency : Float
    , q : Float
    , detune : Float
    }


type alias PannerProps =
    { id : String
    , distanceModel : DistanceModel
    , panningModel : PanningModel
    , refDistance : Float
    , maxDistance : Float
    , rolloffFactor : Float
    , coneInnerAngle : Float
    , coneOuterAngle : Float
    , coneOuterGain : Float
    , position : List Float
    , orientation : List Float
    }


gainDefaults : GainProps
gainDefaults =
    { id = "__default"
    , volume = 1
    }


oscDefaults : OscillatorProps
oscDefaults =
    { id = "__default"
    , waveform = Sine
    , frequency = 400
    , detune = 0
    }


filterDefaults : BiquadFilterProps
filterDefaults =
    { id = "__default"
    , mode = Lowpass
    , frequency = 400
    , q = 1
    , detune = 0
    }


pannerDefaults : PannerProps
pannerDefaults =
    { id = "__default"
    , distanceModel = Inverse
    , panningModel = HRTF
    , refDistance = 1
    , maxDistance = 10000
    , rolloffFactor = 1
    , coneInnerAngle = 360
    , coneOuterAngle = 0
    , coneOuterGain = 0
    , position = [ 0, 0, 0 ]
    , orientation = [ 1, 0, 0 ]
    }


gain : GainProps -> AudioNode
gain =
    GainNode


osc : OscillatorProps -> AudioNode
osc =
    OscillatorNode


filter : BiquadFilterProps -> AudioNode
filter =
    BiquadFilterNode


panner : PannerProps -> AudioNode
panner =
    PannerNode
