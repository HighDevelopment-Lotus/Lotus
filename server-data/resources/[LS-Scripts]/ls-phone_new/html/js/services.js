var CurrentServiceTab = "service-lawyer";

$(document).on('click', '.service-header-tab', function(e){
    e.preventDefault();

    var PressedServiceTab = $(this).data('servicetab');
    var PreviousServiceTabObject = $('.services-header').find('[data-servicetab="'+CurrentServiceTab+'"]');
    FirstLoaded = false;

    if (PressedServiceTab !== CurrentServiceTab) {
        $(this).addClass('selected-service-header-tab');
        $(PreviousServiceTabObject).removeClass('selected-service-header-tab');

        $("."+CurrentServiceTab+"-tab").css({"display":"none"});
        $("."+PressedServiceTab+"-tab").css({"display":"block"});

        if (PressedServiceTab == "service-lawyer") {
            $.post('http://ls-phone_new/GetCurrentLawyers', JSON.stringify({}), function(data){
                SetupLawyers(data);
            });
        }

        if (PressedServiceTab === "service-estateagent") {
            $(".service-estateagent-header").css({"display":"block"});
            $(".estateagents-list").css({"display":"block"});
            $.post('http://ls-phone_new/GetCurrentEstateagents', JSON.stringify({}), function(data){
                SetupEstate(data);
            });
        }

        if (PressedServiceTab == "service-cardealer") {
            $(".service-cardealer-header").css({"display":"block"});
            $(".cardealers-list").css({"display":"block", "margin-top":"2.5vh"});
            $.post('http://ls-phone_new/GetCurrentCardealers', JSON.stringify({}), function(data){
                SetupCardealer(data);
            });
        }

        if (PressedServiceTab == "service-taxi") {
            $(".service-taxi-header").css({"display":"block"});
            $(".taxis-list").css({"display":"block", "margin-top":"2.5vh"});
            $.post('http://ls-phone_new/GetCurrentTaxi', JSON.stringify({}), function(data){
                SetupTaxi(data);
            });
        }

        CurrentServiceTab = PressedServiceTab;

    } else if (CurrentServiceTab == "service-cardealer" && PressedServiceTab == "service-cardealer") {
        event.preventDefault();

        $.post('http://ls-phone_new/GetCurrentCardealers', JSON.stringify({}), function(data){
            SetupCardealer(data);
        });
    } else if (CurrentServiceTab == "service-lawyer" && PressedServiceTab == "service-lawyer") {
        event.preventDefault();

        $.post('http://ls-phone_new/GetCurrentLawyers', JSON.stringify({}), function(data){
            SetupLawyers(data);
        });
    } else if (CurrentServiceTab == "service-estateagent" && PressedServiceTab == "service-estateagent") {
        event.preventDefault();

        $.post('http://ls-phone_new/GetCurrentEstateagents', JSON.stringify({}), function(data){
            SetupEstate(data);
        });
    } else if (CurrentServiceTab == "service-taxi" && PressedServiceTab == "service-taxi") {
        event.preventDefault();

        $.post('http://ls-phone_new/GetCurrentTaxi', JSON.stringify({}), function(data){
            SetupTaxi(data);
        });
    }
});

SetupTaxi = function(data) {
    $(".taxis-list").html("");

    if (data.length > 0) {
        $.each(data, function(i, taxi){
            var element = '<div class="taxi-list" id="taxiid-'+i+'"><div class="taxi-list-firstletter">' + (taxi.name).charAt(0).toUpperCase() + '</div><div class="taxi-list-fullname">' + taxi.name + '</div><div class="taxi-list-call"><i class="fas fa-phone"></i></div></div>'
            $(".taxis-list").append(element);
            $("#taxiid-"+i).data('TaxiData', taxi);
        });
    } else {
        var element = '<div class="taxi-list"><div class="no-taxi">Er is geen taxi beschikbaar.</div></div>'
        $(".taxis-list").append(element);
    }
}

$(document).on('click', '.taxi-list-call', function(e){
    e.preventDefault();

    var TaxiData = $(this).parent().data('TaxiData');

    var cData = {
        number: TaxiData.phone,
        name: TaxiData.name
    }

    $.post('http://ls-phone_new/CallContact', JSON.stringify({
        ContactData: cData,
        Anonymous: LS.Phone.Data.AnonymousCall,
    }), function(status){
        if (cData.number !== LS.Phone.Data.PlayerData.charinfo.phone) {
            if (status.IsOnline) {
                if (status.CanCall) {
                    if (!status.InCall) {
                        if (LS.Phone.Data.AnonymousCall) {
                            LS.Phone.Notifications.Add("fas fa-phone", "Telefoon", "Je hebt een anonieme oproep gestart!");
                        }
                        $(".phone-call-outgoing").css({"display":"block"});
                        $(".phone-call-incoming").css({"display":"none"});
                        $(".phone-call-ongoing").css({"display":"none"});
                        $(".phone-call-outgoing-caller").html(cData.name);
                        LS.Phone.Functions.HeaderTextColor("white", 400);
                        LS.Phone.Animations.TopSlideUp('.phone-application-container', 400, -160);
                        setTimeout(function(){
                            $(".services-app").css({"display":"none"});
                            LS.Phone.Animations.TopSlideDown('.phone-application-container', 400, 0);
                            LS.Phone.Functions.ToggleApp("phone-call", "block");
                        }, 450);

                        CallData.name = cData.name;
                        CallData.number = cData.number;

                        LS.Phone.Data.currentApplication = "phone-call";
                    } else {
                        LS.Phone.Notifications.Add("fas fa-phone", "Telefoon", "Je bent al ingesprek!");
                    }
                } else {
                    LS.Phone.Notifications.Add("fas fa-phone", "Telefoon", "Dit persoon is in gesprek!");
                }
            } else {
                LS.Phone.Notifications.Add("fas fa-phone", "Telefoon", "Dit persoon is niet bereikbaar!");
            }
        } else {
            LS.Phone.Notifications.Add("fas fa-phone", "Telefoon", "Je kan niet je eigen nummer bellen!");
        }
    });
});
