port module Main exposing (..)

import Html.App
import Messages exposing (Msg(..))
import Models exposing (Model, initModel)
import View exposing (view)
import Update exposing (update)
import Json.Encode as Encode


type alias Flags =
    { list : String }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( initModel, changeList flags.list )


port changeList : String -> Cmd msg


port listItems : (Encode.Value -> msg) -> Sub msg


main =
    Html.App.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = (\_ -> listItems GotListItems)
        }
