module Lib exposing (..)


type alias AudioContextGraph =
    List ( AudioNode, List String )


type AudioNode
    = GainNode Gain
    | OscillatorNode Oscillator


type GainProp
    = Volume Float


type OscProp
    = OscType Waveform
    | Frequency Float


type alias Gain =
    { id : String
    , props : List GainProp
    }


type alias Oscillator =
    { id : String
    , props : List OscProp
    }


type Waveform
    = Sawtooth
    | Square
    | Sine


gain : String -> List GainProp -> AudioNode
gain id props =
    GainNode
        { id = id
        , props = props
        }


osc : String -> List OscProp -> AudioNode
osc id props =
    OscillatorNode
        { id = id
        , props = props
        }


volume : Float -> GainProp
volume =
    Volume


oscType : Waveform -> OscProp
oscType =
    OscType


frequency : Float -> OscProp
frequency =
    Frequency
