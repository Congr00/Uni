export TITLE="WyboryApp :: Arch"
export ACTUAL_PAGE="Archiwum"

export LINK1="index.html"
export LINK1N="Start"
export LINK2="auth.html"
export LINK2N="Głosuj"
export LINK3="kand.html"
export LINK3N="Kandydaci"




export CONTENT=$(cat <<DOC
<div class="container">
    <div class="row red-text center"><h5>UWAGA: Rozpoczęło się <a href="auth.html"><u><b>GŁOSOWANIE!</b></u><a>    </h5></div>
    <hr>
    <div class="row wybr">
        <a class="waves-effect waves-light btn-small" href="results.html">Wybory A</a><br>
        <a class="waves-effect waves-light btn-small" href="results.html">Wybory B</a><br>
        <a class="waves-effect waves-light btn-small" href="results.html">Wybory C</a><br>
        <a class="waves-effect waves-light btn-small" href="results.html">Wybory D</a><br>
        <a class="waves-effect waves-light btn-small" href="results.html">Wybory E</a><br>
        <a class="waves-effect waves-light btn-small" href="results.html">Wybory F</a><br>
        <a class="waves-effect waves-light btn-small" href="results.html">Wybory G</a><br>
    </div>
</div>
DOC
)
