port module Main exposing (..)

import Html.App
import Messages exposing (Msg(..))
import Models exposing (Model, initModel)
import View exposing (view)
import Update exposing (update)


-- import Items.Commands exposing (fetchAll)

import Json.Encode as Encode


init : ( Model, Cmd Msg )
init =
    -- ( initModel, Cmd.map ItemsMsg fetchAll )
    ( initModel, changeList "jensen-larsen" )


port changeList : String -> Cmd msg


-- port storeItem : String -> Cmd msg


port listItems : (Encode.Value -> msg) -> Sub msg


main : Program Never
main =
    Html.App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = (\_ -> listItems GotListItems)
        }
