

const form = document.getElementById('form');
const email = document.getElementById('email');
const password = document.getElementById('password');



// patterns for a valid email and password
function isEmail(email) {
	return /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/.test(email);
}

function isPassword(password) {
	return /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[^a-zA-Z0-9])(?!.*\s).{8,25}$/.test(password);
}




//Created error class
//show alert message and change format - see:changePassword.css


function setErrorFor(input, alert) {
	//parentElement=form-group
	const formGroup = input.parentElement;
	const small = formGroup.querySelector('small');
	formGroup.className = 'form-group error';
	
	//alert message inside <small>
	small.innerText = alert;
}


//Created Valid class
//show validatioon by changingformat

function setValidFor(input) {
	const formGroup = input.parentElement;
	formGroup.className = 'form-group valid';
}




// to enable reusing form
form.addEventListener('submit', (e) => {
  if(!inputValid()){
    e.preventDefault();
  }
});



//function checking input fields
function inputValid() {
	
	
	const emailValue = email.value.trim();
	const passwordValue = password.value;
	var isValid = true;
	
	//Email Validation
	if(emailValue === '') {
		setErrorFor(email, 'Username or email cannot be blank');
    isValid = false;
	} 

	else {
		setValidFor(email);
	}
	
	
	//Password Validation
	if(passwordValue === '') {
		setErrorFor(password, 'Password cannot be blank');
    isValid = false;
	} 
	else if (!isPassword(passwordValue)) {
		setErrorFor(password, 'Password length should be between 8 to 25 characters and must contain a lowercase letter, an uppercase letter, a number and a special character ');
    isValid = false;
  }
	else {
		setValidFor(password);
	}
	return isValid;
}