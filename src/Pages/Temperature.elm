module Pages.Temperature exposing (Model, Msg, page)

import Element exposing (Element, centerX, centerY, column, spacing)
import Element.Input as Input
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
toFahrenheit c =
    c * 9 / 5 + 32


fromFahrenheit : Float -> Float
fromFahrenheit f =
    (f - 32) * 5 / 9



-- VIEW


content : Model -> Element Msg
content model =
    column [ spacing 32, centerX, centerY ]
        [ Input.text []
            { onChange = SetCelsius
            , text = model.celsius
            , placeholder = Just <| Input.placeholder [] <| Element.text "°C"
            , label = Input.labelAbove [] <| Element.text "Celsius"
            }
        , Input.text []
            { onChange = SetFahrenheit
            , text = model.fahrenheit
            , placeholder = Just <| Input.placeholder [] <| Element.text "°F"
            , label = Input.labelAbove [] <| Element.text "Fahrenheit"
            }
        ]


view : Model -> View Msg
view model =
    { title = "7GUIs - Temparature Converter"
    , element = content model
    }
