module Pages.Flights exposing (Model, Msg, page)

import Date
import Element exposing (Element, centerX, centerY, mouseOver, paddingEach, spacing, text)
import Element.Background as Background
import Element.Font as Font
import Element.Input as Input
import Gen.Params.Flights exposing (Params)
import Html.Attributes exposing (class, disabled, value)
import Html.Events exposing (onInput)
import Page
import Request
import Shared
import UI exposing (color)
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


content : Model -> Element Msg
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

        handleSetFlight : String -> Msg
        handleSetFlight dir =
            if
                dir
                    == direction.oneWay
            then
                SetFlightType (OneWayFlight fromDate)

            else
                SetFlightType (ReturnFlight fromDate fromDate)

        selectedFlight =
            case model.flight of
                OneWayFlight _ ->
                    Just direction.oneWay

                _ ->
                    Just direction.return
    in
    Element.column [ spacing 16, centerX, centerY ]
        [ Input.radioRow []
            { onChange = handleSetFlight
            , label = Input.labelLeft [] <| text "Flight type"
            , selected = selectedFlight
            , options =
                [ Input.optionWith direction.oneWay <| button "One-Way flight"
                , Input.optionWith direction.return <| button "Return flight"
                ]
            }
        , defaultDateInput SetFromDate fromDate
        , maybeDateInput SetReturnDate returnDate
        ]


button : String -> Input.OptionState -> Element Msg
button label state =
    let
        isSelected =
            state == Input.Selected

        colors =
            if isSelected then
                { fg = color.primaryContrast, bg = color.primaryHovered }

            else
                { fg = color.secondaryContrast, bg = color.secondary }

        hoverColors =
            if isSelected then
                { fg = color.primaryContrast, bg = color.primaryHovered }

            else
                { fg = color.secondaryContrast, bg = color.secondaryHovered }
    in
    Element.el
        [ paddingEach { left = 20, right = 20, top = 10, bottom = 10 }
        , Background.color colors.bg
        , Font.color colors.fg
        , mouseOver [ Background.color hoverColors.bg ]
        ]
    <|
        Element.el [ centerX, centerY ] <|
            text label


defaultDateInput : (String -> Msg) -> DateString -> Element Msg
defaultDateInput handleInput date =
    dateInput handleInput date True


maybeDateInput : (String -> Msg) -> Maybe DateString -> Element Msg
maybeDateInput handleInput date =
    case date of
        Just d ->
            dateInput handleInput d True

        _ ->
            dateInput handleInput (ValidDate "") False


dateInput : (String -> Msg) -> DateString -> Bool -> Element Msg
dateInput handleInput date enabled =
    let
        colors =
            case date of
                ValidDate _ ->
                    { fg = color.text, bg = color.paper }

                _ ->
                    { fg = color.disabledContrast, bg = color.disabled }

        valueString =
            case date of
                ValidDate str ->
                    str

                InvalidDate str ->
                    str
    in
    Input.text
        [ Background.color colors.bg
        , Font.color colors.fg
        ]
        { onChange = handleInput, text = valueString, placeholder = Nothing, label = Input.labelHidden "" }


view : Model -> View Msg
view model =
    { title = "7GUIs - Flight Booker"
    , element = content model
    }
