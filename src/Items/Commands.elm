port module Items.Commands exposing (fbPush, fbRemove, includeUniqueId, itemDecoder, itemEncoded, persist, receive)

import Dict
import Http exposing (Body)
import Items.Messages exposing (..)
import Items.Models exposing (Item, ItemId)
import Json.Decode as Decode exposing (field)
import Json.Encode as Encode
import Task


port fbPush : Item -> Cmd msg


port fbRemove : ItemId -> Cmd msg


receive : Encode.Value -> Cmd Msg
receive json =
    let
        decodedItemsResult =
            Decode.decodeValue (Decode.dict itemDecoder) json

        mappedItems =
            case decodedItemsResult of
                Ok decodedItems ->
                    Dict.toList decodedItems
                        |> List.map includeUniqueId

                Err err ->
                    []
    in
    Task.perform ItemUpdate (Task.succeed mappedItems)


includeUniqueId : ( String, Item ) -> Item
includeUniqueId ( uniqueId, item ) =
    { item | id = Just uniqueId }


itemDecoder : Decode.Decoder Item
itemDecoder =
    Decode.map5 Item
        (Decode.maybe (field "id" Decode.string))
        (field "name" Decode.string)
        (field "done" Decode.bool)
        (field "archived" Decode.bool)
        (field "used" Decode.int)


persist : Item -> Cmd Msg
persist item =
    fbPush item


itemEncoded : Item -> Encode.Value
itemEncoded item =
    let
        id =
            case item.id of
                Just itemId ->
                    itemId

                Nothing ->
                    ""
    in
    [ ( "id", Encode.string id )
    , ( "name", Encode.string item.name )
    , ( "done", Encode.bool item.done )
    , ( "archived", Encode.bool item.archived )
    , ( "used", Encode.int item.used )
    ]
        |> Encode.object
