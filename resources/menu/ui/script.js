$(function () {

    var menuBody = $("#menu-body");
    var mainMenu = $("#main");
    var inventoryMenus = [
        {
            selector: $("#inventory-use"),
            event: "item:use"
        },
        {
            selector: $("#inventory-give"),
            event: "item:give"
        },
        {
            selector: $("#inventory-drop"),
            event: "item:drop"
        }
    ];

    var contactsMenu = $("#contacts");
    var asideMenu = $("#aside");
    var currentMenu = false;

    function openMenu(menu) {
        resetSelection(menu);
        menu.show();
    }

    function closeMenu(menu) {
        menu.hide();
    }

    function closeAllMenus() {
        $('.menu').hide();
    }

    function resetSelection(menu) {
        var buttons = menu.find('button');
        if (buttons.length > 0) {
            buttons.removeClass('selected');
            buttons.eq(0).addClass('selected');
            menu.find('.position').html('1/' + buttons.length);
        }
        return true;
    }

    function updateSelection(menu, orientation) {
        var currentIndex = false;
        var targetIndex = false;
        var buttons = menu.find('button');

        if (buttons.length > 0) {
            buttons.each(function (index) {
                if ($(this).hasClass('selected')) {
                    currentIndex = index;
                    if (orientation === "up") {
                        if (index !== 0) {
                            targetIndex = index - 1;
                        } else {
                            targetIndex = buttons.length - 1;
                        }
                    } else if (orientation === "down") {
                        if (index !== buttons.length - 1) {
                            targetIndex = index + 1;
                        } else {
                            targetIndex = 0;
                        }
                    }
                    return false;
                }
            });

            if (currentIndex !== false && targetIndex !== false) {
                buttons.eq(currentIndex).removeClass('selected');
                buttons.eq(targetIndex).addClass('selected').focus();
            }

            menu.find('.position').html((targetIndex + 1) + '/' + buttons.length);
        }

        return true;
    }

    function getSelectedButton(menu) {
        var target = false;
        var buttons = menu.find('button');
        buttons.each(function (index) {
            if ($(this).hasClass('selected')) {
                target = $(this);
                return false;
            }
        });
        return target;
    }

    function getParentMenuId(menu) {
        return (undefined !== menu.data('parent') ? menu.data('parent') : false);
    }

    function getSubMenuId(menu) {
        return (undefined !== getSelectedButton(menu).data('menu') ? getSelectedButton(menu).data('menu') : false);
    }

    function updateInventoryMenus(items) {
        $.each(inventoryMenus, function (index, menu) {

            menu.selector.find('button').remove();

            var itemsWrapper = menu.selector.find('.content');

            if (items.length > 0) {
                for (var key in items) {
                    var item = items[key];

                    $('<button/>', {
                        "data-event": menu.event,
                        "data-id": item.id,
                        "data-libelle": item.libelle,
                        "data-quantity": item.quantity,
                        "data-illegal": item.isIllegal,
                        "html": item.libelle + '<span class="quantity">' + item.quantity + '</span>'
                    }).appendTo(itemsWrapper);
                }
            } else {
                $('<button/>', {
                    "text": 'Vide'
                }).appendTo(itemsWrapper);
            }

            resetSelection(menu.selector);
        });
    }

    /*
     * PHONE FUNCTIONS
     */

    function updateRepertoire(players) {

        contactsMenu.find('button:not(.permanent)').remove();
        var contactsWrapper = contactsMenu.find('.content');

        players.sort(sortByName);

        if (players.length > 0) {
            for (var key in players) {
                var player = players[key];
                $('<button/>', {
                    "data-form": "phone-message",
                    "data-receiver": player.id,
                    "html": player.name
                }).appendTo(contactsWrapper);
            }
        } else {
            $('<button/>', {
                "text": 'Vide'
            }).appendTo(contactsWrapper);
        }

        resetSelection(contactsMenu);
    }

    function displayPhoneMessage(message, sender) {

        var messageBlock = $('<div/>', {
            "class": "message"
        });

        messageBlock.append(
            $('<div/>', {
                "class": "header",
                "html": "Message"
            })
        );

        messageBlock.append(
            $('<div/>', {
                "class": "sender",
                "html": 'De : <span class="name">' + sender + '</span>'
            })
        );

        messageBlock.append(
            $('<div/>', {
                "class": "content",
                "html": message
            })
        );

        var currentMessage = messageBlock.prependTo($('#phone-messages'));

        currentMessage.fadeIn('slow', function () {
            currentMessage.delay(17000).fadeOut('slow', function () {
                currentMessage.remove();
            });
        });
    }

    /*
     * FORMS FUNCTIONS
     */

    function openForm(selector, receiver) {
        var form = $('#' + selector);
        form.find(".receiver").first().val(receiver);
        form.show();
        form.bind('submit', function (e) {
            e.preventDefault();
            var event = $(this).attr("action");
            var message = "";
            var receiver = false;
            var amount = 0;
            switch (event) {
                case 'phone:sendMessage':
                    message = $(this).find(".message").first().val();
                    receiver = $(this).find(".receiver").first().val();
                    $.post('http://menu/action', JSON.stringify({
                        'event': event,
                        'message': stripTags(message),
                        'receiver': receiver
                    }));
                    break;
                case 'bank:givecash':
                    amount = $(this).find(".amount").first().val();
                    $.post('http://menu/action', JSON.stringify({
                        'event': event,
                        'amount': stripTags(amount)
                    }));
                    break;
                default:
                    break;
            }

            return false;
        });

        var box = form.find('.focus').first();
        box.focus();
        box.keyup(function (e) {
            switch (e.which) {
                case 27:
                    /* Key : Escape */
                    $.post('http://menu/closeform', JSON.stringify({
                        'selector': selector
                    }));
                    break;
                case 13:
                    /* Key : Return */
                    submitForm(form);
                    box.unbind('keyup');
                    break;
                default:
                    break;
            }
        });
        box.keydown(function (e) {
            if (e.keyCode == 9) {
                /* Tab will focus back to current form element */
                $(this).focus();
                e.preventDefault();
            }
        });
    }

    function submitForm(form) {
        form.submit();
        $.post('http://menu/closeform', JSON.stringify({
            'selector': form.attr("id")
        }));
    }

    function closeForm(selector) {
        var form = $('#' + selector);
        form.unbind('submit');
        form[0].reset();
        form.hide();
    }

    /*
     * UTILS FUNCTIONS
     */

    function stripTags(str) {
        str = str.toString();
        return str.replace(/<\/?[^>]+>/gi, '');
    }

    function sortByName(a, b) {
        var aName = a.name.toLowerCase();
        var bName = b.name.toLowerCase();
        return ((aName < bName) ? -1 : ((aName > bName) ? 1 : 0));
    }


    /*
     * NUI MESSAGES HANDLER
     */

    window.addEventListener('message', function (event) {

        var item = event.data;

        /*
         * MENU BEHAVIOUR
         */
        if (item.type === 'menu') {

            if (undefined !== item.selector && item.selector !== false) {
                currentMenu = $("#" + item.selector);
            } else {
                currentMenu = mainMenu;
            }

            if (undefined !== item.display) {
                switch (item.display) {
                    case true :
                        openMenu(currentMenu);
                        break;
                    case false :
                        if (item.selector === false) {
                            closeAllMenus();
                        } else {
                            closeMenu(currentMenu);
                        }
                        break;
                    default:
                        break;
                }
            }

            if (undefined !== item.visible) {
                switch (item.visible) {
                    case true :
                        menuBody.show(400);
                        break;
                    case false :
                        menuBody.hide(400);
                        break;
                    default:
                        break;
                }
            }

            if (undefined !== item.selection) {
                updateSelection(currentMenu, item.selection);
            }

            if (undefined !== item.back) {
                var currentMenuId = false;
                var displayMenuId = false;
                if (currentMenu !== false) {
                    currentMenuId = currentMenu.attr('id');
                    displayMenuId = getParentMenuId(currentMenu);
                }
                $.post('http://menu/update', JSON.stringify({
                    'current': currentMenuId,
                    'display': displayMenuId
                }));
            }

            if (undefined !== item.enter) {
                var enterCurrentId = false;
                var enterTargetId = false;
                if (currentMenu !== false) {
                    enterCurrentId = currentMenu.attr('id');
                    enterTargetId = getSubMenuId(currentMenu);
                }

                if (enterTargetId !== false) {
                    $.post('http://menu/update', JSON.stringify({
                        'current': enterCurrentId,
                        'display': enterTargetId
                    }));
                } else {
                    $.post('http://menu/action', JSON.stringify(
                        getSelectedButton(currentMenu).data()
                    ));
                }
            }
        }

        /*
         * INVENTORY BEHAVIOUR
         */
        if (item.type === 'inventory') {
            if (undefined !== item.items) {
                updateInventoryMenus(item.items);
            }
        }

        /*
         * PHONE BEHAVIOUR
         */

        if (item.type === 'phone') {
            if (undefined !== item.players) {
                updateRepertoire(item.players);
            }
            if (undefined !== item.message) {
                displayPhoneMessage(item.message, item.sender);
            }
        }

        /*
         * FORM BEHAVIOUR
         */

        if (item.type === 'form') {
            if (undefined !== item.selector) {
                if (undefined !== item.display) {
                    if (item.display === true) {
                        openForm(item.selector, item.receiver);
                    } else {
                        closeForm(item.selector);
                    }
                }
            }
        }

    });

});
