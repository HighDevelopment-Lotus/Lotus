document.onkeyup = function (data) {
    if (data.which == 27) { // Escape
       if (PoliceTabletOpen) {
           ClosePoliceTablet();
       } else if (NewspaperOpen) {
            CloseNewsPaper();
       } else if (MagazineOpen) {
            CloseMagazine();
       } else if (BlocksOpen) {
            StopBlocksGame();
       } else if (PoliceFingerOpen) {
            ClosePoliceFinger();
       } else if (DoingTask) {
            FailedSkill();
       } else if (InputOpen) {
           CloseInput();
       } else {
           CloseContextMenu(true);
       }   
    } else if (data.which == 13) { 
       if (InputOpen) {
           $('.input-button-accept').click()
       }
    } else if (event.key == 'g' || event.key == 'G') {
        if (EyeOpen) {
           CloseEye()
        } 
    }
};

UiReload = function() {
    $('.ui-reload').show(1);
    ClosePoliceTablet();
    CloseNewsPaper();
    CloseMagazine();
    ClosePoliceFinger();
    CloseInput();
    RemoveInfo();
    ResetEye()
    CloseEye()
    HideInteraction();
    CloseContextMenu(true);
    setTimeout(function(){
        $('.ui-reload').hide(1);
    }, 3500);
}

window.addEventListener('message', function(event) {
    switch(event.data.action) {
        case "UiReload":
            UiReload()
            break;
    }
});

window.addEventListener("mousedown", function onEvent(event) {
    if (event.button == 2) {
        if (EyeOpen) {
            $.post(`http://fw-ui/CloseMenu`, JSON.stringify({}));
        }
    }
});