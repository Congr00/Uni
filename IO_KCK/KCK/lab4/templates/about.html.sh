export TITLE="WyboryApp :: Start"
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
    <div class="row about">
        <img class="col s6 offset-s3" src="img/profile.png" />
    </div>
    <div class="row about" style="margin-top:-2vh;">
        <div class="col s6 offset-s3">
            <h4>Pan numer N</h4>
        </div>
    </div>
    <div class="row">
    <p style="text-align: justify;">
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.        
    </p>
    </div>
</div>
DOC
)
