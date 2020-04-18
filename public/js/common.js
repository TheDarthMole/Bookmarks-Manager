var navbar = document.getElementById('navbarTogglerDemo03');

var button = document.getElementsByClassName('navbar-toggler')[0];
button.onclick = function() {
    if (navbar.classList.value.includes('collapse ')) {
        navbar.classList.remove('collapse');
    } else {
        navbar.classList.value = "collapse " + navbar.classList.value;
    }
}