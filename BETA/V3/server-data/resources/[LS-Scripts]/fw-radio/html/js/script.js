Radio = {}

Radio.Enabled = false

window.addEventListener('message', function(event) {
    if (event.data.type == "open") {
        Radio.SlideUp()
    }
    if (event.data.type == "close") {
        Radio.SlideDown()
    }
    if (event.data.type == "setchannel") {
        Radio.SetChannellet(event.data)
    }
    if (event.data.type == "disableinput") {
        Radio.DisableInput()
    }
    if (event.data.type == "enableinput") {
        Radio.EnableInput()
    }
});

document.onkeyup = function (data) {
    if (data.which == 27) { // Escape key
        $.post('https://fw-radio/Escape', JSON.stringify({}));
        Radio.SlideDown()
    } else if (data.which == 13) { // Enter
        $.post('https://fw-radio/JoinRadio', JSON.stringify({
            channel: $("#channel").val()
        }));
    }
};

$(document).on('click', '.button', function(e){
    e.preventDefault();

    let KeyData = $(this).data('button')
    Radio.OnClick()
    if (KeyData === 'onoff') {
        $.post('https://fw-radio/ToggleOnOff', JSON.stringify({}));
    }
    if (Radio.Enabled) {
        if (KeyData === 'submit') {
            $.post('https://fw-radio/JoinRadio', JSON.stringify({
                channel: $("#channel").val()
            }));
        } else if (KeyData === 'disconnect') {
            $.post('https://fw-radio/LeaveRadio');
            $("#channel").val('');
        } else if (KeyData === 'volumeup') {
            $.post('https://fw-radio/SetVolume', JSON.stringify({
                Type: 'Up'
            }));
        } else if (KeyData === 'volumedown') {
            $.post('https://fw-radio/SetVolume', JSON.stringify({
                Type: 'Down'
            }));
        }
    }
});

Radio.SetChannellet = function(data) {
    $("#channel").val(data.channel);
}

Radio.OnClick = function() {
 $.post('https://fw-radio/OnClick');
}

Radio.SlideUp = function() {
    $(".container").css("display", "block");
    $(".radio-container").animate({bottom: "6vh",}, 250);
}

Radio.SlideDown = function() {
    $(".radio-container").animate({bottom: "-110vh",}, 400, function(){
        $(".container").css("display", "none");
    });
}

Radio.EnableInput = function() {
    Radio.Enabled = true;
    $(".channel").css("pointer-events", "all");
    $(".channel").css("user-select", "all");
}

Radio.DisableInput = function() {
    Radio.Enabled = false;
    $(".channel").css("pointer-events", "none");
    $(".channel").css("user-select", "none");
}