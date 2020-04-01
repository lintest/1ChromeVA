(function (base, files) {
    files.forEach(file => fetch(base + file)
        .then(response => response.text())
        .then(text => eval.apply(null, [text]))
    )
}("http://localhost/vanessa/", [
    "jquery.min.js",
    "leader-line.min.js",
    "library.js",
]));
