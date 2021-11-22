LS = {}
LS.Phone = {}
LS.Screen = {}
LS.Phone.Functions = {}
LS.Phone.Animations = {}
LS.Phone.Notifications = {}
LS.Phone.ContactColors = {
    0: "#9b59b6",
    1: "#3498db",
    2: "#e67e22",
    3: "#e74c3c",
    4: "#1abc9c",
    5: "#9c88ff",
}

LS.Phone.Data = {
    currentApplication: null,
    PlayerData: {},
    Applications: {},
    IsOpen: false,
    CallActive: false,
    MetaData: {},
    PlayerJob: {},
    AnonymousCall: false,
}

OpenedChatData = {
    number: null,
}

var CanOpenApp = true;

var htmlMatch = /<[^>].*?>/gm;

function IsAppJobBlocked(joblist, myjob) {
    var retval = false;
    if (joblist.length > 0) {
        $.each(joblist, function(i, job){
            if (job == myjob && LS.Phone.Data.PlayerData.job.onduty) {
                retval = true;
            }
        });
    }
    return retval;
}

function IsAppAccess(joblist, myjob) {
    var retval = false;
    if (joblist.length > 0) {
        $.each(joblist, function(i, job){
            //console.log(job);
            if (job == myjob && LS.Phone.Data.PlayerData.job.onduty) {
                retval = true;
            }
        });
    }
    return retval;
}

LS.Phone.Functions.SetupApplications = function(data) {
    LS.Phone.Data.Applications = data.applications;
    $.each(data.applications, function(i, app){
        var applicationSlot = $(".phone-applications").find('[data-appslot="'+app.slot+'"]');
        var blockedapp = IsAppJobBlocked(app.blockedjobs, LS.Phone.Data.PlayerJob.name);
        var accessapp = IsAppAccess(app.access, LS.Phone.Data.PlayerJob.name);
        $(applicationSlot).html("");
        $(applicationSlot).css({"background-color":"transparent"});
        $(applicationSlot).prop('title', "");
        $(applicationSlot).removeData('app');
        if (app.tooltipPos !== undefined) {
            $(applicationSlot).removeData('placement')
        }

        if ((!app.job || app.job === LS.Phone.Data.PlayerJob.name) && !blockedapp) {
            $(applicationSlot).css({"background-color":app.color});
            var icon = '<i class="ApplicationIcon '+app.icon+'" style="'+app.style+'"></i>';
            if (app.app == "meos") {
                icon = '<img src="./img/politie.png" class="police-icon">';
            }
            $(applicationSlot).html(icon+'<div class="app-unread-alerts">0</div>');
            $(applicationSlot).prop('title', app.tooltipText);
            $(applicationSlot).data('app', app.app);

            if (app.tooltipPos !== undefined) {
                $(applicationSlot).data('placement', app.tooltipPos)
            }
        }
    });

    $('[data-toggle="tooltip"]').tooltip();
}

LS.Phone.Functions.SetupAppWarnings = function(AppData) {
    $.each(AppData, function(i, app){
        var AppObject = $(".phone-applications").find("[data-appslot='"+app.slot+"']").find('.app-unread-alerts');

        if (app.Alerts > 0) {
            $(AppObject).html(app.Alerts);
            $(AppObject).css({"display":"block"});
        } else {
            $(AppObject).css({"display":"none"});
        }
    });
}

LS.Phone.Functions.IsAppHeaderAllowed = function(app) {
    var retval = true;
    $.each(Config.HeaderDisabledApps, function(i, blocked){
        if (app == blocked) {
            retval = false;
        }
    });
    return retval;
}

$(document).on('click', '.phone-application', function(e){
    e.preventDefault();
    var PressedApplication = $(this).data('app');
    var AppObject = $("."+PressedApplication+"-app");

    if (AppObject.length !== 0) {
        if (CanOpenApp) {
            if (LS.Phone.Data.currentApplication == null) {
                LS.Phone.Animations.TopSlideDown('.phone-application-container', 300, 0);
                LS.Phone.Functions.ToggleApp(PressedApplication, "block");

                if (LS.Phone.Functions.IsAppHeaderAllowed(PressedApplication)) {
                    LS.Phone.Functions.HeaderTextColor("black", 300);
                }

                LS.Phone.Data.currentApplication = PressedApplication;

                if (PressedApplication == "settings") {
                    $("#myPhoneNumber").text(LS.Phone.Data.PlayerData.charinfo.phone)
                } else if (PressedApplication == "twitter") {
                    $.post('http://ls-phone_new/GetMentionedTweets', JSON.stringify({}), function(MentionedTweets){
                        LS.Phone.Notifications.LoadMentionedTweets(MentionedTweets)
                    })
                    $.post('http://ls-phone_new/GetHashtags', JSON.stringify({}), function(Hashtags){
                        LS.Phone.Notifications.LoadHashtags(Hashtags)
                    })
                    if (LS.Phone.Data.IsOpen) {
                        $.post('http://ls-phone_new/GetTweets', JSON.stringify({}), function(Tweets){
                            LS.Phone.Notifications.LoadTweets(Tweets);
                        });
                    }
                } else if (PressedApplication == "bank") {
                    LS.Phone.Functions.DoBankOpen();
                    $.post('http://ls-phone_new/GetBankContacts', JSON.stringify({}), function(contacts){
                        LS.Phone.Functions.LoadContactsWithNumber(contacts);
                    });
                    $.post('http://ls-phone_new/GetInvoices', JSON.stringify({}), function(invoices){
                        LS.Phone.Functions.LoadBankInvoices(invoices);
                    });
                    $.post('http://ls-phone_new/SetupSharedAccounts', JSON.stringify({}), function(accounts){
                        LS.Phone.Functions.SetupSharedAccounts(accounts);
                    });
                } else if (PressedApplication == "whatsapp") {
                    $.post('http://ls-phone_new/GetWhatsappChats', JSON.stringify({}), function(chats){
                        LS.Phone.Functions.LoadWhatsappChats(chats);
                    });
                } else if (PressedApplication == "phone") {
                    $.post('http://ls-phone_new/GetMissedCalls', JSON.stringify({}), function(recent){
                        LS.Phone.Functions.SetupRecentCalls(recent);
                    });
                    $.post('http://ls-phone_new/GetSuggestedContacts', JSON.stringify({}), function(suggested){
                        LS.Phone.Functions.SetupSuggestedContacts(suggested);
                    });
                    $.post('http://ls-phone_new/ClearGeneralAlerts', JSON.stringify({
                        app: "phone"
                    }));
                } else if (PressedApplication == "mail") {
                    $.post('http://ls-phone_new/GetMails', JSON.stringify({}), function(mails){
                        LS.Phone.Functions.SetupMails(mails);
                    });
                    $.post('http://ls-phone_new/ClearGeneralAlerts', JSON.stringify({
                        app: "mail"
                    }));
                } else if (PressedApplication == "advert") {
                    $.post('http://ls-phone_new/LoadAdverts', JSON.stringify({}), function(Adverts){
                        LS.Phone.Functions.RefreshAdverts(Adverts);
                    })
                } else if (PressedApplication == "garage") {
                    $.post('http://ls-phone_new/SetupGarageVehicles', JSON.stringify({}), function(Vehicles){
                        SetupGarageVehicles(Vehicles);
                    })
                } else if (PressedApplication == "crypto") {
                    $.post('http://ls-phone_new/GetCryptoData', JSON.stringify({
                        crypto: "bitcoin",
                    }), function(CryptoData){
                        SetupCryptoData(CryptoData);
                    })

                    $.post('http://ls-phone_new/GetCryptoTransactions', JSON.stringify({}), function(data){
                        RefreshCryptoTransactions(data);
                    })
                } else if (PressedApplication == "racing") {
                    $.post('http://ls-phone_new/GetAvailableRaces', JSON.stringify({}), function(Races){
                        SetupRaces(Races);
                    });
                } else if (PressedApplication == "houses") {
                    $.post('http://ls-phone_new/GetPlayerHouses', JSON.stringify({}), function(Houses){
                        SetupPlayerHouses(Houses);
                    });
                    $.post('http://ls-phone_new/GetPlayerKeys', JSON.stringify({}), function(Houses){
                        SetupPlayerKeys(Houses);
                    });
                } else if (PressedApplication == "meos") {
                    SetupMeosHome();
                } else if (PressedApplication == "services") {
                    $.post('http://ls-phone_new/GetCurrentLawyers', JSON.stringify({}), function(data){
                        SetupLawyers(data);
                    });
                } else if (PressedApplication == "autocare") {
                    $.post('http://ls-phone_new/GetCurrentAutocare', JSON.stringify({}), function(data){
                        SetupAutocare(data);
                    });
                }
            }
        }
    } else {
        LS.Phone.Notifications.Add("fas fa-exclamation-circle", "Systeem", LS.Phone.Data.Applications[PressedApplication].tooltipText+" is niet beschikbaar!")
    }
});

$(document).on('click', '.phone-home-container', function(event){
    event.preventDefault();

    if (LS.Phone.Data.currentApplication === null) {
        LS.Phone.Functions.Close();
    } else {
        LS.Phone.Animations.TopSlideUp('.phone-application-container', 400, -160);
        LS.Phone.Animations.TopSlideUp('.'+LS.Phone.Data.currentApplication+"-app", 400, -160);
        CanOpenApp = false;
        setTimeout(function(){
            LS.Phone.Functions.ToggleApp(LS.Phone.Data.currentApplication, "none");
            CanOpenApp = true;
        }, 400)
        LS.Phone.Functions.HeaderTextColor("white", 300);

        if (LS.Phone.Data.currentApplication == "whatsapp") {
            if (OpenedChatData.number !== null) {
                setTimeout(function(){
                    $(".whatsapp-chats").css({"display":"block"});
                    $(".whatsapp-chats").animate({
                        left: 0+"vh"
                    }, 1);
                    $(".whatsapp-openedchat").animate({
                        left: -30+"vh"
                    }, 1, function(){
                        $(".whatsapp-openedchat").css({"display":"none"});
                    });
                    OpenedChatPicture = null;
                    OpenedChatData.number = null;
                }, 450);
            }
        } else if (LS.Phone.Data.currentApplication == "bank") {
            if (CurrentTab == "invoices") {
                setTimeout(function(){
                    $(".bank-app-invoices").animate({"left": "30vh"});
                    $(".bank-app-invoices").css({"display":"none"})
                    $(".bank-app-accounts").css({"display":"block"})
                    $(".bank-app-accounts").css({"left": "0vh"});

                    var InvoicesObjectBank = $(".bank-app-header").find('[data-headertype="invoices"]');
                    var HomeObjectBank = $(".bank-app-header").find('[data-headertype="accounts"]');

                    $(InvoicesObjectBank).removeClass('bank-app-header-button-selected');
                    $(HomeObjectBank).addClass('bank-app-header-button-selected');

                    CurrentTab = "accounts";
                }, 400)
            }
        } else if (LS.Phone.Data.currentApplication == "meos") {
            $(".meos-alert-new").remove();
            setTimeout(function(){
                $(".meos-recent-alert").removeClass("noodknop");
                $(".meos-recent-alert").css({"background-color":"#004682"});
            }, 400)
        }

        LS.Phone.Data.currentApplication = null;
    }
});

LS.Phone.Functions.Open = function(data) {
    LS.Phone.Animations.BottomSlideUp('.container', 300, 0);
    LS.Phone.Notifications.LoadTweets(data.Tweets);
    LS.Phone.Data.IsOpen = true;
}

LS.Phone.Functions.ToggleApp = function(app, show) {
    $("."+app+"-app").css({"display":show});
}

LS.Phone.Functions.Close = function() {

    if (LS.Phone.Data.currentApplication == "whatsapp") {
        setTimeout(function(){
            LS.Phone.Animations.TopSlideUp('.phone-application-container', 400, -160);
            LS.Phone.Animations.TopSlideUp('.'+LS.Phone.Data.currentApplication+"-app", 400, -160);
            $(".whatsapp-app").css({"display":"none"});
            LS.Phone.Functions.HeaderTextColor("white", 300);

            if (OpenedChatData.number !== null) {
                setTimeout(function(){
                    $(".whatsapp-chats").css({"display":"block"});
                    $(".whatsapp-chats").animate({
                        left: 0+"vh"
                    }, 1);
                    $(".whatsapp-openedchat").animate({
                        left: -30+"vh"
                    }, 1, function(){
                        $(".whatsapp-openedchat").css({"display":"none"});
                    });
                    OpenedChatData.number = null;
                }, 450);
            }
            OpenedChatPicture = null;
            LS.Phone.Data.currentApplication = null;
        }, 500)
    } else if (LS.Phone.Data.currentApplication == "meos") {
        $(".meos-alert-new").remove();
        $(".meos-recent-alert").removeClass("noodknop");
        $(".meos-recent-alert").css({"background-color":"#004682"});
    }

    LS.Phone.Animations.BottomSlideDown('.container', 300, -70);
    $.post('http://ls-phone_new/Close');
    LS.Phone.Data.IsOpen = false;
}

LS.Phone.Functions.HeaderTextColor = function(newColor, Timeout) {
    $(".phone-header").animate({color: newColor}, Timeout);
}

LS.Phone.Animations.BottomSlideUp = function(Object, Timeout, Percentage) {
    $(Object).css({'display':'block'}).animate({
        bottom: Percentage+"%",
    }, Timeout);
}

LS.Phone.Animations.BottomSlideDown = function(Object, Timeout, Percentage) {
    $(Object).css({'display':'block'}).animate({
        bottom: Percentage+"%",
    }, Timeout, function(){
        $(Object).css({'display':'none'});
    });
}

LS.Phone.Animations.TopSlideDown = function(Object, Timeout, Percentage) {
    $(Object).css({'display':'block'}).animate({
        top: Percentage+"%",
    }, Timeout);
}

LS.Phone.Animations.TopSlideUp = function(Object, Timeout, Percentage, cb) {
    $(Object).css({'display':'block'}).animate({
        top: Percentage+"%",
    }, Timeout, function(){
        $(Object).css({'display':'none'});
    });
}

LS.Phone.Notifications.Add = function(icon, title, text, color, timeout) {
    $.post('http://ls-phone_new/HasPhone', JSON.stringify({}), function(HasPhone){
        if (HasPhone) {
            if (timeout == null && timeout == undefined) {
                timeout = 1500;
            }
            if (LS.Phone.Notifications.Timeout == undefined || LS.Phone.Notifications.Timeout == null) {
                if (color != null || color != undefined) {
                    $(".notification-icon").css({"color":color});
                    $(".notification-title").css({"color":color});
                } else if (color == "default" || color == null || color == undefined) {
                    $(".notification-icon").css({"color":"#e74c3c"});
                    $(".notification-title").css({"color":"#e74c3c"});
                }
                LS.Phone.Animations.TopSlideDown(".phone-notification-container", 200, 8);
                if (icon !== "politie") {
                    $(".notification-icon").html('<i class="'+icon+'"></i>');
                } else {
                    $(".notification-icon").html('<img src="./img/politie.png" class="police-icon-notify">');
                }
                $(".notification-title").html(title);
                $(".notification-text").html(text);
                if (LS.Phone.Notifications.Timeout !== undefined || LS.Phone.Notifications.Timeout !== null) {
                    clearTimeout(LS.Phone.Notifications.Timeout);
                }
                LS.Phone.Notifications.Timeout = setTimeout(function(){
                    LS.Phone.Animations.TopSlideUp(".phone-notification-container", 200, -8);
                    LS.Phone.Notifications.Timeout = null;
                }, timeout);
            } else {
                if (color != null || color != undefined) {
                    $(".notification-icon").css({"color":color});
                    $(".notification-title").css({"color":color});
                } else {
                    $(".notification-icon").css({"color":"#e74c3c"});
                    $(".notification-title").css({"color":"#e74c3c"});
                }
                $(".notification-icon").html('<i class="'+icon+'"></i>');
                $(".notification-title").html(title);
                $(".notification-text").html(text);
                if (LS.Phone.Notifications.Timeout !== undefined || LS.Phone.Notifications.Timeout !== null) {
                    clearTimeout(LS.Phone.Notifications.Timeout);
                }
                LS.Phone.Notifications.Timeout = setTimeout(function(){
                    LS.Phone.Animations.TopSlideUp(".phone-notification-container", 200, -8);
                    LS.Phone.Notifications.Timeout = null;
                }, timeout);
            }
        }
    });
}

LS.Phone.Functions.LoadPhoneData = function(data) {
    LS.Phone.Data.PlayerData = data.PlayerData;
    LS.Phone.Data.PlayerJob = data.PlayerJob;
    LS.Phone.Data.MetaData = data.PhoneData.MetaData;
    LS.Phone.Functions.LoadMetaData(data.PhoneData.MetaData);
    LS.Phone.Functions.LoadContacts(data.PhoneData.Contacts);
    LS.Phone.Functions.SetupApplications(data);
}

LS.Phone.Functions.UpdateTime = function(data) {
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
    var MessageTime = Hourssssss + ":" + Minutessss

    $("#phone-time").html(MessageTime + " <span style='font-size: 1.1vh;'>" + data.InGameTime.hour + ":" + data.InGameTime.minute + "</span>");
}

var NotificationTimeout = null;

LS.Screen.Notification = function(title, content, icon, timeout, color) {
    $.post('http://ls-phone_new/HasPhone', JSON.stringify({}), function(HasPhone){
        if (HasPhone) {
            if (color != null && color != undefined) {
                $(".screen-notifications-container").css({"background-color":color});
            }
            $(".screen-notification-icon").html('<i class="'+icon+'"></i>');
            $(".screen-notification-title").text(title);
            $(".screen-notification-content").text(content);
            $(".screen-notifications-container").css({'display':'block'}).animate({
                right: 5+"vh",
            }, 200);

            if (NotificationTimeout != null) {
                clearTimeout(NotificationTimeout);
            }

            NotificationTimeout = setTimeout(function(){
                $(".screen-notifications-container").animate({
                    right: -35+"vh",
                }, 200, function(){
                    $(".screen-notifications-container").css({'display':'none'});
                });
                NotificationTimeout = null;
            }, timeout);
        }
    });
}

// LS.Screen.Notification("Nieuwe Tweet", "Dit is een test tweet like #YOLO", "fab fa-twitter", 4000);

$(document).ready(function(){
    window.addEventListener('message', function(event) {
        switch(event.data.action) {
            case "open":
                LS.Phone.Functions.Open(event.data);
                LS.Phone.Functions.SetupAppWarnings(event.data.AppData);
                LS.Phone.Functions.SetupCurrentCall(event.data.CallData);
                LS.Phone.Data.IsOpen = true;
                LS.Phone.Data.PlayerData = event.data.PlayerData;
                break;
            // case "LoadPhoneApplications":
            //     LS.Phone.Functions.SetupApplications(event.data);
            //     break;
            case "LoadPhoneData":
                LS.Phone.Functions.LoadPhoneData(event.data);
                break;
            case "UpdateTime":
                LS.Phone.Functions.UpdateTime(event.data);
                break;
            case "Notification":
                LS.Screen.Notification(event.data.NotifyData.title, event.data.NotifyData.content, event.data.NotifyData.icon, event.data.NotifyData.timeout, event.data.NotifyData.color);
                break;
            case "PhoneNotification":
                LS.Phone.Notifications.Add(event.data.PhoneNotify.icon, event.data.PhoneNotify.title, event.data.PhoneNotify.text, event.data.PhoneNotify.color, event.data.PhoneNotify.timeout);
                break;
            case "RefreshAppAlerts":
                LS.Phone.Functions.SetupAppWarnings(event.data.AppData);
                break;
            case "UpdateMentionedTweets":
                LS.Phone.Notifications.LoadMentionedTweets(event.data.Tweets);
                break;
            case "UpdateBank":
                $(".bank-app-account-balance").html("&euro; "+event.data.NewBalance);
                $(".bank-app-account-balance").data('balance', event.data.NewBalance);
                break;
            case "UpdateChat":
                if (LS.Phone.Data.currentApplication == "whatsapp") {
                    if (OpenedChatData.number !== null && OpenedChatData.number == event.data.chatNumber) {
                        //console.log('Chat reloaded')
                        LS.Phone.Functions.SetupChatMessages(event.data.chatData);
                    } else {
                        //console.log('Chats reloaded')
                        LS.Phone.Functions.LoadWhatsappChats(event.data.Chats);
                    }
                }
                break;
            case "UpdateHashtags":
                LS.Phone.Notifications.LoadHashtags(event.data.Hashtags);
                break;
            case "RefreshWhatsappAlerts":
                LS.Phone.Functions.ReloadWhatsappAlerts(event.data.Chats);
                break;
            case "CancelOutgoingCall":
                $.post('http://ls-phone_new/HasPhone', JSON.stringify({}), function(HasPhone){
                    if (HasPhone) {
                        CancelOutgoingCall();
                    }
                });
                break;
            case "IncomingCallAlert":
                $.post('http://ls-phone_new/HasPhone', JSON.stringify({}), function(HasPhone){
                    if (HasPhone) {
                        IncomingCallAlert(event.data.CallData, event.data.Canceled, event.data.AnonymousCall);
                    }
                });
                break;
            case "SetupHomeCall":
                LS.Phone.Functions.SetupCurrentCall(event.data.CallData);
                break;
            case "AnswerCall":
                LS.Phone.Functions.AnswerCall(event.data.CallData);
                break;
            case "UpdateCallTime":
                var CallTime = event.data.Time;
                var date = new Date(null);
                date.setSeconds(CallTime);
                var timeString = date.toISOString().substr(11, 8);

                if (!LS.Phone.Data.IsOpen) {
                    if ($(".call-notifications").css("right") !== "52.1px") {
                        $(".call-notifications").css({"display":"block"});
                        $(".call-notifications").animate({right: 5+"vh"});
                    }
                    $(".call-notifications-title").html("Ingesprek ("+timeString+")");
                    $(".call-notifications-content").html("Aan het bellen met "+event.data.Name);
                    $(".call-notifications").removeClass('call-notifications-shake');
                } else {
                    $(".call-notifications").animate({
                        right: -35+"vh"
                    }, 400, function(){
                        $(".call-notifications").css({"display":"none"});
                    });
                }

                $(".phone-call-ongoing-time").html(timeString);
                $(".phone-currentcall-title").html("In gesprek ("+timeString+")");
                break;
            case "CancelOngoingCall":
                $(".call-notifications").animate({right: -35+"vh"}, function(){
                    $(".call-notifications").css({"display":"none"});
                });
                LS.Phone.Animations.TopSlideUp('.phone-application-container', 400, -160);
                setTimeout(function(){
                    LS.Phone.Functions.ToggleApp("phone-call", "none");
                    $(".phone-application-container").css({"display":"none"});
                }, 400)
                LS.Phone.Functions.HeaderTextColor("white", 300);

                LS.Phone.Data.CallActive = false;
                LS.Phone.Data.currentApplication = null;
                break;
            case "RefreshContacts":
                LS.Phone.Functions.LoadContacts(event.data.Contacts);
                break;
            case "UpdateMails":
                LS.Phone.Functions.SetupMails(event.data.Mails);
                break;
            case "RefreshAdverts":
                if (LS.Phone.Data.currentApplication == "advert") {
                    LS.Phone.Functions.RefreshAdverts(event.data.Adverts);
                }
                break;
            case "AddPoliceAlert":
                AddPoliceAlert(event.data)
                break;
            case "AddPagerAlert":
                AddPagerAlert(event.data)
                break;
            case "UpdateApplications":
                LS.Phone.Data.PlayerJob = event.data.JobData;
                LS.Phone.Functions.SetupApplications(event.data);
                break;
            case "UpdateTransactions":
                RefreshCryptoTransactions(event.data);
                break;
            case "UpdateRacingApp":
                $.post('http://ls-phone_new/GetAvailableRaces', JSON.stringify({}), function(Races){
                    SetupRaces(Races);
                });
                break;
            case "close-force":
                LS.Phone.Functions.Close();
                break;
        }
    })
});

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27: // ESCAPE
            LS.Phone.Functions.Close();
            break;
    }
});

// LS.Phone.Functions.Open();
