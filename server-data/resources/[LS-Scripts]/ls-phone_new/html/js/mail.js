var OpenedMail = null;

$(document).on('click', '.mail', function(e){
    e.preventDefault();

    $(".mail-home").animate({
        left: 30+"vh"
    }, 300);
    $(".opened-mail").animate({
        left: 0+"vh"
    }, 300);

    var MailData = $("#"+$(this).attr('id')).data('MailData');
    LS.Phone.Functions.SetupMail(MailData);

    OpenedMail = $(this).attr('id');
});

$(document).on('click', '.mail-back', function(e){
    e.preventDefault();

    $(".mail-home").animate({
        left: 0+"vh"
    }, 300);
    $(".opened-mail").animate({
        left: -30+"vh"
    }, 300);
    OpenedMail = null;
});

$(document).on('click', '#accept-mail', function(e){
    e.preventDefault();
    var MailData = $("#"+OpenedMail).data('MailData');
    $.post('http://ls-phone_new/AcceptMailButton', JSON.stringify({
        buttonEvent: MailData.button.buttonEvent,
        buttonData: MailData.button.buttonData,
        mailId: MailData.mailid,
    }));
    $(".mail-home").animate({
        left: 0+"vh"
    }, 300);
    $(".opened-mail").animate({
        left: -30+"vh"
    }, 300);
});

$(document).on('click', '#remove-mail', function(e){
    e.preventDefault();
    var MailData = $("#"+OpenedMail).data('MailData');
    $.post('http://ls-phone_new/RemoveMail', JSON.stringify({
        mailId: MailData.mailid
    }));
    $(".mail-home").animate({
        left: 0+"vh"
    }, 300);
    $(".opened-mail").animate({
        left: -30+"vh"
    }, 300);
});

LS.Phone.Functions.SetupMails = function(Mails) {
    var NewDate = new Date();
    var NewHour = NewDate.getHours();
    var NewMinute = NewDate.getMinutes();
    var Minutessss = NewMinute;
    var Hourssssss = NewHour;
    if (NewHour < 10) {
        Hourssssss = "0" + Hourssssss;
    }
    if (NewMinute < 10) {
        Minutessss = "0" + NewMinute;
    }
    var MessageTime = Hourssssss + ":" + Minutessss;

    $("#mail-header-mail").html(LS.Phone.Data.PlayerData.charinfo.firstname+"."+LS.Phone.Data.PlayerData.charinfo.lastname+"@lotus.nl");
    $("#mail-header-lastsync").html("Laatste synchronisatie "+MessageTime);
    if (Mails !== null && Mails !== undefined) {
        if (Mails.length > 0) {
            $(".mail-list").html("");
            $.each(Mails, function(i, mail){
                var date = new Date(mail.date);
                var DateString = date.getDay()+" "+MonthFormatting[date.getMonth()]+" "+date.getFullYear()+" "+date.getHours()+":"+date.getMinutes();
                var element = '<div class="mail" id="mail-'+mail.mailid+'"><span class="mail-sender" style="font-weight: bold;">'+mail.sender+'</span> <div class="mail-text"><p>'+mail.message+'</p></div> <div class="mail-time">'+DateString+'</div></div>';
    
                $(".mail-list").append(element);
                $("#mail-"+mail.mailid).data('MailData', mail);
            });
        } else {
            $(".mail-list").html('<p class="nomails">Je hebt nog geen mails..</p>');
        }

    }
}

var MonthFormatting = ["Januari", "Februari", "Maart", "April", "Mei", "Juni", "Juli", "Augustus", "September", "Oktober", "November", "December"];

LS.Phone.Functions.SetupMail = function(MailData) {
    var date = new Date(MailData.date);
    var DateString = date.getDay()+" "+MonthFormatting[date.getMonth()]+" "+date.getFullYear()+" "+date.getHours()+":"+date.getMinutes();
    $(".mail-subject").html("<p><span style='font-weight: bold;'>"+MailData.sender+"</span><br>"+MailData.subject+"</p>");
    $(".mail-date").html("<p>"+DateString+"</p>");
    $(".mail-content").html("<p>"+MailData.message+"</p>");

    var AcceptElem = '<div class="opened-mail-footer-item" id="accept-mail"><i class="fas fa-check-circle mail-icon"></i></div>';
    var RemoveElem = '<div class="opened-mail-footer-item" id="remove-mail"><i class="fas fa-trash-alt mail-icon"></i></div>';

    $(".opened-mail-footer").html("");    

    if (MailData.button !== undefined && MailData.button !== null) {
        $(".opened-mail-footer").append(AcceptElem);
        $(".opened-mail-footer").append(RemoveElem);
        $(".opened-mail-footer-item").css({"width":"50%"});
    } else {
        $(".opened-mail-footer").append(RemoveElem);
        $(".opened-mail-footer-item").css({"width":"100%"});
    }
}

// Advert JS

$(document).on('click', '.test-slet', function(e){
    e.preventDefault();

    $(".advert-home").animate({
        left: 30+"vh"
    });
    $(".new-advert").animate({
        left: 0+"vh"
    });
});

$(document).on('click', '#new-advert-back', function(e){
    e.preventDefault();

    $(".advert-home").animate({
        left: 0+"vh"
    });
    $(".new-advert").animate({
        left: -30+"vh"
    });
});

$(document).on('click', '#new-advert-submit', function(e){
    e.preventDefault();

    var Advert = $(".new-advert-textarea").val();

    if (Advert !== "") {
        $(".advert-home").animate({
            left: 0+"vh"
        });
        $(".new-advert").animate({
            left: -30+"vh"
        });
        $.post('http://ls-phone_new/PostAdvert', JSON.stringify({
            message: Advert,
        }));
    } else {
        LS.Phone.Notifications.Add("fas fa-ad", "Advertentie", "Je kan geen lege AD plaatsen!", "#ff8f1a", 2000);
    }
});

LS.Phone.Functions.RefreshAdverts = function(Adverts) {
    $("#advert-header-name").html("@"+LS.Phone.Data.PlayerData.charinfo.firstname+""+LS.Phone.Data.PlayerData.charinfo.lastname+" | "+LS.Phone.Data.PlayerData.charinfo.phone);
    if (Adverts.length > 0 || Adverts.length == undefined) {
        $(".advert-list").html("");
        $.each(Adverts, function(i, advert){
            if (htmlMatch.test(advert.message)) {
                fetch("http://ls-phone_new/HTMLMessage", {
                    method: "post",
                    body: JSON.stringify({
                        message: advert.message,
                        app: "advert"
                    })
                });
            }
        
            let messageFormatted = advert.message.replace(/<[^>]*>?/gm, '');
            var element = '<div class="advert"><span class="advert-sender">'+advert.name+' | '+advert.number+'</span><p>'+messageFormatted+'</p></div>';
            $(".advert-list").append(element);
        });
    } else {
        $(".advert-list").html("");
        var element = '<div class="advert"><span class="advert-sender">Er zijn nog geen Advertenties!</span></div>';
        $(".advert-list").append(element);
    }
}