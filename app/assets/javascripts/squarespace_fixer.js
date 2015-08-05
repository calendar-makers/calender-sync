var setup_squarespace = function() {
    var open_menu = function() {
        menu = $('#mobileNav');
        if (menu.prop('class') == '') {
            menu.addClass('menu-open');
        } else {
            menu.removeClass('menu-open');
        }
    };

    $('#mobileMenuLink').find('a').on('click', open_menu);
};