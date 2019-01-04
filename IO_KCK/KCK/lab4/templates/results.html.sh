export TITLE="WyboryApp :: Results"
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
    <div class="row red-text center"><h2>WYBORY A</h2>
    <hr>
    <hr>
    <br>
    <div class="center">
        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.        
    </div>
    <div class="row">
        <img class="col s6" src="img/chart1.jpg"/>
        <img class="col s6" src="img/chart2.jpg"/>
    </div>
    <div class="row center">
        <img class="col s6" src="img/chart3.jpg"/><img>
        <div class="col s6 marg">
            <div class="col s12"><a class="waves-effect waves-light btn-small" href="#">Button</a></div>
            <div class="col s12"><a class="waves-effect waves-light btn-small" href="#">Button</a></div>
            <div class="col s12"><a class="waves-effect waves-light btn-small" href="#">Button</a></div>
        </div>
    </div>

</div>
DOC
)
