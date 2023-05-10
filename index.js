const express = require("express");
const ejs = require("ejs");
const mysql = require('mysql');
const formidable = require("formidable");

app = express();
app.set("view engine", "ejs");
app.use(express.urlencoded({ extended: false }));
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

app.post("/inreg/:tabel",function(req, res){
    query = "INSERT INTO " + req.params.tabel + " VALUES(";

    valori = Object.values(req.body);

    for(let i = 0; i < valori.length; i++){
        if(valori[i] == '') query = query + `null, `;
        else query = query + `'${valori[i]}', `;
    }

    query = query.slice(0, -2); // se elimina ultima virgula care nu e necesara
    query = query + ");";
    // console.log(query);


    con.query(query, function(err){
        if(err) console.log(err);
        res.redirect(`/viz/${req.params.tabel}`);
    })
});

app.post("/editare/:tabel", function(req, res){
    query = "UPDATE " + req.params.tabel + " SET ";

    chei = Object.keys(req.body);
    valori = Object.values(req.body);

    for(let i = 1; i < chei.length; i++){
        if(valori[i] == '') query = query + `${chei[i]} = null, `;
        //else if(!isNaN(valori[i])) query = query + `${chei[i]} = ${valori[i]}, `;
        else  query = query + `${chei[i]} = '${valori[i]}', `;
    }

    query = query.slice(0, -2); // se elimina ultima virgula care nu e necesara
    query = query + ` WHERE ${chei[0]} = ${valori[0]}`; // stiu ca nu e o idee foarte inspirata sa iau id-ul din formular
    // console.log(query);


    con.query(query, function(err){
        if(err) console.log(err);
        res.redirect(`/viz/${req.params.tabel}`);
    })
});


app.get("/add/:tabel", function(req, res, next){
    tabel = req.params.tabel;
    titlu = tabel.toUpperCase()[0] + tabel.slice(1);
    con.query(`SELECT * FROM ${tabel}`, function(err, rows){
        coloane = Object.keys(rows[0]);
        for (var i = 0; i < coloane.length; i++) {
            coloane[i] = coloane[i].charAt(0).toUpperCase() + coloane[i].slice(1);

            if(coloane[i].includes("_")){
                coloane[i] = coloane[i].split("_").join(" ");
            }
        }

        res.render("pages/adaugare", 
                    {titlu: titlu,
                    coloane: coloane,
                    valori: rows
                    }
                );
    });
});


app.get("/viz/:tabel", function(req, res, next){
    tabel = req.params.tabel;
    
    titlu = tabel.toUpperCase()[0] + tabel.slice(1);
    con.query(`SELECT * FROM ${tabel}`, function(err, rows){
        if(rows.length > 0){
            
            coloane = Object.keys(rows[0]);
            for (var i = 0; i < coloane.length; i++) {
                coloane[i] = coloane[i].charAt(0).toUpperCase() + coloane[i].slice(1);

                if(coloane[i].includes("_")){
                    coloane[i] = coloane[i].split("_").join(" ");
                }
            }

            if(tabel == "angajati" || tabel == "pacienti") {
                rows.forEach(row => { row.data_nasterii = row.data_nasterii.toISOString().split('T')[0]}); } 
            else if(tabel == "inventare") {
                rows.forEach(row => { row.data_inventar = row.data_inventar.toISOString().split('T')[0]}); } 
            else if(tabel == "repartizare_sali") {
                rows.forEach(row => { row.data_repartizare = row.data_repartizare.toISOString().split('T')[0]}); }

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