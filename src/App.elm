module App exposing (..)

import Html exposing (Html, text, div, br)
import Mouse exposing (Position)
import Lib exposing (..)
import Encode exposing (updateAudioGraph)


audioGraph : Model -> AudioGraph
audioGraph model =
    let
        lfo =
            { oscillatorParams | frequency = model.y / 100 }

        lfoGain =
            { gainParams | volume = model.y }

        saw =
            { oscillatorParams | waveform = Sawtooth, frequency = model.x }

        lowpass =
            { filterParams | frequency = 900, q = 10 }

        master =
            { gainParams | volume = model.y * 0.001 }
    in
        [ Oscillator lfo [ input lfoGain ]
        , Gain lfoGain [ frequency lowpass ]
        , Oscillator saw [ input lowpass ]
        , Filter lowpass [ input master ]
        , Gain master [ Output ]
        ]



----- PROGRAM ----


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
            ( { model | x = toFloat x, y = toFloat y }
            , updateAudioGraph (audioGraph model)
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Mouse.moves (\{ x, y } -> Position x y)



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ div [] [ text ("x: " ++ (toString model.x) ++ "  y: " ++ (toString model.y)) ]
        , br [] []
        , div []
            (List.map
                (\node -> div [] [ text (toString <| node) ])
                (audioGraph model)
            )
        ]
