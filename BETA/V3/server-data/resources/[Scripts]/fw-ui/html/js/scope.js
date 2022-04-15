var ScopeToggled = false;

ToggleScope = function(Toggle) {
    if (Toggle) {
        if (!ScopeToggled) {
            ScopeToggled = true
            $('.main-sniper-scope').show(); 
        }
    } else {
        if (ScopeToggled) {
            ScopeToggled = false;
            $('.main-sniper-scope').removeClass('FadeIn');
            $('.main-sniper-scope').addClass('FadeOut');
            setTimeout(function(){
                $('.main-sniper-scope').hide(0, function() {
                    $('.main-sniper-scope').removeClass('FadeOut');
                    $('.main-sniper-scope').addClass('FadeIn');
                }); 
            }, 235);
        }
    }
}

window.addEventListener('message', function(event) {
    switch(event.data.action) {
        case "scopetoggle":
            ToggleScope(event.data.toggle)
            break;
    }
});