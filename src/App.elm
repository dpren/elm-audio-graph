module App exposing (Model, Msg(..), audioGraph, init, main, subscriptions, update, view)

import Browser
import Browser.Events exposing (onMouseMove)
import Encode exposing (updateAudioGraph)
import Html exposing (Html, br, div, text)
import Json.Decode
import Lib exposing (..)


audioGraph : Model -> AudioGraph
audioGraph model =
    let
        lfo =
            oscillatorParams 0 { oscillatorDefaults | frequency = model.y / 100 }

        lfoGain =
            gainParams 1 { gainDefaults | volume = model.y }

        saw =
            oscillatorParams 2 { oscillatorDefaults | waveform = Sawtooth, frequency = model.x }

        lowpass =
            filterParams 3 { filterDefaults | frequency = 900, q = 10 }

        master =
            gainParams 4 { gainDefaults | volume = model.y * 0.001 }
    in
    [ Oscillator lfo [ input lfoGain ]
    , Gain lfoGain [ frequency lowpass ]
    , Oscillator saw [ input lowpass ]
    , Filter lowpass [ input master ]
    , Gain master [ Output ]
    ]



----- PROGRAM ----


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { x : Float
    , y : Float
    }


type alias Flags =
    ()


init : Flags -> ( Model, Cmd Msg )
init =
    always ( { x = 0, y = 0 }, Cmd.none )



-- UPDATE


type Msg
    = Position Int Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Position x y ->
            ( { model | x = toFloat x, y = toFloat y }
            , updateAudioGraph (audioGraph model)
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    onMouseMove
        (Json.Decode.map2 Position
            (Json.Decode.field "clientX" Json.Decode.int)
            (Json.Decode.field "clientY" Json.Decode.int)
        )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ div [] [ text ("x: " ++ String.fromFloat model.x ++ "  y: " ++ String.fromFloat model.y) ]
        , br [] []
        , div []
            (List.map
                (\node -> div [] [ text (nodeToString node) ])
                (audioGraph model)
            )
        ]
