module Items.Messages exposing (..)

import Http
import Items.Models exposing (Item, ItemId)


type Msg
    = ItemUpdate (List Item)
    | ReuseItem Item
    | ToggleItem Item Bool
    | RemoveItem Item
    | DeleteItem ItemId
    | SaveSuccess Item
    | SaveFail Http.Error
    | DoneShopping
    | ArchiveSelected
    | ErrorOccured String
