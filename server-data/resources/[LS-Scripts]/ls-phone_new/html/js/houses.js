var AnimationDuration = 200;
var SelectedHousesTab = "myhouses";
var CurrentHouseData = {};
var HousesData = {};

$(document).on('click', '.houses-app-header-tab', function(e){
    e.preventDefault();
    var CurrentHouseTab = $("[data-housetab='"+SelectedHousesTab+"']");
    var Data = $(this).data('housetab');

    if (Data !== SelectedHousesTab) {
        $(".house-app-" + $(CurrentHouseTab).data('housetab') + "-container").css("display", "none");
        $(".house-app-" + Data + "-container").css("display", "block");
        $(CurrentHouseTab).removeClass('houses-app-header-tab-selected');
        $("[data-housetab='"+Data+"']").addClass('houses-app-header-tab-selected');
        SelectedHousesTab = Data
    }
});

$(document).on('click', '.myhouses-house', function(e){
    e.preventDefault();
    if (e.currentTarget.id !== "blocked") {
        var HouseData = $(this).data('HouseData');
        CurrentHouseData = HouseData;
        $(".myhouses-options-container").fadeIn(150);
        $(".myhouses-options-header").html(HouseData.label);
    }
});

$(document).on('click', '#myhouse-option-close', function(e){
    e.preventDefault();
    $(".myhouses-options-container").fadeOut(150);
});

function SetupPlayerHouses(Houses) {
    HousesData = Houses;
    $(".house-app-myhouses-container").html("");
    if (Houses.length > 0) {
        $.each(Houses, function(id, house){
            var HouseDetails = '<i class="fas fa-key"></i>&nbsp;&nbsp;' + house['TotalKeys'] + '&nbsp&nbsp&nbsp&nbsp<i class="fas fa-warehouse"></i>&nbsp;&nbsp;&nbsp;<i class="fas fa-times"></i>';
            if (house['Garage'] !== undefined && house['Garage'] !== null && house['Garage'] != 'false') {
                HouseDetails = '<i class="fas fa-key"></i>&nbsp;&nbsp;' + house['TotalKeys'] + '&nbsp&nbsp&nbsp&nbsp<i class="fas fa-warehouse"></i>&nbsp;&nbsp;&nbsp;<i class="fas fa-check"></i>';
            }
            var elem = '<div class="myhouses-house" id="house-' + id + '"><div class="myhouse-house-icon"><i class="fas fa-home"></i></div> <div class="myhouse-house-titel">' + house['Label'] + ' | Tier ' + house['Tier'] + '</div> <div class="myhouse-house-details">' + HouseDetails + '</div> </div>';
            $(".house-app-myhouses-container").append(elem);
            $("#house-" + id).data('HouseData', house)
        });
    }
}

function SetupPlayerKeys(HousesA) {
    $(".house-app-mykeys-container").html("");
    if (HousesA.length > 0) {
        $.each(HousesA, function(id, house){
            var HouseDetails = '<i class="fas fa-key"></i>&nbsp;&nbsp;' + house['TotalKeys'] + '&nbsp&nbsp&nbsp&nbsp<i class="fas fa-warehouse"></i>&nbsp;&nbsp;&nbsp;<i class="fas fa-times"></i>';
            if (house['Garage'] != undefined && house['Garage'] != null && house['Garage'] != 'false') {
                HouseDetails = '<i class="fas fa-key"></i>&nbsp;&nbsp;' + house['TotalKeys'] + '&nbsp&nbsp&nbsp&nbsp<i class="fas fa-warehouse"></i>&nbsp;&nbsp;&nbsp;<i class="fas fa-check"></i>';
            }
            var elem = '<div class="mykeys" id="blocked-'+id+'"><div class="myhouse-house-icon"><i class="fas fa-home"></i></div> <div class="myhouse-house-titel">' + house['Label'] + ' | Tier ' + house['Tier'] + '</div><div class="myhouse-house-details">' + HouseDetails + '</div></div>';
            $(".house-app-mykeys-container").append(elem);
            $("#blocked-" + id).data('HouseData', house)
        });
    }
}

$(document).on('click', '.mykeys', function(e){
    e.preventDefault();
    var HouseData = $(this).data('HouseData');
    $.post('http://ls-phone_new/setwaypoint', JSON.stringify({CoordsX: HouseData['Coords']['X'], CoordsY: HouseData['Coords']['Y']}));
});

$(document).on('click', '#myhouse-option-transfer', function(e){
    e.preventDefault();

    $(".myhouses-options").animate({
        left: -35+"vw"
    }, AnimationDuration);

    $(".myhouse-option-transfer-container").animate({
        left: 0
    }, AnimationDuration);
});

$(document).on('click', '#myhouse-option-keys', function(e){
    if (CurrentHouseData['Keyholders'] !== undefined && CurrentHouseData['Keyholders'] !== null) {
        $(".keys-container").empty();
        $.each(CurrentHouseData['Keyholders'], function(i, keyholder){
            if (keyholder !== null && keyholder !== undefined) {
                var elem;
                if (keyholder['Name'] != LS.Phone.Data.PlayerData.charinfo.firstname+' '+LS.Phone.Data.PlayerData.charinfo.lastname) {
                    elem = '<div class="house-key" id="holder-'+i+'"><span class="house-key-holder">' + keyholder['Name'] + '</span> <div class="house-key-delete"><i class="fas fa-trash"></i></div> </div>';
                } else {
                    elem = '<div class="house-key" id="holder-'+i+'"><span class="house-key-holder">(Ik) ' + keyholder['Name'] + '</span></div>';
                }
                $(".keys-container").append(elem);
                $('#holder-' + i).data('KeyholderData', keyholder);
            }
        });
    }
    $(".myhouses-options").animate({
        left: -35+"vw"
    }, AnimationDuration);
    $(".myhouse-option-keys-container").animate({
        left: 0
    }, AnimationDuration);
});

$(document).on('click', '.house-key-delete', function(e){
    e.preventDefault();
    var Data = $(this).parent().data('KeyholderData');
    //console.log(CurrentHouseData['House'], Data['CitizenId'])
    $.post('http://ls-phone_new/RemoveKeyholder', JSON.stringify({
        RemoveCid: Data['CitizenId'],
        House: CurrentHouseData['House'],
    }));
    $(this).parent().fadeOut(250, function(){
        $(this).remove();
    });
    $.post('http://ls-phone_new/GetPlayerHouses', JSON.stringify({}), function(Houses){
        SetupPlayerHouses(Houses);
    });
    $.post('http://ls-phone_new/GetPlayerKeys', JSON.stringify({}), function(Houses){
        SetupPlayerKeys(Houses);
    });
});

$(document).on('click', '#myhouse-option-transfer-confirm', function(e){
    e.preventDefault();
    let newCitizenId = $(".myhouse-option-transfer-container-citizenid")[0].value;
    $.post('http://ls-phone_new/ChangeOwner', JSON.stringify({newCid: newCitizenId, HouseData: CurrentHouseData['House']}), function(Transferd){
        if (Transferd) {
            $(".myhouses-options").animate({
                left: 0
            }, AnimationDuration);
            $(".myhouse-option-transfer-container").animate({
                left: 35+"vw"
            }, AnimationDuration);
            $(".myhouses-options-container").fadeOut(150);
            $.post('http://ls-phone_new/GetPlayerHouses', JSON.stringify({}), function(Houses){
                SetupPlayerHouses(Houses);
            });
            $.post('http://ls-phone_new/GetPlayerKeys', JSON.stringify({}), function(Houses){
                SetupPlayerKeys(Houses);
            });
        }
    }); 
});

$(document).on('click', '#myhouse-option-transfer-back', function(e){
    e.preventDefault();

    $(".myhouses-options").animate({
        left: 0
    }, AnimationDuration);

    $(".myhouse-option-transfer-container").animate({
        left: 35+"vw"
    }, AnimationDuration);
});

$(document).on('click', '#myhouse-option-keys-back', function(e){
    e.preventDefault();

    $(".myhouses-options").animate({
        left: 0
    }, AnimationDuration);
    $(".myhouse-option-keys-container").animate({
        left: 35+"vw"
    }, AnimationDuration);
});
