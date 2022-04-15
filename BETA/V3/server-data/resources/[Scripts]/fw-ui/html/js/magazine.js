var MagazineOpen = false;

CloseMagazine = function() {
    $('.main-magazine-container').slideUp(400, function() {
        $('.main-magazine-container').hide(0);
        $.post('http://fw-ui/CloseMenuSecond', JSON.stringify({clear: true}))
        MagazineOpen = false;
    });
}

OpenMagazine = function() {
    MagazineOpen = true;
    $('.main-magazine-container').slideDown(400);
}

$(document).on('click', '.close-button', function(e) {
    e.preventDefault();
    CloseMagazine()
});

window.addEventListener('message', function(event) {
    switch(event.data.action) {
        case "OpenMagazine":
            OpenMagazine();
            break;
    }
});