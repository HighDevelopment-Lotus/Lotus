$(document).on('click', '.button', function(e) {
    e.preventDefault();
    var ButtonType = $(this).data('type')
    if ($(this).data('state') == 'off') {
        if (ButtonType == 'blue') {
            $(this).data('state', 'on')
            $(this).html(`<img src="./img/blauw-aan.png">`);
            $.post(`http://fw-els/SetLights`, JSON.stringify({Type: 'Blauw', State: 0}));
            $.post(`http://fw-els/RegisterButton`, JSON.stringify({Type: 'Blue', State: true}));
        } else if (ButtonType == 'sound') {
            $(this).data('state', 'on')
            $(this).html(`<img src="./img/geluid-aan.png">`);
            $.post(`http://fw-els/SetSirens`, JSON.stringify({Bool: true}));
            $.post(`http://fw-els/RegisterButton`, JSON.stringify({Type: 'Siren', State: true}));
        } else if (ButtonType == 'volg') {
            $(this).data('state', 'on')
            $(this).html(`<img src="./img/volg-aan.png">`);
            $.post(`http://fw-els/SetLights`, JSON.stringify({Type: 'Volg', State: 0}));
            $.post(`http://fw-els/RegisterButton`, JSON.stringify({Type: 'Follow', State: true}));
        } else if (ButtonType == 'stop') {
            $(this).data('state', 'on')
            $(this).html(`<img src="./img/stop-aan.png">`);
            $.post(`http://fw-els/SetLights`, JSON.stringify({Type: 'Stop', State: 0}));
            $.post(`http://fw-els/RegisterButton`, JSON.stringify({Type: 'Stop', State: true}));
        } else if (ButtonType == 'groen') {
            $(this).data('state', 'on')
            $(this).html(`<img src="./img/groen-aan.png">`);
            $.post(`http://fw-els/SetLights`, JSON.stringify({Type: 'Groen', State: 0}));
            $.post(`http://fw-els/RegisterButton`, JSON.stringify({Type: 'Green', State: true}));
        } else if (ButtonType == 'oranje') {
            $(this).data('state', 'on')
            $(this).html(`<img src="./img/oranje-aan.png">`);
            $.post(`http://fw-els/SetLights`, JSON.stringify({Type: 'Oranje', State: 0}));
            $.post(`http://fw-els/RegisterButton`, JSON.stringify({Type: 'Orange', State: true}));
        }
    } else {
        if (ButtonType == 'blue') {
            $(this).data('state', 'off')
            $(this).html(`<img src="./img/lamp-uit.png">`);
            $.post(`http://fw-els/SetLights`, JSON.stringify({Type: 'Blauw', State: 1}));
            $.post(`http://fw-els/RegisterButton`, JSON.stringify({Type: 'Blue', State: false}));
        } else if (ButtonType == 'sound') {
            $(this).data('state', 'off')
            $(this).html(`<img src="./img/geluid-uit.png">`);
            $.post(`http://fw-els/SetSirens`, JSON.stringify({Bool: false}));
            $.post(`http://fw-els/RegisterButton`, JSON.stringify({Type: 'Siren', State: false}));
        } else if (ButtonType == 'volg') {
            $(this).data('state', 'off')
            $(this).html(`<img src="./img/volg-uit.png">`);
            $.post(`http://fw-els/SetLights`, JSON.stringify({Type: 'Volg', State: 1}));
            $.post(`http://fw-els/RegisterButton`, JSON.stringify({Type: 'Follow', State: false}));
        } else if (ButtonType == 'stop') {
            $(this).data('state', 'off')
            $(this).html(`<img src="./img/stop-uit.png">`);
            $.post(`http://fw-els/SetLights`, JSON.stringify({Type: 'Stop', State: 1}));
            $.post(`http://fw-els/RegisterButton`, JSON.stringify({Type: 'Stop', State: false}));
        } else if (ButtonType == 'oranje') {
            $(this).data('state', 'off')
            $(this).html(`<img src="./img/lamp-uit.png">`);
            $.post(`http://fw-els/SetLights`, JSON.stringify({Type: 'Oranje', State: 1}));
            $.post(`http://fw-els/RegisterButton`, JSON.stringify({Type: 'Orange', State: false}));
        } else if (ButtonType == 'groen') {
            $(this).data('state', 'off')
            $(this).html(`<img src="./img/lamp-uit.png">`);
            $.post(`http://fw-els/SetLights`, JSON.stringify({Type: 'Groen', State: 1}));
            $.post(`http://fw-els/RegisterButton`, JSON.stringify({Type: 'Green', State: false}));
        }
    }
    $.post(`http://fw-els/Click`, JSON.stringify({}));
});

ResetAll = function() {
    $('.sound').html(`<img src="./img/geluid-uit.png">`);
    $('.blue').html(`<img src="./img/lamp-uit.png">`);
    $('.stop').html(`<img src="./img/stop-uit.png">`);
    $('.follow').html(`<img src="./img/volg-uit.png">`);
    $('.orange').html(`<img src="./img/lamp-uit.png">`);
    $('.green').html(`<img src="./img/lamp-uit.png">`);
    $('.button').data('state', 'off')
}

SetupButtonData = function(data) {
    for (const [key, value] of Object.entries(data.buttondata)) {
        if (value == true) {
            if (key == 'Blue') {
                $('.blue').data('state', 'on')
                $('.blue').html(`<img src="./img/blauw-aan.png">`);
            } else if (key == 'Siren') {
                $('.sound').data('state', 'on')
                $('.sound').html(`<img src="./img/geluid-aan.png">`);
            } else if (key == 'Follow') {
                $('.follow').data('state', 'on')
                $('.follow').html(`<img src="./img/volg-aan.png">`);
            } else if (key == 'Stop') {
                $('.stop').data('state', 'on')
                $('.stop').html(`<img src="./img/stop-aan.png">`);
            } else if (key == 'Green') {
                $('.green').data('state', 'on')
                $('.green').html(`<img src="./img/groen-aan.png">`);
            } else if (key == 'Orange') {
                $('.orange').data('state', 'on')
                $('.orange').html(`<img src="./img/oranje-aan.png">`);
            }
        }
    }
    OpenLightControl(data);
}

CloseLightControl = function() {
    $('.control-panel-container').animate({right: "-45vh"}, 250, function() {
        ResetAll()
        $('.control-panel-container').css("display", "none");
    })
}

OpenLightControl = function(data) {
    $('.control-panel-container').css("display", "block");
    $('.control-panel-container').animate({right: "1vh"}, 250)
}

window.addEventListener('message', function(event) {
    switch(event.data.action) {
        case "open":
            SetupButtonData(event.data)
            break;
    }
});

window.addEventListener("keyup", function onEvent(event) {
    // Close menu when key is released
    if (event.key == 'Control') {
        CloseLightControl()
        $.post(`http://fw-els/CloseUi`, JSON.stringify({}));
    }
});