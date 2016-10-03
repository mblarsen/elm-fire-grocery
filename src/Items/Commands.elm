module Items.Commands exposing (..)

import Http exposing (Body)
import Json.Decode as Decode exposing ((:=))
import Json.Encode as Encode
import Task
import Items.Models exposing (ItemId, Item)
import Items.Messages exposing (..)
import Dict


{- Receives a JSON value and turns it into either ItemUpdate or ErrorOccured -}


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
        Task.perform ItemUpdate ItemUpdate (Task.succeed mappedItems)


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



-- SAVE AND ENCODE
-- TODO update


save : Item -> Cmd Msg
save item =
    Cmd.none



-- saveTask item
--     |> Task.perform SaveFail SaveSuccess
-- TODO update
-- saveUrl : ItemId -> String
-- saveUrl id =
--     let
--         baseUrl =
--             "https://groceries.codeboutique.com/items/"
--     in
--         if id == 0 then
--             baseUrl
--         else
--             baseUrl ++ (toString id)
-- saveMethod : ItemId -> String
-- saveMethod id =
--     if id == 0 then
--         "POST"
--     else
--         "PUT"
-- TODO update
-- saveTask : Item -> Task.Task Http.Error Item
-- saveTask item =
--     let
--         body =
--             itemEncoded item
--                 |> Encode.encode 0
--                 |> Http.string
--
--         config =
--             { verb = saveMethod item.id
--             , headers = [ ( "Content-Type", "application/json" ) ]
--             , url = saveUrl item.id
--             , body = body
--             }
--     in
--         Http.send Http.defaultSettings config
--             |> Http.fromJson itemDecoder
-- itemEncoded : Item -> Encode.Value
-- itemEncoded item =
--     let
--         id = case item.id of
--             Just itemId ->
--                 item.id
--
--
--     [ ( "id", Encode.string item.id )
--     , ( "name", Encode.string item.name )
--     , ( "done", Encode.bool item.done )
--     , ( "archived", Encode.bool item.archived )
--     , ( "used", Encode.int item.used )
--     ]
--         |> Encode.object
