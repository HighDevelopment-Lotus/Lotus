
ToggleMeter = function(data) {
    if (data) {
        $(".main-taxi-container").css("display", "block");
        $(".main-taxi-container").animate({"bottom": "1vh"}, 550)
    } else {
        $(".main-taxi-container").animate({"bottom": "-25vh"}, 550, function() {
            $(".main-taxi-container").css("display", "none");
        })
    }
}

ToggleMeterActive = function(data) {
    if (data) {
        $(".meter-button").css({"color":"rgb(51, 160, 37)"});
    } else {
        $(".meter-button").css({"color":"rgb(231, 30, 37)"});
    }
}

ResetMeter = function() {
    $(".meter-button").css({"color":"rgb(231, 30, 37)"});
    $(".total-distance").html("0.0 KM")
    $(".total-price").html("€ 20.00")
}

UpdateMeter = function(data) {
  $(".total-price").html("€ "+ (data['CurrentFare']).toFixed(2))
  $(".total-distance").html((data['Distance'] / 200).toFixed(1) + " KM")
}

window.addEventListener('message', function(event) {
    switch(event.data.action) {
        case "UpdateMeter":
            UpdateMeter(event.data.meterdata);
            break;
        case "ResetMeter":
            ResetMeter();
            break;
        case "ToggleMeter":
            ToggleMeter(event.data.toggle);
            break;
        case "ToggleMeterActive":
            ToggleMeterActive(event.data.toggle);
            break;
    }
});

// $(document).ready ( function(){
    // $(".main-taxi-container").css("display", "block");
    // $(".main-taxi-container").animate({"bottom": "1vh"}, 550)
// })