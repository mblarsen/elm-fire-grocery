module Items.Models exposing (Item, ItemId, new)


type alias ItemId =
    String


type alias Item =
    { id : Maybe ItemId
    , name : String
    , done : Bool
    , archived : Bool
    , used : Int
    }


new : Item
new =
    Item Nothing "" False False 0
