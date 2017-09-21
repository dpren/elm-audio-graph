module Lib exposing (..)

import Murmur3


type alias AudioGraph =
    List AudioNode


type AudioNode
    = Gain GainParams NodeEdges
    | Oscillator OscillatorParams NodeEdges
    | Filter BiquadFilterParams NodeEdges
    | Delay DelayParams NodeEdges


type alias NodeEdges =
    List (NodePort NodeId)



--


type alias NodeId =
    String


type AudioInput
    = AudioInput


type Waveform
    = Sine
    | Square
    | Sawtooth
    | Triangle


type FilterMode
    = Lowpass
    | Highpass
    | Bandpass
    | Lowshelf
    | Highshelf
    | Peaking
    | Notch
    | Allpass



-------- Node Constructors --------


{-| <https://developer.mozilla.org/en-US/docs/Web/API/GainNode>
-}
type alias GainParams =
    { input : AudioInput
    , volume : Float
    }


gainParams : GainParams
gainParams =
    { input = AudioInput
    , volume = 1
    }


{-| <https://developer.mozilla.org/en-US/docs/Web/API/OscillatorNode>
-}
type alias OscillatorParams =
    { waveform : Waveform
    , frequency : Float
    , detune : Float
    }


oscillatorParams : OscillatorParams
oscillatorParams =
    { waveform = Sine
    , frequency = 440
    , detune = 0
    }


{-| <https://developer.mozilla.org/en-US/docs/Web/API/BiquadFilterNode>
-}
type alias BiquadFilterParams =
    { input : AudioInput
    , mode : FilterMode
    , frequency : Float
    , q : Float
    , detune : Float
    }


filterParams : BiquadFilterParams
filterParams =
    { input = AudioInput
    , mode = Lowpass
    , frequency = 350
    , q = 1
    , detune = 0
    }


{-| <https://developer.mozilla.org/en-US/docs/Web/API/DelayNode>
-}
type alias DelayParams =
    { delayTime : Float
    , maxDelayTime : Float
    }


delayParams : DelayParams
delayParams =
    { delayTime = 0
    , maxDelayTime = 0
    }



-------- Param Ports --------


type NodePort id
    = Output
    | Input id
    | Volume id
    | Frequency id
    | Detune id
    | Q id
    | DelayTime id


input : { a | input : AudioInput } -> NodePort NodeId
input a =
    Input (toHashString a)


volume : { a | volume : Float } -> NodePort NodeId
volume a =
    Volume (toHashString a)


frequency : { a | frequency : Float } -> NodePort NodeId
frequency a =
    Frequency (toHashString a)


detune : { a | detune : Float } -> NodePort NodeId
detune a =
    Detune (toHashString a)


q : { a | q : Float } -> NodePort NodeId
q a =
    Q (toHashString a)


delayTime : { a | delayTime : Float } -> NodePort NodeId
delayTime a =
    DelayTime (toHashString a)



--


toHashString : a -> NodeId
toHashString =
    toString >> Murmur3.hashString 0 >> toString
