module Items.Update exposing (update)

import Items.Messages exposing (Msg(..))
import Items.Models exposing (Item, ItemId)
import Items.Commands exposing (save)


update : Msg -> List Item -> ( List Item, Cmd Msg )
update msg items =
    case msg of
        FetchAllDone newItems ->
            ( newItems, Cmd.none )

        FetchAllFail error ->
            ( items, Cmd.none )

        ReuseItem item ->
            ( items, unarchiveCommand item )

        ToggleItem item toggle ->
            ( items, toggleCommand item (not item.done) )

        SaveSuccess item ->
            ( updateItems item items, Cmd.none )

        SaveFail error ->
            ( items, Cmd.none )

        DoneShopping ->
            ( items, archiveCommand items |> Cmd.batch )


toggleCommand : Item -> Bool -> Cmd Msg
toggleCommand item toggle =
    save { item | done = toggle }


archiveCommand : List Item -> List (Cmd Msg)
archiveCommand items =
    let
        commandForItem item =
            if item.archived == False then
                save { item | archived = True, done = False }
            else
                Cmd.none
    in
        List.map commandForItem items


unarchiveCommand : Item -> Cmd Msg
unarchiveCommand item =
    save { item | archived = False }


updateItems : Item -> List Item -> List Item
updateItems item items =
    let
        replace existing =
            if existing.id == item.id then
                item
            else
                existing
    in
        items
            |> List.map replace
            |> addNew item


addNew : Item -> List Item -> List Item
addNew item items =
    let
        existing =
            items
                |> List.filter (\i -> i.id == item.id)
                |> List.head
    in
        case existing of
            Nothing ->
                item :: items

            _ ->
                items
