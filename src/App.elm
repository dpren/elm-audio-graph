port module App exposing (..)

import Html exposing (Html, text, div)
import Json.Encode exposing (Value)
import Lib exposing (..)
import Encode exposing (encodeGraph)
import Mouse exposing (Position)


---- PORT ----


port renderContextJs : Value -> Cmd msg



---- AUDIO GRAPH ----


renderAudioGraph : Model -> Cmd msg
renderAudioGraph =
    renderContextJs << encodeGraph << audioGraph


audioGraph : Model -> AudioContextGraph
audioGraph model =
    [ ( osc { oscDefaults | id = "osc1", waveform = Sine, frequency = model.x }, [ "panL" ] )
    , ( osc { oscDefaults | id = "osc2", waveform = Sawtooth, frequency = model.x }, [ "panR" ] )
    , ( panner { pannerDefaults | id = "panL", position = [ 1, 1, 0 ] }, [ "filter" ] )
    , ( panner { pannerDefaults | id = "panR", position = [ -1, -1, 0 ] }, [ "filter" ] )
    , ( filter { filterDefaults | id = "filter", q = 10, frequency = model.y * 10 }, [ "delayInput", "master" ] )
    ]
        ++ madSpookyDelay 0.2 "delayInput" "master"
        ++ [ ( gain { gainDefaults | id = "master", volume = model.y * 0.0005 }, [ "output" ] )
           ]


madSpookyDelay vol input output =
    [ ( gain { gainDefaults | id = input, volume = vol }, [ "delay" ] )
    , ( delay { delayDefaults | id = "delay", delayTime = (1 / 3), maxDelayTime = (1 / 3) }, [ "feedbackGain", output ] )
    , ( gain { gainDefaults | id = "feedbackGain", volume = 0.02 }, [ input ] )
    ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
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


init : ( Model, Cmd Msg )
init =
    ( { x = 0, y = 0 }, Cmd.none )



-- UPDATE


type Msg
    = Position Int Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Position x y ->
            ( { model | x = toFloat x, y = toFloat y }, renderAudioGraph model )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Mouse.moves (\{ x, y } -> Position x y)



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ div [] [ text ("x: " ++ (toString model.x) ++ "  y: " ++ (toString model.y)) ]
        , Html.br [] []
        , div []
            (List.map
                (\node -> div [] [ text (toString <| node) ])
                (audioGraph model)
            )
        ]
