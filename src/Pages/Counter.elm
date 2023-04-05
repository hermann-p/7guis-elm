module Pages.Counter exposing (Model, Msg, page)

import Element exposing (Element, centerX, centerY, column, spacing, text)
import Gen.Params.Counter exposing (Params)
import Page
import Request
import Shared
import String exposing (fromInt)
import UI exposing (button)
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
    , element = counter model
    }


counter : Model -> Element Msg
counter model =
    column [ spacing 40, centerX, centerY ]
        [ text <| fromInt model.count
        , button { onPress = Just Increase, label = text "Increase" }
        ]
