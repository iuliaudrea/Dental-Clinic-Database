window.addEventListener("DOMContentLoaded", function() {
    let btns = document.querySelectorAll('.stergere');

    for (let btn of btns) {
        btn.addEventListener('click', function() {
            console.log("S-a apasat pe delete");
            rand = this.parentElement.parentElement;
            let id = Number(rand.getElementsByTagName("td")[0].innerHTML);
            let tabel = window.location.href.split("viz/")[1];

            rand.remove();
            fetch(`http://localhost:8080/stergere/${tabel}/${id}`, {method:'POST'});
        });
    }
});