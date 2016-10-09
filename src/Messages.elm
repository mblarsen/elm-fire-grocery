module Messages exposing (..)

import Items.Messages
import Json.Encode as Encode


type Msg
    = NoOp
    | ItemsMsg Items.Messages.Msg
    | AddNew
    | UpdateName String
    | GotListItems Encode.Value
