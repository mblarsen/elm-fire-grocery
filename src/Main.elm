module Main exposing (..)

import Html.App
import Messages exposing (Msg(..))
import Models exposing (Model, initModel)
import View exposing (view)
import Update exposing (update)
import Items.Commands exposing (fetchAll)


init : ( Model, Cmd Msg )
init =
    ( initModel, Cmd.map ItemsMsg fetchAll )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program Never
main =
    Html.App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
