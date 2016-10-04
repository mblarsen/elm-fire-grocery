module Items.Update exposing (update)

import Items.Messages exposing (Msg(..))
import Items.Models exposing (Item)
import Items.Commands exposing (persist)


update : Msg -> List Item -> ( List Item, Cmd Msg )
update msg items =
    case msg of
        ItemUpdate newItems ->
            ( newItems, Cmd.none )

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

        ErrorOccured err ->
            let
                _ =
                    Debug.log "error" err
            in
                ( items, Cmd.none )


toggleCommand : Item -> Bool -> Cmd Msg
toggleCommand item toggle =
    if toggle then
        persist { item | done = toggle, used = item.used + 1 }
    else
        persist { item | done = toggle }


archiveCommand : List Item -> List (Cmd Msg)
archiveCommand items =
    let
        commandForItem item =
            if item.archived == False then
                persist { item | archived = True, done = False }
            else
                Cmd.none
    in
        List.map commandForItem items


unarchiveCommand : Item -> Cmd Msg
unarchiveCommand item =
    persist { item | archived = False }


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
