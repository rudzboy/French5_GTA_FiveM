$(function () {

    var blink = 10;

    window.onload = function (e) {
        window.addEventListener('message', function (event) {
            var item = event.data;
            if (item !== undefined && item.type === "basicneeds") {

                if (item.display === true) {
                    $('#basic-needs').delay(600).show();
                } else if (item.display === false) {
                    $('#basic-needs').hide();
                }

                $hunger = $('#hunger > .value');
                $hunger.css('height', item.hunger + '%');
                if (item.hunger < blink && !$hunger.hasClass('blink')) {
                    $hunger.addClass("blink");
                } else if (item.hunger > blink && $hunger.hasClass('blink')) {
                    $hunger.removeClass("blink");
                }

                $thirst = $('#thirst > .value');
                $thirst.css('height', item.thirst + '%');
                if (item.thirst < blink && !$thirst.hasClass('blink')) {
                    $thirst.addClass("blink");
                } else if (item.thirst > blink && $thirst.hasClass('blink')) {
                    $thirst.removeClass("blink");
                }
            }
        });
    };
});