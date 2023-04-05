module UI exposing (..)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (onClick)
import Element.Font as Font
import Element.Input


color =
    { text = rgba255 0 0 0 0.7
    , textLight = rgba255 0 0 0 0.5
    , paper = rgb255 255 255 255
    , primary = rgb255 0x2D 0x82 0xB7
    , primaryContrast = rgb255 0xD6 0xE5 0xE3
    , primaryHovered = rgb255 0x45 0xB1 0xF4
    , secondary = rgb255 0x9F 0xD8 0xCB
    , secondaryContrast = rgba255 0 0 0 0.7
    , secondaryHovered = rgb255 0xAA 0xF7 0xE5
    , shadow = rgb255 0x0E 0x0E 0x0E
    , selected = rgb255 0xD6 0xE5 0xE3
    , selectedLight = rgb255 0xC4 0xF8 0xF1
    , disabled = rgb255 0xAA 0x33 0x33
    , disabledContrast = rgb255 0xFF 0xFF 0xFF
    }


buttonStyle : List (Attribute msg)
buttonStyle =
    [ padding 16
    , Background.color color.primary
    , Font.color color.primaryContrast
    , Border.width 1
    , Border.rounded 8
    , mouseOver
        [ Background.color color.primaryHovered
        , Border.shadow { offset = ( 0, 0 ), size = 1, blur = 10, color = rgb255 0x2D 0x82 0xB7 }
        ]
    ]


button : { onPress : Maybe msg, label : Element msg } -> Element msg
button =
    Element.Input.button buttonStyle


link : { url : String, label : Element msg } -> Element msg
link =
    Element.link
        [ Font.color color.primary
        , mouseOver
            [ Font.color color.primaryHovered ]
        ]


type SelectState a
    = Chosen a
    | Select
