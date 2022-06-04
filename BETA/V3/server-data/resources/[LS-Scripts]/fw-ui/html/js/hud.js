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
    $('.hud-status').show(0, function() {
        $('.hud-status').animate({"bottom": "3.5vh"}, 450)
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
        /*VoiceHud = CreateHud('hud-voice', 'rgb(255, 255, 255)', 'rgba(255, 255, 255, 0.5)');
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
        SpeedHud.animate(0.1);*/
    }
}

UpdateHud = function(data) {
    /*HealthHud.animate((data.health - 100) / 100)
    ArmorHud.animate(data.armor / 100)
    FoodHud.animate(data.hunger / 100)
    WaterHud.animate(data.thirst / 100)
    StressHud.animate(data.stress / 100)
    TimerHud.animate(data.timer / 100)*/

    
    $("#hp-bar").animate({"width": (data.health - 100) + "%"})

    // if(data.cornerselling['isInZone']) {
    //     $("#placeholder-cornerselling").fadeIn()
    // } else {
    //     $("#placeholder-cornerselling").fadeOut()
    // }

    // if(data.cornerselling['isSelling']) {
    //     $("#cornerselling-bar").css({"color": "#27ae60"})
    // } else {
    //     $("#cornerselling-bar").css({"color": "white"})
    // }

    if((data.health - 100) < 20) {
        $("#hp-bar").css({"background-color": "red"})
        $("#hp-icon").css({"color": "red"})
    } else {
        $("#hp-bar").css({"background-color": "white"})
        $("#hp-icon").css({"color": "white"})
    }

    // ARMOR
    if (data.armor == 0 || data.armor < 1) {
        $('#placeholder-armor').fadeOut(1300)
    } else {
        $('#placeholder-armor').fadeIn(1300)
        $("#armor-bar").animate({"width": data.armor + "%"})

        if(data.armor < 20) {
            $("#armor-bar").css({"background-color": "red"})
            $("#armor-icon").css({"color": "red"})
        } else {
            $("#armor-bar").css({"background-color": "white"})
            $("#armor-icon").css({"color": "white"})
        }
    }

    // STRESS
    if (data.stress > 1) {
        $('#placeholder-stress').fadeIn(1300);
        $("#stress-percentage").html(data.stress + "%");
    } else {
        $('#placeholder-stress').fadeOut(1300);
    }

    if (data.air > 0 && data.swimming) {
        $("#air-percentage").html(data.air + "%");
        setTimeout(function() {
            $('#placeholder-air').fadeIn(1300)
        }, 250)
    } else {
        $('#placeholder-air').fadeOut(1300)
    }

    if (data.nos > 0) {
        $("#nos-percentage").html(data.nos + "%");
        setTimeout(function() {
            $('#placeholder-nos').fadeIn(1300)
        }, 250)
    } else {
        setTimeout(function() {
            $('#placeholder-nos').fadeOut(1300)
        }, 250)
    }

    if (data.enginehealth < 450) {
        console.log('showing')
        $("#placeholder-engine").fadeIn(500)
    } else {
        $("#placeholder-engine").fadeOut(500)
    }

    if (data.seatbelt) {
        $('#placeholder-belt').fadeOut(500)
    } else {
        $('#placeholder-belt').fadeIn(500)
    }

    if (data.radio) {
        $("#voice-bar").css("color", "rgb(192, 28, 3)")
    } else if (data.talking) {
        $("#voice-bar").css("color", "rgb(255, 179, 15)")
    }  else if (!data.radio && !data.talking) {
        $("#voice-bar").css("color", "white")
    }
   
    if (data.voice == 1) {
        $("#voiceline-1").fadeIn(500);
        $("#voiceline-2").fadeOut(500);
        $("#voiceline-3").fadeOut(500);
    } else if (data.voice == 2) {
        $("#voiceline-1").fadeIn(500);
        $("#voiceline-2").fadeIn(500);
        $("#voiceline-3").fadeOut(500);
    } else if (data.voice == 3) {
        $("#voiceline-1").fadeIn(500);
        $("#voiceline-2").fadeIn(500);
        $("#voiceline-3").fadeIn(500);
    }
    $("#hunger-percentage").html(data.hunger + "%");

    if(data.hunger < 15) {
        $("#hunger-percentage").css({"color": "red"})
        $("#hunger-icon").css({"color": "red"})
    } else {
        $("#hunger-percentage").css({"color": "white"})
        $("#hunger-icon").css({"color": "white"})
    }

    $("#fuel-percentage").html(data.fuel + "%");
    $("#thirst-percentage").html(data.thirst + "%");

    if(data.thirst < 15) {
        $("#thirst-percentage").css({"color": "red"})
        $("#thirst-icon").css({"color": "red"})
    } else {
        $("#thirst-percentage").css({"color": "white"})
        $("#thirst-icon").css({"color": "white"})
    }
   
};

OpenCarHud = function() {
    $('.hud-status').animate({"left": "31vh"}, 450, function() {
        $('.hud-status').animate({"bottom": "3vh"}, 450)
        $("#main-car-hud").show(450)
    })
}

CloseCarHud = function() {
    $("#main-car-hud").hide(450, function() {
        $('.hud-status').animate({"bottom": "3.5vh"}, 450, function() {
            $('.hud-status').animate({"left": "3.5vh"}, 450)
        })
    });
}

SetSpeed = function(data) {
    $('#speed').html(data.speed);
    if(data.speed > 9) {
        $('#speed-meter').css({'width': '4rem'});
    } else {
        $('#speed-meter').css({'width': '2rem'});
    }

    if (data.speed > 99) {
        $('#speed-meter').css({'width': '5.8rem'});
    }
    
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
            SetSpeed(event.data);
            break;
        case "OpenCarHud":
            OpenCarHud();
            break;
        case "CloseCarHud":
            CloseCarHud();
            break;
    }
});