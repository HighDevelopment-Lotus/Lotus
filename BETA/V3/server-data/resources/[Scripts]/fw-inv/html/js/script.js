var UseHover = false;
var CanQuickMove = true;
var ShowingRequired = false;
var CurrentOtherInventory = [];
var OtherInventoryMaxWeight = 0;
var DraggingData = [Dragging = false, DraggingSlot = null, FromInv = null, From = null]
var WeaponAttachments = ['smg_extendedclip', 'pistol_extendedclip', 'pistol_suppressor']

OpenPlayerInventory = function(data) {
    SetupInventory(data.Slots, data.Other, data)   
    if (ShowingRequired) {
        HandleHideRequired();
    }
}

ClosePlayerInventory = function() {
    $(".background").fadeOut(0);
    $('.main-inventory-containter').slideUp(300, function() {
        $.post('http://fw-inv/CloseInventory', JSON.stringify({OtherInv: CurrentOtherInventory['Type'], OtherName: CurrentOtherInventory['SubType']}))
        $('.my-inventory-weight > .inventory-weight-fill').css({"width": "0%"})
        $('.other-inventory-weight > .inventory-weight-fill').css({"width": "0%"})
        $('.my-inventory-blocks').html('');
        $('.other-inventory-blocks').html('');
        $('.main-inventory-containter').hide(0); 
        $(".inventory-item-description").hide(0);
        $('.inventory-item-move').hide(0);
        $('.inventory-option-steal').hide(0);
        $('.inventory-info-container').fadeOut(0);
        DraggingData.DraggingSlot = null;
        DraggingData.Dragging = false;
        DraggingData.FromInv = null;
        DraggingData.From = null;
        CanQuickMove = true;
        UseHover = false;
        CurrentOtherInventory = [];
    })
}

RefreshInventory = function(data) {
    $('.my-inventory-blocks').html('');
    $('.inventory-item-move').hide(0);
    for(i = 1; i < data.Slots + 1; i++) {
        var ItemSlotInfo = '<div class="inventory-block" data-slot='+i+'></div>';
        if (i == 1 || i == 2 || i == 3 || i == 4 || i == 5) {
            ItemSlotInfo = '<div class="inventory-block" data-slot='+i+'><div class="inventory-block-number">'+i+'</div></div>';
        }
        $('.my-inventory-blocks').append(ItemSlotInfo);
    }
    $.each(data.Items, function (key, value) {
        if (value != null) {
            $(".my-inventory-blocks").find("[data-slot=" + value['Slot'] + "]").addClass("draghandle");
            $(".my-inventory-blocks").find("[data-slot=" + value['Slot'] + "]").data("itemdata", data.Items[key]);
            if (value['Slot'] == 1 | value['Slot'] == 2 || value['Slot'] == 3 || value['Slot'] == 4 || value['Slot'] == 5) {
                if (value['Type'] == 'weapon') {
                    var Quality = 'quality-good'
                    if (value['Info'].quality < 40) { Quality = 'quality-bad' } else if (value['Info'].quality >= 40 && value['Info'].quality < 70) { Quality = 'quality-okay'}
                    $(".my-inventory-blocks").find(`[data-slot=${value['Slot']}]`).html(`<div class="inventory-block-number">${value['Slot']}</div><img src="./img/items/${value['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${value['Amount']} (${((value['Weight'] * value['Amount']) / 1000).toFixed(1)})</div><div class="inventory-block-name">${value['Label']}</div><div class="inventory-quality"><div class="inventory-quality-fill ${Quality}" style="width: ${value['Info'].quality}%"></div></div>`);
                } else {
                    $(".my-inventory-blocks").find(`[data-slot=${value['Slot']}]`).html(`<div class="inventory-block-number">${value['Slot']}</div><img src="./img/items/${value['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${value['Amount']} (${((value['Weight'] * value['Amount']) / 1000).toFixed(1)})</div><div class="inventory-block-name">${value['Label']}</div>`);
                }
            } else {
                if (value['Type'] == 'weapon') {
                    var Quality = 'quality-good'
                    if (value['Info'].quality < 40) { Quality = 'quality-bad' } else if (value['Info'].quality >= 40 && value['Info'].quality < 70) { Quality = 'quality-okay'}
                    $(".my-inventory-blocks").find(`[data-slot=${value['Slot']}]`).html(`<img src="./img/items/${value['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${value['Amount']} (${((value['Weight'] * value['Amount']) / 1000).toFixed(1)})</div><div class="inventory-block-name">${value['Label']}</div><div class="inventory-quality"><div class="inventory-quality-fill ${Quality}" style="width: ${value['Info'].quality}%"></div></div>`);
                } else {
                    $(".my-inventory-blocks").find(`[data-slot=${value['Slot']}]`).html(`<img src="./img/items/${value['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${value['Amount']} (${((value['Weight'] * value['Amount']) / 1000).toFixed(1)})</div><div class="inventory-block-name">${value['Label']}</div>`);
                }
            }
        }
    });
    $('.my-inventory-weight > .inventory-weight-fill > .inventory-weight-amount').html(`${(data.Weight / 1000).toFixed(1)}`)
    $('.my-inventory-weight > .inventory-weight-fill').animate({"width": ((data.Weight / 1000) / 1.30)+"%"}, 1)
}

SetupInventory = function(BlockAmount, OtherData, data) {
    $('.my-inventory-blocks').html('');
    $('.other-inventory-blocks').html('');
    for(i = 1; i < BlockAmount + 1; i++) {
        var ItemSlotInfo = '<div class="inventory-block" data-slot='+i+'></div>';
        if (i == 1 || i == 2 || i == 3 || i == 4 || i == 5) {
            ItemSlotInfo = '<div class="inventory-block" data-slot='+i+'><div class="inventory-block-number">'+i+'</div></div>';
        }
        $('.my-inventory-blocks').append(ItemSlotInfo);
    }
    $.each(data.Items, function (key, value) {
        if (value != null) {
            $(".my-inventory-blocks").find("[data-slot=" + value['Slot'] + "]").addClass("draghandle");
            $(".my-inventory-blocks").find("[data-slot=" + value['Slot'] + "]").data("itemdata", data.Items[key]);
            if (value['Slot'] == 1 | value['Slot'] == 2 || value['Slot'] == 3 || value['Slot'] == 4 || value['Slot'] == 5) {
                if (value['Type'] == 'weapon') {
                    var Quality = 'quality-good'
                    if (value['Info'].quality < 40) { Quality = 'quality-bad' } else if (value['Info'].quality >= 40 && value['Info'].quality < 70) { Quality = 'quality-okay'}
                    $(".my-inventory-blocks").find(`[data-slot=${value['Slot']}]`).html(`<div class="inventory-block-number">${value['Slot']}</div><img src="./img/items/${value['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${value['Amount']} (${((value['Weight'] * value['Amount']) / 1000).toFixed(1)})</div><div class="inventory-block-name">${value['Label']}</div><div class="inventory-quality"><div class="inventory-quality-fill ${Quality}" style="width: ${value['Info'].quality}%"></div></div>`);
                } else {
                    $(".my-inventory-blocks").find(`[data-slot=${value['Slot']}]`).html(`<div class="inventory-block-number">${value['Slot']}</div><img src="./img/items/${value['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${value['Amount']} (${((value['Weight'] * value['Amount']) / 1000).toFixed(1)})</div><div class="inventory-block-name">${value['Label']}</div>`);
                }
            } else {
                if (value['Type'] == 'weapon') {
                    var Quality = 'quality-good'
                    if (value['Info'].quality < 40) { Quality = 'quality-bad' } else if (value['Info'].quality >= 40 && value['Info'].quality < 70) { Quality = 'quality-okay'}
                    $(".my-inventory-blocks").find(`[data-slot=${value['Slot']}]`).html(`<img src="./img/items/${value['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${value['Amount']} (${((value['Weight'] * value['Amount']) / 1000).toFixed(1)})</div><div class="inventory-block-name">${value['Label']}</div><div class="inventory-quality"><div class="inventory-quality-fill ${Quality}" style="width: ${value['Info'].quality}%"></div></div>`);
                } else {
                    $(".my-inventory-blocks").find(`[data-slot=${value['Slot']}]`).html(`<img src="./img/items/${value['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${value['Amount']} (${((value['Weight'] * value['Amount']) / 1000).toFixed(1)})</div><div class="inventory-block-name">${value['Label']}</div>`);
                }
            }
        }
    });
    if (data.OtherExtra != 'Empty') {
        if (OtherData != null && OtherData != undefined) {
            CurrentOtherInventory = OtherData;
            OtherInventoryMaxWeight = (data.OtherMaxWeight / 1000)
            $('.other-inventory-name').html(OtherData['InvName'])
            $('.other-inventory-max-weight').html((data.OtherMaxWeight / 1000).toFixed(2))
            if (OtherData['Type'] == 'Store') {
                OtherData['InvSlots'] = OtherData['Items'].length
                for(i = 1; i < OtherData['Items'].length + 1; i++) {
                    var ItemSlotInfo = `<div class="inventory-block" data-slot=${i}></div>`
                    $('.other-inventory-blocks').append(ItemSlotInfo);
                }
            } else if (OtherData['Type'] == 'Crafting') {
                OtherData['InvSlots'] = OtherData['Items'].length
                for(i = 1; i < OtherData['Items'].length + 1; i++) {
                    var ItemSlotInfo = `<div class="crafting-inventory-blocks" data-slot=${i}></div>`
                    $('.other-inventory-blocks').append(ItemSlotInfo);
                }
            } else {
                for(i = 1; i < OtherData['InvSlots'] + 1; i++) {
                    var ItemSlotInfo = `<div class="inventory-block" data-slot=${i}></div>`
                    $('.other-inventory-blocks').append(ItemSlotInfo);
                }
            }
            $.each(data.OtherItems, function (key, value) {
                if (value != null) {
                    if (OtherData['Type'] == 'Store') {
                        $(".other-inventory-blocks").find("[data-slot=" + value['Slot'] + "]").addClass("draghandle");
                        $(".other-inventory-blocks").find("[data-slot=" + value['Slot'] + "]").data("itemdata", data.OtherItems[key]);
                        $(".other-inventory-blocks").find("[data-slot=" + value['Slot'] + "]").html('<img src="./img/items/'+value['Image']+'" class="inventory-block-img"><div class="inventory-block-amount">'+value['Amount']+' ('+ ((value['Weight'] * value['Amount']) / 1000).toFixed(1) +')</div><div class="inventory-block-price">€'+value['Price']+'</div><div class="inventory-block-name">'+value['Label']+'</div>');
                    } else if (OtherData['Type'] == 'Crafting') {
                        var CraftingText = ''
                        $.each(value['Cost'], function (key2, value2) {
                            CraftingText = CraftingText + `<div class="crafting-text"><img src="./img/items/${value2['Image']}" class="crafting-img">${value2['Label']}: ${value2['Amount']}</div>`
                        });
                        var ItemSlotInfo = `<div class="inventory-block-crafting draghandle" data-craftslot=${value['Slot']}><img src="./img/items/${value['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${value['Amount']} (${((value['Weight'] * value['Amount']) / 1000).toFixed(1)})</div><div class="inventory-block-name">${value['Label']}</div></div><div class="crafting-needed-text">${CraftingText}</div>`
                        $(".other-inventory-blocks").find("[data-slot=" + value['Slot'] + "]").data("itemdata", data.OtherItems[key]);
                        $(".other-inventory-blocks").find("[data-slot=" + value['Slot'] + "]").html(ItemSlotInfo);
                    } else {
                        if (value['Type'] == 'weapon') {
                            var Quality = 'quality-good'
                            if (value['Info'].quality < 40) { Quality = 'quality-bad' } else if (value['Info'].quality >= 40 && value['Info'].quality < 70) { Quality = 'quality-okay'}
                            $(".other-inventory-blocks").find("[data-slot=" + value['Slot'] + "]").html(`<img src="./img/items/${value['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${value['Amount']} (${((value['Weight'] * value['Amount']) / 1000).toFixed(1)})</div><div class="inventory-block-name">${value['Label']}</div><div class="inventory-quality"><div class="inventory-quality-fill ${Quality}" style="width: ${value['Info'].quality}%"></div></div>`);
                        } else {
                            $(".other-inventory-blocks").find("[data-slot=" + value['Slot'] + "]").html(`<img src="./img/items/${value['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${value['Amount']} (${((value['Weight'] * value['Amount']) / 1000).toFixed(1)})</div><div class="inventory-block-name">${value['Label']}</div>`);
                        }
                        $(".other-inventory-blocks").find("[data-slot=" + value['Slot'] + "]").addClass("draghandle");
                        $(".other-inventory-blocks").find("[data-slot=" + value['Slot'] + "]").data("itemdata", data.OtherItems[key]);
                    }
                }
            });
            HandleInventoryWeights()
        } else {
            $('.other-inventory-name').html('Grond')
            OtherInventoryMaxWeight = 100
            CurrentOtherInventory['InvSlots'] = 15
            CurrentOtherInventory['Type'] = 'Drop'
            CurrentOtherInventory['SubType'] = Math.floor(Math.random() * 100000)
            for(i = 1; i < 15 + 1; i++) {
                var ItemSlotInfo = '<div class="inventory-block" data-slot='+i+'></div>';
                $('.other-inventory-blocks').append(ItemSlotInfo);
            }
            $('.other-inventory-max-weight').html((100).toFixed(2))
            $('.other-inventory-weight > .inventory-weight-fill > .inventory-weight-amount').html(`${(0 / 1000).toFixed(1)}`)
            $('.other-inventory-weight > .inventory-weight-fill').animate({"width": ((0 / 1000) / OtherInventoryMaxWeight)+"%"}, 650)
        }
    }
    $('.my-inventory-weight > .inventory-weight-fill > .inventory-weight-amount').html(`${(data.Weight / 1000).toFixed(1)}`)
    $('.my-inventory-weight > .inventory-weight-fill').animate({"width": ((data.Weight / 1000) / 1.30)+"%"}, 650)
    $('.main-inventory-containter').slideDown(350, function() {
        $(".background").fadeIn(200);
    })
}

HandleItemSwap = function(FromSlot, ToSlot, FromInv, ToInv, Amount) {
    var FromData = $(FromInv).find("[data-slot=" + FromSlot + "]").data("itemdata");
    var ToData = $(ToInv).find("[data-slot=" + ToSlot + "]").data("itemdata");
    if (Amount == 0 || Amount == undefined || Amount == null || Amount > FromData['Amount']) {Amount = FromData['Amount']}
    if (ToData != undefined && ToData != null && ToData['ItemName'] == FromData['ItemName'] && !FromData['Unique']) {
        if (FromData['Amount'] == Amount) {

            var NewItemData = [];
            NewItemData['Label'] = ToData['Label']
            NewItemData['ItemName'] = ToData['ItemName']
            NewItemData['Slot'] = parseInt(ToSlot)
            NewItemData['Type'] = ToData['Type']
            NewItemData['Unique'] = ToData['Unique']
            NewItemData['Amount'] = (parseInt(Amount) + parseInt(ToData['Amount']))
            NewItemData['Image'] = ToData['Image']
            NewItemData['Weight'] = ToData['Weight']
            NewItemData['Info'] = ToData['Info']
            NewItemData['Description'] = ToData['Description']
            NewItemData['Combinable'] = ToData['Combinable']

            if (FromInv == '.my-inventory-blocks' && ToInv == '.my-inventory-blocks') {
                $(ToInv).find("[data-slot=" + ToSlot + "]").data("itemdata", NewItemData);
                $(ToInv).find("[data-slot=" + ToSlot + "]").attr("class", "inventory-block draghandle");
                $(FromInv).find("[data-slot=" + FromSlot + "]").attr("class", "inventory-block");
                if (ToSlot == 1 | ToSlot == 2 || ToSlot == 3 || ToSlot == 4 || ToSlot == 5) {
                    $(ToInv).find("[data-slot=" + ToSlot + "]").html(`<div class="inventory-block-number">${ToSlot}</div><img src="./img/items/${NewItemData['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${NewItemData['Amount']} (${((NewItemData['Weight'] * NewItemData['Amount']) / 1000).toFixed(1)})</div><div class="inventory-block-name">${NewItemData['Label']}</div>`);
                } else {
                    $(ToInv).find("[data-slot=" + ToSlot + "]").html(`<img src="./img/items/${NewItemData['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${NewItemData['Amount']} (${((NewItemData['Weight'] * NewItemData['Amount']) / 1000).toFixed(1)})</div><div class="inventory-block-name">${NewItemData['Label']}</div>`);
                }
                if (FromSlot == 1 | FromSlot == 2 || FromSlot == 3 || FromSlot == 4 || FromSlot == 5) {
                    $(FromInv).find("[data-slot=" + FromSlot + "]").html('<div class="inventory-block-number">'+FromSlot+'</div>');
                } else {
                    $(FromInv).find("[data-slot=" + FromSlot + "]").html('');
                }
                $(FromInv).find("[data-slot=" + FromSlot + "]").removeData('itemdata');
                HandleInventorySave();
            } else if (FromInv == '.my-inventory-blocks' && ToInv == '.other-inventory-blocks') {
                if (CurrentOtherInventory != null && CurrentOtherInventory != undefined && CurrentOtherInventory['Type'] == 'Store') {
                } else if (CurrentOtherInventory != null && CurrentOtherInventory != undefined && CurrentOtherInventory['Type'] == 'Crafting') {
                } else {
                    $.post('http://fw-inv/DoItemData', JSON.stringify({ToInv: ToInv, FromInv: FromInv, ToSlot: ToSlot, FromSlot: FromSlot, Amount: Amount, Type: CurrentOtherInventory['Type'], SubType: CurrentOtherInventory['SubType'], OtherItems: CurrentOtherInventory['Items'], MaxOtherWeight: OtherInventoryMaxWeight, ExtraData: CurrentOtherInventory['ExtraData']}), function(DidData){
                        if (DidData) {
                            $(ToInv).find("[data-slot=" + ToSlot + "]").data("itemdata", NewItemData);
                            $(ToInv).find("[data-slot=" + ToSlot + "]").attr("class", "inventory-block draghandle");
                            $(ToInv).find("[data-slot=" + ToSlot + "]").html(`<img src="./img/items/${NewItemData['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${NewItemData['Amount']} (${((NewItemData['Weight'] * NewItemData['Amount']) / 1000).toFixed(1)})</div><div class="inventory-block-name">${NewItemData['Label']}</div>`);
                            $.post('http://fw-inv/RefreshInv', JSON.stringify({}))
                            HandleInventoryWeights()
                        } else {
                            HandleInventoryError('.other-inventory-weight-container');
                        }
                    });  
                }
            } else if (FromInv == '.other-inventory-blocks' && ToInv == '.other-inventory-blocks') {
                if (CurrentOtherInventory != null && CurrentOtherInventory != undefined && CurrentOtherInventory['Type'] == 'Store') {
                } else if (CurrentOtherInventory != null && CurrentOtherInventory != undefined && CurrentOtherInventory['Type'] == 'Crafting') {
                } else {
                    $.post('http://fw-inv/DoItemData', JSON.stringify({ToInv: ToInv, FromInv: FromInv, ToSlot: ToSlot, FromSlot: FromSlot, Amount: Amount, Type: CurrentOtherInventory['Type'], SubType: CurrentOtherInventory['SubType'], OtherItems: CurrentOtherInventory['Items'], MaxOtherWeight: OtherInventoryMaxWeight, ExtraData: CurrentOtherInventory['ExtraData']}), function(DidData){
                        if (DidData) {
                            $(ToInv).find("[data-slot=" + ToSlot + "]").data("itemdata", NewItemData);
                            $(ToInv).find("[data-slot=" + ToSlot + "]").attr("class", "inventory-block draghandle");
                            $(ToInv).find("[data-slot=" + ToSlot + "]").html(`<img src="./img/items/${NewItemData['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${NewItemData['Amount']} (${((NewItemData['Weight'] * NewItemData['Amount']) / 1000).toFixed(1)})</div><div class="inventory-block-name">${NewItemData['Label']}</div>`);
                            $(FromInv).find("[data-slot=" + FromSlot + "]").html('');
                            $(FromInv).find("[data-slot=" + FromSlot + "]").removeData('itemdata');
                        } else {
                            HandleInventoryError('.other-inventory-weight-container');
                        }
                    });
                }
            } else if (FromInv == '.other-inventory-blocks' && ToInv == '.my-inventory-blocks') {
                if (CurrentOtherInventory != null && CurrentOtherInventory != undefined && CurrentOtherInventory['Type'] == 'Store') {
                    $.post('http://fw-inv/DoItemData', JSON.stringify({ToInv: ToInv, FromInv: FromInv, ToSlot: ToSlot, FromSlot: FromSlot, Amount: Amount, Type: CurrentOtherInventory['Type'], SubType: CurrentOtherInventory['SubType'], OtherItems: CurrentOtherInventory['Items'], MaxOtherWeight: OtherInventoryMaxWeight, ExtraData: CurrentOtherInventory['ExtraData']}), function(DidData){
                        if (DidData) {
                            $.post('http://fw-inv/RefreshInv', JSON.stringify({}))
                        } else {
                            HandleInventoryError('.my-inventory-weight-container');
                        }
                    });
                } else if (CurrentOtherInventory != null && CurrentOtherInventory != undefined && CurrentOtherInventory['Type'] == 'Crafting') {
                    $.post('http://fw-inv/DoItemData', JSON.stringify({ToInv: ToInv, FromInv: FromInv, ToSlot: ToSlot, FromSlot: FromSlot, Amount: Amount, Type: CurrentOtherInventory['Type'], SubType: CurrentOtherInventory['SubType'], OtherItems: CurrentOtherInventory['Items'], MaxOtherWeight: OtherInventoryMaxWeight, ExtraData: CurrentOtherInventory['ExtraData']}), function(DidData){
                        if (DidData) {
                            $.post('http://fw-inv/RefreshInv', JSON.stringify({}))
                        } else {
                            HandleInventoryError('.my-inventory-weight-container');
                        }
                    });
                } else {
                    $.post('http://fw-inv/DoItemData', JSON.stringify({ToInv: ToInv, FromInv: FromInv, ToSlot: ToSlot, FromSlot: FromSlot, Amount: Amount, Type: CurrentOtherInventory['Type'], SubType: CurrentOtherInventory['SubType'], OtherItems: CurrentOtherInventory['Items'], MaxOtherWeight: OtherInventoryMaxWeight, ExtraData: CurrentOtherInventory['ExtraData']}), function(DidData){
                        if (DidData) {
                            $(FromInv).find("[data-slot=" + FromSlot + "]").html('');
                            $(FromInv).find("[data-slot=" + FromSlot + "]").removeData('itemdata');
                            $.post('http://fw-inv/RefreshInv', JSON.stringify({})) 
                            HandleInventoryWeights()
                        } else {
                            HandleInventoryError('.my-inventory-weight-container');
                        }
                    });
                }
            }
        } else if (FromData['Amount'] > Amount) {

            var NewItemData = [];
            NewItemData['Label'] = ToData['Label']
            NewItemData['ItemName'] = ToData['ItemName']
            NewItemData['Slot'] = parseInt(ToSlot)
            NewItemData['Type'] = ToData['Type']
            NewItemData['Unique'] = ToData['Unique']
            NewItemData['Amount'] = (parseInt(Amount) + parseInt(ToData['Amount']))
            NewItemData['Image'] = ToData['Image']
            NewItemData['Weight'] = ToData['Weight']
            NewItemData['Info'] = ToData['Info']
            NewItemData['Description'] = ToData['Description']
            NewItemData['Combinable'] = ToData['Combinable']

            var NewItemDataFrom = [];
            NewItemDataFrom['Label'] = FromData['Label']
            NewItemDataFrom['ItemName'] = FromData['ItemName']
            NewItemDataFrom['Slot'] = parseInt(FromSlot)
            NewItemDataFrom['Type'] = FromData['Type']
            NewItemDataFrom['Unique'] = FromData['Unique']
            NewItemDataFrom['Image'] = FromData['Image']
            NewItemDataFrom['Weight'] = FromData['Weight']
            NewItemDataFrom['Info'] = FromData['Info']
            NewItemDataFrom['Description'] = FromData['Description']
            NewItemDataFrom['Combinable'] = FromData['Combinable']
            NewItemDataFrom['Amount'] =  (parseInt(FromData['Amount']) - parseInt(Amount))

            if (FromInv == '.my-inventory-blocks' && ToInv == '.my-inventory-blocks') {
                $(ToInv).find("[data-slot=" + ToSlot + "]").data("itemdata", NewItemData);
                $(ToInv).find("[data-slot=" + ToSlot + "]").attr("class", "inventory-block draghandle");
                if (ToSlot == 1 | ToSlot == 2 || ToSlot == 3 || ToSlot == 4 || ToSlot == 5) {
                    $(ToInv).find("[data-slot=" + ToSlot + "]").html(`<div class="inventory-block-number">${ToSlot}</div><img src="./img/items/${NewItemData['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${NewItemData['Amount']} (${ ((NewItemData['Weight'] * NewItemData['Amount']) / 1000).toFixed(1) })</div><div class="inventory-block-name">${NewItemData['Label']}</div>`);
                } else {
                    $(ToInv).find("[data-slot=" + ToSlot + "]").html(`<img src="./img/items/${NewItemData['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${NewItemData['Amount']} (${ ((NewItemData['Weight'] * NewItemData['Amount']) / 1000).toFixed(1)})</div><div class="inventory-block-name">${NewItemData['Label']}</div>`);
                }
                if (FromSlot == 1 | FromSlot == 2 || FromSlot == 3 || FromSlot == 4 || FromSlot == 5) {
                    $(FromInv).find("[data-slot=" + FromSlot + "]").html(`<div class="inventory-block-number">${FromSlot}</div><img src="./img/items/${NewItemDataFrom['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${NewItemDataFrom['Amount']} (${ ((NewItemDataFrom['Weight'] * NewItemDataFrom['Amount']) / 1000).toFixed(1) })</div><div class="inventory-block-name">${NewItemDataFrom['Label']}</div>`);
                } else {
                    $(FromInv).find("[data-slot=" + FromSlot + "]").html(`<img src="./img/items/${NewItemDataFrom['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${NewItemDataFrom['Amount']} (${ ((NewItemDataFrom['Weight'] * NewItemDataFrom['Amount']) / 1000).toFixed(1)})</div><div class="inventory-block-name">${NewItemDataFrom['Label']}</div>`);
                }
                $(FromInv).find("[data-slot=" + FromSlot + "]").data("itemdata", NewItemDataFrom);
                HandleInventorySave();
            } else if (FromInv == '.my-inventory-blocks' && ToInv == '.other-inventory-blocks') {
                if (CurrentOtherInventory != null && CurrentOtherInventory != undefined && CurrentOtherInventory['Type'] == 'Store') {
                } else if (CurrentOtherInventory != null && CurrentOtherInventory != undefined && CurrentOtherInventory['Type'] == 'Crafting') {
                } else {
                    $.post('http://fw-inv/DoItemData', JSON.stringify({ToInv: ToInv, FromInv: FromInv, ToSlot: ToSlot, FromSlot: FromSlot, Amount: Amount, Type: CurrentOtherInventory['Type'], SubType: CurrentOtherInventory['SubType'], OtherItems: CurrentOtherInventory['Items'], MaxOtherWeight: OtherInventoryMaxWeight, ExtraData: CurrentOtherInventory['ExtraData']}), function(DidData){
                        if (DidData) {
                            $(ToInv).find("[data-slot=" + ToSlot + "]").html(`<img src="./img/items/${NewItemData['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${NewItemData['Amount']} (${ ((NewItemData['Weight'] * NewItemData['Amount']) / 1000).toFixed(1)})</div><div class="inventory-block-name">${NewItemData['Label']}</div>`);
                            $(ToInv).find("[data-slot=" + ToSlot + "]").data("itemdata", NewItemData);
                            $.post('http://fw-inv/RefreshInv', JSON.stringify({}))
                            HandleInventoryWeights()
                        } else {
                            HandleInventoryError('.other-inventory-weight-container');
                        }
                    });  
                }
            } else if (FromInv == '.other-inventory-blocks' && ToInv == '.other-inventory-blocks') {
                if (CurrentOtherInventory != null && CurrentOtherInventory != undefined && CurrentOtherInventory['Type'] == 'Store') {
                } else if (CurrentOtherInventory != null && CurrentOtherInventory != undefined && CurrentOtherInventory['Type'] == 'Crafting') {
                } else {
                    $.post('http://fw-inv/DoItemData', JSON.stringify({ToInv: ToInv, FromInv: FromInv, ToSlot: ToSlot, FromSlot: FromSlot, Amount: Amount, Type: CurrentOtherInventory['Type'], SubType: CurrentOtherInventory['SubType'], OtherItems: CurrentOtherInventory['Items'], MaxOtherWeight: OtherInventoryMaxWeight, ExtraData: CurrentOtherInventory['ExtraData']}), function(DidData){
                        if (DidData) {
                            $(ToInv).find("[data-slot=" + ToSlot + "]").data("itemdata", NewItemData);
                            $(ToInv).find("[data-slot=" + ToSlot + "]").attr("class", "inventory-block draghandle");
                            $(ToInv).find("[data-slot=" + ToSlot + "]").html(`<img src="./img/items/${NewItemData['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${NewItemData['Amount']} (${ ((NewItemData['Weight'] * NewItemData['Amount']) / 1000).toFixed(1)})</div><div class="inventory-block-name">${NewItemData['Label']}</div>`);
                            $(FromInv).find("[data-slot=" + FromSlot + "]").html(`<img src="./img/items/${NewItemDataFrom['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${NewItemDataFrom['Amount']} (${ ((NewItemDataFrom['Weight'] * NewItemDataFrom['Amount']) / 1000).toFixed(1)})</div><div class="inventory-block-name">${NewItemDataFrom['Label']}</div>`);
                            $(FromInv).find("[data-slot=" + FromSlot + "]").data("itemdata", NewItemDataFrom);
                        } else {
                            HandleInventoryError('.other-inventory-weight-container');
                        }
                    });
                }
            } else if (FromInv == '.other-inventory-blocks' && ToInv == '.my-inventory-blocks') {
                if (CurrentOtherInventory != null && CurrentOtherInventory != undefined && CurrentOtherInventory['Type'] == 'Store') {
                    $.post('http://fw-inv/DoItemData', JSON.stringify({ToInv: ToInv, FromInv: FromInv, ToSlot: ToSlot, FromSlot: FromSlot, Amount: Amount, Type: CurrentOtherInventory['Type'], SubType: CurrentOtherInventory['SubType'], OtherItems: CurrentOtherInventory['Items'], MaxOtherWeight: OtherInventoryMaxWeight, ExtraData: CurrentOtherInventory['ExtraData']}), function(DidData){
                        if (DidData) {
                            $.post('http://fw-inv/RefreshInv', JSON.stringify({}))
                        } else {
                            HandleInventoryError('.my-inventory-weight-container');
                        }
                    });
                } else if (CurrentOtherInventory != null && CurrentOtherInventory != undefined && CurrentOtherInventory['Type'] == 'Crafting') {
                    $.post('http://fw-inv/DoItemData', JSON.stringify({ToInv: ToInv, FromInv: FromInv, ToSlot: ToSlot, FromSlot: FromSlot, Amount: Amount, Type: CurrentOtherInventory['Type'], SubType: CurrentOtherInventory['SubType'], OtherItems: CurrentOtherInventory['Items'], MaxOtherWeight: OtherInventoryMaxWeight, ExtraData: CurrentOtherInventory['ExtraData']}), function(DidData){
                        if (DidData) {
                            $.post('http://fw-inv/RefreshInv', JSON.stringify({}))
                        } else {
                            HandleInventoryError('.my-inventory-weight-container');
                        }
                    });
                } else {
                    $.post('http://fw-inv/DoItemData', JSON.stringify({ToInv: ToInv, FromInv: FromInv, ToSlot: ToSlot, FromSlot: FromSlot, Amount: Amount, Type: CurrentOtherInventory['Type'], SubType: CurrentOtherInventory['SubType'], OtherItems: CurrentOtherInventory['Items'], MaxOtherWeight: OtherInventoryMaxWeight, ExtraData: CurrentOtherInventory['ExtraData']}), function(DidData){
                        if (DidData) {
                            $(FromInv).find("[data-slot=" + FromSlot + "]").html(`<img src="./img/items/${NewItemDataFrom['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${NewItemDataFrom['Amount']} (${ ((NewItemDataFrom['Weight'] * NewItemDataFrom['Amount']) / 1000).toFixed(1)})</div><div class="inventory-block-name">${NewItemDataFrom['Label']}</div>`);
                            $(FromInv).find("[data-slot=" + FromSlot + "]").data("itemdata", NewItemDataFrom);
                            $.post('http://fw-inv/RefreshInv', JSON.stringify({}))
                            HandleInventoryWeights()
                        } else {
                            HandleInventoryError('.my-inventory-weight-container');
                        }
                    });
                }
            }
        }
    } else if (ToData == null && ToData == undefined) {
        if (FromData['Amount'] == Amount) {
            var NewItemData = [];
            NewItemData['Label'] = FromData['Label']
            NewItemData['ItemName'] = FromData['ItemName']
            NewItemData['Slot'] = parseInt(ToSlot)
            NewItemData['Type'] = FromData['Type']
            NewItemData['Unique'] = FromData['Unique']
            NewItemData['Image'] = FromData['Image']
            NewItemData['Weight'] = FromData['Weight']
            NewItemData['Info'] = FromData['Info']
            NewItemData['Description'] = FromData['Description']
            NewItemData['Combinable'] = FromData['Combinable']
            NewItemData['Amount'] = parseInt(FromData['Amount'])
            if (FromInv == '.my-inventory-blocks' && ToInv == '.my-inventory-blocks') {
                $(ToInv).find("[data-slot=" + ToSlot + "]").data("itemdata", NewItemData);
                $(ToInv).find("[data-slot=" + ToSlot + "]").attr("class", "inventory-block draghandle");
                $(FromInv).find("[data-slot=" + FromSlot + "]").attr("class", "inventory-block");
                if (ToSlot == 1 | ToSlot == 2 || ToSlot == 3 || ToSlot == 4 || ToSlot == 5) {
                    if (NewItemData['Type'] == 'weapon') {
                        var Quality = 'quality-good'
                        if (NewItemData['Info'].quality < 40) { Quality = 'quality-bad' } else if (NewItemData['Info'].quality >= 40 && NewItemData['Info'].quality < 70) { Quality = 'quality-okay'}
                        $(ToInv).find("[data-slot=" + ToSlot + "]").html(`<div class="inventory-block-number">${ToSlot}</div><img src="./img/items/${NewItemData['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${NewItemData['Amount']} (${ ((NewItemData['Weight'] * NewItemData['Amount']) / 1000).toFixed(1) })</div><div class="inventory-block-name">${NewItemData['Label']}</div><div class="inventory-quality"><div class="inventory-quality-fill ${Quality}" style="width: ${NewItemData['Info'].quality}%"></div></div>`);
                    } else {
                        $(ToInv).find("[data-slot=" + ToSlot + "]").html(`<div class="inventory-block-number">${ToSlot}</div><img src="./img/items/${NewItemData['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${NewItemData['Amount']} (${ ((NewItemData['Weight'] * NewItemData['Amount']) / 1000).toFixed(1) })</div><div class="inventory-block-name">${NewItemData['Label']}</div>`);
                    }
                } else {
                    if (NewItemData['Type'] == 'weapon') {
                        var Quality = 'quality-good'
                        if (NewItemData['Info'].quality < 40) { Quality = 'quality-bad' } else if (NewItemData['Info'].quality >= 40 && NewItemData['Info'].quality < 70) { Quality = 'quality-okay'}
                        $(ToInv).find("[data-slot=" + ToSlot + "]").html(`<img src="./img/items/${NewItemData['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${NewItemData['Amount']} (${ ((NewItemData['Weight'] * NewItemData['Amount']) / 1000).toFixed(1)})</div><div class="inventory-block-name">${NewItemData['Label']}</div><div class="inventory-quality"><div class="inventory-quality-fill ${Quality}" style="width: ${NewItemData['Info'].quality}%"></div></div>`);
                    } else {
                        $(ToInv).find("[data-slot=" + ToSlot + "]").html(`<img src="./img/items/${NewItemData['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${NewItemData['Amount']} (${ ((NewItemData['Weight'] * NewItemData['Amount']) / 1000).toFixed(1)})</div><div class="inventory-block-name">${NewItemData['Label']}</div>`);
                    }
                }
                if (FromSlot == 1 | FromSlot == 2 || FromSlot == 3 || FromSlot == 4 || FromSlot == 5) {
                    $(FromInv).find("[data-slot=" + FromSlot + "]").html(`<div class="inventory-block-number">${FromSlot}</div>`);
                } else {
                    $(FromInv).find("[data-slot=" + FromSlot + "]").html('');
                }
                $(FromInv).find("[data-slot=" + FromSlot + "]").removeData('itemdata');
                HandleInventorySave();
            } else if (FromInv == '.my-inventory-blocks' && ToInv == '.other-inventory-blocks') {
                if (CurrentOtherInventory != null && CurrentOtherInventory != undefined && CurrentOtherInventory['Type'] == 'Store') {
                } else if (CurrentOtherInventory != null && CurrentOtherInventory != undefined && CurrentOtherInventory['Type'] == 'Crafting') {
                } else {
                    $.post('http://fw-inv/DoItemData', JSON.stringify({ToInv: ToInv, FromInv: FromInv, ToSlot: ToSlot, FromSlot: FromSlot, Amount: Amount, Type: CurrentOtherInventory['Type'], SubType: CurrentOtherInventory['SubType'], OtherItems: CurrentOtherInventory['Items'], MaxOtherWeight: OtherInventoryMaxWeight, ExtraData: CurrentOtherInventory['ExtraData']}), function(DidData){
                        if (DidData) {
                            if (NewItemData['Type'] == 'weapon') {
                                var Quality = 'quality-good'
                                if (NewItemData['Info'].quality < 40) { Quality = 'quality-bad' } else if (NewItemData['Info'].quality >= 40 && NewItemData['Info'].quality < 70) { Quality = 'quality-okay'}
                                $(ToInv).find("[data-slot=" + ToSlot + "]").html(`<img src="./img/items/${NewItemData['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${NewItemData['Amount']} (${ ((NewItemData['Weight'] * NewItemData['Amount']) / 1000).toFixed(1)})</div><div class="inventory-block-name">${NewItemData['Label']}</div><div class="inventory-quality"><div class="inventory-quality-fill ${Quality}" style="width: ${NewItemData['Info'].quality}%"></div></div>`);
                            } else {
                                $(ToInv).find("[data-slot=" + ToSlot + "]").html(`<img src="./img/items/${NewItemData['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${NewItemData['Amount']} (${ ((NewItemData['Weight'] * NewItemData['Amount']) / 1000).toFixed(1)})</div><div class="inventory-block-name">${NewItemData['Label']}</div>`);
                            }
                            $(ToInv).find("[data-slot=" + ToSlot + "]").data("itemdata", NewItemData);
                            $(ToInv).find("[data-slot=" + ToSlot + "]").attr("class", "inventory-block draghandle");
                            $.post('http://fw-inv/RefreshInv', JSON.stringify({}))
                            HandleInventoryWeights()
                        } else {
                            HandleInventoryError('.other-inventory-weight-container');
                        }
                    });   
                }
            } else if (FromInv == '.other-inventory-blocks' && ToInv == '.other-inventory-blocks') {
                $.post('http://fw-inv/DoItemData', JSON.stringify({ToInv: ToInv, FromInv: FromInv, ToSlot: ToSlot, FromSlot: FromSlot, Amount: Amount, Type: CurrentOtherInventory['Type'], SubType: CurrentOtherInventory['SubType'], OtherItems: CurrentOtherInventory['Items'], MaxOtherWeight: OtherInventoryMaxWeight, ExtraData: CurrentOtherInventory['ExtraData']}), function(DidData){
                    if (DidData) {
                        if (NewItemData['Type'] == 'weapon') {
                            var Quality = 'quality-good'
                            if (NewItemData['Info'].quality < 40) { Quality = 'quality-bad' } else if (NewItemData['Info'].quality >= 40 && NewItemData['Info'].quality < 70) { Quality = 'quality-okay'}
                            $(ToInv).find("[data-slot=" + ToSlot + "]").html(`<img src="./img/items/${NewItemData['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${NewItemData['Amount']} (${ ((NewItemData['Weight'] * NewItemData['Amount']) / 1000).toFixed(1)})</div><div class="inventory-block-name">${NewItemData['Label']}</div><div class="inventory-quality"><div class="inventory-quality-fill ${Quality}" style="width: ${NewItemData['Info'].quality}%"></div></div>`);
                        } else {
                            $(ToInv).find("[data-slot=" + ToSlot + "]").html(`<img src="./img/items/${NewItemData['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${NewItemData['Amount']} (${ ((NewItemData['Weight'] * NewItemData['Amount']) / 1000).toFixed(1)})</div><div class="inventory-block-name">${NewItemData['Label']}</div>`);
                        }
                        $(ToInv).find("[data-slot=" + ToSlot + "]").data("itemdata", NewItemData);
                        $(ToInv).find("[data-slot=" + ToSlot + "]").attr("class", "inventory-block draghandle");
                        $(FromInv).find("[data-slot=" + FromSlot + "]").html('');
                        $(FromInv).find("[data-slot=" + FromSlot + "]").attr("class", "inventory-block");
                        $(FromInv).find("[data-slot=" + FromSlot + "]").removeData('itemdata');
                    } else {
                        HandleInventoryError('.other-inventory-weight-container');
                    }
                });
            } else if (FromInv == '.other-inventory-blocks' && ToInv == '.my-inventory-blocks') {
                if (CurrentOtherInventory != null && CurrentOtherInventory != undefined && CurrentOtherInventory['Type'] == 'Store') {
                    $.post('http://fw-inv/DoItemData', JSON.stringify({ToInv: ToInv, FromInv: FromInv, ToSlot: ToSlot, FromSlot: FromSlot, Amount: Amount, Type: CurrentOtherInventory['Type'], SubType: CurrentOtherInventory['SubType'], OtherItems: CurrentOtherInventory['Items'], MaxOtherWeight: OtherInventoryMaxWeight, ExtraData: CurrentOtherInventory['ExtraData']}), function(DidData){
                        if (DidData) {
                            $.post('http://fw-inv/RefreshInv', JSON.stringify({}))
                        } else {
                            HandleInventoryError('.my-inventory-weight-container');
                        }
                    });
                } else if (CurrentOtherInventory != null && CurrentOtherInventory != undefined && CurrentOtherInventory['Type'] == 'Crafting') {
                    $.post('http://fw-inv/DoItemData', JSON.stringify({ToInv: ToInv, FromInv: FromInv, ToSlot: ToSlot, FromSlot: FromSlot, Amount: Amount, Type: CurrentOtherInventory['Type'], SubType: CurrentOtherInventory['SubType'], OtherItems: CurrentOtherInventory['Items'], MaxOtherWeight: OtherInventoryMaxWeight, ExtraData: CurrentOtherInventory['ExtraData']}), function(DidData){
                        if (DidData) {
                            $.post('http://fw-inv/RefreshInv', JSON.stringify({}))
                        } else {
                            HandleInventoryError('.my-inventory-weight-container');
                        }
                    });
                } else {
                    $.post('http://fw-inv/DoItemData', JSON.stringify({ToInv: ToInv, FromInv: FromInv, ToSlot: ToSlot, FromSlot: FromSlot, Amount: Amount, Type: CurrentOtherInventory['Type'], SubType: CurrentOtherInventory['SubType'], OtherItems: CurrentOtherInventory['Items'], MaxOtherWeight: OtherInventoryMaxWeight, ExtraData: CurrentOtherInventory['ExtraData']}), function(DidData){
                        if (DidData) {
                            $(FromInv).find("[data-slot=" + FromSlot + "]").attr("class", "inventory-block");
                            $(FromInv).find("[data-slot=" + FromSlot + "]").html('');
                            $(FromInv).find("[data-slot=" + FromSlot + "]").removeData('itemdata');
                            $.post('http://fw-inv/RefreshInv', JSON.stringify({}));
                            HandleInventoryWeights()
                        } else {
                            HandleInventoryError('.my-inventory-weight-container');
                        }
                    });
                }
            }
        } else if (FromData['Amount'] > Amount) {
            var NewItemData = [];
            NewItemData['Label'] = FromData['Label']
            NewItemData['ItemName'] = FromData['ItemName']
            NewItemData['Slot'] = parseInt(ToSlot)
            NewItemData['Type'] = FromData['Type']
            NewItemData['Unique'] = FromData['Unique']
            NewItemData['Image'] = FromData['Image']
            NewItemData['Weight'] = FromData['Weight']
            NewItemData['Info'] = FromData['Info']
            NewItemData['Description'] = FromData['Description']
            NewItemData['Combinable'] = FromData['Combinable']
            NewItemData['Amount'] = parseInt(Amount)

            var NewItemDataFrom = [];
            NewItemDataFrom['Label'] = FromData['Label']
            NewItemDataFrom['ItemName'] = FromData['ItemName']
            NewItemDataFrom['Slot'] = parseInt(FromSlot)
            NewItemDataFrom['Type'] = FromData['Type']
            NewItemDataFrom['Unique'] = FromData['Unique']
            NewItemDataFrom['Image'] = FromData['Image']
            NewItemDataFrom['Weight'] = FromData['Weight']
            NewItemDataFrom['Info'] = FromData['Info']
            NewItemDataFrom['Description'] = FromData['Description']
            NewItemDataFrom['Combinable'] = FromData['Combinable']
            NewItemDataFrom['Amount'] =  (parseInt(FromData['Amount']) - parseInt(Amount))

            if (FromInv == '.my-inventory-blocks' && ToInv == '.my-inventory-blocks') {
                if (ToSlot == 1 | ToSlot == 2 || ToSlot == 3 || ToSlot == 4 || ToSlot == 5) {
                    if (NewItemData['Type'] == 'weapon') {
                        var Quality = 'quality-good'
                        if (NewItemData['Info'].quality < 40) { Quality = 'quality-bad' } else if (NewItemData['Info'].quality >= 40 && NewItemData['Info'].quality < 70) { Quality = 'quality-okay'}
                        $(ToInv).find("[data-slot=" + ToSlot + "]").html(`<div class="inventory-block-number">${ToSlot}</div><img src="./img/items/${NewItemData['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${NewItemData['Amount']} (${ ((NewItemData['Weight'] * NewItemData['Amount']) / 1000).toFixed(1) })</div><div class="inventory-block-name">${NewItemData['Label']}</div><div class="inventory-quality"><div class="inventory-quality-fill ${Quality}" style="width: ${NewItemData['Info'].quality}%"></div></div>`);
                    } else {
                        $(ToInv).find("[data-slot=" + ToSlot + "]").html(`<div class="inventory-block-number">${ToSlot}</div><img src="./img/items/${NewItemData['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${NewItemData['Amount']} (${ ((NewItemData['Weight'] * NewItemData['Amount']) / 1000).toFixed(1) })</div><div class="inventory-block-name">${NewItemData['Label']}</div>`);
                    }
                } else {
                    if (NewItemData['Type'] == 'weapon') {
                        var Quality = 'quality-good'
                        if (NewItemData['Info'].quality < 40) { Quality = 'quality-bad' } else if (NewItemData['Info'].quality >= 40 && NewItemData['Info'].quality < 70) { Quality = 'quality-okay'}
                        $(ToInv).find("[data-slot=" + ToSlot + "]").html(`<img src="./img/items/${NewItemData['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${NewItemData['Amount']} (${ ((NewItemData['Weight'] * NewItemData['Amount']) / 1000).toFixed(1)})</div><div class="inventory-block-name">${NewItemData['Label']}</div><div class="inventory-quality"><div class="inventory-quality-fill ${Quality}" style="width: ${NewItemData['Info'].quality}%"></div></div>`);
                    } else {
                        $(ToInv).find("[data-slot=" + ToSlot + "]").html(`<img src="./img/items/${NewItemData['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${NewItemData['Amount']} (${ ((NewItemData['Weight'] * NewItemData['Amount']) / 1000).toFixed(1)})</div><div class="inventory-block-name">${NewItemData['Label']}</div>`);
                    }
                }
                if (FromSlot == 1 | FromSlot == 2 || FromSlot == 3 || FromSlot == 4 || FromSlot == 5) {
                    if (NewItemDataFrom['Type'] == 'weapon') {
                        var Quality = 'quality-good'
                        if (NewItemDataFrom['Info'].quality < 40) { Quality = 'quality-bad' } else if (NewItemDataFrom['Info'].quality >= 40 && NewItemDataFrom['Info'].quality < 70) { Quality = 'quality-okay'}
                        $(FromInv).find("[data-slot=" + FromSlot + "]").html(`<div class="inventory-block-number">${FromSlot}</div><img src="./img/items/${NewItemDataFrom['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${NewItemDataFrom['Amount']} (${ ((NewItemDataFrom['Weight'] * NewItemDataFrom['Amount']) / 1000).toFixed(1) })</div><div class="inventory-block-name">${NewItemDataFrom['Label']}</div><div class="inventory-quality"><div class="inventory-quality-fill ${Quality}" style="width: ${NewItemDataFrom['Info'].quality}%"></div></div>`);
                    } else {
                        $(FromInv).find("[data-slot=" + FromSlot + "]").html(`<div class="inventory-block-number">${FromSlot}</div><img src="./img/items/${NewItemDataFrom['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${NewItemDataFrom['Amount']} (${ ((NewItemDataFrom['Weight'] * NewItemDataFrom['Amount']) / 1000).toFixed(1) })</div><div class="inventory-block-name">${NewItemDataFrom['Label']}</div>`);
                    }
                } else {
                    if (NewItemDataFrom['Type'] == 'weapon') {
                        var Quality = 'quality-good'
                        if (NewItemDataFrom['Info'].quality < 40) { Quality = 'quality-bad' } else if (NewItemDataFrom['Info'].quality >= 40 && NewItemDataFrom['Info'].quality < 70) { Quality = 'quality-okay'}
                        $(FromInv).find("[data-slot=" + FromSlot + "]").html(`<img src="./img/items/${NewItemDataFrom['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${NewItemDataFrom['Amount']} (${ ((NewItemDataFrom['Weight'] * NewItemDataFrom['Amount']) / 1000).toFixed(1)})</div><div class="inventory-block-name">${NewItemDataFrom['Label']}</div><div class="inventory-quality"><div class="inventory-quality-fill ${Quality}" style="width: ${NewItemDataFrom['Info'].quality}%"></div></div>`);
                    } else {
                        $(FromInv).find("[data-slot=" + FromSlot + "]").html(`<img src="./img/items/${NewItemDataFrom['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${NewItemDataFrom['Amount']} (${ ((NewItemDataFrom['Weight'] * NewItemDataFrom['Amount']) / 1000).toFixed(1)})</div><div class="inventory-block-name">${NewItemDataFrom['Label']}</div>`);
                    }
                }
                $(ToInv).find("[data-slot=" + ToSlot + "]").data("itemdata", NewItemData);
                $(ToInv).find("[data-slot=" + ToSlot + "]").attr("class", "inventory-block draghandle");
                $(FromInv).find("[data-slot=" + FromSlot + "]").data("itemdata", NewItemDataFrom);
                HandleInventorySave();
            } else if (FromInv == '.my-inventory-blocks' && ToInv == '.other-inventory-blocks') {
                $.post('http://fw-inv/DoItemData', JSON.stringify({ToInv: ToInv, FromInv: FromInv, ToSlot: ToSlot, FromSlot: FromSlot, Amount: Amount, Type: CurrentOtherInventory['Type'], SubType: CurrentOtherInventory['SubType'], OtherItems: CurrentOtherInventory['Items'], MaxOtherWeight: OtherInventoryMaxWeight, ExtraData: CurrentOtherInventory['ExtraData']}), function(DidData){
                    if (DidData) {
                        if (NewItemData['Type'] == 'weapon') {
                            var Quality = 'quality-good'
                            if (NewItemData['Info'].quality < 40) { Quality = 'quality-bad' } else if (NewItemData['Info'].quality >= 40 && NewItemData['Info'].quality < 70) { Quality = 'quality-okay'}
                            $(ToInv).find("[data-slot=" + ToSlot + "]").html(`<img src="./img/items/${NewItemData['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${NewItemData['Amount']} (${ ((NewItemData['Weight'] * NewItemData['Amount']) / 1000).toFixed(1)})</div><div class="inventory-block-name">${NewItemData['Label']}</div><div class="inventory-quality"><div class="inventory-quality-fill ${Quality}" style="width: ${NewItemData['Info'].quality}%"></div></div>`);
                        } else {
                            $(ToInv).find("[data-slot=" + ToSlot + "]").html(`<img src="./img/items/${NewItemData['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${NewItemData['Amount']} (${ ((NewItemData['Weight'] * NewItemData['Amount']) / 1000).toFixed(1)})</div><div class="inventory-block-name">${NewItemData['Label']}</div>`);
                        }
                        $(ToInv).find("[data-slot=" + ToSlot + "]").data("itemdata", NewItemData);
                        $(ToInv).find("[data-slot=" + ToSlot + "]").attr("class", "inventory-block draghandle");
                        $.post('http://fw-inv/RefreshInv', JSON.stringify({}))
                        HandleInventoryWeights()
                    } else {
                        HandleInventoryError('.other-inventory-weight-container');
                    }
                }); 
            } else if (FromInv == '.other-inventory-blocks' && ToInv == '.other-inventory-blocks') {
                if (CurrentOtherInventory != null && CurrentOtherInventory != undefined && CurrentOtherInventory['Type'] == 'Store') {
                } else if (CurrentOtherInventory != null && CurrentOtherInventory != undefined && CurrentOtherInventory['Type'] == 'Crafting') {
                } else {
                    $.post('http://fw-inv/DoItemData', JSON.stringify({ToInv: ToInv, FromInv: FromInv, ToSlot: ToSlot, FromSlot: FromSlot, Amount: Amount, Type: CurrentOtherInventory['Type'], SubType: CurrentOtherInventory['SubType'], OtherItems: CurrentOtherInventory['Items'], MaxOtherWeight: OtherInventoryMaxWeight, ExtraData: CurrentOtherInventory['ExtraData']}), function(DidData){
                        if (DidData) {
                            if (NewItemData['Type'] == 'weapon') {
                                var Quality = 'quality-good'
                                if (NewItemData['Info'].quality < 40) { Quality = 'quality-bad' } else if (NewItemData['Info'].quality >= 40 && NewItemData['Info'].quality < 70) { Quality = 'quality-okay'}
                                $(ToInv).find("[data-slot=" + ToSlot + "]").html(`<img src="./img/items/${NewItemData['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${NewItemData['Amount']} (${ ((NewItemData['Weight'] * NewItemData['Amount']) / 1000).toFixed(1)})</div><div class="inventory-block-name">${NewItemData['Label']}</div><div class="inventory-quality"><div class="inventory-quality-fill ${Quality}" style="width: ${NewItemData['Info'].quality}%"></div></div>`);
                            } else {
                                $(ToInv).find("[data-slot=" + ToSlot + "]").html(`<img src="./img/items/${NewItemData['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${NewItemData['Amount']} (${ ((NewItemData['Weight'] * NewItemData['Amount']) / 1000).toFixed(1)})</div><div class="inventory-block-name">${NewItemData['Label']}</div>`);
                            }
                            if (NewItemDataFrom['Type'] == 'weapon') {
                                var Quality = 'quality-good'
                                if (NewItemDataFrom['Info'].quality < 40) { Quality = 'quality-bad' } else if (NewItemDataFrom['Info'].quality >= 40 && NewItemDataFrom['Info'].quality < 70) { Quality = 'quality-okay'}
                                $(FromInv).find("[data-slot=" + FromSlot + "]").html(`<img src="./img/items/${NewItemDataFrom['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${NewItemDataFrom['Amount']} (${ ((NewItemDataFrom['Weight'] * NewItemDataFrom['Amount']) / 1000).toFixed(1)})</div><div class="inventory-block-name">${NewItemDataFrom['Label']}</div><div class="inventory-quality"><div class="inventory-quality-fill ${Quality}" style="width: ${NewItemDataFrom['Info'].quality}%"></div></div>`);
                            } else {
                                $(FromInv).find("[data-slot=" + FromSlot + "]").html(`<img src="./img/items/${NewItemDataFrom['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${NewItemDataFrom['Amount']} (${ ((NewItemDataFrom['Weight'] * NewItemDataFrom['Amount']) / 1000).toFixed(1)})</div><div class="inventory-block-name">${NewItemDataFrom['Label']}</div>`);
                            }
                            $(ToInv).find("[data-slot=" + ToSlot + "]").data("itemdata", NewItemData);
                            $(ToInv).find("[data-slot=" + ToSlot + "]").attr("class", "inventory-block draghandle");
                            $(FromInv).find("[data-slot=" + FromSlot + "]").data("itemdata", NewItemDataFrom);
                        } else {
                            HandleInventoryError('.other-inventory-weight-container');
                        }
                    });
                }
            } else if (FromInv == '.other-inventory-blocks' && ToInv == '.my-inventory-blocks') {
                if (CurrentOtherInventory != null && CurrentOtherInventory != undefined && CurrentOtherInventory['Type'] == 'Store') {
                    $.post('http://fw-inv/DoItemData', JSON.stringify({ToInv: ToInv, FromInv: FromInv, ToSlot: ToSlot, FromSlot: FromSlot, Amount: Amount, Type: CurrentOtherInventory['Type'], SubType: CurrentOtherInventory['SubType'], OtherItems: CurrentOtherInventory['Items'], MaxOtherWeight: OtherInventoryMaxWeight, ExtraData: CurrentOtherInventory['ExtraData']}), function(DidData){
                        if (DidData) {
                            $.post('http://fw-inv/RefreshInv', JSON.stringify({}))
                        } else {
                            HandleInventoryError('.my-inventory-weight-container');
                        }
                    });
                } else if (CurrentOtherInventory != null && CurrentOtherInventory != undefined && CurrentOtherInventory['Type'] == 'Crafting') {
                    $.post('http://fw-inv/DoItemData', JSON.stringify({ToInv: ToInv, FromInv: FromInv, ToSlot: ToSlot, FromSlot: FromSlot, Amount: Amount, Type: CurrentOtherInventory['Type'], SubType: CurrentOtherInventory['SubType'], OtherItems: CurrentOtherInventory['Items'], MaxOtherWeight: OtherInventoryMaxWeight, ExtraData: CurrentOtherInventory['ExtraData']}), function(DidData){
                        if (DidData) {
                            $.post('http://fw-inv/RefreshInv', JSON.stringify({}))
                        } else {
                            HandleInventoryError('.my-inventory-weight-container');
                        }
                    });
                } else {
                    $.post('http://fw-inv/DoItemData', JSON.stringify({ToInv: ToInv, FromInv: FromInv, ToSlot: ToSlot, FromSlot: FromSlot, Amount: Amount, Type: CurrentOtherInventory['Type'], SubType: CurrentOtherInventory['SubType'], OtherItems: CurrentOtherInventory['Items'], MaxOtherWeight: OtherInventoryMaxWeight, ExtraData: CurrentOtherInventory['ExtraData']}), function(DidData){
                        if (DidData) {
                            if (NewItemDataFrom['Type'] == 'weapon') {
                                var Quality = 'quality-good'
                                if (NewItemDataFrom['Info'].quality < 40) { Quality = 'quality-bad' } else if (NewItemDataFrom['Info'].quality >= 40 && NewItemDataFrom['Info'].quality < 70) { Quality = 'quality-okay'}
                                $(FromInv).find("[data-slot=" + FromSlot + "]").html(`<img src="./img/items/${NewItemDataFrom['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${NewItemDataFrom['Amount']} (${ ((NewItemDataFrom['Weight'] * NewItemDataFrom['Amount']) / 1000).toFixed(1)})</div><div class="inventory-block-name">${NewItemDataFrom['Label']}</div><div class="inventory-quality"><div class="inventory-quality-fill ${Quality}" style="width: ${NewItemDataFrom['Info'].quality}%"></div></div>`);
                            } else {
                                $(FromInv).find("[data-slot=" + FromSlot + "]").html(`<img src="./img/items/${NewItemDataFrom['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${NewItemDataFrom['Amount']} (${ ((NewItemDataFrom['Weight'] * NewItemDataFrom['Amount']) / 1000).toFixed(1)})</div><div class="inventory-block-name">${NewItemDataFrom['Label']}</div>`);
                            }
                            $(FromInv).find("[data-slot=" + FromSlot + "]").data("itemdata", NewItemDataFrom);
                            $.post('http://fw-inv/RefreshInv', JSON.stringify({}))
                            HandleInventoryWeights()
                        } else {
                            HandleInventoryError('.my-inventory-weight-container');
                        }
                    });
                }
            }
        }
    } else if (ToData != undefined && ToData != null && FromData != undefined && FromData != null && FromData['ItemName'] != ToData['ItemName']) {
        if (FromInv == '.my-inventory-blocks' && ToInv == '.my-inventory-blocks' && FromData['Combinable'] != undefined && FromData['Combinable'] != null && FromData['Combinable']['AcceptItems'][0] == ToData['ItemName']) {
            ClosePlayerInventory();
            $.post('http://fw-inv/CombineItems', JSON.stringify({FromSlot: FromData['Slot'], FromItem: FromData['ItemName'], ToSlot: ToData['Slot'], ToItem: ToData['ItemName'], Reward: FromData['Combinable']['RewardItem']}));
        } else {
            if (FromData['Amount'] == Amount) {
                var NewItemData = FromData;
                NewItemData['Slot'] = parseInt(ToSlot)
                
                var NewItemDataFrom = ToData;
                NewItemDataFrom['Slot'] = parseInt(FromSlot)
    
                if (FromInv == '.my-inventory-blocks' && ToInv == '.my-inventory-blocks') {
                    if (ToSlot == 1 | ToSlot == 2 || ToSlot == 3 || ToSlot == 4 || ToSlot == 5) {
                        if (NewItemData['Type'] == 'weapon') {
                            var Quality = 'quality-good'
                            if (NewItemData['Info'].quality < 40) { Quality = 'quality-bad' } else if (NewItemData['Info'].quality >= 40 && NewItemData['Info'].quality < 70) { Quality = 'quality-okay'}
                            $(ToInv).find("[data-slot=" + ToSlot + "]").html(`<div class="inventory-block-number">${ToSlot}</div><img src="./img/items/${NewItemData['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${NewItemData['Amount']} (${ ((NewItemData['Weight'] * NewItemData['Amount']) / 1000).toFixed(1) })</div><div class="inventory-block-name">${NewItemData['Label']}</div><div class="inventory-quality"><div class="inventory-quality-fill ${Quality}" style="width: ${NewItemData['Info'].quality}%"></div></div>`);
                        } else {
                            $(ToInv).find("[data-slot=" + ToSlot + "]").html(`<div class="inventory-block-number">${ToSlot}</div><img src="./img/items/${NewItemData['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${NewItemData['Amount']} (${ ((NewItemData['Weight'] * NewItemData['Amount']) / 1000).toFixed(1) })</div><div class="inventory-block-name">${NewItemData['Label']}</div>`);
                        }
                    } else {
                        if (NewItemData['Type'] == 'weapon') {
                            var Quality = 'quality-good'
                            if (NewItemData['Info'].quality < 40) { Quality = 'quality-bad' } else if (NewItemData['Info'].quality >= 40 && NewItemData['Info'].quality < 70) { Quality = 'quality-okay'}
                            $(ToInv).find("[data-slot=" + ToSlot + "]").html(`<img src="./img/items/${NewItemData['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${NewItemData['Amount']} (${ ((NewItemData['Weight'] * NewItemData['Amount']) / 1000).toFixed(1)})</div><div class="inventory-block-name">${NewItemData['Label']}</div><div class="inventory-block-name">${NewItemData['Label']}</div><div class="inventory-quality"><div class="inventory-quality-fill ${Quality}" style="width: ${NewItemData['Info'].quality}%"></div></div>`);
                        } else {
                            $(ToInv).find("[data-slot=" + ToSlot + "]").html(`<img src="./img/items/${NewItemData['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${NewItemData['Amount']} (${ ((NewItemData['Weight'] * NewItemData['Amount']) / 1000).toFixed(1)})</div><div class="inventory-block-name">${NewItemData['Label']}</div>`);
                        }
                    }
                    $(ToInv).find("[data-slot=" + ToSlot + "]").data("itemdata", NewItemData);
                    if (FromSlot == 1 | FromSlot == 2 || FromSlot == 3 || FromSlot == 4 || FromSlot == 5) {
                        if (NewItemDataFrom['Type'] == 'weapon') {
                            var Quality = 'quality-good'
                            if (NewItemDataFrom['Info'].quality < 40) { Quality = 'quality-bad' } else if (NewItemDataFrom['Info'].quality >= 40 && NewItemDataFrom['Info'].quality < 70) { Quality = 'quality-okay'}
                            $(FromInv).find("[data-slot=" + FromSlot + "]").html(`<div class="inventory-block-number">${FromSlot}</div><img src="./img/items/${NewItemDataFrom['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${NewItemDataFrom['Amount']} (${ ((NewItemDataFrom['Weight'] * NewItemDataFrom['Amount']) / 1000).toFixed(1) })</div><div class="inventory-block-name">${NewItemDataFrom['Label']}</div><div class="inventory-quality"><div class="inventory-quality-fill ${Quality}" style="width: ${NewItemDataFrom['Info'].quality}%"></div></div>`);
                        } else {
                            $(FromInv).find("[data-slot=" + FromSlot + "]").html(`<div class="inventory-block-number">${FromSlot}</div><img src="./img/items/${NewItemDataFrom['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${NewItemDataFrom['Amount']} (${ ((NewItemDataFrom['Weight'] * NewItemDataFrom['Amount']) / 1000).toFixed(1) })</div><div class="inventory-block-name">${NewItemDataFrom['Label']}</div>`);
                        }
                    } else {
                        if (NewItemDataFrom['Type'] == 'weapon') {
                            var Quality = 'quality-good'
                            if (NewItemDataFrom['Info'].quality < 40) { Quality = 'quality-bad' } else if (NewItemDataFrom['Info'].quality >= 40 && NewItemDataFrom['Info'].quality < 70) { Quality = 'quality-okay'}
                            $(FromInv).find("[data-slot=" + FromSlot + "]").html(`<img src="./img/items/${NewItemDataFrom['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${NewItemDataFrom['Amount']} (${ ((NewItemDataFrom['Weight'] * NewItemDataFrom['Amount']) / 1000).toFixed(1)})</div><div class="inventory-block-name">${NewItemDataFrom['Label']}</div><div class="inventory-quality"><div class="inventory-quality-fill ${Quality}" style="width: ${NewItemDataFrom['Info'].quality}%"></div></div>`);
                        } else {
                            $(FromInv).find("[data-slot=" + FromSlot + "]").html(`<img src="./img/items/${NewItemDataFrom['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${NewItemDataFrom['Amount']} (${ ((NewItemDataFrom['Weight'] * NewItemDataFrom['Amount']) / 1000).toFixed(1)})</div><div class="inventory-block-name">${NewItemDataFrom['Label']}</div>`);
                        }
                    }
                    $(FromInv).find("[data-slot=" + FromSlot + "]").data("itemdata", NewItemDataFrom);
                    HandleInventorySave();
                } else if (FromInv == '.my-inventory-blocks' && ToInv == '.other-inventory-blocks') {
                } else if (FromInv == '.other-inventory-blocks' && ToInv == '.other-inventory-blocks') {
                    if (CurrentOtherInventory != null && CurrentOtherInventory != undefined && CurrentOtherInventory['Type'] == 'Store') {
                    } else if (CurrentOtherInventory != null && CurrentOtherInventory != undefined && CurrentOtherInventory['Type'] == 'Crafting') {
                    } else {
                        $.post('http://fw-inv/DoItemData', JSON.stringify({ToInv: ToInv, FromInv: FromInv, ToSlot: ToSlot, FromSlot: FromSlot, Amount: Amount, Type: CurrentOtherInventory['Type'], SubType: CurrentOtherInventory['SubType'], OtherItems: CurrentOtherInventory['Items'], MaxOtherWeight: OtherInventoryMaxWeight, ExtraData: 'Swap'}), function(DidData){
                            if (DidData) {
                                if (NewItemData['Type'] == 'weapon') {
                                    var Quality = 'quality-good'
                                    if (NewItemData['Info'].quality < 40) { Quality = 'quality-bad' } else if (NewItemData['Info'].quality >= 40 && NewItemData['Info'].quality < 70) { Quality = 'quality-okay'}
                                    $(ToInv).find("[data-slot=" + ToSlot + "]").html(`<img src="./img/items/${NewItemData['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${NewItemData['Amount']} (${ ((NewItemData['Weight'] * NewItemData['Amount']) / 1000).toFixed(1)})</div><div class="inventory-block-name">${NewItemData['Label']}</div><div class="inventory-quality"><div class="inventory-quality-fill ${Quality}" style="width: ${NewItemData['Info'].quality}%"></div></div>`);
                                } else {
                                    $(ToInv).find("[data-slot=" + ToSlot + "]").html(`<img src="./img/items/${NewItemData['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${NewItemData['Amount']} (${ ((NewItemData['Weight'] * NewItemData['Amount']) / 1000).toFixed(1)})</div><div class="inventory-block-name">${NewItemData['Label']}</div>`);
                                }
                                if (NewItemDataFrom['Type'] == 'weapon') {
                                    var Quality = 'quality-good'
                                    if (NewItemDataFrom['Info'].quality < 40) { Quality = 'quality-bad' } else if (NewItemDataFrom['Info'].quality >= 40 && NewItemDataFrom['Info'].quality < 70) { Quality = 'quality-okay'}
                                    $(FromInv).find("[data-slot=" + FromSlot + "]").html(`<img src="./img/items/${NewItemDataFrom['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${NewItemDataFrom['Amount']} (${ ((NewItemDataFrom['Weight'] * NewItemDataFrom['Amount']) / 1000).toFixed(1)})</div><div class="inventory-block-name">${NewItemDataFrom['Label']}</div><div class="inventory-quality"><div class="inventory-quality-fill ${Quality}" style="width: ${NewItemDataFrom['Info'].quality}%"></div></div>`);                   
                                } else {
                                    $(FromInv).find("[data-slot=" + FromSlot + "]").html(`<img src="./img/items/${NewItemDataFrom['Image']}" class="inventory-block-img"><div class="inventory-block-amount">${NewItemDataFrom['Amount']} (${ ((NewItemDataFrom['Weight'] * NewItemDataFrom['Amount']) / 1000).toFixed(1)})</div><div class="inventory-block-name">${NewItemDataFrom['Label']}</div>`);                   
                                }
                                $(ToInv).find("[data-slot=" + ToSlot + "]").data("itemdata", NewItemData);
                                $(FromInv).find("[data-slot=" + FromSlot + "]").data("itemdata", NewItemDataFrom);
                            } else {
                                HandleInventoryError('.other-inventory-weight-container');
                            }
                        });
                    }
                } else if (FromInv == '.other-inventory-blocks' && ToInv == '.my-inventory-blocks') {
                }
            } else {
                HandleInventoryError(false);
            }
        }
    }
    if (FromData['Type'] == 'weapon') {
        if (CurrentOtherInventory != null && CurrentOtherInventory != undefined && CurrentOtherInventory['Type'] != 'Store' && CurrentOtherInventory['Type'] != 'Crafting') {
            $.post('http://fw-inv/ResetWeapons', JSON.stringify({}))
        }
    }
}

HandleInventorySave = function() {
    for (i = 1; i < 45 + 1; i++) {
        var InventoryData = $(".my-inventory-blocks").find("[data-slot=" + i + "]").data("itemdata");
        if (InventoryData != null && InventoryData != undefined) {
            var SendData = {};
            SendData['Label'] = InventoryData['Label']
            SendData['ItemName'] = InventoryData['ItemName']
            SendData['Slot'] = parseInt(InventoryData['Slot'])
            SendData['Type'] = InventoryData['Type']
            SendData['Unique'] = InventoryData['Unique']
            SendData['Amount'] = InventoryData['Amount']
            SendData['Image'] = InventoryData['Image']
            SendData['Weight'] = InventoryData['Weight']
            SendData['Info'] = InventoryData['Info']
            SendData['Description'] = InventoryData['Description']
            SendData['Combinable'] = InventoryData['Combinable']
            $.post('http://fw-inv/SaveInventory', JSON.stringify({Type: 'TableInput', InventoryData: SendData}))
        }
    }
    $.post('http://fw-inv/SaveInventory', JSON.stringify({Type: 'SaveNow'}))
}

HandleInventoryInfo = function(ItemData) {
    if (ItemData['Info'] != null && ItemData['Info'] != undefined && ItemData['Info'] != "") {
        if (ItemData['Type'] == 'weapon') {
            if (ItemData['Info'].serie != null && ItemData['Info'].serie != undefined && ItemData['Info'].ammo != null && ItemData['Info'].ammo != undefined) {
                $('.info-desc').html(`Serie: ${ItemData['Info'].serie}<br>Kogels: ${ItemData['Info'].ammo}`);
            } else if (ItemData['Info'].ammo != null && ItemData['Info'].ammo != undefined) {
                if (ItemData['ItemName'] == 'weapon_snspistol') { // Paintball Gun
                    $('.info-desc').html(`Paintballs: ${ItemData['Info'].ammo}`);
                } else {
                    $('.info-desc').html(`Kogels: ${ItemData['Info'].ammo}`);
                }
            } else {
                $('.info-desc').html(ItemData['Description']);
            }
        } else if (ItemData['ItemName'] == 'id_card') {
            var SendGender = 'Man'; if (SendGender == 1) {SendGender = 'Vrouw'}
            $('.info-desc').html(`BSN: ${ItemData['Info'].citizenid}<br>Naam: ${ItemData['Info'].firstname}<br>Achternaam: ${ItemData['Info'].lastname}<br>Geboortedag: ${ItemData['Info'].birthdate}<br>Geslacht: ${SendGender}<br>Nationaliteit: ${ItemData['Info'].nationality}`);
        } else if (ItemData['ItemName'] == 'driver_license') {
            $('.info-desc').html(`Naam: ${ItemData['Info'].firstname}<br>Achternaam: ${ItemData['Info'].lastname}<br>Geboortedag: ${ItemData['Info'].birthdate}<br>Type: ${ItemData['Info'].type}`);
        } else if (ItemData['ItemName'] == 'licence') {
            $('.info-desc').html(`Soort: ${ItemData['Info'].type}<br>Serie: ${ItemData['Info'].serie}`);
        } else if (ItemData['ItemName'] == 'bloodvial') {
            $('.info-desc').html(`Medisch Bloed Monster: ${ItemData['Info'].vialid}<br>BSN: ${ItemData['Info'].vialbsn}<br>Bloed Type: ${ItemData['Info'].bloodtype}`);
        } else if (ItemData['ItemName'] == 'rentalpapers') {
            $('.info-desc').html(`Kenteken: ${ItemData['Info'].plate}`);
        } else if (ItemData['ItemName'] == 'stickynote') {
            $('.info-desc').html(`Notitie: ${ItemData['Info'].label}`);
        } else if (ItemData['ItemName'] == 'burger-box') {
            $('.info-desc').html(`Bestelling Nummer: ${ItemData['Info'].boxid}`);
        } else if (ItemData['ItemName'] == 'duffel-bag') {
            $('.info-desc').html(`Tas Nummer: ${ItemData['Info'].bagid}`);
        } else if (ItemData['ItemName'] == 'used-card') {
            $('.info-desc').html(`Waarde: €${ItemData['Info'].card}`);
        } else if (ItemData['ItemName'] == 'mask' || ItemData['ItemName'] == 'hat' || ItemData['ItemName'] == 'glasses') {
            $('.info-desc').html(`Prop: ${ItemData['Info'].prop}; Texture: ${ItemData['Info'].texture}`);
        } else if (ItemData['ItemName'] == 'hunting-carcas-one' || ItemData['ItemName'] == 'hunting-carcas-two' || ItemData['ItemName'] == 'hunting-carcas-three') {
            var CatchTime = HandleInformationTimeDifference(ItemData['Info'].date, 'Single')
            $('.info-desc').html(`Gedood: ${CatchTime}<br>Dier: ${ItemData['Info'].animal}`);
        } else if (ItemData['ItemName'] == 'hunting-carcas-four') {
            var CatchTime = HandleInformationTimeDifference(ItemData['Info'].date, 'Single')
            $('.info-desc').html(`Gedood: ${CatchTime};<br>Dier: ${ItemData['Info'].animal}; Pasop voor politie!`);
        } else if (ItemData['ItemName'] == 'scuba-gear') {
            $('.info-desc').html(`Lucht Inhoud: ${ItemData['Info'].air}%`);
        } else if (ItemData['ItemName'] == 'moneybag') {
            $('.info-desc').html(`Aantal contant: €${ItemData['Info'].worth}`);
        } else if (ItemData['ItemName'] == 'markedbills') {
            $('.info-desc').html(`Waarde: €${ItemData['Info'].worth}`);
        } else if (ItemData['ItemName'] == 'filled_evidence_bag') {
            if (ItemData['Info'].type == 'casing') {
                $('.info-desc').html(`Bewijstuk: ${ItemData['Info'].label}<br>Kogel: ${ItemData['Info'].ammo}<br>Kogel Type: ${ItemData['Info'].ammotype}<br>Kogel Serie: ${ItemData['Info'].serie}<br>Straat: ${ItemData['Info'].street}`);
            } else if (ItemData['Info'].type == 'blood') {
                $('.info-desc').html(`Bewijstuk: ${ItemData['Info'].label}<br>Bloodgroep: ${ItemData['Info'].bloodtype}<br>Plaats Delict: ${ItemData['Info'].street}`);
            } else if (ItemData['Info'].type == 'fingerprint') {
                $('.info-desc').html(`Bewijstuk: ${ItemData['Info'].label}<br>Vingerpatroon: ${ItemData['Info'].fingerid}<br>Plaats Delict: ${ItemData['Info'].street}`);
            } else if (ItemData['Info'].type == 'hair') {
            } else if (ItemData['Info'].type == 'slime') {
            }
        } else {
            $('.info-desc').html(ItemData['Description']);
        }
    } else {
        $('.info-desc').html(ItemData['Description']);
    }
    if (ItemData['Type'] == 'weapon') {
        $('.info-sub').html(`<strong>Gewicht</strong>: ${(ItemData['Weight'] / 1000).toFixed(1)} | Aantal: 1 | Kwaliteit: ${Math.floor(ItemData['Info'].quality)}%`);
    } else {
        $('.info-sub').html(`<strong>Gewicht</strong>: ${(ItemData['Weight'] / 1000).toFixed(1)} | Aantal: 1`);
    }
    $(".inventory-item-description").show(150);
}

HandleInventoryWeights = function() {
    if (CurrentOtherInventory != null && CurrentOtherInventory != undefined) {
        var TotalWeightOther = 0
        for (i = 1; i < CurrentOtherInventory['InvSlots'] + 1; i++) {
            var InventoryData = $(".other-inventory-blocks").find("[data-slot=" + i + "]").data("itemdata");
            if (InventoryData != null && InventoryData != undefined) {
                TotalWeightOther = parseInt(TotalWeightOther) + parseInt(InventoryData['Amount'] * InventoryData['Weight']) 
            }
        }
        $('.other-inventory-weight > .inventory-weight-fill > .inventory-weight-amount').html(`${(TotalWeightOther / 1000).toFixed(1)}`)
        $('.other-inventory-weight > .inventory-weight-fill').animate({"width": ((TotalWeightOther / 10) / OtherInventoryMaxWeight)+"%"}, 1)
    }
}

HandleShake = function (Target) {
    var Target = Target
    for (var Iter = 0; Iter < 3 + 1; Iter++) {
        $(Target).animate({left: Iter % 2 == 0 ? 10 : 10 * -1 }, 100);
    }
    return $(Target).animate({left: 0 }, 100);
};

HandleInformationTimeDifference = function(Time, Type) {
    var NowTime = new Date();
    var ItemTime = new Date(Time);
    var DifferenceMS = (NowTime - ItemTime);
    var DifferenceDays = Math.floor(DifferenceMS / 86400000);
    var DifferenceHours = Math.floor((DifferenceMS % 86400000) / 3600000);
    var DifferenceMins = Math.round(((DifferenceMS % 86400000) % 3600000) / 60000);
    var DifferenceSeconds = Math.round(DifferenceMS / 1000);
    var TimeAgo = ``;
    if (Type == 'Exact') {
        var MinuteText = 'Minuten'
        var DayText = 'Dagen'
        if (DifferenceMins == 1) {
            MinuteText = 'Minuut'
        }
        if (DifferenceDays == 1) {
            DayText = 'Dag'
        }
        TimeAgo = `${DifferenceDays} ${DayText}, ${DifferenceHours} Uur, ${DifferenceMins} ${MinuteText}`
    } else {
            TimeAgo = `${DifferenceSeconds} seconde geleden`
            if (DifferenceDays > 0) {
                if (DifferenceDays == 1) {
                    TimeAgo = `${DifferenceDays} dag geleden`
                } else {
                    TimeAgo = `${DifferenceDays} dagen geleden`
                }
            } else if (DifferenceHours) {
                TimeAgo = `${DifferenceHours} uur geleden`
            } else if (DifferenceMins > 0) {
                if (DifferenceMins == 1) {
                    TimeAgo = `${DifferenceMins} minuut geleden`
                } else {
                    TimeAgo = `${DifferenceMins} minuten geleden`
                }
            }
    }
    return TimeAgo 
}

GetQuickSlot = function(FromInv, ItemName, Unique) {
    if (FromInv == 'my') {
        if (CurrentOtherInventory != null && CurrentOtherInventory != undefined) {
            if (!Unique) {
                for (i = 1; i < CurrentOtherInventory['InvSlots'] + 1; i++) {
                    var InventoryData = $(".other-inventory-blocks").find("[data-slot=" + i + "]").data("itemdata");
                    if (InventoryData != null && InventoryData != undefined) {
                        if (InventoryData['ItemName'] == ItemName) {
                            return InventoryData['Slot'];
                        }
                    }
                }
            }
            for (i = 1; i < CurrentOtherInventory['InvSlots'] + 1; i++) {
                var InventoryData = $(".other-inventory-blocks").find("[data-slot=" + i + "]").data("itemdata");
                if (InventoryData == null && InventoryData == undefined) {
                    return i
                } 
            }
            return false;
        }
    } else if (FromInv == 'other') {
        if (!Unique) {
            for (i = 1; i < 45 + 1; i++) {
                var InventoryData = $(".my-inventory-blocks").find("[data-slot=" + i + "]").data("itemdata");
                if (InventoryData != null && InventoryData != undefined) {
                    if (InventoryData['ItemName'] == ItemName) {
                        return InventoryData['Slot'];
                    }
                }
            }
        }
        for (i = 1; i < 45 + 1; i++) {
            var InventoryData = $(".my-inventory-blocks").find("[data-slot=" + i + "]").data("itemdata");
            if (InventoryData == null && InventoryData == undefined) {
                return i
            } 
        }
        return false;
    }
}

ShowStealButton = function() {
    $('.inventory-option-steal').show();
}

IsThisAWeaponAttachment = function(ItemName) {
    var Retval = true
    $.each(WeaponAttachments, function(key, value) {
        if (value == ItemName) {
            Retval = false;
        }
    });
    return Retval;
}

HandleInventoryError = function(Element) {
    $.post('http://fw-inv/ErrorSound', JSON.stringify({}))
    if (Element != false) {
        HandleShake(Element);
    }
}

HandleInventoryShowBox = function(data) {
    if (!ShowingRequired) {
        var AddToBox = ''
        var RandomId = Math.floor(Math.random() * 100000)
        if (data['Type'] == 'Add') {
            AddToBox = `<div class="item-box-block" id="box-${RandomId}"><div class="item-box-display">Ontvangen</div><div class="inventory-block-amount">${data['Amount']}x</div><img class="item-box-img" src="./img/items/${data['Image']}"><div class="item-box-name">${data['Label']}</div></div>`
        } else if (data['Type'] == 'Remove') {
            AddToBox = `<div class="item-box-block" id="box-${RandomId}"><div class="item-box-display">Verwijderd</div><div class="inventory-block-amount">${data['Amount']}x</div><img class="item-box-img" src="./img/items/${data['Image']}"><div class="item-box-name">${data['Label']}</div></div>`
        } else if (data['Type'] == 'Used') {
            AddToBox = `<div class="item-box-block" id="box-${RandomId}"><div class="item-box-display">Gebruikt</div><img class="item-box-img" src="./img/items/${data['Image']}"><div class="item-box-name">${data['Label']}</div></div>`
        }
        $(".item-box-container").prepend(AddToBox);
        $('#box-'+RandomId).fadeOut(0);
        $('#box-'+RandomId).fadeIn(750);
        setTimeout(function() {
            $('#box-'+RandomId).fadeOut(1350, function() {
                $('#box-'+RandomId).remove();
            });
        }, 1500);
    }
}

HandleShowRequired = function(data) {
    $.each(data, function (key, value) {
        var AddToBox = `<div class="item-box-block"><div class="item-box-display">Nodig</div><img class="item-box-img" src="./img/items/${value['Image']}"><div class="item-box-name">${value['Label']}</div></div>`
        $(".item-needed-container").prepend(AddToBox);
    });
    ShowingRequired = true;
    $('.item-needed-container').fadeIn(500);
}

HandleHideRequired = function() {
    $('.item-needed-container').fadeOut(500, function() {
        ShowingRequired = false;
        $(".item-needed-container").html("");
    });
}

HandelInventoryHotbar = function(data) {
    $('.item-hotbar-container').html('');
    for(i = 1; i < 5 + 1; i++) {
        var ItemSlotInfo = '<div class="inventory-block" data-slot='+i+'></div>';
        if (i == 1 || i == 2 || i == 3 || i == 4 || i == 5) {
            ItemSlotInfo = '<div class="inventory-block" data-slot='+i+'><div class="inventory-block-number">'+i+'</div></div>';
        }
        $('.item-hotbar-container').append(ItemSlotInfo);
    }
    $.each(data.Items, function (key, value) {
        if (value != null) {
            $(".item-hotbar-container").find("[data-slot=" + value['Slot'] + "]").data("itemdata", data.Items[key]);
            if (value['Slot'] == 1 | value['Slot'] == 2 || value['Slot'] == 3 || value['Slot'] == 4 || value['Slot'] == 5) {
                if (value['Type'] == 'weapon') {
                    var Quality = 'quality-good'
                    if (value['Info'].quality < 40) { Quality = 'quality-bad' } else if (value['Info'].quality >= 40 && value['Info'].quality < 70) { Quality = 'quality-okay'}
                    $(".item-hotbar-container").find("[data-slot=" + value['Slot'] + "]").html(`<div class="inventory-block-number">${value['Slot']}</div><div><img src="./img/items/${value['Image']}" class="inventory-block-img"></div><div class="inventory-block-amount">${value['Amount']} (${((value['Weight'] * value['Amount']) / 1000).toFixed(1)})</div><div class="inventory-block-name">${value['Label']}</div><div class="inventory-quality"><div class="inventory-quality-fill ${Quality}" style="width: ${value['Info'].quality}%"></div></div>`);
                } else {
                    $(".item-hotbar-container").find("[data-slot=" + value['Slot'] + "]").html(`<div class="inventory-block-number">${value['Slot']}</div><div><img src="./img/items/${value['Image']}" class="inventory-block-img"></div><div class="inventory-block-amount">${value['Amount']} (${((value['Weight'] * value['Amount']) / 1000).toFixed(1)})</div><div class="inventory-block-name">${value['Label']}</div>`);
                }
            } else {
                $(".item-hotbar-container").find("[data-slot=" + value['Slot'] + "]").html('');
            }
        }
    });
    $('.item-hotbar-container').fadeIn(650);
}

$(document).on({
    mousedown: function(e){
        e.preventDefault();
        if (e.button === 0) {
            var ThisSlot = $(this).attr("data-slot")
            var InventoryType = $(this).parent().data('type')
            var HasThisSlotAnything = $(this).hasClass("draghandle")
            var FromData = $('.my-inventory-blocks').find("[data-slot=" + ThisSlot + "]").data("itemdata");
            if (InventoryType == null && InventoryType == undefined && CurrentOtherInventory['Type'] == 'Crafting') {
                InventoryType = $(this).parent().parent().data('type')
                ThisSlot = $(this).attr("data-craftslot")
            }
            if (InventoryType == 'other') {
                FromData = $('.other-inventory-blocks').find("[data-slot=" + ThisSlot + "]").data("itemdata");
            }
            if (HasThisSlotAnything) {
                if (InventoryType == 'other' && CurrentOtherInventory != null && CurrentOtherInventory != undefined && CurrentOtherInventory['Type'] == 'Store') {
                    if (FromData['Amount'] > 0) {
                        DraggingData.Dragging = true;
                        DraggingData.DraggingSlot = ThisSlot
                        DraggingData.FromInv = InventoryType
                        DraggingData.From = $(this)
                        $(DraggingData.From).css("opacity", "0.3");
                        var MoveAmount = $('.inventory-option-amount').val();
                        if (MoveAmount == 0 || MoveAmount == undefined || MoveAmount == null || MoveAmount > FromData['Amount']) {MoveAmount = FromData['Amount']}
                        if (FromData['Type'] == 'weapon') {
                            var Quality = 'quality-good'
                            if (FromData['Info'].quality < 40) { Quality = 'quality-bad' } else if (FromData['Info'].quality >= 40 && FromData['Info'].quality < 70) { Quality = 'quality-okay'}
                            $('.inventory-item-move').html(`<img src="./img/items/${FromData['Image']}" class="inventory-item-move-img"><div class="inventory-item-move-amount">${MoveAmount} (${((FromData['Weight'] * MoveAmount) / 1000).toFixed(1)})</div><div class="inventory-move-price">€${FromData['Price']}</div><div class="inventory-item-move-name">${FromData['Label']}</div><div class="inventory-item-move-quality"><div class="inventory-quality-fill ${Quality}" style="width: ${FromData['Info'].quality}%"></div></div>`)        
                        } else {
                            $('.inventory-item-move').html(`<img src="./img/items/${FromData['Image']}" class="inventory-item-move-img"><div class="inventory-item-move-amount">${MoveAmount} (${((FromData['Weight'] * MoveAmount) / 1000).toFixed(1)})</div><div class="inventory-move-price">€${FromData['Price']}</div><div class="inventory-item-move-name">${FromData['Label']}</div>`)        
                        }
                    } else {
                        HandleInventoryError(false);
                    }
                } else {
                    if (InventoryType == 'my') {
                        DraggingData.From = $(this)
                        $.post('http://fw-inv/IsHoldingWeapon', JSON.stringify({}), function(HasWeapon){
                            if (HasWeapon) {
                                var CanMove = IsThisAWeaponAttachment(FromData['ItemName'])
                                if (CanMove) {
                                    DraggingData.Dragging = true;
                                    DraggingData.DraggingSlot = ThisSlot
                                    DraggingData.FromInv = InventoryType
                                    $(DraggingData.From).css("opacity", "0.3");
                                    var MoveAmount = $('.inventory-option-amount').val();
                                    if (MoveAmount == 0 || MoveAmount == undefined || MoveAmount == null || MoveAmount > FromData['Amount']) {MoveAmount = FromData['Amount']}
                                    if (FromData['Type'] == 'weapon') {
                                        var Quality = 'quality-good'
                                        if (FromData['Info'].quality < 40) { Quality = 'quality-bad' } else if (FromData['Info'].quality >= 40 && FromData['Info'].quality < 70) { Quality = 'quality-okay'}
                                        $('.inventory-item-move').html(`<img src="./img/items/${FromData['Image']}" class="inventory-item-move-img"><div class="inventory-item-move-amount">${MoveAmount} (${((FromData['Weight'] * MoveAmount) / 1000).toFixed(1)})</div><div class="inventory-item-move-name">${FromData['Label']}</div><div class="inventory-item-move-quality"><div class="inventory-quality-fill ${Quality}" style="width: ${FromData['Info'].quality}%"></div></div>`)        
                                    } else {
                                        $('.inventory-item-move').html(`<img src="./img/items/${FromData['Image']}" class="inventory-item-move-img"><div class="inventory-item-move-amount">${MoveAmount} (${((FromData['Weight'] * MoveAmount) / 1000).toFixed(1)})</div><div class="inventory-item-move-name">${FromData['Label']}</div>`)        
                                    }
                                } else {
                                    HandleInventoryError(false);
                                }
                            } else {
                                DraggingData.Dragging = true;
                                DraggingData.DraggingSlot = ThisSlot
                                DraggingData.FromInv = InventoryType
                                $(DraggingData.From).css("opacity", "0.3");
                                var MoveAmount = $('.inventory-option-amount').val();
                                if (MoveAmount == 0 || MoveAmount == undefined || MoveAmount == null || MoveAmount > FromData['Amount']) {MoveAmount = FromData['Amount']}
                                if (FromData['Type'] == 'weapon') {
                                    var Quality = 'quality-good'
                                    if (FromData['Info'].quality < 40) { Quality = 'quality-bad' } else if (FromData['Info'].quality >= 40 && FromData['Info'].quality < 70) { Quality = 'quality-okay'}
                                    $('.inventory-item-move').html(`<img src="./img/items/${FromData['Image']}" class="inventory-item-move-img"><div class="inventory-item-move-amount">${MoveAmount} (${((FromData['Weight'] * MoveAmount) / 1000).toFixed(1)})</div><div class="inventory-item-move-name">${FromData['Label']}</div><div class="inventory-item-move-quality"><div class="inventory-quality-fill ${Quality}" style="width: ${FromData['Info'].quality}%"></div></div>`)        
                                } else {
                                    $('.inventory-item-move').html(`<img src="./img/items/${FromData['Image']}" class="inventory-item-move-img"><div class="inventory-item-move-amount">${MoveAmount} (${((FromData['Weight'] * MoveAmount) / 1000).toFixed(1)})</div><div class="inventory-item-move-name">${FromData['Label']}</div>`)        
                                }
                            }
                        });
                    } else {
                        DraggingData.Dragging = true;
                        DraggingData.DraggingSlot = ThisSlot
                        DraggingData.FromInv = InventoryType
                        DraggingData.From = $(this)
                        $(DraggingData.From).css("opacity", "0.3");
                        var MoveAmount = $('.inventory-option-amount').val();
                        if (MoveAmount == 0 || MoveAmount == undefined || MoveAmount == null || MoveAmount > FromData['Amount']) {MoveAmount = FromData['Amount']}
                        if (FromData['Type'] == 'weapon') {
                            var Quality = 'quality-good'
                            if (FromData['Info'].quality < 40) { Quality = 'quality-bad' } else if (FromData['Info'].quality >= 40 && FromData['Info'].quality < 70) { Quality = 'quality-okay'}
                            $('.inventory-item-move').html(`<img src="./img/items/${FromData['Image']}" class="inventory-item-move-img"><div class="inventory-item-move-amount">${MoveAmount} (${((FromData['Weight'] * MoveAmount) / 1000).toFixed(1)})</div><div class="inventory-item-move-name">${FromData['Label']}</div><div class="inventory-item-move-quality"><div class="inventory-quality-fill ${Quality}" style="width: ${FromData['Info'].quality}%"></div></div>`)        
                        } else {
                            $('.inventory-item-move').html(`<img src="./img/items/${FromData['Image']}" class="inventory-item-move-img"><div class="inventory-item-move-amount">${MoveAmount} (${((FromData['Weight'] * MoveAmount) / 1000).toFixed(1)})</div><div class="inventory-item-move-name">${FromData['Label']}</div>`)        
                        }
                    }
                }
            }
        } else if (e.button === 1) {
            var HasThisSlotAnything = $(this).hasClass("draghandle")
            if (HasThisSlotAnything) {
                var ThisSlot = $(this).attr("data-slot")
                ClosePlayerInventory()
                $.post('http://fw-inv/UseItem', JSON.stringify({Slot: ThisSlot}))
            }
        } else if (e.button === 2) {
            var HasThisSlotAnything = $(this).hasClass("draghandle")
            if (HasThisSlotAnything && CanQuickMove) {
                CanQuickMove = false;
                var ThisSlot = $(this).attr("data-slot")
                var InventoryType = $(this).parent().data('type')
                if (InventoryType == null && InventoryType == undefined && CurrentOtherInventory['Type'] == 'Crafting') {
                    InventoryType = $(this).parent().parent().data('type')
                    ThisSlot = $(this).attr("data-craftslot")
                }
                var FromData = $('.my-inventory-blocks').find("[data-slot=" + ThisSlot + "]").data("itemdata");
                if (InventoryType == 'other') {
                    FromData = $('.other-inventory-blocks').find("[data-slot=" + ThisSlot + "]").data("itemdata");
                }
                if (FromData != null && FromData != undefined ) {
                    var MoveToSlot = GetQuickSlot(InventoryType, FromData['ItemName'], FromData['Unique'])
                    var MoveAmount = FromData['Amount']
                    if (e.shiftKey) {
                        MoveAmount = Math.floor(MoveAmount / 2)
                    } else if (e.ctrlKey) {
                        MoveAmount = 1
                    }
                    if (MoveToSlot != false) {
                        if (InventoryType == 'my') {
                            $('.inventory-item-info').hide();
                            HandleItemSwap(ThisSlot, MoveToSlot, '.my-inventory-blocks', '.other-inventory-blocks', MoveAmount)
                            setTimeout(function() {
                                CanQuickMove = true;
                            }, 200)
                        } else if (InventoryType == 'other') {
                            $('.inventory-item-info').hide();
                            HandleItemSwap(ThisSlot, MoveToSlot, '.other-inventory-blocks', '.my-inventory-blocks', MoveAmount)
                            setTimeout(function() {
                                CanQuickMove = true;
                            }, 200)
                        }
                    } else {
                        HandleInventoryError(false);
                        CanQuickMove = true;
                    }
                }
            } 
        }
    },
    mouseup: function(e){
        e.preventDefault();
        if (e.button === 0) {
            var ToSlot = $(this).attr("data-slot")
            var ToInventory = $(this).parent().data('type')
            var MoveAmount = $('.inventory-option-amount').val();
            if (DraggingData.DraggingSlot != undefined && DraggingData.DraggingSlot != null) {
                if (DraggingData.FromInv == 'my' && ToInventory == 'my') {
                    if (ToSlot != DraggingData.DraggingSlot) {
                        HandleItemSwap(DraggingData.DraggingSlot, ToSlot, '.my-inventory-blocks', '.my-inventory-blocks', MoveAmount)
                    }
                } else if (DraggingData.FromInv == 'my' && ToInventory == 'other') {
                    HandleItemSwap(DraggingData.DraggingSlot, ToSlot, '.my-inventory-blocks', '.other-inventory-blocks', MoveAmount)
                } else if (DraggingData.FromInv == 'other' && ToInventory == 'other') {
                    if (ToSlot != DraggingData.DraggingSlot) {
                        HandleItemSwap(DraggingData.DraggingSlot, ToSlot, '.other-inventory-blocks', '.other-inventory-blocks', MoveAmount)
                    }
                } else if (DraggingData.FromInv == 'other' && ToInventory == 'my') {
                    HandleItemSwap(DraggingData.DraggingSlot, ToSlot, '.other-inventory-blocks', '.my-inventory-blocks', MoveAmount)
                }
            }
            $(DraggingData.From).css("opacity", "");
            $('.inventory-item-move').hide();
            DraggingData.DraggingSlot = null;
            DraggingData.Dragging = false;
            DraggingData.FromInv = null;
            DraggingData.From = null;
        }
    },
},'.inventory-block, .inventory-block-crafting');

$(document).on({
    mouseenter: function(e){
        e.preventDefault();
        if (!DraggingData.Dragging) {
            $('.inventory-info-container').fadeIn(150);
        }
    },
    mouseleave: function(e){
        e.preventDefault();
        $('.inventory-info-container').fadeOut(150);
    }
},'.inventory-option-info');

$(document).on('keydown', function(){
    if (event.keyCode == 67 && event.ctrlKey) {
        var InfoText = $(".info-desc").text();
        if (InfoText != '' && InfoText != null && InfoText != undefined) {
            var TextArea = document.createElement('textarea');
            TextArea.value = InfoText
            TextArea.style.top = '0';
            TextArea.style.left = '0';
            TextArea.style.position = 'fixed';
            document.body.appendChild(TextArea);
            TextArea.focus();
            TextArea.select();
            try {
                document.execCommand('copy');
            } catch (err) { }
            document.body.removeChild(TextArea);
            $.post("http://fw-inv/CopyToClipboard", JSON.stringify({}));
        }
    }
});

$(document).on({
    mousemove: function(e){
        if (DraggingData.Dragging) {
            $('.inventory-item-move')
            $('.inventory-item-move').css({
                'top': e.pageY - ($(document).height() / 100) * 6.5,
                'left': e.pageX - ($(document).width() / 100) * 2.6,
            })
            $('.inventory-item-move').show();
        }
    },
    mouseup: function(e){
        setTimeout(function() {
            if (e.button === 0) {
                if (DraggingData.Dragging) {
                    if (UseHover) {
                        ClosePlayerInventory()
                        $.post('http://fw-inv/UseItem', JSON.stringify({Slot: DraggingData.DraggingSlot}))
                    } else {
                        $(DraggingData.From).css("opacity", "");
                        $('.inventory-item-move').hide();
                        DraggingData.DraggingSlot = null;
                        DraggingData.Dragging = false;
                        DraggingData.FromInv = null;
                        DraggingData.From = null;
                    }
                }
            }
        }, 20)
    },
});

// $(document).on({
//     mouseup: function(e){
//         e.preventDefault();
//         UseHover = true;
        
//         setTimeout(function() {
//             if (e.button === 0) {
//                 if (DraggingData.Dragging) {
//                     if (UseHover) {
//                         ClosePlayerInventory()
//                         $.post('http://fw-inv/GiveItem', JSON.stringify({Slot: DraggingData.DraggingSlot}))
//                     } else {
//                         $(DraggingData.From).css("opacity", "");
//                         $('.inventory-item-move').hide();
//                         DraggingData.DraggingSlot = null;
//                         DraggingData.Dragging = false;
//                         DraggingData.FromInv = null;
//                         DraggingData.From = null;
//                     }
//                 }
//             }
//         }, 20)
//     },
//     mouseleave: function(e){
//         e.preventDefault();
//         UseHover = false;
//     }
// }, ".inventory-option-give");


$(document).on({
    mouseenter: function(e){
        e.preventDefault();
        UseHover = true;
    },
    mouseleave: function(e){
        e.preventDefault();
        UseHover = false;
    }
}, ".inventory-option-use");

$(document).on({
    mousemove: function(e){
        e.preventDefault();
        if (!DraggingData.Dragging) {     
            var HasThisSlotAnything = $(this).hasClass("draghandle")
            if (HasThisSlotAnything) {
                var ThisSlot = $(this).attr("data-slot")
                var InventoryType = $(this).parent().data('type')
                if (InventoryType == null && InventoryType == undefined && CurrentOtherInventory['Type'] == 'Crafting') {
                    InventoryType = $(this).parent().parent().data('type')
                    ThisSlot = $(this).attr("data-craftslot")
                }
                var FromData = $('.my-inventory-blocks').find("[data-slot=" + ThisSlot + "]").data("itemdata");
                if (InventoryType == 'other') {
                    FromData = $('.other-inventory-blocks').find("[data-slot=" + ThisSlot + "]").data("itemdata");
                }
                if (InventoryType == 'my' || InventoryType == 'other' && CurrentOtherInventory['Type'] == 'Stash' || CurrentOtherInventory['Type'] == 'Glovebox' || CurrentOtherInventory['Type'] == 'Trunk' || CurrentOtherInventory['Type'] == 'Drop' || CurrentOtherInventory['Type'] == 'OtherPlayer') {
                    if (FromData != null && FromData != undefined) {
                        $('.info-name').html(`${FromData['Label']}`)
                        HandleInventoryInfo(FromData);
                        $('.inventory-item-info').css({
                            'top': e.pageY - ($(document).height() / 100) * -1.5,
                            'left': e.pageX - ($(document).width() / 100) * -0.4,
                        })
                        $('.inventory-item-info').show();
                    } else {
                        $('.inventory-item-info').hide();
                        $('.info-name').html("")
                        $('.info-desc').html("")
                    }
                }
            } else {
                $('.inventory-item-info').hide();
                $('.info-name').html("")
                $('.info-desc').html("")
            }
        }
    },
    mouseleave: function(e){
        $('.inventory-item-info').hide();
        $('.info-name').html("")
        $('.info-desc').html("")
    },
}, '.inventory-block, .inventory-block-crafting');

$(document).on('click', '.inventory-option-steal', function(e) {
    $('.inventory-option-steal').hide();
    $.post('http://fw-inv/StealMoney', JSON.stringify({Slot: DraggingData.DraggingSlot}))
});

$(document).on('click', '.inventory-option-close', function(e) {
    e.preventDefault();
    ClosePlayerInventory()
});

document.onkeyup = function(data) {
    if (data.which == 9 || data.which == 27) {
        ClosePlayerInventory()
    }
};

window.onload = function(e) {
 $(".background").fadeOut(0);
 $('.item-hotbar-container').fadeOut(0);
 $('.item-needed-container').fadeOut(0);
 $('.inventory-info-container').fadeOut(0);
}

window.addEventListener('message', function(event) {
    switch(event.data.action) {
        case "OpenInventory":
            OpenPlayerInventory(event.data)
            break;
        case "RefreshInventory":
            RefreshInventory(event.data)
            break;
        case "ForceClose":
            ClosePlayerInventory()
            break;
        case "ShowStealButton":
            ShowStealButton()
            break;
        case "ShowRequired":
            HandleShowRequired(event.data.data)
            break;
        case "HideRequired":
            HandleHideRequired()
            break;
        case "ShowItemBox":
            HandleInventoryShowBox(event.data.data)
            break;
        case "ShowHotbar":
            HandelInventoryHotbar(event.data)
            break;
        case "HideHotbar":
            $('.item-hotbar-container').fadeOut(850, function(){
                $('.item-hotbar-container').html('');
            });
            break;
    }
});