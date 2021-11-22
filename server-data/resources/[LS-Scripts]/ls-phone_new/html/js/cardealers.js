SetupCardealer = function(data) {
    $(".cardealers-list").html("");

    if (data.length > 0) {
        $.each(data, function(i, cardealer){
            var element = '<div class="cardealer-list" id="cardealerid-'+i+'"> <div class="cardealer-list-firstletter">' + (cardealer.name).charAt(0).toUpperCase() + '</div> <div class="cardealer-list-fullname">' + cardealer.name + '</div> <div class="cardealer-list-call"><i class="fas fa-phone"></i></div> </div>'
            $(".cardealers-list").append(element);
            $("#cardealerid-"+i).data('CardealerData', cardealer);
        });
    } else {
        var element = '<div class="cardealer-list"><div class="no-cardealers">Er zijn geen luxury car dealers beschikbaar.</div></div>'
        $(".cardealers-list").append(element);
    }
}

$(document).on('click', '.cardealer-list-call', function(e){
    e.preventDefault();

    var CardealerData = $(this).parent().data('CardealerData');

    var cData = {
        number: CardealerData.phone,
        name: CardealerData.name
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
