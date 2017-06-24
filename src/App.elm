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
    [ ( osc "osc1" [ oscType Sine, frequency model.x ], [ "gain1" ] )
    , ( osc "osc2" [ oscType Sawtooth, frequency model.x ], [ "gain2" ] )
    , ( gain "gain1" [ volume 0.03 ], [ "master" ] )
    , ( gain "gain2" [ volume 0.01 ], [ "master" ] )
    , ( gain "master" [ volume (model.y * 0.0008) ], [ "output" ] )
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
        , div [] [ text (toString <| audioGraph model) ]
        ]
