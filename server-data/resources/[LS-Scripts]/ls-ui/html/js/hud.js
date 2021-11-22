var VoiceHud, HealthHud, ArmorHud, FoodHud, Waterhud, StressHud, AirHud, NosHud, TimerHud, FuelHud, BeltHud, SpeedHud;
var CurrentTransactionsShowing = 0;
var CurrentCash = 0;

// Money //

ChangeMoney = function(data) {
    var RandomId = Math.floor(Math.random() * 100000)
    $(".current-money").fadeIn(150);
    if (data.type == 'Remove') {
        var MoneyChange = '<div class="money minus" id="id-'+RandomId+'">-€ <span class="reset-color">'+data.amount+'</span></div>'
        $('.money-container').append(MoneyChange);
        CurrentTransactionsShowing = CurrentTransactionsShowing + 1
        setTimeout(function() {
            $("#id-"+RandomId).fadeOut(750, function() {
                $("#id-"+RandomId).remove();
                CurrentTransactionsShowing = CurrentTransactionsShowing - 1
                if (CurrentTransactionsShowing == 0 || CurrentTransactionsShowing < 0) {
                    $(".current-money").fadeOut(300);
                }
            });
        }, 3500)
    } else {
        var MoneyChange = '<div class="money plus" id="id-'+RandomId+'">+€ <span class="reset-color">'+data.amount+'</span></div>'
        $('.money-container').append(MoneyChange);
        CurrentTransactionsShowing = CurrentTransactionsShowing + 1
        setTimeout(function() {
            $("#id-"+RandomId).fadeOut(750, function() {
                $("#id-"+RandomId).remove();
                CurrentTransactionsShowing = CurrentTransactionsShowing - 1
                if (CurrentTransactionsShowing == 0 || CurrentTransactionsShowing < 0) {
                    $(".current-money").fadeOut(300);
                }
            });
        }, 3500)
    }
}

ShowCurrentMoney = function() {
    $(".current-money").fadeIn(150);
    setTimeout(function() {
        $(".current-money").fadeOut(750);
    }, 3500)
}

// Hud //


ShowHud = function() {
    SetupHud();
    $('.hud-status').show(0, function() {
        $('.hud-status').animate({"bottom": ".5vh"}, 450)
    })
}

HideHud = function() {
    $('.hud-status').animate({"bottom": "-4vh"}, 450, function() {
        $('.hud-status').hide(0)
    })
}

function CreateHud(className, color, trailColor){
    return new ProgressBar.Circle(`.${className}`, {
        color: color,
        trailColor: trailColor,
        strokeWidth: 15,
        trailWidth: 15,
        duration: 215,
        easing: "easeInOut",
        fill: "transparent",
    });
}

function CreateSpeed(className, color, trailColor){
    return new ProgressBar.SemiCircle(`.${className}`, {
        color: color,
        trailColor: trailColor,
        strokeWidth: 7,
        trailWidth: 7,
        duration: 215,
        easing: "easeInOut",
    });
}

SetupHud = function() {
    if (VoiceHud == undefined) {
        VoiceHud = CreateHud('hud-voice', 'rgb(255, 255, 255)', 'rgba(255, 255, 255, 0.5)');
        VoiceHud.animate(1.0);
        HealthHud = CreateHud('hud-health', 'rgb(0, 182, 91)', 'rgba(0, 128, 0, 0.5)');
        HealthHud.animate(1.0);
        ArmorHud = CreateHud('hud-armor', 'rgb(0, 103, 213)', 'rgba(0, 49, 102, 0.5)');
        ArmorHud.animate(1.0);
        FoodHud = CreateHud('hud-hunger', 'rgb(255, 118, 0)', 'rgba(179, 82, 0, 0.5)')
        FoodHud.animate(1.0);
        WaterHud = CreateHud('hud-thirst', 'rgb(3, 140, 252)', 'rgba(3, 140, 252, 0.5)')
        WaterHud.animate(1.0);
        StressHud = CreateHud('hud-stress', 'rgb(232, 51, 37)', 'rgba(102, 23, 16, 0.5)')
        StressHud.animate(1.0);
        AirHud = CreateHud('hud-air', 'rgb(89, 181, 178)', 'rgba(89, 181, 178, 0.5)')
        AirHud.animate(1.0);
        NosHud = CreateHud('hud-nos', 'rgb(255, 74, 104)', 'rgba(102, 27, 40, 0.5)')
        NosHud.animate(1.0);
        TimerHud = CreateHud('hud-timer', 'rgb(146, 52, 235)', 'rgba(146, 52, 235, 0.5)')
        TimerHud.animate(1.0);
        FuelHud = CreateHud('hud-fuel', 'rgb(255, 255, 255)', 'rgba(255, 255, 255, 0.5)')
        FuelHud.animate(1.0);
        BeltHud = CreateHud('hud-belt', 'rgb(232, 51, 37)', 'rgba(232, 51, 37, 0.5)')
        BeltHud.animate(1.0);
        SpeedHud = CreateSpeed('hud-speed', 'rgb(255, 255, 255)', 'rgba(255, 255, 255, 0.5)')
        SpeedHud.animate(0.1);
    }
}

UpdateHud = function(data) {
    HealthHud.animate((data.health - 100) / 100)
    ArmorHud.animate(data.armor / 100)
    FoodHud.animate(data.hunger / 100)
    WaterHud.animate(data.thirst / 100)
    StressHud.animate(data.stress / 100)
    TimerHud.animate(data.timer / 100)

    if (data.armor == 0 || data.armor < 1) {
        $('.hud-armor').fadeOut(1300)
    } else {
        $('.hud-armor').fadeIn(1300)
    }

    if (data.stress == 0 || data.stress < 1) {
        $('.hud-stress').fadeOut(1300)
    } else {
        $('.hud-stress').fadeIn(1300)
    }

    if (data.timer == 0 || data.timer < 1) {
        $('.hud-timer').fadeOut(1300)
    } else {
        StressHud.animate(data.timer / 100)
        $('.hud-timer').fadeIn(1300)
    }

    if (data.air > 0 && data.swimming) {
        AirHud.animate(data.air / 100)
        setTimeout(function() {
            $('.hud-air').fadeIn(1300)
        }, 250)
    } else {
        $('.hud-air').fadeOut(1300)
        AirHud.animate(0)
    }

    if (data.nos > 0) {
        NosHud.animate(data.nos / 100)
        setTimeout(function() {
            $('.hud-nos').fadeIn(1300)
        }, 250)
    } else {
        NosHud.animate(0)
        setTimeout(function() {
            $('.hud-nos').fadeOut(1300)
        }, 250)
    }

    if (data.voice == 1) {
        VoiceHud.animate(0.25)
    } else if (data.voice == 2) {
        VoiceHud.animate(0.5)
    } else if (data.voice == 3) {
       VoiceHud.animate(0.75)
    } else if (data.voice == 4) {
       VoiceHud.animate(1.0)
    }

    if (data.radio) {
        VoiceHud.path.setAttribute("stroke", "rgb(235, 76, 52)")
        VoiceHud.trail.setAttribute("stroke", "rgba(235, 76, 52, 0.5)")
    } else if (data.talking) {
        VoiceHud.path.setAttribute("stroke", "rgb(235, 211, 52)")
        VoiceHud.trail.setAttribute("stroke", "rgba(235, 211, 52, 0.5)")
    }  else if (!data.radio && !data.talking) {
        VoiceHud.path.setAttribute("stroke", "rgb(255, 255, 255)")
        VoiceHud.trail.setAttribute("stroke", "rgba(255, 255, 255, 0.5)")
    }
    // Vehicle Hud
    if (data.seatbelt) {
        $('.hud-belt').fadeOut(1300)
    } else {
        $('.hud-belt').fadeIn(1300)
    }

    FuelHud.animate(data.fuel / 100)
    if (data.fuel <= 10) {
        FuelHud.path.setAttribute("stroke", "rgb(232, 51, 37)")
        FuelHud.trail.setAttribute("stroke", "rgba(232, 51, 37, 0.5)")
    } else if (data.fuel > 10) {
        FuelHud.path.setAttribute("stroke", "rgb(255, 255, 255)")
        FuelHud.trail.setAttribute("stroke", "rgba(255, 255, 255, 0.5)")
    }

    var CurrentRpm = data.rpm - 0.2
    SpeedHud.animate(CurrentRpm)
    if (CurrentRpm >= 0.7) {
        SpeedHud.path.setAttribute("stroke", "rgb(232, 51, 37)")
        SpeedHud.trail.setAttribute("stroke", "rgba(232, 51, 37, 0.5)")
    } else if (CurrentRpm < 0.7) {
        SpeedHud.path.setAttribute("stroke", "rgb(255, 255, 255)")
        SpeedHud.trail.setAttribute("stroke", "rgba(255, 255, 255, 0.5)")
    }
};

OpenCarHud = function() {
    $('.hud-status').animate({"left": "29vh"}, 450, function() {
        $('.hud-status').animate({"bottom": "3vh"}, 450)
        $(".main-car-hud").show(450)
    })
}

CloseCarHud = function() {
    $(".main-car-hud").hide(450, function() {
        $('.hud-status').animate({"bottom": ".5vh"}, 450, function() {
            $('.hud-status').animate({"left": ".5vh"}, 450)
        })
    });
}

window.onload = function(e) {
    $(".current-money").fadeOut(0);
}

window.addEventListener('message', function(event) {
    switch(event.data.action) {
        case "UpdateHud":
            UpdateHud(event.data);
            break;
        case "ChangeMoney":
            ChangeMoney(event.data);
            break;
        case "SetMoney":
            CurrentCash = event.data.amount
            $(".current-money").html(`€ <span class="reset-color">${CurrentCash}</span>`)
            break;
        case "ShowCash":
            ShowCurrentMoney()
            break;
        case "Show":
            ShowHud();
            break;
        case "Hide":
            HideHud();
            break;
        case "CarSpeed":
            $('.speed').html(event.data.speed)
            break;
        case "OpenCarHud":
            OpenCarHud();
            break;
        case "CloseCarHud":
            CloseCarHud();
            break;
    }
});