module Encode exposing (..)

import Json.Encode exposing (Value, list, object, string, float)
import Lib exposing (..)


encodeGraph : AudioContextGraph -> Value
encodeGraph =
    object << List.map encodeNode


encodeNode : ( AudioNode, List String ) -> ( String, Value )
encodeNode ( node, edges ) =
    nodePatternMatch edges <|
        case node of
            GainNode gainNode ->
                ( gainNode.id, "gain", encodeGainProps gainNode )

            OscillatorNode oscNode ->
                ( oscNode.id, "oscillator", encodeOscProps oscNode )

            BiquadFilterNode filterNode ->
                ( filterNode.id, "biquadFilter", encodeFilterProps filterNode )


nodePatternMatch : List String -> ( String, String, Value ) -> ( String, Value )
nodePatternMatch edges ( id, apiName, encodedNodeProps ) =
    ( id
    , list [ string apiName, encodeEdges edges, encodedNodeProps ]
    )


encodeEdges : List String -> Value
encodeEdges =
    list << List.map string


encodeGainProps : GainProps -> Value
encodeGainProps node =
    object
        [ ( "gain", float node.volume ) ]


encodeOscProps : OscillatorProps -> Value
encodeOscProps node =
    object
        [ ( "type", toLowerStringValue node.waveform )
        , ( "frequency", float node.frequency )
        ]


encodeFilterProps : BiquadFilterProps -> Value
encodeFilterProps node =
    object
        [ ( "type", toLowerStringValue node.mode )
        , ( "frequency", float node.frequency )
        , ( "Q", float node.q )
        , ( "detune", float node.detune )
        ]


toLowerStringValue =
    string << String.toLower << toString
