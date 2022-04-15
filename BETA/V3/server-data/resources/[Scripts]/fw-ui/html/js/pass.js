

ShowPass = function(data) {
    $('.police-pass-name').html(`${data.name}<br>${data.pfunction}<br>${data.callsign}`)
    $('.police-image').attr("src", data.photo)
    $('.main-pass-container').slideDown(350, function() {
        setTimeout(function(){
            $('.main-pass-container').slideUp(350);
        }, 4000);
    });
}

window.addEventListener('message', function(event) {
    switch(event.data.action) {
        case "show-pass":
            ShowPass(event.data.data)
            break;
    }
});