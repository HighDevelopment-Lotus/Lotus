var CurrentCitizenId = null;
var CurrentCharNumber = 1;
var CreatingChar = false
var CanClick = true

$(document).on('click', '.multichar-arrow-right', function(e) {
    if (CanClick) {
        CanClick = false;
        $.post('http://fw-multichar/ClickSound', JSON.stringify({}))
        $('.multichar-container').slideUp(450, function() {
            CurrentCharNumber = CurrentCharNumber + 1
            $.post('http://fw-multichar/GetChar', JSON.stringify({CharNumber: CurrentCharNumber}), function(CharData){
                SetCharData(CharData)
                ChangeArrows(CurrentCharNumber)
                $('.multichar-container').slideDown(500)
            });
        })
    }
});

$(document).on('click', '.multichar-arrow-left', function(e) {
    if (CanClick) {
        CanClick = false;
        $.post('http://fw-multichar/ClickSound', JSON.stringify({}))
        $('.multichar-container').slideUp(450, function() {
            CurrentCharNumber = CurrentCharNumber - 1
            $.post('http://fw-multichar/GetChar', JSON.stringify({CharNumber: CurrentCharNumber}), function(CharData){
                SetCharData(CharData)
                ChangeArrows(CurrentCharNumber)
                $('.multichar-container').slideDown(500)
            });
        })
    }
});

$(document).on('click', '.multichar-play-button', function(e) {
    if (CanClick) {
        CanClick = false;
        $.post('http://fw-multichar/ClickSound', JSON.stringify({}))
        if (CreatingChar) {
            var CharName = $('.name').val();
            var CharLast = $('.lastname').val();
            var CharBirth = $('.date').val();
            var CharGender = $('.gender').val();
            var ResultGender = 0
            if (CharGender == 'vrouw') {
                ResultGender = 1
            }
            if (CharName != '' && CharLast != '' && CharBirth != '') {
                $.post('http://fw-multichar/CreateChar', JSON.stringify({Slot: CurrentCharNumber, FirstName: CharName, LastName: CharLast, BirthDate: CharBirth, Gender: ResultGender}))
                CloseCharScreen()
            } else {
                $.post('http://fw-multichar/ErrorSound', JSON.stringify({}))
            }
        } else {
            $.post('http://fw-multichar/ChooseChar', JSON.stringify({CitizenId: CurrentCitizenId}))
            CloseCharScreen()
        }
    }
});

$(document).on('click', '.multichar-delete-button', function(e) {
    $.post('http://fw-multichar/ClickSound', JSON.stringify({}))
    $.post('http://fw-multichar/DeleteCharacter', JSON.stringify({CitizenId: CurrentCitizenId}))
    CloseCharScreen()
});

SetupFirstChar = function() {
    $.post('http://fw-multichar/GetChar', JSON.stringify({CharNumber: 1}), function(CharData){
        SetCharData(CharData)
        $('.multichar-container').slideDown(500)
    });
}

ChangeArrows = function(Numbers) {
    if (Numbers == 1) {
        $('.multichar-arrow-left').hide(0);
    } else if (Numbers == 2 || Numbers == 3 || Numbers == 4) {
        $('.multichar-arrow-left').show(0);
        $('.multichar-arrow-right').show(0);
    } else if (Numbers == 5) {
        $('.multichar-arrow-right').hide(0);
    }
    CanClick = true;
}

SetCharData = function(Data) {
    if (Data['Active']) {
        if (Data['Photo'] != null && Data['Photo'] != undefined) {
            $('.multichar-photo').html('<img src="'+Data['Photo']+'">');
        } else {
            // $('.multichar-photo').html('<img src="./img/default.png">');
        }
        $('.multichar-name').html(Data['Name']);
        $('.multichar-date').html('Datum: <span class="small-font">'+Data['Date']+'</span>');
        $('.multichar-work').html('Werk: <span class="small-font">'+Data['JobName']+' '+Data['JobFunctie']+'</span>');
        $('.multichar-bsn').html('BSN: <span class="small-font">'+Data['CitizenId']+'</span>');
        $('.multichar-banksaldo').html('Bank Saldo: <span class="small-font">€ '+Data['Bank']+'</span>');
        // $('.multichar-playtime').html('Speeltijd: <span class="small-font">'+Data['Playtime']+'</span>');
        $('.multichar-play-button').html('Bevestigen');
        $('.multichar-delete-button').html('Verwijderen');
        $('.multichar-new-name').hide();
        $('.multichar-remove-info').show();
        $('.multichar-delete-button').show();
        CurrentCitizenId = Data['CitizenId']
        CreatingChar = false;
    } else {
        // $('.multichar-photo').html('<img src="./img/default.png">');
        $('.multichar-name').html('Nieuw Karakter');
        $('.multichar-new-name').show();
        $('.multichar-remove-info').hide();
        $('.multichar-delete-button').hide();
        CurrentCitizenId = null;
        CreatingChar = true;
    }
}

CloseCharScreen = function() {
    $.post('http://fw-multichar/CloseUi', JSON.stringify({}))
    $('.multichar-container').slideUp(450, function() {
        $('.multichar-arrow-left').hide(0);
        $('.multichar-arrow-right').show(0);
        $('.multichar-play-button').html('Bevestigen');
        $('.multichar-delete-button').html('Verwijderen');
        CurrentCitizenId = null;
        CurrentCharNumber = 1;
        CreatingChar = false;
        CanClick = true;
    })
}

window.addEventListener('message', function(event) {
    switch(event.data.action) {
        case "SetupChars":
            SetupFirstChar()
            break;
    }
});