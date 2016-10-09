module Items.List exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onCheck, onInput)
import Html.Keyed as Keyed
import Items.Messages exposing (..)
import Items.Models exposing (Item, ItemId)


view : List Item -> Html Msg
view items =
    div []
        [ div [ class "section column is-offset-3 is-6" ] [ (incompleteSection items) ]
        , div [ class "section column is-offset-3 is-6" ] [ (completeSection items) ]
        , div [ class "section column is-offset-3 is-6" ] [ (doneShopping items) ]
        , div [ class "section column is-offset-3 is-6" ]
            [ h1 [ class "title is-4" ] [ text "Common Items" ]
            , div [] [ (archivedList items) ]
            ]
        ]


doneShopping : List Item -> Html Msg
doneShopping items =
    if items |> isActive |> List.isEmpty then
        div [] []
    else
        div []
            [ button
                [ class "button is-primary", onClick ArchiveSelected ]
                [ text "Remove Completed" ]
            , text " "
            , button
                [ class "button is-primary", onClick DoneShopping ]
                [ text "Done Shopping" ]
            ]


isActive : List Item -> List Item
isActive items =
    items
        |> List.filter (not << .archived)


incomplete : List Item -> List Item
incomplete items =
    items |> isActive |> List.filter (not << .done)


complete : List Item -> List Item
complete items =
    items |> isActive |> List.filter .done


incompleteSection : List Item -> Html Msg
incompleteSection items =
    let
        itemNodes =
            items
                |> incomplete
                |> List.sortBy .name
                |> List.map activeItem

        headerNode =
            -- Needs to be Tuble ( String, Html Msg ) to
            -- work with Keyed.node "div" below
            ( "header-get", h1 [ class "title is-4" ] [ text "Get this" ] )
    in
        if List.isEmpty itemNodes then
            p [] [ text "Add new items or scroll down to add commonly purchased items." ]
        else
            Keyed.node "div" [] (headerNode :: itemNodes)


completeSection : List Item -> Html Msg
completeSection items =
    let
        itemNodes =
            items
                |> complete
                |> List.sortBy .name
                |> List.map activeItem

        headerNode =
            -- Needs to be Tuble ( String, Html Msg ) to
            -- work with Keyed.node "div" below
            ( "header-basket", h2 [ class "title is-5" ] [ text "In the basket" ] )
    in
        if List.isEmpty itemNodes then
            text ""
        else
            Keyed.node "div" [] (headerNode :: itemNodes)


activeItem : Item -> ( String, Html Msg )
activeItem item =
    ( (toString item.id)
    , div
        [ class "Item--active" ]
        [ p [ class "control" ]
            [ label [ class "checkbox" ]
                [ input
                    [ type' "checkbox"
                    , id (toString item.id)
                    , checked item.done
                    , onCheck (ToggleItem item)
                    ]
                    []
                , text " "
                , text item.name
                ]
            , span [ class "icon is-small", onClick (RemoveItem item) ] [ i [ class "fa fa-times" ] [] ]
            ]
        ]
    )


archivedList : List Item -> Html Msg
archivedList items =
    div [ class "section" ]
        (items
            |> List.filter (\i -> i.archived == True)
            |> List.sortWith sortOrder
            |> List.map archivedItem
        )


sortOrder : Item -> Item -> Order
sortOrder a b =
    case compare a.used b.used of
        LT ->
            GT

        GT ->
            LT

        EQ ->
            compare a.name b.name


archivedItem : Item -> Html Msg
archivedItem item =
    div [ class "Item--archived", onClick (ReuseItem item) ]
        [ span [ class "icon" ] [ i [ class "fa fa-plus-circle" ] [] ]
        , text (item.name ++ " (" ++ (toString item.used) ++ ")")
        , span [ class "icon is-small remove", onClick (DeleteItem (getItemId item)) ] [ i [ class "fa fa-times" ] [] ]
        ]


getItemId : Item -> ItemId
getItemId item =
    case item.id of
        Just id ->
            id

        Nothing ->
            ""
