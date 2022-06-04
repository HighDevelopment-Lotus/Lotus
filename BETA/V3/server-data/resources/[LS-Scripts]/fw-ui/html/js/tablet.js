var PoliceTabletOpen = false;
var PoliceFingerOpen = false;

OpenPoliceTablet = function() {
    PoliceTabletOpen = true;
    $('.main-police-tablet').show(250);
}

ClosePoliceTablet = function() {
    PoliceTabletOpen = false;
    $('.main-police-tablet').hide(250);
    $.post('http://fw-ui/CloseMenuSecond', JSON.stringify({clear: true}))
}

OpenPoliceFinger = function() {
    PoliceFingerOpen = true;
    $('.main-police-scanner').slideDown(750);
}

ClosePoliceFinger = function() {
    PoliceFingerOpen = false;
    $('.main-police-scanner').slideUp(750, function() {
        $.post('http://fw-ui/CloseMenuSecond', JSON.stringify({clear: false}))
    });
}

$(document).on('click', '.scanner-button', function(e) {
    e.preventDefault();
    $.post('http://fw-ui/ScanFinger', JSON.stringify({}))
});

window.addEventListener('message', function(event) {
    switch(event.data.action) {
        case "OpenPoliceTablet":
            OpenPoliceTablet()
            break;
        case "ClosePoliceTablet":
            ClosePoliceTablet()
            break;
        case "OpenPoliceFinger":
            OpenPoliceFinger()
            break;
        case "set-finger":
            $('.scanner-id').html(event.data.finger);
            break;
    }
});