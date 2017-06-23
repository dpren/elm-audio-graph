port module App exposing (..)

import Html exposing (Html, text, div)
import Json.Encode exposing (Value)
import Lib exposing (..)
import Encode exposing (encodeGraph)


---- PORT ----


port renderContextJs : Value -> Cmd msg



---- AUDIO GRAPH ----


jsAudioGraph =
    encodeGraph audioGraph


audioGraph : AudioContextGraph
audioGraph =
    [ ( osc "osc1" [ oscType Sine, frequency 440 ], [ "gain1" ] )
    , ( osc "osc2" [ oscType Sawtooth, frequency 220 ], [ "gain2" ] )
    , ( gain "gain1" [ volume 0.03 ], [ "output" ] )
    , ( gain "gain2" [ volume 0.01 ], [ "output" ] )
    ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        }


view : Model -> Html Msg
view model =
    div []
        [ div [] [ text model.message ]
        , div [] [ text (toString audioGraph) ]
        ]


type alias Model =
    { message : String }


init : ( Model, Cmd Msg )
init =
    ( { message = "audio node graph:" }, (renderContextJs jsAudioGraph) )


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )
