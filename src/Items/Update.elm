module Items.Update exposing (update)

import Items.Messages exposing (Msg(..))
import Items.Models exposing (Item)
import Items.Commands exposing (persist, fbRemove)


update : Msg -> List Item -> ( List Item, Cmd Msg )
update msg items =
    case msg of
        ItemUpdate newItems ->
            ( newItems, Cmd.none )

        ReuseItem item ->
            ( items, unarchiveCommand item )

        ToggleItem item toggle ->
            ( items, toggleCommand item (not item.done) )

        RemoveItem item ->
            ( items, removeCommand item )

        DeleteItem id ->
            ( items, fbRemove id )

        SaveSuccess item ->
            ( updateItems item items, Cmd.none )

        SaveFail error ->
            ( items, Cmd.none )

        DoneShopping ->
            ( items, archiveCommand items |> Cmd.batch )

        ArchiveSelected ->
            ( items
            , items
                |> List.filter (\i -> i.done == True)
                |> archiveCommand
                |> Cmd.batch
            )

        ErrorOccured err ->
            let
                _ =
                    Debug.log "error" err
            in
                ( items, Cmd.none )


removeCommand : Item -> Cmd Msg
removeCommand item =
    persist { item | done = False, archived = True }


toggleCommand : Item -> Bool -> Cmd Msg
toggleCommand item toggle =
    persist { item | done = toggle }


archiveCommand : List Item -> List (Cmd Msg)
archiveCommand items =
    let
        commandForItem item =
            if item.archived == False then
                case item.done of
                    False ->
                        persist { item | archived = True, done = False }

                    True ->
                        persist { item | archived = True, done = False, used = item.used + 1 }
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
