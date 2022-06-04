var Board = false;

OpenBoard = function() {
    Board = true;
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

CloseBoard = function() {
    Board = false;
    $(".scoreboard-block").fadeOut(150);
    // $('.main-police-scanner').slideUp(750, function() {
    //     $.post('http://fw-ui/CloseMenuSecond', JSON.stringify({clear: false}))
    // });
}
window.addEventListener('message', function(event) {
    switch(event.data.action) {
        case "OpenBoard":
            OpenBoard()
            break;
        case "CloseBoard":
            CloseBoard()
            break;
    }
});