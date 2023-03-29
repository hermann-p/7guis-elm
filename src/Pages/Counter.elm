module Pages.Counter exposing (Model, Msg, page)

import Gen.Params.Counter exposing (Params)
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Page
import Request
import Shared
import String exposing (fromInt)
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
    { count : Int }


init : Model
init =
    { count = 0 }



-- UPDATE


type Msg
    = Increase


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increase ->
            { model | count = model.count + 1 }



-- VIEW


view : Model -> View Msg
view model =
    { title = "7GUIs - Counter"
    , body = [ counter model ]
    }


counter : Model -> Html Msg
counter model =
    div []
        [ div [] [ text <| fromInt model.count ]
        , button [ onClick Increase ] [ text "Increase count" ]
        ]
