$(function () {
    var speedContainer = $("#speedcontainer");

    var unit = $(".unit");
    var speed = $(".speed");
    var engine = $(".health > .engine");
    var body = $(".health > .body");
    var tank = $(".health > .tank");
    var danger = $(".health > .danger");

    var engineValue = 1000;
    var bodyValue = 1000;
    var tankValue = 1000;
    var dangerValue = false;

    window.addEventListener("message", function (event) {
        var item = event.data;

        if (undefined !== item.showhud) {
            speedContainer.fadeIn();
            unit.text(item.unit);
            speed.text(item.speed);
            engineValue = Math.floor(item.engine);
            bodyValue = Math.floor(item.body);
            tankValue = Math.floor(item.tank);

            /* engineHealth */

            if (engineValue > 0) {
                danger.removeClass('critical').addClass('normal');
            }

            if (engineValue > 500) {
                engine.removeClass('critical heavy light').addClass('normal');
            } else if (engineValue <= 500 && engineValue > 250) {
                engine.removeClass('normal').addClass('light');
            } else if (engineValue <= 250 && engineValue > 0) {
                engine.removeClass('light').addClass('heavy');
            } else if (engineValue <= 0) {
                engine.removeClass('heavy').addClass('critical');
                danger.removeClass('normal').addClass('critical');
            }

            /* tankHealth */

            if (tankValue > 0) {
                danger.removeClass('critical').addClass('normal');
            }

            if (tankValue > 600) {
                tank.removeClass('critical heavy light').addClass('normal');
            } else if (tankValue <= 600 && tankValue > 300) {
                tank.removeClass('normal').addClass('light');
            } else if (tankValue <= 300 && tankValue > 0) {
                tank.removeClass('light').addClass('heavy');
            } else if (tankValue <= 0) {
                tank.removeClass('heavy').addClass('critical');
                danger.removeClass('normal heavy').addClass('critical');
            }

            /* bodyHealth */

            if (bodyValue > 900) {
                body.removeClass('critical heavy light').addClass('normal');
            } else if (bodyValue <= 900 && bodyValue > 400) {
                body.removeClass('normal').addClass('light');
            } else if (bodyValue <= 400 && bodyValue > 0) {
                body.removeClass('light').addClass('heavy');
            } else if (bodyValue <= 0) {
                body.removeClass('heavy').addClass('critical');
            }

        } else if (undefined !== item.hidehud) {
            speedContainer.fadeOut();
        }
    });
});