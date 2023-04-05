module View exposing (View, map, none, placeholder, toBrowserDocument)

import Browser
import Element exposing (Element)
import Element.Font as Font
import UI exposing (color)


type alias View msg =
    { title : String
    , element : Element msg
    }


placeholder : String -> View msg
placeholder str =
    { title = str
    , element = Element.text str
    }


none : View msg
none =
    { title = ""
    , element = Element.none
    }


map : (a -> b) -> View a -> View b
map fn view =
    { title = view.title
    , element = Element.map fn view.element
    }


toBrowserDocument : View msg -> Browser.Document msg
toBrowserDocument view =
    { title = view.title
    , body =
        [ Element.layout [ Font.color color.text ] view.element
        ]
    }
