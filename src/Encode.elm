module Encode exposing (..)

import Json.Encode exposing (Value, list, object, string, float)
import Lib exposing (..)


encodeGraph : AudioContextGraph -> Value
encodeGraph =
    object << List.map encodeNode


encodeNode : ( AudioNode, List String ) -> ( String, Value )
encodeNode ( node, edges ) =
    case node of
        GainNode gainNode ->
            gainPatternMatch gainNode edges

        OscillatorNode oscNode ->
            oscPatternMatch oscNode edges


gainPatternMatch : Gain -> List String -> ( String, Value )
gainPatternMatch node edges =
    ( node.id
    , list [ string "gain", encodeEdges edges, encodeGainProps node.props ]
    )


oscPatternMatch : Oscillator -> List String -> ( String, Value )
oscPatternMatch node edges =
    ( node.id
    , list [ string "oscillator", encodeEdges edges, encodeOscProps node.props ]
    )


encodeEdges : List String -> Value
encodeEdges =
    list << List.map string


encodeGainProps : List GainProp -> Value
encodeGainProps =
    object
        << List.map
            (\prop ->
                case prop of
                    Volume vol ->
                        ( "gain", float vol )
            )


encodeOscProps : List OscProp -> Value
encodeOscProps =
    object
        << List.map
            (\prop ->
                case prop of
                    OscType wave ->
                        ( "type", string <| String.toLower <| toString wave )

                    Frequency freq ->
                        ( "frequency", float freq )
            )
