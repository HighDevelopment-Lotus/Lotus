SetupAutocare = function(data) {
    $(".autocare-list").html("");

    if (data.length > 0) {
        $.each(data, function(i, autocare){
            var element = '<div class="autocare-item" id="autocareid-'+i+'"><div class="autocare-list-call"><i class="fas fa-phone"></i></div><div class="autocare-namehandler"><p class="autocare-name">' + autocare.name + '</p><p class="autocare-business">' + autocare.business + '</p></div></div>'
            $(".autocare-list").append(element);
            $("#autocareid-"+i).data('AutocareData', autocare);
        });
    } else {
        var element = '<div class="autocare-list"><div class="no-autocare">Er is geen autocare beschikbaar.</div></div>'
        $(".autocare-list").append(element);
    }
}

$(document).on('click', '.autocare-list-call', function(e){
    e.preventDefault();

    var AutoData = $(this).parent().data('AutocareData');

    var cData = {
        number: AutoData.phone,
        name: AutoData.name
    }

    $.post('http://fw-phone/CallContact', JSON.stringify({
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
                            $(".autocare-app").css({"display":"none"});
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
