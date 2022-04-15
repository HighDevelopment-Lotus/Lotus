var CanClick = true;
var CurrentType = null;
var ContextOpen = false;
var CurrentContextType = null;
var CurrentAccountData = null;

OpenBankContainer = function(data) {
    $('.bank-container').animate({"height": "10vh"}, 0)
    $('.bank-container').slideDown(350)
    $('.bank-accounts-container').html('');
    if (data.type === 'bank') {
        CurrentType = 'bank';
        $.post('http://fw-banking/GetAccounts', JSON.stringify({}), function(Accounts){
            for (const [key, value] of Object.entries(Accounts)) {
                var AccountCard = '<div class="account-card" id="accout-card-'+value['BankId']+'" data-cardid="'+value['BankId']+'"><div class="account-name">Prive / '+value['BankId']+'</div><div class="account-owner">'+value['PersonalName']+'</div><div class="account-name-name">'+value['Name']+'</div><div class="account-balance">€'+value['Balance']+'</div><div class="account-desc">Beschikbaar Balans</div><div class="account-transaction"><i class="fas fa-clipboard-list"></i></div><div class="remove-account"><i class="fas fa-times-circle"></i></div><div class="account-button-deposit">Storten</div><div class="account-button-withdraw">Opnemen</div><div class="account-button-transfer">Overmaken</div></div>'
                $('.bank-accounts-container').append(AccountCard);
                $("#accout-card-"+value['BankId']).data('AccountData', Accounts[key]);
            }
        });
        $.post('http://fw-banking/GetSharedAccounts', JSON.stringify({}), function(Accounts){
            for (const [key, value] of Object.entries(Accounts)) {
                var AccountCard = '<div class="account-card" id="accout-card-'+value['BankId']+'" data-cardid="'+value['BankId']+'"><div class="account-name">Gezamelijk / '+value['BankId']+'</div><div class="account-owner">'+value['OwnerName']+'</div><div class="account-name-name">'+value['Name']+'</div><div class="account-balance">€'+value['Balance']+'</div><div class="account-desc">Beschikbaar Balans</div><div class="account-transaction"><i class="fas fa-clipboard-list"></i></div><div class="account-button-deposit">Storten</div><div class="account-button-withdraw">Opnemen</div><div class="account-button-transfer">Overmaken</div></div>'
                if (value['IsOwner']) {
                    AccountCard = '<div class="account-card" id="accout-card-'+value['BankId']+'" data-cardid="'+value['BankId']+'"><div class="account-name">Gezamelijk / '+value['BankId']+'</div><div class="account-owner">'+value['OwnerName']+'</div><div class="account-name-name">'+value['Name']+'</div><div class="account-balance">€'+value['Balance']+'</div><div class="account-desc">Beschikbaar Balans</div><div class="account-man"><i class="fas fa-user"></i></div><div class="account-transaction"><i class="fas fa-clipboard-list"></i></div><div class="remove-account"><i class="fas fa-times-circle"></i></div><div class="account-button-deposit">Storten</div><div class="account-button-withdraw">Opnemen</div><div class="account-button-transfer">Overmaken</div></div>'
                }
                $('.bank-accounts-container').append(AccountCard);
                $("#accout-card-"+value['BankId']).data('AccountData', Accounts[key]);
            }
        });
        $.post('http://fw-banking/GetBusinessdAccounts', JSON.stringify({}), function(Accounts){
            for (const [key, value] of Object.entries(Accounts)) {
                var AccountCard = '<div class="account-card" id="accout-card-'+value['BankId']+'" data-cardid="'+value['BankId']+'"><div class="account-name">Zakelijk / '+value['BankId']+'</div><div class="account-owner">'+value['OwnerName']+'</div><div class="account-name-name">'+value['Name']+'</div><div class="account-balance">€'+value['Balance']+'</div><div class="account-desc">Beschikbaar Balans</div><div class="account-transaction"><i class="fas fa-clipboard-list"></i></div><div class="account-button-deposit">Storten</div><div class="account-button-withdraw">Opnemen</div><div class="account-button-transfer">Overmaken</div></div>'
                if (value['IsOwner']) {
                    AccountCard = '<div class="account-card" id="accout-card-'+value['BankId']+'" data-cardid="'+value['BankId']+'"><div class="account-name">Zakelijk / '+value['BankId']+'</div><div class="account-owner">'+value['OwnerName']+'</div><div class="account-name-name">'+value['Name']+'</div><div class="account-balance">€'+value['Balance']+'</div><div class="account-desc">Beschikbaar Balans</div><div class="account-man"><i class="fas fa-user"></i></div><div class="account-transaction"><i class="fas fa-clipboard-list"></i></div><div class="remove-account"><i class="fas fa-times-circle"></i></div><div class="account-button-deposit">Storten</div><div class="account-button-withdraw">Opnemen</div><div class="account-button-transfer">Overmaken</div></div>'
                }
                $('.bank-accounts-container').append(AccountCard);
                $("#accout-card-"+value['BankId']).data('AccountData', Accounts[key]);
            }
        });
        $.post('http://fw-banking/GetMyAccount', JSON.stringify({}), function(AccountData){
            var AccountCard = '<div class="account-card" id="accout-card-'+AccountData['BankId']+'" data-cardid="'+AccountData['BankId']+'"><div class="account-name">Persoonlijk / '+AccountData['BankId']+'</div><div class="account-owner">'+AccountData['PersonalName']+'</div><div class="account-name-name">Standaard Rekening</div><div class="account-balance">€'+AccountData['Balance']+'</div><div class="account-desc">Beschikbaar Balans</div><div class="account-button-deposit">Storten</div><div class="account-button-withdraw">Opnemen</div><div class="account-button-transfer">Overmaken</div></div>'
            $('.bank-accounts-container').prepend(AccountCard);
            $("#accout-card-"+AccountData['BankId']).data('AccountData', AccountData);
        });
    } else {
        CurrentType = 'atm';
        $.post('http://fw-banking/GetAccounts', JSON.stringify({}), function(Accounts){
            for (const [key, value] of Object.entries(Accounts)) {
                var AccountCard = '<div class="account-card" id="accout-card-'+value['BankId']+'" data-cardid="'+value['BankId']+'"><div class="account-name">Prive / '+value['BankId']+'</div><div class="account-owner">'+value['PersonalName']+'</div><div class="account-name-name">'+value['Name']+'</div><div class="account-balance">€'+value['Balance']+'</div><div class="account-desc">Beschikbaar Balans</div><div class="account-transaction"><i class="fas fa-clipboard-list"></i></div><div class="remove-account"><i class="fas fa-times-circle"></i></div><div class="account-button-withdraw">Opnemen</div><div class="account-button-transfer">Overmaken</div></div>'
                $('.bank-accounts-container').append(AccountCard);
                $("#accout-card-"+value['BankId']).data('AccountData', Accounts[key]);
            }
        });
        $.post('http://fw-banking/GetSharedAccounts', JSON.stringify({}), function(Accounts){
            for (const [key, value] of Object.entries(Accounts)) {
                var AccountCard = '<div class="account-card" id="accout-card-'+value['BankId']+'" data-cardid="'+value['BankId']+'"><div class="account-name">Gezamelijk / '+value['BankId']+'</div><div class="account-owner">'+value['OwnerName']+'</div><div class="account-name-name">'+value['Name']+'</div><div class="account-balance">€'+value['Balance']+'</div><div class="account-desc">Beschikbaar Balans</div><div class="account-transaction"><i class="fas fa-clipboard-list"></i></div><div class="account-button-withdraw">Opnemen</div><div class="account-button-transfer">Overmaken</div></div>'
                if (value['IsOwner']) {
                    AccountCard = '<div class="account-card" id="accout-card-'+value['BankId']+'" data-cardid="'+value['BankId']+'"><div class="account-name">Gezamelijk / '+value['BankId']+'</div><div class="account-owner">'+value['OwnerName']+'</div><div class="account-name-name">'+value['Name']+'</div><div class="account-balance">€'+value['Balance']+'</div><div class="account-desc">Beschikbaar Balans</div><div class="account-man"><i class="fas fa-user"></i></div><div class="account-transaction"><i class="fas fa-clipboard-list"></i></div><div class="remove-account"><i class="fas fa-times-circle"></i></div><div class="account-button-withdraw">Opnemen</div><div class="account-button-transfer">Overmaken</div></div>'
                }
                $('.bank-accounts-container').append(AccountCard);
                $("#accout-card-"+value['BankId']).data('AccountData', Accounts[key]);
            }
        });
        $.post('http://fw-banking/GetBusinessdAccounts', JSON.stringify({}), function(Accounts){
            for (const [key, value] of Object.entries(Accounts)) {
                var AccountCard = '<div class="account-card" id="accout-card-'+value['BankId']+'" data-cardid="'+value['BankId']+'"><div class="account-name">Zakelijk / '+value['BankId']+'</div><div class="account-owner">'+value['OwnerName']+'</div><div class="account-name-name">'+value['Name']+'</div><div class="account-balance">€'+value['Balance']+'</div><div class="account-desc">Beschikbaar Balans</div><div class="account-transaction"><i class="fas fa-clipboard-list"></i></div><div class="account-button-withdraw">Opnemen</div><div class="account-button-transfer">Overmaken</div></div>'
                if (value['IsOwner']) {
                    AccountCard = '<div class="account-card" id="accout-card-'+value['BankId']+'" data-cardid="'+value['BankId']+'"><div class="account-name">Zakelijk / '+value['BankId']+'</div><div class="account-owner">'+value['OwnerName']+'</div><div class="account-name-name">'+value['Name']+'</div><div class="account-balance">€'+value['Balance']+'</div><div class="account-desc">Beschikbaar Balans</div><div class="account-man"><i class="fas fa-user"></i></div><div class="account-transaction"><i class="fas fa-clipboard-list"></i></div><div class="remove-account"><i class="fas fa-times-circle"></i></div><div class="account-button-withdraw">Opnemen</div><div class="account-button-transfer">Overmaken</div></div>'
                }
                $('.bank-accounts-container').append(AccountCard);
                $("#accout-card-"+value['BankId']).data('AccountData', Accounts[key]);
            }
        });
        $.post('http://fw-banking/GetMyAccount', JSON.stringify({}), function(AccountData){
            var AccountCard = '<div class="account-card" id="accout-card-'+AccountData['BankId']+'" data-cardid="'+AccountData['BankId']+'"><div class="account-name">Persoonlijk / '+AccountData['BankId']+'</div><div class="account-owner">'+AccountData['PersonalName']+'</div><div class="account-name-name">Standaard Rekening</div><div class="account-balance">€'+AccountData['Balance']+'</div><div class="account-desc">Beschikbaar Balans</div><div class="account-button-withdraw">Opnemen</div><div class="account-button-transfer">Overmaken</div></div>'
            $('.bank-accounts-container').prepend(AccountCard);
            $("#accout-card-"+AccountData['BankId']).data('AccountData', AccountData);
        });
    }
    $('.my-cash').html('Kijk voor je contant geld in je Inventaris (TAB)')
    // $('.my-cash').html('Contant: €'+data.cash)
    setTimeout(function() {
        $('.loading').fadeOut(450, function() {
            $('.bank-inside').slideDown(250)
            $('.bank-container').animate({"height": "70vh"}, 1100)
        });
    }, 2500)
}

RefreshAccountCards = function() {
    $('.bank-accounts-container').html('');
    $('.account-transaction-container').html('');
    setTimeout(function() {
        if (CurrentType === 'bank') {
            $.post('http://fw-banking/GetAccounts', JSON.stringify({}), function(Accounts){
                for (const [key, value] of Object.entries(Accounts)) {
                    var AccountCard = '<div class="account-card" id="accout-card-'+value['BankId']+'" data-cardid="'+value['BankId']+'"><div class="account-name">Prive / '+value['BankId']+'</div><div class="account-owner">'+value['PersonalName']+'</div><div class="account-name-name">'+value['Name']+'</div><div class="account-balance">€'+value['Balance']+'</div><div class="account-desc">Beschikbaar Balans</div><div class="account-transaction"><i class="fas fa-clipboard-list"></i></div><div class="remove-account"><i class="fas fa-times-circle"></i></div><div class="account-button-deposit">Storten</div><div class="account-button-withdraw">Opnemen</div><div class="account-button-transfer">Overmaken</div></div>'
                    $('.bank-accounts-container').append(AccountCard);
                    $("#accout-card-"+value['BankId']).data('AccountData', Accounts[key]);
                }
            });
            $.post('http://fw-banking/GetSharedAccounts', JSON.stringify({}), function(Accounts){
                for (const [key, value] of Object.entries(Accounts)) {
                    var AccountCard = '<div class="account-card" id="accout-card-'+value['BankId']+'" data-cardid="'+value['BankId']+'"><div class="account-name">Gezamelijk / '+value['BankId']+'</div><div class="account-owner">'+value['OwnerName']+'</div><div class="account-name-name">'+value['Name']+'</div><div class="account-balance">€'+value['Balance']+'</div><div class="account-desc">Beschikbaar Balans</div><div class="account-transaction"><i class="fas fa-clipboard-list"></i></div><div class="account-button-deposit">Storten</div><div class="account-button-withdraw">Opnemen</div><div class="account-button-transfer">Overmaken</div></div>'
                    if (value['IsOwner']) {
                        AccountCard = '<div class="account-card" id="accout-card-'+value['BankId']+'" data-cardid="'+value['BankId']+'"><div class="account-name">Gezamelijk / '+value['BankId']+'</div><div class="account-owner">'+value['OwnerName']+'</div><div class="account-name-name">'+value['Name']+'</div><div class="account-balance">€'+value['Balance']+'</div><div class="account-desc">Beschikbaar Balans</div><div class="account-man"><i class="fas fa-user"></i></div><div class="account-transaction"><i class="fas fa-clipboard-list"></i></div><div class="remove-account"><i class="fas fa-times-circle"></i></div><div class="account-button-deposit">Storten</div><div class="account-button-withdraw">Opnemen</div><div class="account-button-transfer">Overmaken</div></div>'
                    }
                    $('.bank-accounts-container').append(AccountCard);
                    $("#accout-card-"+value['BankId']).data('AccountData', Accounts[key]);
                }
            });
            $.post('http://fw-banking/GetBusinessdAccounts', JSON.stringify({}), function(Accounts){
                for (const [key, value] of Object.entries(Accounts)) {
                    var AccountCard = '<div class="account-card" id="accout-card-'+value['BankId']+'" data-cardid="'+value['BankId']+'"><div class="account-name">Zakelijk / '+value['BankId']+'</div><div class="account-owner">'+value['OwnerName']+'</div><div class="account-name-name">'+value['Name']+'</div><div class="account-balance">€'+value['Balance']+'</div><div class="account-desc">Beschikbaar Balans</div><div class="account-transaction"><i class="fas fa-clipboard-list"></i></div><div class="account-button-deposit">Storten</div><div class="account-button-withdraw">Opnemen</div><div class="account-button-transfer">Overmaken</div></div>'
                    if (value['IsOwner']) {
                        AccountCard = '<div class="account-card" id="accout-card-'+value['BankId']+'" data-cardid="'+value['BankId']+'"><div class="account-name">Zakelijk / '+value['BankId']+'</div><div class="account-owner">'+value['OwnerName']+'</div><div class="account-name-name">'+value['Name']+'</div><div class="account-balance">€'+value['Balance']+'</div><div class="account-desc">Beschikbaar Balans</div><div class="account-man"><i class="fas fa-user"></i></div><div class="account-transaction"><i class="fas fa-clipboard-list"></i></div><div class="remove-account"><i class="fas fa-times-circle"></i></div><div class="account-button-deposit">Storten</div><div class="account-button-withdraw">Opnemen</div><div class="account-button-transfer">Overmaken</div></div>'
                    }
                    $('.bank-accounts-container').append(AccountCard);
                    $("#accout-card-"+value['BankId']).data('AccountData', Accounts[key]);
                }
            });
            $.post('http://fw-banking/GetMyAccount', JSON.stringify({}), function(AccountData){
                var AccountCard = '<div class="account-card" id="accout-card-'+AccountData['BankId']+'" data-cardid="'+AccountData['BankId']+'"><div class="account-name">Persoonlijk / '+AccountData['BankId']+'</div><div class="account-owner">'+AccountData['PersonalName']+'</div><div class="account-name-name">Standaard Rekening</div><div class="account-balance">€'+AccountData['Balance']+'</div><div class="account-desc">Beschikbaar Balans</div><div class="account-button-deposit">Storten</div><div class="account-button-withdraw">Opnemen</div><div class="account-button-transfer">Overmaken</div></div>'
                $('.bank-accounts-container').prepend(AccountCard);
                $("#accout-card-"+AccountData['BankId']).data('AccountData', AccountData);
            });
        } else {
            $.post('http://fw-banking/GetAccounts', JSON.stringify({}), function(Accounts){
                for (const [key, value] of Object.entries(Accounts)) {
                    var AccountCard = '<div class="account-card" id="accout-card-'+value['BankId']+'" data-cardid="'+value['BankId']+'"><div class="account-name">Prive / '+value['BankId']+'</div><div class="account-owner">'+value['PersonalName']+'</div><div class="account-name-name">'+value['Name']+'</div><div class="account-balance">€'+value['Balance']+'</div><div class="account-desc">Beschikbaar Balans</div><div class="account-transaction"><i class="fas fa-clipboard-list"></i></div><div class="remove-account"><i class="fas fa-times-circle"></i></div><div class="account-button-withdraw">Opnemen</div><div class="account-button-transfer">Overmaken</div></div>'
                    $('.bank-accounts-container').append(AccountCard);
                    $("#accout-card-"+value['BankId']).data('AccountData', Accounts[key]);
                }
            });
            $.post('http://fw-banking/GetSharedAccounts', JSON.stringify({}), function(Accounts){
                for (const [key, value] of Object.entries(Accounts)) {
                    var AccountCard = '<div class="account-card" id="accout-card-'+value['BankId']+'" data-cardid="'+value['BankId']+'"><div class="account-name">Gezamelijk / '+value['BankId']+'</div><div class="account-owner">'+value['OwnerName']+'</div><div class="account-name-name">'+value['Name']+'</div><div class="account-balance">€'+value['Balance']+'</div><div class="account-desc">Beschikbaar Balans</div><div class="account-transaction"><i class="fas fa-clipboard-list"></i></div><div class="account-button-withdraw">Opnemen</div><div class="account-button-transfer">Overmaken</div></div>'
                    if (value['IsOwner']) {
                        AccountCard = '<div class="account-card" id="accout-card-'+value['BankId']+'" data-cardid="'+value['BankId']+'"><div class="account-name">Gezamelijk / '+value['BankId']+'</div><div class="account-owner">'+value['OwnerName']+'</div><div class="account-name-name">'+value['Name']+'</div><div class="account-balance">€'+value['Balance']+'</div><div class="account-desc">Beschikbaar Balans</div><div class="account-man"><i class="fas fa-user"></i></div><div class="account-transaction"><i class="fas fa-clipboard-list"></i></div><div class="remove-account"><i class="fas fa-times-circle"></i></div><div class="account-button-withdraw">Opnemen</div><div class="account-button-transfer">Overmaken</div></div>'
                    }
                    $('.bank-accounts-container').append(AccountCard);
                    $("#accout-card-"+value['BankId']).data('AccountData', Accounts[key]);
                }
            });
            $.post('http://fw-banking/GetBusinessdAccounts', JSON.stringify({}), function(Accounts){
                for (const [key, value] of Object.entries(Accounts)) {
                    var AccountCard = '<div class="account-card" id="accout-card-'+value['BankId']+'" data-cardid="'+value['BankId']+'"><div class="account-name">Zakelijk / '+value['BankId']+'</div><div class="account-owner">'+value['OwnerName']+'</div><div class="account-name-name">'+value['Name']+'</div><div class="account-balance">€'+value['Balance']+'</div><div class="account-desc">Beschikbaar Balans</div><div class="account-transaction"><i class="fas fa-clipboard-list"></i></div><div class="account-button-withdraw">Opnemen</div><div class="account-button-transfer">Overmaken</div></div>'
                    if (value['IsOwner']) {
                        AccountCard = '<div class="account-card" id="accout-card-'+value['BankId']+'" data-cardid="'+value['BankId']+'"><div class="account-name">Zakelijk / '+value['BankId']+'</div><div class="account-owner">'+value['OwnerName']+'</div><div class="account-name-name">'+value['Name']+'</div><div class="account-balance">€'+value['Balance']+'</div><div class="account-desc">Beschikbaar Balans</div><div class="account-man"><i class="fas fa-user"></i></div><div class="account-transaction"><i class="fas fa-clipboard-list"></i></div><div class="remove-account"><i class="fas fa-times-circle"></i></div><div class="account-button-withdraw">Opnemen</div><div class="account-button-transfer">Overmaken</div></div>'
                    }
                    $('.bank-accounts-container').append(AccountCard);
                    $("#accout-card-"+value['BankId']).data('AccountData', Accounts[key]);
                }
            });
            $.post('http://fw-banking/GetMyAccount', JSON.stringify({}), function(AccountData){
                var AccountCard = '<div class="account-card" id="accout-card-'+AccountData['BankId']+'" data-cardid="'+AccountData['BankId']+'"><div class="account-name">Persoonlijk / '+AccountData['BankId']+'</div><div class="account-owner">'+AccountData['PersonalName']+'</div><div class="account-name-name">Standaard Rekening</div><div class="account-balance">€'+AccountData['Balance']+'</div><div class="account-desc">Beschikbaar Balans</div><div class="account-button-withdraw">Opnemen</div><div class="account-button-transfer">Overmaken</div></div>'
                $('.bank-accounts-container').prepend(AccountCard);
                $("#accout-card-"+AccountData['BankId']).data('AccountData', AccountData);
            });
        }
        $.post('http://fw-banking/GetCash', JSON.stringify({}), function(Cash){
            $('.my-cash').html('Contant: €'+Cash)
        });
    }, 25)
}

SetupAccountTransactions = function(data) {
    $('.account-transaction-container').html('');
    for (const [key, value] of Object.entries(data)) {
        var TransactionCard = null;
        if (value['Type'] === 'transfer') {
            TransactionCard = '<div class="trnasaction-card" style="border-left-color: #6e85d1;"><div class="transaction-card-name">Geld Overboeking</div><div class="transaction-amount">Bedrag: '+value['Amount']+'</div><div class="transaction-reason">Reden: '+value['Reason']+'</div><div class="transaction-card-message">Beschrijving: '+value['Message']+'</div><div class="transaction-logo"><i class="fas fa-piggy-bank"></i></div></div>'
        } else if (value['Type'] === 'deposit') {
            TransactionCard = '<div class="trnasaction-card" style="border-left-color: #498f54;"><div class="transaction-card-name">Geld Storting</div><div class="transaction-amount">Bedrag: '+value['Amount']+'</div><div class="transaction-reason">Reden: '+value['Reason']+'</div><div class="transaction-card-message">Beschrijving: '+value['Message']+'</div><div class="transaction-logo"><i class="fas fa-piggy-bank"></i></div></div>'
        } else {
            TransactionCard = '<div class="trnasaction-card" style="border-left-color: #8f4949;"><div class="transaction-card-name">Geld Opname</div><div class="transaction-amount">Bedrag: '+value['Amount']+'</div><div class="transaction-reason">Reden: '+value['Reason']+'</div><div class="transaction-card-message">Beschrijving: '+value['Message']+'</div><div class="transaction-logo"><i class="fas fa-piggy-bank"></i></div></div>'
        }
        $('.account-transaction-container').prepend(TransactionCard);
    }
}

CloseBankContainer = function() {
    $.post('http://fw-banking/ClickSound', JSON.stringify({}))
    $('.bank-inside').slideUp(650)
    $('.account-transaction-container').html('');
    $('.bank-container').slideUp(650, function() {
       $('.loading').fadeIn(0);
       CanClick = true;
       CurrentType = null;
       ContextOpen = false;
       CurrentContextType = null;
       CurrentAccountData = null;
    });
    if (ContextOpen) {
       CloseBankContext();
    }
    $.post('http://fw-banking/CloseUi', JSON.stringify({}))
}

OpenBankContext = function(data, type) {
    var BankType = 'Persoonlijk'
    if (data['Type'] === 'private') {
        BankType = 'Privé'
    } else if (data['Type'] === 'shared') {
        BankType = 'Gezamelijk'
    }
    CanClick = false
    ContextOpen = true
    CurrentAccountData = data
    CurrentContextType = type
    $('.bank').hide(); 
    $('.context-logo-bank').hide(); 
    if (type === 'Overmaken') {
        $('.bank').show();
        $('.context-logo-bank').show();
        $('.context-title').html(BankType+' / '+data['BankId']+' / '+type)
    } else if (type == 'Storten' || type == 'Opname') {
        $('.context-title').html(BankType+' / '+data['BankId']+' / '+type)
    } else if (type == 'Spelers') { 
        $('.context-1').hide(); 
        $('.context-3').show(); 
        $('.context-title').html(data['BankId']+' / Account Beheer')
        for (const [key, value] of Object.entries(data['Authorized'])) {
            if (value['CitizenId'] !== data['Owner']) {
                var PlayerCard = '<div class="player-card" id="player-card-'+key+'" data-cardid="'+key+'"><div class="player-card-name">'+value['Name']+' ('+value['CitizenId']+')</div><div class="player-card-delete"><i class="fas fa-user-times"></i></div></div>'
                $('.context-players-container').append(PlayerCard);
                $("#player-card-"+key).data('PlayerData', value);
            }
        }
    } else {
        $('.context-1').hide();
        $('.context-2').show();
        $('.context-title').html('Account Aanmaken')
    }
    $('.context-container').slideDown(350)
}

CloseBankContext = function(data) {
    $('.context-container').slideUp(350, function() {
        $('.context-input').val('');
        $('.context-3-add-container').hide(0);
        $('.context-players-container').html('');
        $('.context-3').hide();
        $('.context-2').hide();
        $('.context-1').show();
        RefreshAccountCards();
        CurrentAccountData = null;
        CurrentContextType = null;
        ContextOpen = false;
        CanClick = true
    })
}

$(document).on('click', '.player-card-delete', function(e) {
    e.preventDefault();
    var PlayerId = $(this).parent().data('cardid');
    var PlayerData = $("#player-card-"+PlayerId).data('PlayerData');
    $.post('http://fw-banking/ClickSound', JSON.stringify({}))
    $.post('http://fw-banking/DeletePlayer', JSON.stringify({CitizenId: PlayerData['CitizenId'], BankId: CurrentAccountData['BankId']}), function(IsDone){
        if (IsDone) {
            CloseBankContext();
        } else {
            $.post('http://fw-banking/ErrorSound', JSON.stringify({}))
        }
    });
});

$(document).on('click', '.context-3-accept', function(e) {
    e.preventDefault();
    var AddCid = $('.add-player').val();
    $.post('http://fw-banking/ClickSound', JSON.stringify({}))
    $.post('http://fw-banking/AddPlayer', JSON.stringify({CitizenId: AddCid, BankId: CurrentAccountData['BankId']}), function(IsDone){
        if (IsDone) {
            CloseBankContext();
        } else {
            $.post('http://fw-banking/ErrorSound', JSON.stringify({}))
        }
    });
});

$(document).on('click', '.context-button-cancel', function(e) {
    e.preventDefault();
    $.post('http://fw-banking/ClickSound', JSON.stringify({}))
    CloseBankContext();
});

$(document).on('click', '.bank-add-account', function(e) {
    e.preventDefault();
    if (CanClick) {
        $.post('http://fw-banking/ClickSound', JSON.stringify({}))
        OpenBankContext(false, 'Aanmaken')
    }
});

$(document).on('click', '.account-transaction', function(e) {
    e.preventDefault();
    var BankId = $(this).parent().data('cardid');
    var BankData = $("#accout-card-"+BankId).data('AccountData');
    if (CanClick) {
        $.post('http://fw-banking/ClickSound', JSON.stringify({}))
        SetupAccountTransactions(BankData['Transactions'])
    }
});

$(document).on('click', '.account-man', function(e) {
    e.preventDefault();
    var BankId = $(this).parent().data('cardid');
    var BankData = $("#accout-card-"+BankId).data('AccountData');
    if (CanClick) {
        $.post('http://fw-banking/ClickSound', JSON.stringify({}))
        OpenBankContext(BankData, 'Spelers')
    }
});

$(document).on('click', '.transactions-clear', function(e) {
    e.preventDefault();
    $.post('http://fw-banking/ClickSound', JSON.stringify({}))
    $('.account-transaction-container').html('');
});

$(document).on('click', '.context-button-accept', function(e) {
 $.post('http://fw-banking/ClickSound', JSON.stringify({}))
 var Amount = $('.number').val();
 var Reason = $('.text').val();
 var Account = $('.bank').val();
 var AccountName = $('.name').val();
 var AccountType = $('.context-menu').val();
 if (Amount !== '') {
    if (CurrentContextType == 'Opname') {
        $.post('http://fw-banking/WithdrawMoney', JSON.stringify({Type: CurrentAccountData['Type'], AccountNumber: CurrentAccountData['BankId'], WithdrawAmount: Amount, WithdrawReason: Reason}), function(IsDone){
            if (IsDone) {
                CloseBankContext();
            } else {
                $.post('http://fw-banking/ErrorSound', JSON.stringify({}))
                CloseBankContext();
            }
        });
    } else if (CurrentContextType == 'Storten') {
        $.post('http://fw-banking/DepositMoney', JSON.stringify({Type: CurrentAccountData['Type'], AccountNumber: CurrentAccountData['BankId'], DepositAmount: Amount, DepositReason: Reason}), function(IsDone){
            if (IsDone) {
                CloseBankContext();
            } else {
                $.post('http://fw-banking/ErrorSound', JSON.stringify({}))
                CloseBankContext();
            }
        });
    } else if (CurrentContextType == 'Overmaken' && Account != '') {
        $.post('http://fw-banking/TransferMoney', JSON.stringify({Type: CurrentAccountData['Type'], TargetNumber: Account, AccountNumber: CurrentAccountData['BankId'], TransferAmount: Amount, TransferReason: Reason}), function(IsDone){
            if (IsDone) {
                CloseBankContext();
            } else {
                $.post('http://fw-banking/ErrorSound', JSON.stringify({}))
                CloseBankContext();
            }
        }); 
    } 
 } else if (AccountName != '') {
    $.post('http://fw-banking/CreateAccount', JSON.stringify({Name: AccountName, Type: AccountType}), function(IsDone){
        if (IsDone) {
            CloseBankContext();
        } else {
            $.post('http://fw-banking/ErrorSound', JSON.stringify({}))
            CloseBankContext();
        }
    }); 
 } else {
    $.post('http://fw-banking/ErrorSound', JSON.stringify({}))
 }
});

$(document).on('click', '.remove-account', function(e) {
    e.preventDefault();
    if (CanClick) {
        var BankId = $(this).parent().data('cardid');
        var BankData = $("#accout-card-"+BankId).data('AccountData');
        $.post('http://fw-banking/ClickSound', JSON.stringify({}))
        $.post('http://fw-banking/DeleteAccount', JSON.stringify({BankId: BankData['BankId']}), function(IsDone){
            if (IsDone) {
                RefreshAccountCards();
            } else {
                $.post('http://fw-banking/ErrorSound', JSON.stringify({}))
            }
        }); 
    }
});

$(document).on('click', '.account-button-deposit', function(e) {
    e.preventDefault();
    if (CanClick) {
        var BankId = $(this).parent().data('cardid');
        var BankData = $("#accout-card-"+BankId).data('AccountData');
        $.post('http://fw-banking/ClickSound', JSON.stringify({}))
        OpenBankContext(BankData, 'Storten')
    }
});

$(document).on('click', '.account-button-withdraw', function(e) {
    e.preventDefault();
    if (CanClick) {
        var BankId = $(this).parent().data('cardid');
        var BankData = $("#accout-card-"+BankId).data('AccountData');
        $.post('http://fw-banking/ClickSound', JSON.stringify({}))
        OpenBankContext(BankData, 'Opname')
    }
});

$(document).on('click', '.account-button-transfer', function(e) {
    e.preventDefault();
    if (CanClick) {
        var BankId = $(this).parent().data('cardid');
        var BankData = $("#accout-card-"+BankId).data('AccountData');
        $.post('http://fw-banking/ClickSound', JSON.stringify({}))
        OpenBankContext(BankData, 'Overmaken')
    }
});


$(document).on('click', '.context-3-add', function(e) {
    e.preventDefault();
    $('.context-3-add-container').show(250);
});

$(document).on('click', '.context-3-close', function(e) {
    e.preventDefault();
    CloseBankContext();
});

$(document).on('click', '.context-3-cancel', function(e) {
    e.preventDefault();
    $('.context-3-add-container').hide(250);
});

window.addEventListener('message', function(event) {
    switch(event.data.action) {
        case "OpenBank":
            OpenBankContainer(event.data);
            break;
    }
});

document.onkeyup = function (data) {
    if (data.which == 27) { // Escape
       CloseBankContainer();
    }
};