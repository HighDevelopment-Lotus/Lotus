SetupEstate = function(data) {
    $(".estateagents-list").html("");

    if (data.length > 0) {
        $.each(data, function(i, estateagent){
            var element = '<div class="estateagent-list" id="estateagentid-'+i+'"> <div class="estateagent-list-firstletter">' + (estateagent.name).charAt(0).toUpperCase() + '</div> <div class="estateagent-list-fullname">' + estateagent.name + '</div> <div class="estateagent-list-call"><i class="fas fa-phone"></i></div> </div>'
            $(".estateagents-list").append(element);
            $("#estateagentid-"+i).data('EstateagentData', estateagent);
        });
    } else {
        var element = '<div class="estateagent-list"><div class="no-estateagents">Er zijn geen makelaren beschikbaar.</div></div>'
        $(".estateagents-list").append(element);
    }
}

$(document).on('click', '.estateagent-list-call', function(e){
    e.preventDefault();

    var EstateagentData = $(this).parent().data('EstateagentData');

    var cData = {
        number: EstateagentData.phone,
        name: EstateagentData.name
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
