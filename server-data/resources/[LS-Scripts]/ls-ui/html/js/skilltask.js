let canvas = document.getElementById("skill-canvas");
let ctx = canvas.getContext("2d");
let W = canvas.width;
let H = canvas.height;
let degrees = 0;
let new_degrees = 0;
let time = 0;
let color = "#ffffff";
let bgcolor = "#212e36";
let bgcolor2 = "#009c85";
let key_to_press;
let g_start, g_end;
let animation_loop;
let streak = 0;
let speed = [8, 10, 15, 90];
let NeededStreak = 0;
let DoingTask = false;

GetRandomInt = function(min, max) {
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min + 1) + min);
}

Init = function() {
    ctx.clearRect(0, 0, W, H);
    ctx.beginPath();
    ctx.strokeStyle = bgcolor;
    ctx.lineWidth = 15;
    ctx.arc(W / 2, H / 2, 85, 0, Math.PI * 2, false);
    ctx.stroke();
    ctx.beginPath();
    ctx.strokeStyle = bgcolor2;
    ctx.lineWidth = 15;
    ctx.arc(W / 2, H / 2, 85, g_start - 90 * Math.PI / 180, g_end - 90 * Math.PI / 180, false);
    ctx.stroke();
    let radians = degrees * Math.PI / 180;
    ctx.beginPath();
    ctx.strokeStyle = color;
    ctx.lineWidth = 15;
    ctx.arc(W / 2, H / 2, 85, 0 - 90 * Math.PI / 180, radians - 90 * Math.PI / 180, false);
    ctx.stroke();
    ctx.fillStyle = color;
    ctx.font = "900 100px sans-serif";
    let text_width = ctx.measureText(key_to_press).width;
    ctx.fillText(key_to_press, W / 2 - text_width / 2, H / 2 + 35);
}

Reset = function() {
    key_to_press = ''
    degrees = 0
    Init()
}

Draw = function() {
    if (typeof animation_loop !== undefined) clearInterval(animation_loop);
    g_start = GetRandomInt(20, 45) / 10;
    g_end = GetRandomInt(5, 12) / 10;
    g_end = g_start + g_end;
    degrees = 0;
    new_degrees = 360;
    key_to_press = '' + GetRandomInt(1, 4);
    if (speed.length > 1) {
        time = speed[GetRandomInt(0, (speed.length - 1))];
    } else {
        time = speed[0];
    }
    animation_loop = setInterval(Animate_To, time);
}

Animate_To = function() {
    if (degrees >= new_degrees) {
        FailedSkill();
        return
    }
    degrees += 2;
    Init();
}

Correct = function() {
    streak++;
    if (streak >= NeededStreak) {
        SuccessSkill();
    } else {
        Draw();
    }
}

FailedSkill = function() {
    streak = 0;
    $.post('http://ls-ui/FailedTask', JSON.stringify({}));
    $(".main-task-container").css("display", "none");
    clearInterval(animation_loop);
    animation_loop = undefined;
    DoingTask = false;
    Reset();
}

SuccessSkill = function() {
    streak = 0;
    $.post('http://ls-ui/SuccessTask', JSON.stringify({}));
    $(".main-task-container").css("display", "none");
    clearInterval(animation_loop);
    animation_loop = undefined;
    DoingTask = false;
    Reset();
}

StartSkill = function(Speed) {
    if (Speed === 'Fast') {
        speed = [8];
    } else if (Speed === 'Slow') {
        speed = [90];
    } else {
        speed = [8, 10, 15, 90];
    }
    DoingTask = true;
    $(".main-task-container").css("display", "block");
    Draw();
}

window.addEventListener('message', function(event) {
    switch(event.data.action) {
        case "StartSkill":
            StartSkill(event.data.speed);
            NeededStreak = event.data.streak
            break;
        case "ForceStopSkill":
            clearInterval(animation_loop);
            animation_loop = undefined;
            DoingTask = false;
            Reset();
            break;
    }
});

document.onkeydown = function (data) {
    if (DoingTask) {
        let key_pressed = data.key;
        let valid_keys = ['1','2','3','4'];
        if (valid_keys.includes(key_pressed)) {
            if (key_pressed === key_to_press) {
                let d_start = (180 / Math.PI) * g_start;
                let d_end = (180 / Math.PI) * g_end;
                if (degrees < d_start) {
                    FailedSkill();
                } else if (degrees > d_end) {
                    FailedSkill();
                } else {
                    Correct();
                }
            } else {
                FailedSkill()
            }
        }
    }   
}