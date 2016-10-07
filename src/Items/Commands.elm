port module Items.Commands exposing (..)

import Http exposing (Body)
import Json.Decode as Decode exposing ((:=))
import Json.Encode as Encode
import Task
import Items.Models exposing (Item)
import Items.Messages exposing (..)
import Dict


port fbPush : Item -> Cmd msg


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
        Task.perform identity ItemUpdate (Task.succeed mappedItems)


includeUniqueId : ( String, Item ) -> Item
includeUniqueId ( uniqueId, item ) =
    { item | id = Just uniqueId }


itemDecoder : Decode.Decoder Item
itemDecoder =
    Decode.object5 Item
        (Decode.maybe ("id" := Decode.string))
        ("name" := Decode.string)
        ("done" := Decode.bool)
        ("archived" := Decode.bool)
        ("used" := Decode.int)


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
