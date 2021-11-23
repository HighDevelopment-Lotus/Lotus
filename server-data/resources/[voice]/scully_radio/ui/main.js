var radioOn = false

$(function() {
    window.addEventListener('message', function(event) {
        if (event.data.type == "openradio") {
            if(event.data.enable) {
                $("body").fadeIn("slow");
            } else {
                $("body").fadeOut("slow");
            }
        };
    });

    document.onkeyup = function (data) {
        if (data.which == 27) {
            $.post('https://scully_radio/close', JSON.stringify({}));
        }
    };

    $("#freqform").submit(function(e) {
        e.preventDefault();
        $.post('https://scully_radio/joinChannel', JSON.stringify({
            channel: $("#channel").val()
        }));
    });
});

function OnOff() {
    if (radioOn) {
        radioOn = false;
        $(".screen").css("display", "none");
        $("#radioimage").attr("src","radiooff.png");
        $.post('https://scully_radio/leaveChannel', JSON.stringify({}));
    } else {
        radioOn = true;
        $("#radioimage").attr("src","radio.png");
        $.post('https://scully_radio/radioOn', JSON.stringify({}));
        setTimeout(function() {
            if (radioOn) {
                $(".screen").css("display", "block");
            };
        }, 1000);
    };
};

function VolUp() {
    $.post('https://scully_radio/VolUp', JSON.stringify({}));
};

function VolDown() {
    $.post('https://scully_radio/VolDown', JSON.stringify({}));
};

function setTwoNumberDecimal() {
    $("#channel").val(parseFloat($("#channel").val()).toFixed(2));
}