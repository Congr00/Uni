export TITLE="WyboryApp :: Kand"
export ACTUAL_PAGE="Kandydaci"

export LINK1="index.html"
export LINK1N="Start"
export LINK2="auth.html"
export LINK2N="Głosuj"
export LINK3="arch.html"
export LINK3N="Archiwum"


export CONTENT=$(cat <<DOC
<div class="container">
    <div class="row red-text center"><h5>UWAGA: Rozpoczęło się <a href="auth.html"><u><b>GŁOSOWANIE!</b></u><a>    </h5></div>
    <hr>
    <div class="row kand input-field">
        <select>
            <option value="" selected>Lista 1</option>
            <option value="">Lista 2</option>
            <option value="">Lista 3</option>
            <option value="">Lista 4</option>
            <option value="">Lista 5</option>
            <option value="">Lista 6</option>
            <option value="">Lista 7</option>
            <option value="">Lista 8</option>
            <option value="">Lista 9</option>
            <option value="">Lista 10</option>
        </select>
    </div>
    <div class="row kand2">
        <div class="col s2"><a href="about.html"><img src="img/profile.png" /></a></div>
        <div class="col s10"><a href="about.html"><h5>Pan Numer 1</h5></a></div>
    </div>
    <div class="row kand2">
        <div class="col s2"><a href="about.html"><img src="img/profile.png" /></a></div>
        <div class="col s10"><a href="about.html"><h5>Pan Numer 2</h5></a></div>
    </div>
        <div class="row kand2">
        <div class="col s2"><a href="about.html"><img src="img/profile.png" /></a></div>
        <div class="col s10"><a href="about.html"><h5>Pan Numer 3</h5></a></div>
    </div>                  
        <div class="row kand2">
        <div class="col s2"><a href="about.html"><img src="img/profile.png" /></a></div>
        <div class="col s10"><a href="about.html"><h5>Pan Numer 4</h5></a></div>
    </div>
        <div class="row kand2">
        <div class="col s2"><a href="about.html"><img src="img/profile.png" /></a></div>
        <div class="col s10"><a href="about.html"><h5>Pan Numer 5</h5></a></div>
    </div>
        <div class="row kand2">
        <div class="col s2"><a href="about.html"><img src="img/profile.png" /></a></div>
        <div class="col s10"><a href="about.html"><h5>Pan Numer 6</h5></a></div>
    </div>
        <div class="row kand2">
        <div class="col s2"><a href="about.html"><img src="img/profile.png" /></a></div>
        <div class="col s10"><a href="about.html"><h5>Pan Numer 7</h5></a></div>
    </div>
    <div class="row kand2">
        <div class="col s2"><a href="about.html"><img src="img/profile.png" /></a></div>
        <div class="col s10"><a href="about.html"><h5>Pan Numer 8</h5></a></div>
    </div>
    


</div>
DOC
)
