const express = require("express");
const ejs = require("ejs");
const mysql = require('mysql');

app = express();
app.set("view engine", "ejs");
app.use("/resources", express.static(__dirname + "/resources"));

const con = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    database: 'clinica',
    password: 'iulia'
});

app.get(["/", "/index", "/home", "/login"], function(req, res){
    res.render("pages/index");
});


app.post("/stergere/:tabel/:id",function(req, res){
    // numele coloanei pentru id difera in functie de tabel
    let iduri = {
        "angajati": "angajat",
        "echipamente": "echipament",
        "furnizori": "furnizor",
        "inventare": "inventar",
        "joburi": "job",
        "livrari": "livrare",
        "pacienti": "pacient",
        "programari": "programare",
        "repartizare_sali": "repartizare",
        "sali": "sala",
        "servicii": "serviciu"
    }
    con.query(`DELETE FROM ${req.params.tabel} WHERE id_${iduri[req.params.tabel]} = ${req.params.id}`, function(err){ 
    });
});


app.get("/viz/:tabel", function(req, res, next){
    tabel = req.params.tabel;
    
    titlu = tabel.toUpperCase()[0] + tabel.slice(1)
    con.query(`SELECT * FROM ${tabel}`, function(err, rows){
        if(rows.length > 0){
            coloane = Object.keys(rows[0]);
            for (var i = 0; i < coloane.length; i++) {
                coloane[i] = coloane[i].charAt(0).toUpperCase() + coloane[i].slice(1);

                if(coloane[i].includes("_")){
                    coloane[i] = coloane[i].split("_").join(" ");
                }
            }
        }
        res.render("pages/afisare", 
                    {titlu: titlu,
                    coloane: coloane,
                    valori: rows
                    }
                );
        });
});


app.listen(8080);
console.log("Serverul a pornit!");