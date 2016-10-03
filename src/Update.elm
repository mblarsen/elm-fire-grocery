module Update exposing (..)

import Messages exposing (Msg(..))
import Models exposing (Model)
import Items.Update
import Items.Models exposing (Item, new)
import Items.Commands exposing (save, receive)
import Json.Encode


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "update" msg of
        ItemsMsg subMsg ->
            let
                ( updatedItems, cmd ) =
                    Items.Update.update subMsg model.items
            in
                ( { model | items = updatedItems }, Cmd.map ItemsMsg cmd )

        NameItem newName ->
            ( { model | newItem = (updateName newName model.newItem) }, Cmd.none )

        AddNew ->
            ( resetNewItem model, Cmd.map ItemsMsg (save model.newItem) )

        GotListItems json ->
            ( model, Cmd.map ItemsMsg (receive json) )


updateName : String -> Item -> Item
updateName newName item =
    { item | name = newName }


resetNewItem : Model -> Model
resetNewItem model =
    { model | newItem = new }
