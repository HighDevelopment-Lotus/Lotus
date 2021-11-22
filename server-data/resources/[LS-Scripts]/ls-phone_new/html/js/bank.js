var FoccusedBank = null;

$(document).on('click', '.bank-app-account', function(e){
    var copyText = document.getElementById("iban-account");
    copyText.select();
    copyText.setSelectionRange(0, 99999);
    document.execCommand("copy");

    LS.Phone.Notifications.Add("fas fa-university", "LSBank", "Bankrekening nr. gekopieerd!", "#badc58", 1750);
});

var CurrentTab = "accounts";

$(document).on('click', '.bank-app-header-button', function(e){
    e.preventDefault();

    var PressedObject = this;
    var PressedTab = $(PressedObject).data('headertype');

    if (CurrentTab != PressedTab) {
        var PreviousObject = $(".bank-app-header").find('[data-headertype="'+CurrentTab+'"]');

        if (PressedTab == "invoices") {
            $(".bank-app-"+CurrentTab).animate({
                left: -30+"vh"
            }, 250, function(){
                $(".bank-app-"+CurrentTab).css({"display":"none"})
            });
            $(".bank-app-"+PressedTab).css({"display":"block"}).animate({
                left: 0+"vh"
            }, 250);
        } else if (PressedTab == "accounts") {
            $(".bank-app-"+CurrentTab).animate({
                left: 30+"vh"
            }, 250, function(){
                $(".bank-app-"+CurrentTab).css({"display":"none"})
            });
            $(".bank-app-"+PressedTab).css({"display":"block"}).animate({
                left: 0+"vh"
            }, 250);
        }

        $(PreviousObject).removeClass('bank-app-header-button-selected');
        $(PressedObject).addClass('bank-app-header-button-selected');
        setTimeout(function(){ CurrentTab = PressedTab; }, 300)
    }
})

LS.Phone.Functions.DoBankOpen = function() {
    LS.Phone.Data.PlayerData.money.bank = (LS.Phone.Data.PlayerData.money.bank).toFixed();
    $(".bank-app-account-number").val(LS.Phone.Data.PlayerData.charinfo.account);
    $(".bank-app-account-balance").html("&euro; "+LS.Phone.Data.PlayerData.money.bank);
    $(".bank-app-account-balance").data('balance', LS.Phone.Data.PlayerData.money.bank);

    $(".bank-app-loaded").css({"display":"none", "padding-left":"30vh"});
    $(".bank-app-accounts").css({"left":"30vh"});
    $(".lsbank-logo").css({"left": "0vh"});
    $("#lsbank-text").css({"opacity":"0.0", "left":"9vh"});
    $(".bank-app-loading").css({
        "display":"block",
        "left":"0vh",
    });

    RefreshBankData();

    setTimeout(function(){
        CurrentTab = "accounts";
        $(".lsbank-logo").animate({
            left: -12+"vh"
        }, 500);
        setTimeout(function(){
            $("#lsbank-text").animate({
                opacity: 1.0,
                left: 14+"vh"
            });
        }, 100);
        setTimeout(function(){
            $(".bank-app-loaded").css({"display":"block"}).animate({"padding-left":"0"}, 300);
            $(".bank-app-accounts").animate({left:0+"vh"}, 300);
            $(".bank-app-loading").animate({
                left: -30+"vh"
            },300, function(){
                $(".bank-app-loading").css({"display":"none"});
            });
        }, 1500)
    }, 500)
}

$(document).on('click', '.bank-app-account-actions', function(e){
    LS.Phone.Animations.TopSlideDown(".bank-app-transfer", 400, 0);
});

$(document).on('click', '#cancel-transfer', function(e){
    e.preventDefault();

    LS.Phone.Animations.TopSlideUp(".bank-app-transfer", 400, -100);
});

$(document).on('click', '#accept-transfer', function(e){
    e.preventDefault();

    var iban = $("#bank-transfer-iban").val();
    var amount = $("#bank-transfer-amount").val();
    var amountData = $(".bank-app-account-balance").data('balance');

    if (iban != "" && amount != "") {
        if (!amount - amountData < 0) {
			if (amount > 0) {
                $.post('http://ls-phone_new/TransferMoney', JSON.stringify({
                    iban: iban,
                    amount: amount
                }), function(data){
                    if (data.CanTransfer) {
                        $("#bank-transfer-iban").val("");
                        $("#bank-transfer-amount").val("");
                        data.NewAmount = (data.NewAmount).toFixed();
                        $(".bank-app-account-balance").html("&euro; "+data.NewAmount);
                        $(".bank-app-account-balance").data('balance', data.NewAmount);
                        LS.Phone.Notifications.Add("fas fa-university", "lsbank", "Je hebt &euro; "+amount+",- overgemaakt!", "#badc58", 1500);
                    } else {
                        LS.Phone.Notifications.Add("fas fa-university", "lsbank", "Je hebt niet genoeg saldo!", "#badc58", 1500);
                    }
                })
                LS.Phone.Animations.TopSlideUp(".bank-app-transfer", 400, -100);
            } else {
                LS.Phone.Notifications.Add("fas fa-university", "lsbank", "Hoeveelheid mag niet kleiner zijn dan 0!", "#badc58", 1500);
            }
        } else {
            LS.Phone.Notifications.Add("fas fa-university", "lsbank", "Je hebt niet genoeg saldo!", "#badc58", 1500);
        }
    } else {
        LS.Phone.Notifications.Add("fas fa-university", "lsbank", "Vul alle velden in!", "#badc58", 1750);
    }
});

GetInvoiceLabel = function(type) {
    retval = null;
    if (type == "request") {
        retval = "Betaalverzoek";
    }

    return retval
}

$(document).on('click', '.pay-invoice', function(event){
    event.preventDefault();

    var InvoiceId = $(this).parent().parent().attr('id');
    var InvoiceData = $("#"+InvoiceId).data('invoicedata');
    var BankBalance = $(".bank-app-account-balance").data('balance');

    if (BankBalance >= InvoiceData.amount) {
        $.post('http://ls-phone_new/PayInvoice', JSON.stringify({
            sender: InvoiceData.sender,
            amount: InvoiceData.amount,
            invoiceId: InvoiceData.invoiceid,
        }), function(CanPay){
            if (CanPay) {
                $("#"+InvoiceId).animate({
                    left: 30+"vh",
                }, 300, function(){
                    setTimeout(function(){
                        $("#"+InvoiceId).remove();
                    }, 100);
                });
                LS.Phone.Notifications.Add("fas fa-university", "lsbank", "Je hebt &euro;"+InvoiceData.amount+" betaald!", "#badc58", 1500);
                var amountData = $(".bank-app-account-balance").data('balance');
                var NewAmount = (amountData - InvoiceData.amount).toFixed();
                $("#bank-transfer-amount").val(NewAmount);
                $(".bank-app-account-balance").data('balance', NewAmount);
            } else {
                LS.Phone.Notifications.Add("fas fa-university", "lsbank", "Je hebt niet genoeg saldo!", "#badc58", 1500);
            }
        });
    } else {
        LS.Phone.Notifications.Add("fas fa-university", "lsbank", "Je hebt niet genoeg saldo!", "#badc58", 1500);
    }
});

$(document).on('click', '.decline-invoice', function(event){
    event.preventDefault();
    var InvoiceId = $(this).parent().parent().attr('id');
    var InvoiceData = $("#"+InvoiceId).data('invoicedata');

    $.post('http://ls-phone_new/DeclineInvoice', JSON.stringify({
        sender: InvoiceData.sender,
        amount: InvoiceData.amount,
        invoiceId: InvoiceData.invoiceid,
    }));
    $("#"+InvoiceId).animate({
        left: 30+"vh",
    }, 300, function(){
        setTimeout(function(){
            $("#"+InvoiceId).remove();
        }, 100);
    });
    LS.Phone.Notifications.Add("fas fa-university", "lsbank", "Je hebt &euro;"+InvoiceData.amount+" betaald!", "#badc58", 1500);
});

LS.Phone.Functions.LoadBankInvoices = function(invoices) {
    if (invoices !== null) {
        $(".bank-app-invoices-list").html("");

        $.each(invoices, function(i, invoice){
            var Elem = '<div class="bank-app-invoice" id="invoiceid-'+i+'"> <div class="bank-app-invoice-title">'+GetInvoiceLabel(invoice.type)+' <span style="font-size: 1vh; color: gray;">(Afzender: '+invoice.name+')</span></div> <div class="bank-app-invoice-amount">&euro; '+invoice.amount+',-</div> <div class="bank-app-invoice-buttons"> <i class="fas fa-check-circle pay-invoice"></i> <i class="fas fa-times-circle decline-invoice"></i> </div> </div>';

            $(".bank-app-invoices-list").append(Elem);
            $("#invoiceid-"+i).data('invoicedata', invoice);
        });
    }
}

LS.Phone.Functions.SetupSharedAccounts = function(accounts) {
    $("#sharedAccounts").html("");
    $.each(accounts, function(i, account){
        var tableElement = '<div class="bank-app-account"><div class="bank-app-account-title">' + account.Label + '</div><div class="bank-app-account-number" id="iban-account">' + account.BankId + '</div><div class="bank-app-account-balance">&euro; ' + account.Balance + '</div></div>';
        $("#sharedAccounts").append(tableElement);
    });
}

RefreshBankData = function() {
    $.post('http://ls-phone_new/RefreshSharedAccounts', JSON.stringify({}), function(accounts){
        //console.log('refreshing');
        $("#sharedAccounts").html("");
        $.each(accounts, function(i, account){
            var tableElement = '<div class="bank-app-account"><div class="bank-app-account-title">' + account.Label + '</div><div class="bank-app-account-number" id="iban-account">' + account.BankId + '</div><div class="bank-app-account-balance">&euro; ' + account.Balance + '</div></div>';
            $("#sharedAccounts").append(tableElement);
        });
    });
}

LS.Phone.Functions.LoadContactsWithNumber = function(myContacts) {
    var ContactsObject = $(".bank-app-my-contacts-list");
    $(ContactsObject).html("");
    var TotalContacts = 0;

    $("#bank-app-my-contact-search").on("keyup", function() {
        var value = $(this).val().toLowerCase();
        $(".bank-app-my-contacts-list .bank-app-my-contact").filter(function() {
          $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1);
        });
    });

    if (myContacts !== null) {
        $.each(myContacts, function(i, contact){
            var RandomNumber = Math.floor(Math.random() * 6);
            var ContactColor = LS.Phone.ContactColors[RandomNumber];
            var ContactElement = '<div class="bank-app-my-contact" data-bankcontactid="'+i+'"> <div class="bank-app-my-contact-firstletter">'+((contact.name).charAt(0)).toUpperCase()+'</div> <div class="bank-app-my-contact-name">'+contact.name+'</div> </div>'
            TotalContacts = TotalContacts + 1
            $(ContactsObject).append(ContactElement);
            $("[data-bankcontactid='"+i+"']").data('contactData', contact);
        });
    }
};

$(document).on('click', '.bank-app-my-contacts-list-back', function(e){
    e.preventDefault();

    LS.Phone.Animations.TopSlideUp(".bank-app-my-contacts", 400, -100);
});

$(document).on('click', '.bank-transfer-mycontacts-icon', function(e){
    e.preventDefault();

    LS.Phone.Animations.TopSlideDown(".bank-app-my-contacts", 400, 0);
});

$(document).on('click', '.bank-app-my-contact', function(e){
    e.preventDefault();
    var PressedContactData = $(this).data('contactData');

    if (PressedContactData.iban !== "" && PressedContactData.iban !== undefined && PressedContactData.iban !== null) {
        $("#bank-transfer-iban").val(PressedContactData.iban);
    } else {
        LS.Phone.Notifications.Add("fas fa-university", "lsbank", "Er is geen IBAN gebonden aan dit contact!", "#badc58", 2500);
    }
    LS.Phone.Animations.TopSlideUp(".bank-app-my-contacts", 400, -100);
});