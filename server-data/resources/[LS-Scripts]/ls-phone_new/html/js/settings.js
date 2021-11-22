LS.Phone.Settings = {};
LS.Phone.Settings.Background = "default-lotus";
LS.Phone.Settings.OpenedTab = null;
LS.Phone.Settings.Backgrounds = {
    'default-lotus': {
        label: "Standaard Lotus"
    }
};

var PressedBackground = null;
var PressedBackgroundObject = null;
var OldBackground = null;
var IsChecked = null;

$(document).on('click', '.settings-app-tab', function(e){
    e.preventDefault();
    var PressedTab = $(this).data("settingstab");

    if (PressedTab == "background") {
        LS.Phone.Animations.TopSlideDown(".settings-"+PressedTab+"-tab", 200, 0);
        LS.Phone.Settings.OpenedTab = PressedTab;
    } else if (PressedTab == "profilepicture") {
        LS.Phone.Animations.TopSlideDown(".settings-"+PressedTab+"-tab", 200, 0);
        LS.Phone.Settings.OpenedTab = PressedTab;
    } else if (PressedTab == "numberrecognition") {
        var checkBoxes = $(".numberrec-box");
        LS.Phone.Data.AnonymousCall = !checkBoxes.prop("checked");
        checkBoxes.prop("checked", LS.Phone.Data.AnonymousCall);

        if (!LS.Phone.Data.AnonymousCall) {
            $("#numberrecognition > p").html('Uit');
        } else {
            $("#numberrecognition > p").html('Aan');
        }
    }
});

$(document).on('click', '#accept-background', function(e){
    e.preventDefault();
    var hasCustomBackground = LS.Phone.Functions.IsBackgroundCustom();

    if (hasCustomBackground === false) {
        LS.Phone.Notifications.Add("fas fa-paint-brush", "Instellingen", LS.Phone.Settings.Backgrounds[LS.Phone.Settings.Background].label+" is ingesteld!")
        LS.Phone.Animations.TopSlideUp(".settings-"+LS.Phone.Settings.OpenedTab+"-tab", 200, -100);
        $(".phone-background").css({"background-image":"url('/html/img/backgrounds/"+LS.Phone.Settings.Background+".png')"})
    } else {
        LS.Phone.Notifications.Add("fas fa-paint-brush", "Instellingen", "Eigen achtergrond ingesteld!")
        LS.Phone.Animations.TopSlideUp(".settings-"+LS.Phone.Settings.OpenedTab+"-tab", 200, -100);
        $(".phone-background").css({"background-image":"url('"+LS.Phone.Settings.Background+"')"});
    }

    $.post('http://ls-phone_new/SetBackground', JSON.stringify({
        background: LS.Phone.Settings.Background,
    }))
});

LS.Phone.Functions.LoadMetaData = function(MetaData) {
    if (MetaData.background !== null && MetaData.background !== undefined) {
        LS.Phone.Settings.Background = MetaData.background;
    } else {
        LS.Phone.Settings.Background = "default-lotus";
    }

    var hasCustomBackground = LS.Phone.Functions.IsBackgroundCustom();

    if (!hasCustomBackground) {
        $(".phone-background").css({"background-image":"url('/html/img/backgrounds/"+LS.Phone.Settings.Background+".png')"})
    } else {
        $(".phone-background").css({"background-image":"url('"+LS.Phone.Settings.Background+"')"});
    }

    if (MetaData.profilepicture == "default") {
        $("[data-settingstab='profilepicture']").find('.settings-tab-icon').html('<img src="./img/default.png">');
    } else {
        $("[data-settingstab='profilepicture']").find('.settings-tab-icon').html('<img src="'+MetaData.profilepicture+'">');
    }
}

$(document).on('click', '#cancel-background', function(e){
    e.preventDefault();
    LS.Phone.Animations.TopSlideUp(".settings-"+LS.Phone.Settings.OpenedTab+"-tab", 200, -100);
});

LS.Phone.Functions.IsBackgroundCustom = function() {
    var retval = true;
    $.each(LS.Phone.Settings.Backgrounds, function(i, background){
        if (LS.Phone.Settings.Background == i) {
            retval = false;
        }
    });
    return retval
}

$(document).on('click', '.background-option', function(e){
    e.preventDefault();
    PressedBackground = $(this).data('background');
    PressedBackgroundObject = this;
    OldBackground = $(this).parent().find('.background-option-current');
    IsChecked = $(this).find('.background-option-current');

    if (IsChecked.length === 0) {
        if (PressedBackground != "custom-background") {
            LS.Phone.Settings.Background = PressedBackground;
            $(OldBackground).fadeOut(50, function(){
                $(OldBackground).remove();
            });
            $(PressedBackgroundObject).append('<div class="background-option-current"><i class="fas fa-check-circle"></i></div>');
        } else {
            LS.Phone.Animations.TopSlideDown(".background-custom", 200, 13);
        }
    }
});

$(document).on('click', '#accept-custom-background', function(e){
    e.preventDefault();

    LS.Phone.Settings.Background = $(".custom-background-input").val();
    $(OldBackground).fadeOut(50, function(){
        $(OldBackground).remove();
    });
    $(PressedBackgroundObject).append('<div class="background-option-current"><i class="fas fa-check-circle"></i></div>');
    LS.Phone.Animations.TopSlideUp(".background-custom", 200, -23);
});

$(document).on('click', '#cancel-custom-background', function(e){
    e.preventDefault();

    LS.Phone.Animations.TopSlideUp(".background-custom", 200, -23);
});

// Profile Picture

var PressedProfilePicture = null;
var PressedProfilePictureObject = null;
var OldProfilePicture = null;
var ProfilePictureIsChecked = null;

$(document).on('click', '#accept-profilepicture', function(e){
    e.preventDefault();
    var ProfilePicture = LS.Phone.Data.MetaData.profilepicture;
    if (ProfilePicture === "default") {
        LS.Phone.Notifications.Add("fas fa-paint-brush", "Instellingen", "Standaard profielfoto is ingesteld!")
        LS.Phone.Animations.TopSlideUp(".settings-"+LS.Phone.Settings.OpenedTab+"-tab", 200, -100);
        $("[data-settingstab='profilepicture']").find('.settings-tab-icon').html('<img src="./img/default.png">');
    } else {
        LS.Phone.Notifications.Add("fas fa-paint-brush", "Instellingen", "Eigen profielfoto ingesteld!")
        LS.Phone.Animations.TopSlideUp(".settings-"+LS.Phone.Settings.OpenedTab+"-tab", 200, -100);
        //console.log(ProfilePicture)
        $("[data-settingstab='profilepicture']").find('.settings-tab-icon').html('<img src="'+ProfilePicture+'">');
    }
    $.post('http://ls-phone_new/UpdateProfilePicture', JSON.stringify({
        profilepicture: ProfilePicture,
    }));
});

$(document).on('click', '#accept-custom-profilepicture', function(e){
    e.preventDefault();
    LS.Phone.Data.MetaData.profilepicture = $(".custom-profilepicture-input").val();
    $(OldProfilePicture).fadeOut(50, function(){
        $(OldProfilePicture).remove();
    });
    $(PressedProfilePictureObject).append('<div class="profilepicture-option-current"><i class="fas fa-check-circle"></i></div>');
    LS.Phone.Animations.TopSlideUp(".profilepicture-custom", 200, -23);
});

$(document).on('click', '.profilepicture-option', function(e){
    e.preventDefault();
    PressedProfilePicture = $(this).data('profilepicture');
    PressedProfilePictureObject = this;
    OldProfilePicture = $(this).parent().find('.profilepicture-option-current');
    ProfilePictureIsChecked = $(this).find('.profilepicture-option-current');
    if (ProfilePictureIsChecked.length === 0) {
        if (PressedProfilePicture != "custom-profilepicture") {
            LS.Phone.Data.MetaData.profilepicture = PressedProfilePicture
            $(OldProfilePicture).fadeOut(50, function(){
                $(OldProfilePicture).remove();
            });
            $(PressedProfilePictureObject).append('<div class="profilepicture-option-current"><i class="fas fa-check-circle"></i></div>');
        } else {
            LS.Phone.Animations.TopSlideDown(".profilepicture-custom", 200, 13);
        }
    }
});

$(document).on('click', '#cancel-profilepicture', function(e){
    e.preventDefault();
    LS.Phone.Animations.TopSlideUp(".settings-"+LS.Phone.Settings.OpenedTab+"-tab", 200, -100);
});


$(document).on('click', '#cancel-custom-profilepicture', function(e){
    e.preventDefault();
    LS.Phone.Animations.TopSlideUp(".profilepicture-custom", 200, -23);
});