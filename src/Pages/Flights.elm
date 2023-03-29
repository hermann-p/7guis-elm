module Pages.Flights exposing (Model, Msg, page)

import Date
import Gen.Params.Flights exposing (Params)
import Html exposing (Html, button, div, form, input, label, option, select, text)
import Html.Attributes exposing (class, disabled, value)
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


type DateString
    = ValidDate String
    | InvalidDate String


type Flight
    = OneWayFlight DateString
    | ReturnFlight DateString DateString


validateDateString : String -> DateString
validateDateString str =
    Date.fromIsoString str
        |> Result.map (\_ -> ValidDate str)
        |> Result.withDefault (InvalidDate str)


type alias Model =
    { flight : Flight }


init : Model
init =
    { flight = OneWayFlight (ValidDate "2022-12-31") }



-- UPDATE


type Msg
    = SetFlightType Flight
    | SetFromDate String
    | SetReturnDate String


direction =
    { oneWay = "one-way"
    , return = "return"
    }


update : Msg -> Model -> Model
update msg model =
    case ( msg, model.flight ) of
        ( SetFlightType flight, _ ) ->
            { model | flight = flight }

        ( SetFromDate str, OneWayFlight _ ) ->
            { model | flight = OneWayFlight (validateDateString str) }

        ( SetFromDate str, ReturnFlight _ return ) ->
            { model | flight = ReturnFlight (validateDateString str) return }

        ( SetReturnDate str, ReturnFlight from _ ) ->
            { model | flight = ReturnFlight from (validateDateString str) }

        _ ->
            model



-- VIEW


content : Model -> Html Msg
content model =
    let
        datesAreValid =
            case model.flight of
                OneWayFlight (ValidDate _) ->
                    True

                ReturnFlight (ValidDate _) (ValidDate _) ->
                    True

                _ ->
                    False

        fromDate =
            case model.flight of
                OneWayFlight date ->
                    date

                ReturnFlight date _ ->
                    date

        returnDate : Maybe DateString
        returnDate =
            case model.flight of
                OneWayFlight _ ->
                    Nothing

                ReturnFlight _ date ->
                    Just date
    in
    form []
        [ label [] [ text "Flight type" ]
        , select
            [ onInput
                (\dir ->
                    if dir == direction.oneWay then
                        SetFlightType (OneWayFlight fromDate)

                    else
                        SetFlightType (ReturnFlight fromDate fromDate)
                )
            ]
            [ option [ value direction.oneWay ] [ text "One-way flight" ]
            , option [ value direction.return ] [ text "Return flight" ]
            ]
        , label [] [ text "Departure" ]
        , defaultDateInput SetFromDate fromDate
        , label [] [ text "Return" ]
        , maybeDateInput SetReturnDate returnDate
        , button [ disabled (not datesAreValid) ] [ text "Book!" ]
        ]


isJust : Maybe a -> Bool
isJust m =
    not (m == Nothing)


defaultDateInput : (String -> Msg) -> DateString -> Html Msg
defaultDateInput handleInput date =
    dateInput handleInput date True


maybeDateInput : (String -> Msg) -> Maybe DateString -> Html Msg
maybeDateInput handleInput date =
    case date of
        Just d ->
            dateInput handleInput d True

        _ ->
            dateInput handleInput (ValidDate "") False


dateInput : (String -> Msg) -> DateString -> Bool -> Html Msg
dateInput handleInput date enabled =
    let
        cssClass =
            case date of
                ValidDate _ ->
                    "input--valid"

                _ ->
                    "input--invalid"

        valueString =
            case date of
                ValidDate str ->
                    str

                InvalidDate str ->
                    str
    in
    input [ class cssClass, onInput handleInput, value valueString, disabled (not enabled) ] []


view : Model -> View Msg
view model =
    { title = "7GUIs - Flight Booker", body = [ content model ] }
