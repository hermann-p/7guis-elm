module Pages.Temperature exposing (Model, Msg, page)

import Gen.Params.Temperature exposing (Params)
import Html exposing (Html, div, input, text)
import Html.Attributes exposing (placeholder, type_, value)
import Html.Events exposing (onInput)
import Page
import Request
import Shared
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page _ _ =
    Page.sandbox
        { init = init
        , update = update
        , view = view
        }



-- INIT


type alias Model =
    { celsius : String
    , fahrenheit : String
    }


init : Model
init =
    { celsius = ""
    , fahrenheit = ""
    }



-- UPDATE


type Msg
    = SetCelsius String
    | SetFahrenheit String


update : Msg -> Model -> Model
update msg model =
    case msg of
        SetCelsius c ->
            if c == "" then
                { model | celsius = c }

            else
                String.toFloat c
                    |> Maybe.map (\t -> { model | celsius = c, fahrenheit = String.fromFloat (toFahrenheit t) })
                    |> Maybe.withDefault model

        SetFahrenheit f ->
            if f == "" then
                { model | fahrenheit = f }

            else
                String.toFloat f
                    |> Maybe.map (\t -> { model | celsius = String.fromFloat (fromFahrenheit t), fahrenheit = f })
                    |> Maybe.withDefault model


toFahrenheit : Float -> Float
toFahrenheit t =
    t * 9 / 5 + 32


fromFahrenheit : Float -> Float
fromFahrenheit t =
    t - 32 * 5 / 9



-- VIEW


content : Model -> Html Msg
content model =
    div []
        [ input
            [ onInput SetCelsius
            , type_ "text"
            , placeholder "°C"
            , value model.celsius
            ]
            []
        , text "Celsius ="
        , input
            [ onInput SetFahrenheit
            , type_ "text"
            , placeholder "°F"
            , value model.fahrenheit
            ]
            []
        , text "Fahrenheit"
        ]


view : Model -> View Msg
view model =
    { title = "7GUIs - Temparature Converter"
    , body = [ content model ]
    }
