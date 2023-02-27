window.addEventListener("DOMContentLoaded", function() {
    let btns = document.querySelectorAll('.stergere');

    for (let btn of btns) {
        btn.addEventListener('click', function() {
            rand = this.parentElement.parentElement;
            let id = Number(rand.getElementsByTagName("td")[0].innerHTML);
            let tabel = document.getElementsByTagName("h1")[0].innerHTML.toLowerCase();

            rand.remove();
            fetch(`http://localhost:8080/stergere/${tabel}/${id}`, {method:'POST'});
        });
    }
});