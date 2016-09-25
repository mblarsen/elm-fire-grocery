module Items.Models exposing (..)


type alias ItemId =
    Int


type alias Item =
    { id : ItemId
    , name : String
    , done : Bool
    , archived : Bool
    }


new : Item
new =
    Item 0 "" False False
