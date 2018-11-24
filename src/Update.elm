module Update exposing (update)

import Items.Commands exposing (persist, receive)
import Items.Models exposing (Item, new)
import Items.Update
import Json.Encode
import Messages exposing (Msg(..))
import Models exposing (Model)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model
            , Cmd.none
            )

        ItemsMsg subMsg ->
            let
                ( updatedItems, cmd ) =
                    Items.Update.update subMsg model.items
            in
            ( { model | items = updatedItems }, Cmd.map ItemsMsg cmd )

        UpdateName newName ->
            let
                newItem =
                    model.newItem

                newNewItem =
                    { newItem | name = newName }
            in
            ( { model | newItem = newNewItem }, Cmd.none )

        AddNew ->
            let
                newItem =
                    model.newItem
            in
            ( { model | newItem = new }, Cmd.map ItemsMsg (persist newItem) )

        GotListItems json ->
            ( model, Cmd.map ItemsMsg (receive json) )
