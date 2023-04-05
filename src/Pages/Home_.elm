module Pages.Home_ exposing (view)

import Element exposing (centerX, centerY, column, spacing, text)
import Gen.Route as Route
import UI exposing (link)
import View exposing (View)


view : View msg
view =
    { title = "7GUIs"
    , element =
        Element.column [ spacing 32, centerX, centerY ]
            [ text "7GUIs challenge in plain Elm"
            , column [ spacing 16 ]
                [ link { url = Route.toHref Route.Counter, label = text "Counter" }
                , link { url = Route.toHref Route.Temperature, label = text "Temperature converter" }
                , link { url = Route.toHref Route.Flights, label = text "Flight booker" }
                ]
            ]
    }
