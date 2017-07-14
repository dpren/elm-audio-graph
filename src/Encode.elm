module Encode exposing (..)

import Json.Encode exposing (Value, list, object, string, float)
import Lib exposing (..)


encodeGraph : AudioContextGraph -> Value
encodeGraph =
    object << List.indexedMap encodeNode


encodeNode : Int -> ( AudioNode, List String ) -> ( String, Value )
encodeNode index ( node, edges ) =
    nodePatternMatch index edges <|
        case node of
            GainNode gainNode ->
                ( gainNode.id, "gain", encodeGainProps gainNode )

            OscillatorNode oscNode ->
                ( oscNode.id, "oscillator", encodeOscProps oscNode )

            BiquadFilterNode filterNode ->
                ( filterNode.id, "biquadFilter", encodeFilterProps filterNode )

            PannerNode pannerNode ->
                ( pannerNode.id, "panner", encodePannerProps pannerNode )


nodePatternMatch : Int -> List String -> ( String, String, Value ) -> ( String, Value )
nodePatternMatch index edges ( id, apiName, encodedNodeProps ) =
    let
        uid =
            -- allows unnamed nodes until we can implement proper validattion
            if id == "__default" then
                (id ++ (toString index))
            else
                id
    in
        ( uid
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
        , ( "detune", float node.detune )
        ]


encodeFilterProps : BiquadFilterProps -> Value
encodeFilterProps node =
    object
        [ ( "type", toLowerStringValue node.mode )
        , ( "frequency", float node.frequency )
        , ( "Q", float node.q )
        , ( "detune", float node.detune )
        ]


encodePannerProps : PannerProps -> Value
encodePannerProps node =
    object
        [ ( "distanceModel", toLowerStringValue node.distanceModel )
        , ( "panningModel", toLowerStringValue node.panningModel )
        , ( "refDistance", float node.refDistance )
        , ( "maxDistance", float node.maxDistance )
        , ( "rolloffFactor", float node.rolloffFactor )
        , ( "coneInnerAngle", float node.coneInnerAngle )
        , ( "coneOuterAngle", float node.coneOuterAngle )
        , ( "coneOuterGain", float node.coneOuterGain )
        , ( "position", list <| List.map float node.position )
        , ( "orientation", list <| List.map float node.orientation )
        ]


toLowerStringValue =
    string << String.toLower << toString
