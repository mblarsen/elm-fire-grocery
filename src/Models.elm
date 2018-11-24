module Models exposing (Model, initModel)

import Items.Models exposing (Item)


type alias Model =
    { items : List Item
    , newItem : Item
    }


initModel : Model
initModel =
    Model [] Items.Models.new
