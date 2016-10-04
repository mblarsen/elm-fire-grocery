module Messages exposing (..)

import Items.Messages
import Json.Encode as Encode


type Msg
    = ItemsMsg Items.Messages.Msg
    | AddNew
    | UpdateName String
    | GotListItems Encode.Value
