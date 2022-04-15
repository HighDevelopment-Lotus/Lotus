
var ShowingInteract = false;

ShowInteraction = function(data) {
    if (!ShowingInteract) {
        ShowingInteract = true;
        $('.interaction-container').html(data.text);
        if (data.type == 'error') {
            $('.interaction-container').css({"background-color": "#8f4949"});
        } else if (data.type == 'success') {
            $('.interaction-container').css({"background-color": "#498f54"});
        } else if (data.type == 'info') {
            $('.interaction-container').css({"background-color": "#d6a042"});
        } else if (data.type == 'pink') {
            $('.interaction-container').css({"background-color": "#954d95"});
        } else {
            $('.interaction-container').css({"background-color": "#496a8f"});
        }
        $('.main-interaction-container').css("display", "block");
        $('.main-interaction-container').animate({"left": "0.5vh"}, 450);
    }
}

EditInteraction = function(data) {
    $('.interaction-container').html(data.text);
    if (data.type == 'error') {
        $('.interaction-container').css({"background-color": "#8f4949"});
    } else if (data.type == 'success') {
        $('.interaction-container').css({"background-color": "#498f54"});
    } else if (data.type == 'info') {
        $('.interaction-container').css({"background-color": "#d6a042"});
    } else if (data.type == 'pink') {
        $('.interaction-container').css({"background-color": "#954d95"});
    } else {
        $('.interaction-container').css({"background-color": "#496a8f"});
    }
}

HideInteraction = function() {
    if (ShowingInteract) {
        ShowingInteract = false;
        $('.main-interaction-container').animate({"left": "-20vh"}, 450, function() {
            $('.main-interaction-container').css("display", "none");
            $('.interaction-container').html('');
        })
    }
}

window.addEventListener('message', function(event) {
    switch(event.data.action) {
        case "showinteraction":
            ShowInteraction(event.data)
            break;
        case "editinteraction":
            EditInteraction(event.data)
            break;
        case "hideinteraction":
            HideInteraction()
            break;
    }
});