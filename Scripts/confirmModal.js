(function ($) {
    var pendingElement = null;
    var confirmed = false;

    function buildModal() {
        if ($('#hhConfirmOverlay').length) return;

        var html =
            '<div id="hhConfirmOverlay" class="hh-confirm-overlay">' +
            '<div class="hh-confirm-box">' +
            '<p id="hhConfirmMessage" class="hh-confirm-message"></p>' +
            '<div class="hh-confirm-actions">' +
            '<button type="button" id="hhConfirmYes" class="hh-confirm-btn hh-confirm-yes">Yes, continue</button>' +
            '<button type="button" id="hhConfirmNo" class="hh-confirm-btn hh-confirm-no">Cancel</button>' +
            '</div>' +
            '</div>' +
            '</div>';

        $('body').append(html);

        $('#hhConfirmYes').on('click', function () {
            $('#hhConfirmOverlay').removeClass('show');
            if (pendingElement) {
                confirmed = true;
                pendingElement.click();
                pendingElement = null;
            }
        });

        $('#hhConfirmNo').on('click', function () {
            $('#hhConfirmOverlay').removeClass('show');
            pendingElement = null;
        });

        // Also close if the dark overlay itself is clicked (not the box)
        $('#hhConfirmOverlay').on('click', function (e) {
            if (e.target.id === 'hhConfirmOverlay') {
                $('#hhConfirmOverlay').removeClass('show');
                pendingElement = null;
            }
        });
    }

    $(function () {
        buildModal();
    });

    window.confirmAction = function (message, element) {
        if (confirmed) {
            confirmed = false;
            return true; // let the real postback proceed this time
        }

        buildModal();
        pendingElement = element;
        $('#hhConfirmMessage').text(message);
        $('#hhConfirmOverlay').addClass('show');
        return false; // cancel this click, wait for the modal instead
    };
})(jQuery);
