module Items.List exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onCheck, onInput)
import Html.Keyed as Keyed
import Items.Messages exposing (..)
import Items.Models exposing (Item)


view : List Item -> Html Msg
view items =
    div []
        [ div [ class "section" ]
            [ (incompleteSection items)
            , (completeSection items)
            , (doneShopping items)
            ]
        , div [ class "section" ]
            [ h1 [] [ text "Common Items" ]
            , div [] [ (archivedList items) ]
            ]
        ]


doneShopping : List Item -> Html Msg
doneShopping items =
    if items |> isActive |> List.isEmpty then
        div [] []
    else
        div []
            [ button [ class "button is-regular", onClick DoneShopping ] [ text "Done Shopping" ]
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
            ( "header-get", h1 [] [ text "Get these items" ] )
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
            ( "header-basket", h2 [] [ text "In the basket" ] )
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
    div [ class "Item--active" ]
        [ text item.name
        , text " "
        , i
            [ class "fa fa-plus-circle"
            , onClick (ReuseItem item)
            ]
            []
        ]
