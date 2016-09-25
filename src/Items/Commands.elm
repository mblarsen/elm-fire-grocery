module Items.Commands exposing (..)

import Http exposing (Body)
import Json.Decode as Decode exposing ((:=))
import Json.Encode as Encode
import Task
import Items.Models exposing (ItemId, Item)
import Items.Messages exposing (..)


-- FETCH AND DECODE


fetchAll : Cmd Msg
fetchAll =
    Http.get collectionDecoder fetchAllUrl
        |> Task.perform FetchAllFail FetchAllDone


fetchAllUrl : String
fetchAllUrl =
    "http://localhost:4000/items"


collectionDecoder : Decode.Decoder (List Item)
collectionDecoder =
    Decode.list itemDecoder


itemDecoder : Decode.Decoder Item
itemDecoder =
    Decode.object4 Item
        ("id" := Decode.int)
        ("name" := Decode.string)
        ("done" := Decode.bool)
        ("archived" := Decode.bool)



-- SAVE AND ENCODE


save : Item -> Cmd Msg
save item =
    saveTask item
        |> Task.perform SaveFail SaveSuccess


saveUrl : ItemId -> String
saveUrl id =
    let
        baseUrl =
            "http://localhost:4000/items/"
    in
        if id == 0 then
            baseUrl
        else
            baseUrl ++ (toString id)


saveMethod : ItemId -> String
saveMethod id =
    if id == 0 then
        "POST"
    else
        "PUT"


saveTask : Item -> Task.Task Http.Error Item
saveTask item =
    let
        body =
            itemEncoded item
                |> Encode.encode 0
                |> Http.string

        config =
            { verb = saveMethod item.id
            , headers = [ ( "Content-Type", "application/json" ) ]
            , url = saveUrl item.id
            , body = body
            }
    in
        Http.send Http.defaultSettings config
            |> Http.fromJson itemDecoder


itemEncoded : Item -> Encode.Value
itemEncoded item =
    [ ( "id", Encode.int item.id )
    , ( "name", Encode.string item.name )
    , ( "done", Encode.bool item.done )
    , ( "archived", Encode.bool item.archived )
    ]
        |> Encode.object
