
var DoorInteraction = false;

ShowDoorInteraction = function(data) {
    if (!DoorInteraction) {
        DoorInteraction = true;
        $('.doorinteraction-container').html(data.text);
        if (data.type == 'error') {
            $('.doorinteraction-container').css({"background-color": "#8f4949"});
        } else if (data.type == 'success') {
            $('.doorinteraction-container').css({"background-color": "#498f54"});
        } else if (data.type == 'info') {
            $('.doorinteraction-container').css({"background-color": "#d6a042"});
        } else if (data.type == 'pink') {
            $('.doorinteraction-container').css({"background-color": "#954d95"});
        } else {
            $('.doorinteraction-container').css({"background-color": "#496a8f"});
        }
        $('.main-doorinteraction-container').css("display", "block");
        $('.main-doorinteraction-container').animate({"top": "3.5vh"}, 450);
    }
}

EditDoorInteraction = function(data) {
    $('.doorinteraction-container').html(data.text);
    if (data.type == 'error') {
        $('.doorinteraction-container').css({"background-color": "#8f4949"});
    } else if (data.type == 'success') {
        $('.doorinteraction-container').css({"background-color": "#498f54"});
    } else if (data.type == 'info') {
        $('.doorinteraction-container').css({"background-color": "#d6a042"});
    } else if (data.type == 'pink') {
        $('.doorinteraction-container').css({"background-color": "#954d95"});
    } else {
        $('.doorinteraction-container').css({"background-color": "#496a8f"});
    }
}

HideDoorInteraction = function() {
    if (DoorInteraction) {
        DoorInteraction = false;
        $('.main-doorinteraction-container').animate({"top": "-5vh"}, 450, function() {
            $('.main-doorinteraction-container').css("display", "none");
            $('.doorinteraction-container').html('');
        })
    }
}

window.addEventListener('message', function(event) {
    switch(event.data.action) {
        case "doorinteraction":
            ShowDoorInteraction(event.data)
            break;
        case "editdoorinteraction":
            EditDoorInteraction(event.data)
            break;
        case "hidedoorinteraction":
            HideDoorInteraction()
            break;
    }
});