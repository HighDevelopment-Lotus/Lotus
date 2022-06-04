var EyeOpen = false;
var MouseActive = false;
var CurrentHoverItem = null;

$(document).on({
    mouseenter: function(e){
        e.preventDefault();
        if (MouseActive) {
            $(this).find('.menu-text').addClass('hover-item')
            CurrentHoverItem = $(this).find('.menu-text');
        }
    },
    mouseleave: function(e){
        e.preventDefault();
        if (MouseActive) {
            $(this).find('.menu-text').removeClass('hover-item')
            CurrentHoverItem = null;
        }
    },
    click: function(e){
        e.preventDefault();
        if (MouseActive) {
            var EyeId = $(this).data('id');
            var EyeData = $("#eye-event-"+EyeId).data('EyeData');
            if (EyeData != null && EyeData != undefined) {
                $.post('http://fw-ui/DoSomething', JSON.stringify({eyedata: EyeData}));
                setTimeout(function(){
                    CloseEye()
                }, 35);
            }
        }
    },
},'.menu-item');

SetMouseState = function(Bool) {
    MouseActive = Bool;
    if (!Bool) {
        if (CurrentHoverItem != null) {
            CurrentHoverItem.removeClass('hover-item');
            CurrentHoverItem = null;
        }
    }
}

OpenEye = function() {
    EyeOpen = true
    $('.main-eye-container').show()
}

CloseEye = function() {
    $(".eye-interact").html('<img src="./img/eye.png" class="eye"/>');
    $(".eye-interact").removeClass("found");
    setTimeout(function(){
        EyeOpen = false
        MouseActive = false
        $('.main-eye-container').hide()
        $('.menu-items-container').hide()
        $.post(`http://fw-ui/CloseUi`, JSON.stringify({}));
    }, 15);
}

SetupOptions = function(data) {
    $('.menu-items-container').html('')
    for (const [key, value] of Object.entries(data.currentdata)) {
        var AddOption = '<div class="menu-item" id="eye-event-'+key+'" data-id="'+key+'">'+value['Logo']+' <span class="menu-text">'+value['Name']+'</span></div>'
        $('.menu-items-container').append(AddOption);
        $("#eye-event-"+key).data('EyeData', value);
    }
    $(".eye-interact").html('<img src="./img/eye-found.png" class="eye"/>');
    $('.menu-items-container').show()
}

ResetEye = function() {
    $('.menu-items-container').html('')
    $(".eye-interact").html('<img src="./img/eye.png" class="eye"/>');
    $('.menu-items-container').hide()
}

window.addEventListener('message', function(event) {
    switch(event.data.action) {
        case "OpenEye":
            OpenEye()
            break;
        case "SetMouseState":
            SetMouseState(event.data.mouse)
            MouseActive = event.data.mouse
            break;
        case "ResetEye":
            ResetEye();
            break;
        case "SetData":
            SetupOptions(event.data);
            break;
    }
});