module Items.Messages exposing (..)

import Http
import Items.Models exposing (Item, ItemId)


type Msg
    = FetchAllDone (List Item)
    | FetchAllFail Http.Error
    | ReuseItem Item
    | ToggleItem Item Bool
    | SaveSuccess Item
    | SaveFail Http.Error
    | DoneShopping
