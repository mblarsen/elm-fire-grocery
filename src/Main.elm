port module Main exposing (Flags, changeList, init, listItems, main)

import Browser
import Json.Encode as Encode
import Messages exposing (Msg(..))
import Models exposing (Model, initModel)
import Update exposing (update)
import View exposing (view)


type alias Flags =
    { list : String }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( initModel, changeList flags.list )


port changeList : String -> Cmd msg


port listItems : (Encode.Value -> msg) -> Sub msg


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> listItems GotListItems
        }
