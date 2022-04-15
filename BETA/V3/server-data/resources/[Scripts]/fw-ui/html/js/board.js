Pepes = {}

$(document).ready(function(){
    window.addEventListener('message', function(event) {
        switch(event.data.action) {
            case "open":
                Pepes.Open(event.data);
                break;
            case "close":
                Pepes.Close();
                break;
        }
    })
});

Pepes.Open = function(data) {
    $(".scoreboard-block").fadeIn(150);
    $("#total-players").html("<p>"+data.players+"/"+data.maxPlayers+"</p>");
    
    if (data.currentAmbus >= 1) {
        $("#total-ambus").html('<i class="fas fa-check"></i>');
    } else {
        $("#total-ambus").html('<i class="fas fa-times"></i>');
    }
    $.each(data.requiredCops, function(i, category){
        var beam = $(".scoreboard-info").find('[data-type="'+i+'"]');
        var status = $(beam).find(".info-beam-status");
        if (category.busy) {
            $(status).html('<i class="fas fa-clock"></i>');
        } else if (data.currentCops >= category.minimum) {
            $(status).html('<i class="fas fa-check"></i>');
        } else {
            $(status).html('<i class="fas fa-times"></i>');
        }

    });
}

Pepes.Close = function() {
    $(".scoreboard-block").fadeOut(150);
}