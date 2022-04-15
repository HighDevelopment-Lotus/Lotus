var CurrentImage = null;
var CanClick = true;

$(document).on('click', '.context-item', function(e) {
    e.preventDefault();
    if (CanClick) {
        var MenuData = $(this).data('MenuData')
        if (MenuData['SecondMenu'] != null && MenuData['SecondMenu'] != undefined) {
            $.post('http://fw-ui/TriggerContextMenu', JSON.stringify({ShitData: MenuData['Data']}))
            CanClick = false;
            GoToSubMenu(MenuData['SecondMenu'])
        } else {
            $.post('http://fw-ui/TriggerContextMenu', JSON.stringify({ShitData: MenuData['Data']}))
            CloseContextMenu(false)
        }
    }
});

$(document).on('click', '.context-sub-item', function(e) {
    e.preventDefault();
    if (CanClick) {
        var MenuData = $(this).data('MenuData')
        if (MenuData['GoBack']) {
            GoBackToMainMenu()
        }
        if (MenuData['CloseMenu']) {
            CloseContextMenu(MenuData['DoCloseEvent'])
        }
        $.post('http://fw-ui/TriggerContextMenu', JSON.stringify({ShitData: MenuData['Event']}))
    }
});

$(document).on('click', '.return', function(e) {
    e.preventDefault();
    if (CanClick) {
        var TotalMenuData = $('.main-context-container').data('AllMenuData')
        if (TotalMenuData['ReturnEvent'] != null && TotalMenuData['ReturnEvent'] != undefined) {
            $.post('http://fw-ui/TriggerContextMenu', JSON.stringify({ShitData: TotalMenuData['ReturnEvent']}))
        }
        GoBackToMainMenu()
    }
});

$(document).on('click', '.close', function(e) {
    e.preventDefault();
    if (CanClick) {
        CloseContextMenu(true)
    }
});

GoBackToMainMenu = function() {
    var TotalMenuData = $('.main-context-container').data('AllMenuData')
    SetupContextMenu(TotalMenuData)
}

ClearContextImage = function() {
    CurrentImage = null;
    $('.context-image').hide();
    $('.context-image img').attr("src", '')
}

CloseContextMenu = function(DoCloseEvent) {
    if (DoCloseEvent) {
        var TotalMenuData = $('.main-context-container').data('AllMenuData')
        if (TotalMenuData != null && TotalMenuData != undefined && TotalMenuData['CloseEvent'] != null && TotalMenuData['CloseEvent'] != undefined) {
            $.post('http://fw-ui/TriggerContextMenu', JSON.stringify({ShitData: TotalMenuData['CloseEvent']}))
        }
    }
    $('.main-context-container').slideUp(350, function() {
        ClearContextImage()
        $('.title').show();
        $('.return').hide();
        $('.title').html('');
        $('.context-menu-items').html('');
        CanClick = true;
    })
    $.post('http://fw-ui/CloseContext', JSON.stringify({}))
}

GoToSubMenu = function(MenuData) {
    ClearContextImage()
    $('.context-menu-items').html('');
    $('.title').hide();
    $('.return').show();
    $.each(MenuData, function (key, value) {
        var AddMenuItem = `<div class="leftmenu"></div><div class="context-menu-item context-menu-hover context-sub-item" id="menu-item${key}">${value['Title']}</div>`
        $('.context-menu-items').append(AddMenuItem);
        $(`#menu-item${key}`).data('MenuData', value);  
    });
    setTimeout(function(){
        CanClick = true;
    }, 400);
}

SetupContextMenu = function(Data) {
    $('.title').show();
    $('.return').hide();
    $('.context-menu-items').html('');
    $('.title').html(Data['Title']);
    $.each(Data['MainMenuItems'], function (key, value) {
        var AddMenuItem = `<div class="leftmenu"></div><div class="context-menu-item context-menu-hover context-item" id="menu-item${key}"><div class="context-menu-title">${value['Title']}</div><div class="context-menu-desc">${value['Desc']}</div></div>`
        $('.context-menu-items').append(AddMenuItem);
        $(`#menu-item${key}`).data('MenuData', value);  
    });
    $('.main-context-container').data('AllMenuData', Data);
    $('.main-context-container').slideDown(350, function() {
        CanClick = true;
    })
}

$(document).on({
    mouseenter: function(e){
        e.preventDefault();
        var MenuData = $(this).data('MenuData');
        if (MenuData['Image'] != null && MenuData['Image'] != undefined) {
            $('.context-image img').attr("src", MenuData['Image'])
            $('.context-image').show();
            CurrentImage = MenuData['Image'];
        }
    },
    mouseleave: function(e){
        e.preventDefault();
        CurrentImage = null;
        $('.context-image').hide();
        $('.context-image img').attr("src", '')
    },
    mousemove: function(e){
        e.preventDefault();
        if (CurrentImage != undefined && CurrentImage != null) {
            $('.context-image').css({
                'top': e.pageY - ($(document).height() / 100) * 15.5,
                'left': e.pageX,
            })
        }
    },
}, ".context-item");

window.addEventListener('message', function(event) {
    switch(event.data.action) {
        case "open-context":
            SetupContextMenu(event.data.menudata)
            break;
    }
});