module Pages.Home_ exposing (view)

import Gen.Route as Route
import Html exposing (a, h3, li, text, ul)
import Html.Attributes exposing (href)
import View exposing (View)


view : View msg
view =
    { title = "7GUIs"
    , body =
        [ h3 [] [ text "7GUIs challenge in plain Elm" ]
        , ul []
            [ li []
                [ a [ href (Route.toHref Route.Counter) ] [ text "Counter" ]
                , li [] [ a [ href (Route.toHref Route.Temperature) ] [ text "Temperature converter" ] ]
                , li [] [ a [ href (Route.toHref Route.Flights) ] [ text "Flight Booker" ] ]
                ]
            ]
        ]
    }
